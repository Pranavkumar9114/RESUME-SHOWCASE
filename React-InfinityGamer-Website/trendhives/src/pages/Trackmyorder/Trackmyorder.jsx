import { useState, useEffect } from "react"
import { getDatabase, ref, onValue,remove,update } from "firebase/database"
import { app } from "../../firebase"
import styles from "./trackmyorder.module.css"
import Navbar from "../../components/navbar/Navbar"

const TrackMyOrder = () => {
  const [orders, setOrders] = useState([])
  const [filteredOrders, setFilteredOrders] = useState([])
  const [loading, setLoading] = useState(true)
  const [error, setError] = useState(null)
  const [expandedOrder, setExpandedOrder] = useState(null)
  const [searchTerm, setSearchTerm] = useState("")
  const [lastUpdated, setLastUpdated] = useState(null)

  const orderStatuses = {
    pending: 0,
    processing: 1,
    shipped: 2,
    out_for_delivery: 3,
    delivered: 4,
    cancelled: -1,
  }

  const statusLabels = {
    pending: "Order Placed",
    processing: "Processing",
    shipped: "Shipped",
    out_for_delivery: "Out for Delivery",
    delivered: "Delivered",
    cancelled: "Cancelled",
  }

  const statusIcons = {
    pending: "📋",
    processing: "⚙️",
    shipped: "📦",
    out_for_delivery: "🚚",
    delivered: "✅",
    cancelled: "❌",
  }

  useEffect(() => {
    const fetchOrders = async () => {
      try {
        const database = getDatabase(app)
        const ordersRef = ref(database, "orders")

        onValue(
          ordersRef,
          (snapshot) => {
            const data = snapshot.val()
            if (data) {
     
              const ordersArray = Object.entries(data).map(([key, value]) => ({
                id: key,
              
                status: value.status || "processing",
                ...value,
              }))

            
              ordersArray.sort((a, b) => {
                return new Date(b.timestamp || 0) - new Date(a.timestamp || 0)
              })

              setOrders(ordersArray)
              setFilteredOrders(ordersArray)
              setLastUpdated(new Date())
            } else {
              setOrders([])
              setFilteredOrders([])
            }
            setLoading(false)
          },
          (error) => {
            setError(error.message)
            setLoading(false)
          },
        )
      } catch (error) {
        setError(error.message)
        setLoading(false)
      }
    }

    fetchOrders()
  }, [])

 
  useEffect(() => {
    if (searchTerm.trim() === "") {
      setFilteredOrders(orders)
    } else {
      const term = searchTerm.toLowerCase()
      const filtered = orders.filter(
        (order) =>
          (order.billNumber && order.billNumber.toLowerCase().includes(term)) ||
          (order.orderId && order.orderId.toLowerCase().includes(term)) ||
          (order.status && statusLabels[order.status].toLowerCase().includes(term)),
      )
      setFilteredOrders(filtered)
    }
  }, [searchTerm, orders])

  const toggleOrder = (orderId) => {
    setExpandedOrder(expandedOrder === orderId ? null : orderId)
  }

  const sanitizeTimestamp = (timestamp) => {

    if (typeof timestamp === "string" && timestamp.includes("/")) {
      const parts = timestamp.split("/")
      if (parts.length === 3) {
     
        const [day, month, year] = parts
        return `${year}-${month}-${day}`
      }
    }
    return timestamp
  }
  

  const formatDate = (timestamp) => {
    if (!timestamp) return "N/A"
  
    try {
      const safeTimestamp = sanitizeTimestamp(timestamp)
      const date = new Date(safeTimestamp)
      return date.toLocaleDateString("en-US", {
        year: "numeric",
        month: "short",
        day: "numeric",
      })
    } catch (e) {
      return timestamp
    }
  }
  
  const formatTime = (timestamp) => {
    if (!timestamp) return ""
  
    try {
      const safeTimestamp = sanitizeTimestamp(timestamp)
      const date = new Date(safeTimestamp)
      return date.toLocaleTimeString("en-US", {
        hour: "2-digit",
        minute: "2-digit",
      })
    } catch (e) {
      return ""
    }
  }

  const handleCancelOrder = (orderId) => {
    const confirmCancel = window.confirm("Are you sure you want to cancel this order? This action cannot be undone.")
    
    if (confirmCancel) {
      const database = getDatabase(app)
      const orderRef = ref(database, `orders/${orderId}`)
      
    
      update(orderRef, {
        status: "cancelled"
      })
        .then(() => {
          alert("Order has been cancelled successfully.")
          
         
          setOrders((prevOrders) =>
            prevOrders.map((order) =>
              order.id === orderId ? { ...order, status: "cancelled" } : order
            )
          )
          setFilteredOrders((prevFilteredOrders) =>
            prevFilteredOrders.map((order) =>
              order.id === orderId ? { ...order, status: "cancelled" } : order
            )
          )
  
          setExpandedOrder(null) 
        })
        .catch((error) => {
          alert("Failed to cancel the order. Please try again.")
          console.error("Cancel Order Error:", error)
        })
    }
  }
  

  // const handleCancelOrder = (orderId) => {
  //   const confirmCancel = window.confirm("Are you sure you want to cancel this order? This action cannot be undone.")
  
  //   if (confirmCancel) {
  //     const database = getDatabase(app)
  //     const orderRef = ref(database, `orders/${orderId}`)
  
  //     remove(orderRef)
  //       .then(() => {
  //         alert("Order has been cancelled successfully.")
  //         setExpandedOrder(null) // Collapse the order details if open
  //       })
  //       .catch((error) => {
  //         alert("Failed to cancel the order. Please try again.")
  //         console.error("Cancel Order Error:", error)
  //       })
  //   }
  // }
  

  const getTimeAgo = (date) => {
    if (!date) return ""

    const seconds = Math.floor((new Date() - date) / 1000)

    let interval = seconds / 31536000
    if (interval > 1) return Math.floor(interval) + " years ago"

    interval = seconds / 2592000
    if (interval > 1) return Math.floor(interval) + " months ago"

    interval = seconds / 86400
    if (interval > 1) return Math.floor(interval) + " days ago"

    interval = seconds / 3600
    if (interval > 1) return Math.floor(interval) + " hours ago"

    interval = seconds / 60
    if (interval > 1) return Math.floor(interval) + " minutes ago"

    return Math.floor(seconds) + " seconds ago"
  }

  const getStatusProgress = (status) => {
    const step = orderStatuses[status] || 0
    if (step === -1) return 0 
    return (step / 4) * 100
  }

  if (loading) {
    return (
      <div className={styles.container}>
        <div className={styles.loadingContainer}>
          <div className={styles.loadingSpinner}></div>
          <p>Loading your orders...</p>
        </div>
      </div>
    )
  }

  if (error) {
    return (
      <div className={styles.container}>
        <div className={styles.errorContainer}>
          <h2>Error Loading Orders</h2>
          <p>{error}</p>
          <button className={styles.retryButton} onClick={() => window.location.reload()}>
            Retry
          </button>
        </div>
      </div>
    )
  }

  return (
    <>
    <><Navbar/></>
    <div className={styles.container}>
      <div className={styles.header}>
        <div className={styles.titleContainer}>
          <div className={styles.iconContainer}>
            <span className={styles.titleIcon}>📦</span>
          </div>
          <h1 className={styles.title}>Track My Orders</h1>
        </div>

        {lastUpdated && <div className={styles.lastUpdated}>Last updated: {getTimeAgo(lastUpdated)}</div>}
      </div>

      <div className={styles.searchContainer}>
        <input
          type="text"
          className={styles.searchInput}
          placeholder="Search by order ID, invoice number or status..."
          value={searchTerm}
          onChange={(e) => setSearchTerm(e.target.value)}
        />
        {searchTerm && (
          <button className={styles.clearSearch} onClick={() => setSearchTerm("")}>
            ×
          </button>
        )}
      </div>

      {filteredOrders.length === 0 ? (
        <div className={styles.emptyContainer}>
          <div className={styles.emptyIcon}>📭</div>
          <h2>No Orders Found</h2>
          <p>We couldn't find any orders matching your criteria.</p>
          {searchTerm && (
            <button className={styles.clearButton} onClick={() => setSearchTerm("")}>
              Clear Search
            </button>
          )}
        </div>
      ) : (
        <div className={styles.ordersList}>
          {filteredOrders.map((order) => (
            <div
              key={order.id}
              className={`${styles.orderCard} ${expandedOrder === order.id ? styles.expanded : ""} ${order.status === "cancelled" ? styles.cancelled : ""}`}
            >
              <div className={styles.orderHeader} onClick={() => toggleOrder(order.id)}>
                <div className={styles.orderSummary}>
                  <h2 className={styles.orderNumber}>{order.billNumber || order.id}</h2>
                  <div className={styles.orderMeta}>
                    <p className={styles.orderDate}>
                      {formatDate(order.billDate || order.timestamp)}
                      <span className={styles.orderTime}>{formatTime(order.timestamp)}</span>
                    </p>
                    <div className={styles.statusBadge} data-status={order.status}>
                      <span className={styles.statusIcon}>{statusIcons[order.status]}</span>
                      <span>{statusLabels[order.status]}</span>
                    </div>
                  </div>
                </div>
                <div className={styles.orderTotal}>
                  <span className={styles.totalAmount}>₹{order.total || "0.00"}</span>
                  <span className={`${styles.expandIcon} ${expandedOrder === order.id ? styles.rotated : ""}`}>
                    &#9662;
                  </span>
                </div>
              </div>

              {expandedOrder === order.id && (
                <div className={styles.orderDetails}>
                  {/* Status Tracker */}
                  {order.status !== "cancelled" && (
                    <div className={styles.statusTracker}>
                      <div className={styles.progressBar}>
                        <div
                          className={styles.progressFill}
                          style={{ width: `${getStatusProgress(order.status)}%` }}
                        ></div>
                      </div>
                      <div className={styles.statusSteps}>
                        <div
                          className={`${styles.statusStep} ${orderStatuses[order.status] >= 0 ? styles.active : ""} ${orderStatuses[order.status] > 0 ? styles.completed : ""}`}
                        >
                          <div className={styles.stepIcon}>📋</div>
                          <span>Order Placed</span>
                        </div>
                        <div
                          className={`${styles.statusStep} ${orderStatuses[order.status] >= 1 ? styles.active : ""} ${orderStatuses[order.status] > 1 ? styles.completed : ""}`}
                        >
                          <div className={styles.stepIcon}>⚙️</div>
                          <span>Processing</span>
                        </div>
                        <div
                          className={`${styles.statusStep} ${orderStatuses[order.status] >= 2 ? styles.active : ""} ${orderStatuses[order.status] > 2 ? styles.completed : ""}`}
                        >
                          <div className={styles.stepIcon}>📦</div>
                          <span>Shipped</span>
                        </div>
                        <div
                          className={`${styles.statusStep} ${orderStatuses[order.status] >= 3 ? styles.active : ""} ${orderStatuses[order.status] > 3 ? styles.completed : ""}`}
                        >
                          <div className={styles.stepIcon}>🚚</div>
                          <span>Out for Delivery</span>
                        </div>
                        <div
                          className={`${styles.statusStep} ${orderStatuses[order.status] >= 4 ? styles.active : ""}`}
                        >
                          <div className={styles.stepIcon}>✅</div>
                          <span>Delivered</span>
                        </div>
                      </div>
                    </div>
                  )}

                  {/* Order Info */}
                  <div className={styles.orderInfo}>
                    <div className={styles.infoItem}>
                      <span className={styles.infoLabel}>Order ID</span>
                      <span className={styles.infoValue}>{order.orderId || "N/A"}</span>
                    </div>
                    <div className={styles.infoItem}>
                      <span className={styles.infoLabel}>Payment ID</span>
                      <span className={styles.infoValue}>{order.paymentId || "N/A"}</span>
                    </div>
                    <div className={styles.infoItem}>
                      <span className={styles.infoLabel}>Order Date</span>
                      <span className={styles.infoValue}>{formatDate(order.timestamp)}</span>
                    </div>
                    <div className={styles.infoItem}>
                      <span className={styles.infoLabel}>Expected Delivery</span>
                      <span className={styles.infoValue}>
                        {order.status === "delivered"
                          ? "Delivered"
                          : order.status === "cancelled"
                            ? "Cancelled"
                            : formatDate(new Date(new Date(order.timestamp).getTime() + 7 * 24 * 60 * 60 * 1000))}
                      </span>
                    </div>
                  </div>

                  {/* Cart Items */}
                  <div className={styles.cartItems}>
                    <h3 className={styles.sectionTitle}>Order Items</h3>

                    {order.cartItems && Object.keys(order.cartItems).length > 0 ? (
                      <div className={styles.itemsList}>
                        {Object.entries(order.cartItems).map(([itemKey, item]) => (
                          <div key={itemKey} className={styles.cartItem}>
                            <div className={styles.itemImagePlaceholder}>{item.name.charAt(0)}</div>
                            <div className={styles.itemDetails}>
                              <span className={styles.itemName}>{item.name}</span>
                              <div className={styles.itemMeta}>
                                <span className={styles.itemPrice}>{item.price}</span>
                                <span className={styles.itemQuantity}>Qty: {item.quantity}</span>
                              </div>
                            </div>
                          </div>
                        ))}
                      </div>
                    ) : (
                      <p className={styles.noItems}>No items found for this order.</p>
                    )}
                  </div>

                  {/* Order Summary */}
                  <div className={styles.orderSummaryDetails}>
                    <h3 className={styles.sectionTitle}>Order Summary</h3>
                    <div className={styles.summaryItem}>
                      <span>Subtotal</span>
                      <span>₹{order.subtotal || "0.00"}</span>
                    </div>
                    {order.cgst && (
                      <div className={styles.summaryItem}>
                        <span>CGST</span>
                        <span>₹{order.cgst}</span>
                      </div>
                    )}
                    {order.sgst && (
                      <div className={styles.summaryItem}>
                        <span>SGST</span>
                        <span>₹{order.sgst}</span>
                      </div>
                    )}
                    <div className={styles.summaryItem}>
                      <span>Discount</span>
                      <span>₹{order.discount || "0"}</span>
                    </div>
                    <div className={`${styles.summaryItem} ${styles.totalItem}`}>
                      <span>Total</span>
                      <span>₹{order.total || "0.00"}</span>
                    </div>
                  </div>

                  {/* Action Buttons */}
                  <div className={styles.actionButtons}>
                    {order.status !== "delivered" && order.status !== "cancelled" && (
                      <button className={styles.actionButton}  onClick={() => handleCancelOrder(order.id)}>Cancel Order</button>
                    )}
                    {/* <button className={styles.actionButton}>Download Invoice</button> */}
                    {/* <button className={styles.actionButton}>Contact Support</button> */}
                  </div>
                </div>
              )}
            </div>
          ))}
        </div>
      )}

      {/* <div className={styles.footer}>
        <button className={styles.footerButton}>
          <span className={styles.buttonIcon}>🏠</span>
          Back to Home
        </button>
        <button className={styles.footerButton}>
          <span className={styles.buttonIcon}>💬</span>
          Contact Support
        </button>
      </div> */}
    </div>
    </>
  )
}

export default TrackMyOrder
