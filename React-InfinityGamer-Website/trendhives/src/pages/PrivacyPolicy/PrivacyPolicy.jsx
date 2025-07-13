import styles from "./PrivacyPolicy.module.css"
import Navbar from "../../components/navbar/Navbar"
import Footer from "../../components/footer/Footer"

const PrivacyPolicy = () => {
  return (
    <>
    <div className={styles.policyContainer}>
        <><Navbar/></>
      <header className={styles.policyHeader}>
        <h1>Privacy Policy</h1>
        <p className={styles.lastUpdated}>Last Updated: April 9, 2025</p>
      </header>

      <section className={styles.policySection}>
        <h2>Types of Data Collected</h2>
        <p>
          INFINITY GAMER is committed to protecting your privacy. We collect various types of information to provide and
          improve our services. The data we collect includes:
        </p>
        <div className={styles.dataGrid}>
          <div className={styles.dataCard}>
            <div className={styles.dataIcon}>👤</div>
            <h3>Personal Information</h3>
            <ul>
              <li>Name</li>
              <li>Email address</li>
              <li>Billing address</li>
              <li>Shipping address</li>
              <li>Phone number</li>
            </ul>
          </div>
          <div className={styles.dataCard}>
            <div className={styles.dataIcon}>💳</div>
            <h3>Payment Information</h3>
            <ul>
              <li>Purchase history</li>
              <li>Transaction records</li>
            </ul>
          </div>
          <div className={styles.dataCard}>
            <div className={styles.dataIcon}>🎮</div>
            <h3>Gaming Information</h3>
            <ul>
              <li>Gaming preferences</li>
              <li>Platform information</li>
              <li>Game progress</li>
              <li>In-game achievements</li>
            </ul>
          </div>
          <div className={styles.dataCard}>
            <div className={styles.dataIcon}>📱</div>
            <h3>Technical Data</h3>
            <ul>
              <li>IP address</li>
              <li>Browser type</li>
              <li>Device information</li>
              <li>Cookies and usage data</li>
            </ul>
          </div>
        </div>
      </section>

      <section className={styles.policySection}>
        <h2>Why Data is Collected</h2>
        <p>We collect and process your personal data for the following purposes:</p>
        <div className={styles.purposeContainer}>
          <div className={styles.purposeItem}>
            <h3>To Provide Our Services</h3>
            <p>
              We use your information to process orders, deliver products, and provide customer support. This includes
              fulfilling purchases, managing your account, and responding to your inquiries.
            </p>
          </div>
          <div className={styles.purposeItem}>
            <h3>To Improve User Experience</h3>
            <p>
              We analyze how you interact with our platform to enhance our website, products, and services. This helps
              us understand what features are most valuable and identify areas for improvement.
            </p>
          </div>
          <div className={styles.purposeItem}>
            <h3>To Personalize Content</h3>
            <p>
              We use your gaming preferences and purchase history to recommend products and content that align with your
              interests, providing a more tailored experience.
            </p>
          </div>
          <div className={styles.purposeItem}>
            <h3>To Communicate With You</h3>
            <p>
              We send important updates about your orders, account, and our services. With your consent, we may also
              send promotional materials and newsletters.
            </p>
          </div>
        </div>
      </section>

      <section className={styles.policySection}>
        <h2>Data Protection Measures</h2>
        <p>INFINITY GAMER implements robust security measures to protect your personal information:</p>
        <ul className={styles.securityList}>
          <li>
            <span className={styles.securityIcon}>🔒</span>
            <div>
              <h3>Encryption</h3>
              <p>
                All sensitive data is encrypted using industry-standard SSL/TLS protocols during transmission and at
                rest.
              </p>
            </div>
          </li>
          <li>
            <span className={styles.securityIcon}>🛡️</span>
            <div>
              <h3>Access Controls</h3>
              <p>
                We restrict access to personal information to authorized employees who need it to perform their job
                functions.
              </p>
            </div>
          </li>
          <li>
            <span className={styles.securityIcon}>🔍</span>
            <div>
              <h3>Regular Audits</h3>
              <p>
                We conduct regular security audits and vulnerability assessments to identify and address potential
                risks.
              </p>
            </div>
          </li>
          <li>
            <span className={styles.securityIcon}>📝</span>
            <div>
              <h3>Data Minimization</h3>
              <p>We only collect and retain the information necessary to provide our services.</p>
            </div>
          </li>
        </ul>
        <div className={styles.securityNote}>
          <p>
            While we implement these safeguards, no method of transmission over the Internet or electronic storage is
            100% secure. We strive to use commercially acceptable means to protect your personal information but cannot
            guarantee its absolute security.
          </p>
        </div>
      </section>

      <section className={styles.policySection}>
        <h2>Third-Party Sharing Details</h2>
        <p>INFINITY GAMER may share your information with certain third parties:</p>
        <div className={styles.sharingTable}>
          <table>
            <thead>
              <tr>
                <th>Category</th>
                <th>Purpose</th>
                <th>Data Shared</th>
              </tr>
            </thead>
            <tbody>
              <tr>
                <td>Payment Processors</td>
                <td>To process transactions</td>
                <td>Payment information, purchase details</td>
              </tr>
              <tr>
                <td>Shipping Partners</td>
                <td>To deliver products</td>
                <td>Name, address, contact information, order details</td>
              </tr>
              <tr>
                <td>Game Publishers</td>
                <td>To activate games and DLC</td>
                <td>Game activation information, platform details</td>
              </tr>
              <tr>
                <td>Marketing Partners</td>
                <td>To provide targeted advertisements</td>
                <td>Anonymized usage data, preferences</td>
              </tr>
              <tr>
                <td>Analytics Providers</td>
                <td>To improve our services</td>
                <td>Usage statistics, device information</td>
              </tr>
            </tbody>
          </table>
        </div>
        <p className={styles.sharingDisclaimer}>
          We do not sell your personal information to third parties. When we share data with service providers, we
          ensure they adhere to similar privacy standards through contractual obligations.
        </p>
      </section>

      <section className={styles.policySection}>
        <h2>User Rights</h2>
        <p>As an INFINITY GAMER user, you have several rights regarding your personal data:</p>
        <div className={styles.rightsContainer}>
          <div className={styles.rightCard}>
            <h3>Right to Access</h3>
            <p>You can request a copy of the personal data we hold about you.</p>
            {/* <button className={styles.rightButton}>Access My Data</button> */}
          </div>
          <div className={styles.rightCard}>
            <h3>Right to Rectification</h3>
            <p>You can request corrections to inaccurate or incomplete information.</p>
            {/* <button className={styles.rightButton}>Update My Data</button> */}
          </div>
          <div className={styles.rightCard}>
            <h3>Right to Erasure</h3>
            <p>You can request deletion of your personal data under certain circumstances.</p>
            {/* <button className={styles.rightButton}>Delete My Data</button> */}
          </div>
          <div className={styles.rightCard}>
            <h3>Right to Restriction</h3>
            <p>You can request limited use of your data in specific situations.</p>
            {/* <button className={styles.rightButton}>Restrict Processing</button> */}
          </div>
          <div className={styles.rightCard}>
            <h3>Right to Data Portability</h3>
            <p>You can request your data in a structured, machine-readable format.</p>
            {/* <button className={styles.rightButton}>Export My Data</button> */}
          </div>
          <div className={styles.rightCard}>
            <h3>Right to Object</h3>
            <p>You can object to processing of your data for certain purposes.</p>
            {/* <button className={styles.rightButton}>Object to Processing</button> */}
          </div>
        </div>
        <p className={styles.rightsNote}>
          To exercise any of these rights, please contact our Data Protection Officer at{" "}
          <a href="mailto:privacy@infinitygamer.com" className={styles.link}>
            privacy@infinitygamer.com
          </a>
          . We will respond to your request within 30 days.
        </p>
      </section>
    </div>
    <><Footer/></>
    </>
  )
}

export default PrivacyPolicy
