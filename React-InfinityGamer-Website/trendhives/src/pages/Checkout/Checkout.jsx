import { useState } from "react"
import styles from "./checkout.module.css"
import { useLocation,Link } from "react-router-dom";
import { database } from "../../firebase";
import { ref, set } from "firebase/database";

export default function Checkout() {
    const { state } = useLocation();
    const {
      cartItems = [],
      subtotal = 0,
      discount = 0,
      cgst = 0,
      sgst = 0,
      total = 0,
      billNumber = "N/A",
      billDate = "N/A",
    } = state || {};
  const [isProcessing, setIsProcessing] = useState(false)
  const [paymentSuccess, setPaymentSuccess] = useState(false)
  const [paymentError, setPaymentError] = useState("")

 
  const formatPrice = (price) => {
    return new Intl.NumberFormat("en-IN", {
      maximumFractionDigits: 2,
      minimumFractionDigits: 2,
    }).format(price)
  }

  const loadRazorpayScript = () => {
    return new Promise((resolve) => {
      const script = document.createElement("script")
      script.src = "https://checkout.razorpay.com/v1/checkout.js"
      script.onload = () => {
        resolve(true)
      }
      script.onerror = () => {
        resolve(false)
      }
      document.body.appendChild(script)
    })
  }
  

  const handlePayment = async () => {
    setIsProcessing(true)
    setPaymentError("")
  
    const isLoaded = await loadRazorpayScript()
  
    if (!isLoaded || !window.Razorpay) {
      setPaymentError("Razorpay script not loaded. Please check your internet connection or try again later.")
      setIsProcessing(false)
      return
    }
  
    const options = {
      key: "", 
      amount: Math.round(total * 100),
      currency: "INR",
      name: "INFINITY GAMER",
      description: `Payment for order #${billNumber}`,
      order_id: "", 
      handler: (response) => {
        setIsProcessing(false)
        setPaymentSuccess(true)
        console.log("Payment successful", response)
        const generatedOrderId = response.razorpay_order_id || `order_${response.razorpay_payment_id}`;
        const orderData = {
          billNumber,
          billDate,
          cartItems: cartItems.map(item => ({
            name: item.name,
            price: item.price,
            quantity: item.quantity,
          })),
          subtotal,
          discount,
          cgst,
          sgst,
          total,
          paymentId: response.razorpay_payment_id,
          orderId: generatedOrderId || "",
          signature: response.razorpay_signature || "",
          timestamp: new Date().toISOString(),
          // billNumber,
          // billDate,
          // cartItems,
          // subtotal,
          // discount,
          // cgst,
          // sgst,
          // total,
          // paymentId: response.razorpay_payment_id,
          // orderId: response.razorpay_order_id || "",
          // signature: response.razorpay_signature || "",
          // timestamp: new Date().toISOString(),
        }
      
        // Save to Firebase
        set(ref(database, "orders/" + billNumber), orderData)
          .then(() => console.log("Order saved to Firebase"))
          .catch((error) => console.error("Error saving order to Firebase:", error));
      },
      prefill: {
        name: "",
        email: "",
        contact: "",
      },
      notes: {
        address: "Customer Address",
      },
      theme: {
        color: "#121212",
      },
      modal: {
        ondismiss: () => {
          setIsProcessing(false)
        },
      },
    }
  
    const razorpayInstance = new window.Razorpay(options)
    razorpayInstance.open()
  }
  
  

  const downloadBill = () => {

    const printWindow = window.open("", "_blank")

    if (!printWindow) {
      alert("Please allow popups to download the bill")
      return
    }

 
    printWindow.document.write(`
      <html>
        <head>
          <title>Invoice #${billNumber}</title>
          <style>
            body {
              font-family: Arial, sans-serif;
              padding: 20px;
              color: #333;
            }
            .invoice-header {
              text-align: center;
              margin-bottom: 30px;
            }
            .invoice-details {
              display: flex;
              justify-content: space-between;
              margin-bottom: 20px;
            }
            table {
              width: 100%;
              border-collapse: collapse;
              margin-bottom: 20px;
            }
            th, td {
              padding: 10px;
              text-align: left;
              border-bottom: 1px solid #ddd;
            }
            th {
              background-color: #f2f2f2;
            }
            .total-row {
              font-weight: bold;
            }
            .footer {
              margin-top: 30px;
              text-align: center;
              font-size: 12px;
            }
          </style>
        </head>
        <body>
          <div class="invoice-header">
            <h1>INVOICE</h1>
          </div>
          <div class="invoice-details">
            <div>
              <p><strong>Invoice #:</strong> ${billNumber}</p>
              <p><strong>Date:</strong> ${billDate}</p>
            </div>
          </div>
          <table>
            <thead>
              <tr>
                <th>Item</th>
                <th>Price</th>
                <th>Quantity</th>
                <th>Total</th>
              </tr>
            </thead>
            <tbody>
              ${cartItems
                .map(
                  (item) => `
                <tr>
                  <td>${item.name}</td>
                  <td>₹${item.price.replace("₹", "")}</td>
                  <td>${item.quantity}</td>
                  <td>₹${formatPrice(item.quantity * Number.parseFloat(item.price.replace("₹", "")))}</td>
                </tr>
              `,
                )
                .join("")}
            </tbody>
          </table>
          <table>
            <tbody>
              <tr>
                <td>Subtotal</td>
                <td>₹${formatPrice(subtotal)}</td>
              </tr>
              ${
                discount > 0
                  ? `
                <tr>
                  <td>Discount</td>
                  <td>-₹${formatPrice(discount)}</td>
                </tr>
              `
                  : ""
              }
              <tr>
                <td>CGST (9%)</td>
                <td>₹${formatPrice(cgst)}</td>
              </tr>
              <tr>
                <td>SGST (9%)</td>
                <td>₹${formatPrice(sgst)}</td>
              </tr>
              <tr class="total-row">
                <td>Total</td>
                <td>₹${formatPrice(total)}</td>
              </tr>
            </tbody>
          </table>
          <div class="footer">
            <p>Thank you for your business!</p>
            <p>* Terms and conditions apply</p>
          </div>
        </body>
      </html>
    `)

    printWindow.document.close()
    printWindow.focus()


    setTimeout(() => {
      printWindow.print()

    }, 500)
  }

  return (
    <div className={styles.checkoutContainer}>
      <h2 className={styles.checkoutTitle}>Checkout</h2>

      {paymentSuccess ? (
        <div className={styles.successMessage}>
          <h3>Payment Successful!</h3>
          <p>Your order has been placed successfully.</p>
          <button className={styles.downloadButton} onClick={downloadBill}>
            Download Invoice
          </button>
          <Link to="/">
          <button className={styles.ContinueShopping}>Continue Shopping</button>
          </Link>
        </div>
      ) : (
        <>
          <div className={styles.billSummary}>
            <div className={styles.billHeader}>
              <div className={styles.billInfo}>
                <span>Invoice #: {billNumber}</span>
                <span>Date: {billDate}</span>
              </div>
              <h3 className={styles.billTitle}>Bill Summary</h3>
            </div>

            <div className={styles.itemsList}>
              {cartItems.map((item, index) => (
                <div key={index} className={styles.billItem}>
                  <div className={styles.itemDetails}>
                    <span className={styles.itemName}>{item.name}</span>
                    <span className={styles.itemQuantity}>x{item.quantity}</span>
                  </div>
                  <span className={styles.itemPrice}>
                    ₹{formatPrice(item.quantity * Number.parseFloat(item.price.replace("₹", "")))}
                  </span>
                </div>
              ))}
            </div>

            <div className={styles.billDetails}>
              <div className={styles.billRow}>
                <span>Subtotal</span>
                <span>₹{formatPrice(subtotal)}</span>
              </div>

              {discount > 0 && (
                <div className={`${styles.billRow} ${styles.discountRow}`}>
                  <span>Discount</span>
                  <span>-₹{formatPrice(discount)}</span>
                </div>
              )}

              <div className={styles.billRow}>
                <span>CGST (9%)</span>
                <span>₹{formatPrice(cgst)}</span>
              </div>

              <div className={styles.billRow}>
                <span>SGST (9%)</span>
                <span>₹{formatPrice(sgst)}</span>
              </div>

              <div className={`${styles.billRow} ${styles.billTotal}`}>
                <span>Total Amount</span>
                <span>₹{formatPrice(total)}</span>
              </div>
            </div>
          </div>

          {paymentError && <div className={styles.errorMessage}>{paymentError}</div>}

          <div className={styles.actionButtons}>

            <button className={styles.payButton} onClick={handlePayment} disabled={isProcessing}>
              {isProcessing ? "Processing..." : "Pay Now"}
            </button>
          </div>
        </>
      )}
    </div>
  )
}
