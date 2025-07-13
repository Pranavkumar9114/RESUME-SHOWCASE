import { useContext, useState } from "react"
import { CartContext } from "./CartContext" 
import { FaTrash, FaShoppingCart, FaPlus, FaMinus, FaTags } from "react-icons/fa" 
import styles from "./CartPage.module.css"
import Navbar from "../../components/navbar/Navbar"
import { Link } from "react-router-dom";

export default function CartPage() {
  const { cartItems, removeFromCart, increaseQuantity, decreaseQuantity } = useContext(CartContext)
  const [couponCode, setCouponCode] = useState("")
  const [appliedCoupon, setAppliedCoupon] = useState(null)
  const [couponError, setCouponError] = useState("")
  const [billNumber] = useState(
    `INV-${Math.floor(Math.random() * 10000)
      .toString()
      .padStart(4, "0")}`,
  )
  const [billDate] = useState(new Date().toLocaleDateString("en-IN"))
  const [priceAnimation, setPriceAnimation] = useState(false)


  const subtotal = cartItems
    .reduce((acc, item) => acc + item.quantity * Number.parseFloat(item.price.replace("₹", "")), 0)
    .toFixed(2)

  
  const formatPrice = (price) => {
    return new Intl.NumberFormat("en-IN", {
      maximumFractionDigits: 2,
      minimumFractionDigits: 2,
    }).format(price)
  }


  const calculateDiscount = () => {
    if (!appliedCoupon) return 0

    if (appliedCoupon.type === "percentage") {
      return ((Number.parseFloat(subtotal) * appliedCoupon.value) / 100).toFixed(2)
    } else if (appliedCoupon.type === "fixed") {
      return Math.min(Number.parseFloat(subtotal), appliedCoupon.value).toFixed(2)
    }
    return 0
  }


  const cgst = ((Number.parseFloat(subtotal) - Number.parseFloat(calculateDiscount())) * 0.09).toFixed(2)
  const sgst = ((Number.parseFloat(subtotal) - Number.parseFloat(calculateDiscount())) * 0.09).toFixed(2)


  const totalAmount = (
    Number.parseFloat(subtotal) -
    Number.parseFloat(calculateDiscount()) +
    Number.parseFloat(cgst) +
    Number.parseFloat(sgst)
  ).toFixed(2)


  const applyCoupon = () => {
    setCouponError("")


    if (!couponCode.trim()) {
      setCouponError("Please enter a coupon code")
      return
    }


    if (couponCode.toUpperCase() === "GET10") {
      setAppliedCoupon({ code: "GET10", type: "percentage", value: 10 })
      triggerPriceAnimation()
    } else if (couponCode.toUpperCase() === "SAVE50") {
      setAppliedCoupon({ code: "SAVE50", type: "fixed", value: 50 })
      triggerPriceAnimation()
    } else {
      setCouponError("Invalid coupon code")
      setAppliedCoupon(null)
    }
  }


  const removeCoupon = () => {
    setAppliedCoupon(null)
    setCouponCode("")
    triggerPriceAnimation()
  }


  const triggerPriceAnimation = () => {
    setPriceAnimation(true)
    setTimeout(() => setPriceAnimation(false), 500)
  }

  return (
    <section className={styles.cartContainer}>
      <><Navbar/></>
      <h2 className={styles.cartTitle}>
        <FaShoppingCart className={styles.cartIcon} /> Your Cart
      </h2>

      {cartItems.length === 0 ? (
        <p className={styles.cartEmpty}>Your cart is empty! Start shopping now.</p>
      ) : (
        <div className={styles.cartGrid}>
          {cartItems.map((item, index) => (
            <div key={index} className={styles.cartItem}>
              <img src={item.image || "/placeholder.svg"} alt={item.name} className={styles.cartItemImage} />
              <div className={styles.cartItemDetails}>
                <h3 className={styles.cartItemName}>{item.name}</h3>
                <p className={styles.cartItemPrice}>₹{formatPrice(item.price.replace("₹", ""))}</p>

           
                <div className={styles.quantityControls}>
                  <button onClick={() => decreaseQuantity(item.id)} className={styles.quantityButton}>
                    <FaMinus />
                  </button>
                  <span className={styles.quantityValue}>{item.quantity}</span>
                  <button onClick={() => increaseQuantity(item.id)} className={styles.quantityButton}>
                    <FaPlus />
                  </button>
                </div>

                <button className={styles.cartRemoveButton} onClick={() => removeFromCart(item.id)}>
                  <FaTrash /> Remove
                </button>
              </div>
            </div>
          ))}
        </div>
      )}

      {cartItems.length > 0 && (
        <div className={styles.cartFooter}>
          <div className={styles.billSummary}>
            <div className={styles.billHeader}>
              <div className={styles.billInfo}>
                <span>Invoice #: {billNumber}</span>
                <span>Date: {billDate}</span>
              </div>
              <h3 className={styles.billTitle}>Billing Summary</h3>
            </div>


            <div className={styles.couponSection}>
              <div className={styles.couponInput}>
                <FaTags className={styles.couponIcon} />
                <input
                  type="text"
                  placeholder="Enter coupon code"
                  value={couponCode}
                  onChange={(e) => setCouponCode(e.target.value)}
                  className={styles.couponField}
                  disabled={appliedCoupon !== null}
                />
                {appliedCoupon ? (
                  <button onClick={removeCoupon} className={styles.couponButton}>
                    Remove
                  </button>
                ) : (
                  <button onClick={applyCoupon} className={styles.couponButton}>
                    Apply
                  </button>
                )}
              </div>
              {couponError && <p className={styles.couponError}>{couponError}</p>}
              {appliedCoupon && (
                <p className={styles.couponSuccess}>
                  Coupon <span>{appliedCoupon.code}</span> applied successfully!
                </p>
              )}
            </div>

            <div className={styles.billDetails}>
              <div className={styles.billRow}>
                <span>Item Total</span>
                <span>₹{formatPrice(subtotal)}</span>
              </div>

              {appliedCoupon && (
                <div className={`${styles.billRow} ${styles.discountRow}`}>
                  <span>Discount ({appliedCoupon.type === "percentage" ? `${appliedCoupon.value}%` : "Flat"})</span>
                  <span className={priceAnimation ? styles.priceChanged : ""}>
                    -₹{formatPrice(calculateDiscount())}
                  </span>
                </div>
              )}

              <div className={styles.billRow}>
                <span>CGST (9%)</span>
                <span className={priceAnimation ? styles.priceChanged : ""}>₹{formatPrice(cgst)}</span>
              </div>

              <div className={styles.billRow}>
                <span>SGST (9%)</span>
                <span className={priceAnimation ? styles.priceChanged : ""}>₹{formatPrice(sgst)}</span>
              </div>

              <div className={styles.billRow}>
                <span>Delivery Charges</span>
                <span>₹0.00</span>
              </div>

              <div className={`${styles.billRow} ${styles.billTotal}`}>
                <span>Total Payable Amount</span>
                <span className={priceAnimation ? styles.priceChanged : ""}>₹{formatPrice(totalAmount)}</span>
              </div>
            </div>

            <div className={styles.billFooter}>
              <p>Thank you for shopping with us!</p>
              <p className={styles.billTerms}>* Terms and conditions apply</p>
            </div>
          </div>

          <Link
  to="/Checkout"
  state={{
    cartItems,
    subtotal,
    discount: calculateDiscount(),
    cgst,
    sgst,
    total: totalAmount,
    billNumber,
    billDate,
  }}
>
  <button className={styles.checkoutButton}>Proceed to Checkout</button>
</Link>

        </div>
      )}
    </section>
  )
}
