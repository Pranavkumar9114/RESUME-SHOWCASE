import Navbar from "../../components/navbar/Navbar"
import styles from "./ShippingPolicy.module.css"
import Footer from "../../components/footer/Footer"

const ShippingPolicy = () => {
    return (
        <>
            <div>
                <><Navbar /></>
            </div>
            <div className={styles.policyContainer}>
                <header className={styles.policyHeader}>
                    <h1>Shipping Policy</h1>
                    <p className={styles.lastUpdated}>Last Updated: April 9, 2025</p>
                </header>

                <section className={styles.policySection}>
                    <h2>Estimated Delivery Times</h2>
                    <p>
                        At INFINITY GAMER, we strive to deliver your gaming products as quickly as possible. Delivery times may vary
                        based on your location and the shipping method selected.
                    </p>
                    <ul className={styles.policyList}>
                        <li>
                            <span className={styles.highlight}>Standard Shipping:</span> 3-5 business days (domestic)
                        </li>
                        <li>
                            <span className={styles.highlight}>Express Shipping:</span> 1-2 business days (domestic)
                        </li>
                        <li>
                            <span className={styles.highlight}>International Standard:</span> 7-14 business days
                        </li>
                        <li>
                            <span className={styles.highlight}>International Express:</span> 3-5 business days
                        </li>
                    </ul>
                    <p>
                        Please note that these are estimated timeframes and may be affected by customs, weather conditions, or other
                        factors beyond our control.
                    </p>
                </section>

                <section className={styles.policySection}>
                    <h2>Shipping Methods</h2>
                    <p>We offer various shipping options to meet your needs:</p>
                    <ul className={styles.policyList}>
                        <li>
                            <span className={styles.highlight}>Standard Shipping:</span> Affordable and reliable delivery for non-urgent
                            orders
                        </li>
                        <li>
                            <span className={styles.highlight}>Express Shipping:</span> Expedited delivery for when you need your gaming
                            gear quickly
                        </li>
                        <li>
                            <span className={styles.highlight}>International Shipping:</span> Available to most countries worldwide
                        </li>
                    </ul>
                    <p>All orders are processed and shipped from our warehouse within 24-48 hours of purchase confirmation.</p>
                </section>

                <section className={styles.policySection}>
                    <h2>Order Tracking</h2>
                    <p>
                        Once your order ships, you'll receive a confirmation email with tracking information. You can also track your
                        order by:
                    </p>
                    <ol className={styles.policyList}>
                        <li>Logging into your INFINITY GAMER account</li>
                        <li>Navigating to "Order History"</li>
                        <li>Selecting the order you wish to track</li>
                        <li>Clicking on the "Track Package" button</li>
                    </ol>
                    <p>If you have any questions about your shipment, please contact our customer support team.</p>
                </section>

                <section className={styles.policySection}>
                    <h2>Shipping Costs</h2>
                    <div className={styles.tableContainer}>
                        <table className={styles.shippingTable}>
                            <thead>
                                <tr>
                                    <th>Shipping Method</th>
                                    <th>Order Value</th>
                                    <th>Cost</th>
                                </tr>
                            </thead>
                            <tbody>
                                <tr>
                                    <td>Standard Domestic</td>
                                    <td>Under ₹3,500</td> 
                                    <td>₹499</td> 
                                </tr>
                                <tr>
                                    <td>Standard Domestic</td>
                                    <td>₹3,500 - ₹7,000</td> 
                                    <td>₹299</td> 
                                </tr>
                                <tr>
                                    <td>Standard Domestic</td>
                                    <td>Over ₹7,000</td> 
                                    <td>FREE</td>
                                </tr>
                                <tr>
                                    <td>Express Domestic</td>
                                    <td>Any value</td>
                                    <td>₹999</td>
                                </tr>
                                <tr>
                                    <td>International Standard</td>
                                    <td>Any value</td>
                                    <td>₹1,499</td> 
                                </tr>
                                <tr>
                                    <td>International Express</td>
                                    <td>Any value</td>
                                    <td>₹2,999</td> 
                                </tr>
                            </tbody>
                        </table>
                    </div>
                </section>

                <section className={styles.policySection}>
                    <h2>International Shipping</h2>
                    <p>INFINITY GAMER ships to most countries worldwide. Please note the following for international orders:</p>
                    <ul className={styles.policyList}>
                        <li>International customers may be subject to import duties and taxes</li>
                        <li>These additional fees are the responsibility of the customer</li>
                        <li>Delivery times may be extended due to customs processing</li>
                        <li>Some products may have regional restrictions due to licensing agreements</li>
                    </ul>
                    <p>For specific information about shipping to your country, please contact our customer support team.</p>
                </section>

                <footer className={styles.policyFooter}>
                    <p>
                        For any questions regarding our shipping policy, please contact our customer support at{" "}
                        <a href="mailto:support@infinitygamer.com" className={styles.link}>
                            support@infinitygamer.com
                        </a>
                    </p>
                </footer>
            </div>
            <div>
                <><Footer /></>
            </div>
        </>
    )
}

export default ShippingPolicy
