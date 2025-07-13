import Footer from "../../components/footer/Footer"
import Navbar from "../../components/navbar/Navbar"
import styles from "./ReturnPolicy.module.css"


const ReturnPolicy = () => {
  return (
    <>
    <div>
        <><Navbar/></>
    </div>
    <div className={styles.policyContainer}>
      <header className={styles.policyHeader}>
        <h1>Return Policy</h1>
        <p className={styles.lastUpdated}>Last Updated: April 9, 2025</p>
      </header>

      <section className={styles.policySection}>
        <h2>Return Eligibility</h2>
        <p>
          At INFINITY GAMER, we want you to be completely satisfied with your purchase. The following items are eligible
          for return:
        </p>
        <ul className={styles.policyList}>
          <li>Unopened physical games and merchandise in original packaging</li>
          <li>Defective hardware and accessories (within warranty period)</li>
          <li>Incorrect items received</li>
        </ul>
        <p className={styles.noteText}>
          <span className={styles.highlight}>Note:</span> Digital game codes, downloadable content (DLC), and
          subscription cards are non-refundable once the code has been revealed or redeemed.
        </p>
      </section>

      <section className={styles.policySection}>
        <h2>Return Window</h2>
        <p>To be eligible for a return, you must initiate the return process within:</p>
        <div className={styles.timelineContainer}>
          <div className={styles.timelineItem}>
            <div className={styles.timelineIcon}>30</div>
            <div className={styles.timelineContent}>
              <h3>30 Days</h3>
              <p>For new, unopened items</p>
            </div>
          </div>
          <div className={styles.timelineItem}>
            <div className={styles.timelineIcon}>14</div>
            <div className={styles.timelineContent}>
              <h3>14 Days</h3>
              <p>For opened items in working condition</p>
            </div>
          </div>
          <div className={styles.timelineItem}>
            <div className={styles.timelineIcon}>90</div>
            <div className={styles.timelineContent}>
              <h3>90 Days</h3>
              <p>For defective items (manufacturer warranty)</p>
            </div>
          </div>
        </div>
        <p>
          The return window begins on the date you receive your order, as confirmed by our delivery tracking system.
        </p>
      </section>

      <section className={styles.policySection}>
        <h2>Step-by-Step Return Process</h2>
        <ol className={styles.processSteps}>
          <li>
            <span className={styles.stepNumber}>1</span>
            <div className={styles.stepContent}>
              <h3>Initiate Return</h3>
              <p>
                Log into your INFINITY GAMER account, navigate to "Order History," and select "Return Item" next to the
                product you wish to return.
              </p>
            </div>
          </li>
          <li>
            <span className={styles.stepNumber}>2</span>
            <div className={styles.stepContent}>
              <h3>Complete Return Form</h3>
              <p>Select your reason for return and provide any additional information requested.</p>
            </div>
          </li>
          <li>
            <span className={styles.stepNumber}>3</span>
            <div className={styles.stepContent}>
              <h3>Receive Return Authorization</h3>
              <p>
                Once approved, you'll receive a Return Merchandise Authorization (RMA) number and shipping instructions
                via email.
              </p>
            </div>
          </li>
          <li>
            <span className={styles.stepNumber}>4</span>
            <div className={styles.stepContent}>
              <h3>Package Your Return</h3>
              <p>
                Securely package the item in its original packaging if possible. Include all accessories, manuals, and
                the RMA number.
              </p>
            </div>
          </li>
          <li>
            <span className={styles.stepNumber}>5</span>
            <div className={styles.stepContent}>
              <h3>Ship Your Return</h3>
              <p>
                Use the provided shipping label or send the package to our returns center using a tracked shipping
                method.
              </p>
            </div>
          </li>
        </ol>
      </section>

      <section className={styles.policySection}>
        <h2>Refund Timeline and Method</h2>
        <p>Once we receive and inspect your return, we'll process your refund according to the following timeline:</p>
        <ul className={styles.policyList}>
          <li>
            <span className={styles.highlight}>Inspection Period:</span> 1-3 business days after receipt
          </li>
          <li>
            <span className={styles.highlight}>Refund Processing:</span> 1-2 business days after approval
          </li>
          <li>
            <span className={styles.highlight}>Credit Card Refunds:</span> 3-5 business days to appear on your statement
          </li>
          <li>
            <span className={styles.highlight}>Store Credit:</span> Immediately available in your account after approval
          </li>
        </ul>
        <p>
          Refunds will be issued to the original payment method used for the purchase. If that's not possible, we'll
          issue store credit to your INFINITY GAMER account.
        </p>
      </section>

      <section className={styles.policySection}>
        <h2>Exchange Policy</h2>
        <p>If you prefer to exchange an item rather than request a refund, you can:</p>
        <ul className={styles.policyList}>
          <li>Select "Exchange" instead of "Return" when initiating the process</li>
          <li>Choose the replacement item from our inventory</li>
          <li>Pay any difference in price if the new item costs more</li>
          <li>Receive a partial refund if the new item costs less</li>
        </ul>
        <div className={styles.callout}>
          <h3>Expedited Exchanges</h3>
          <p>
            For Elite and Premium members, we offer expedited exchanges where we ship your replacement item immediately,
            before receiving your return. Contact customer support to use this service.
          </p>
        </div>
      </section>
    </div>
    <div>
        <><Footer/></>
    </div>
    </>
  )
}

export default ReturnPolicy
