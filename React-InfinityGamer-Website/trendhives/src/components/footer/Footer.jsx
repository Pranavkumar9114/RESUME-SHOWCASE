import React, {useEffect,useState} from "react";
import { FaFacebook, FaTwitter, FaInstagram, FaLinkedin, FaEnvelope, FaPhone, FaMapMarkerAlt } from "react-icons/fa";
import styles from "./Footer.module.css";
import { Link } from "react-router-dom";
import { ref, push } from "firebase/database";
import { database } from "../../firebase"; 
const Footer = () => {
  const [email, setEmail] = useState('');
  const isValidEmail = (email) => {
    const emailRegex = /^[a-zA-Z0-9._-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$/;
    return emailRegex.test(email);
  };
  
  const handleSubscribe = async (e) => {
    e.preventDefault();  
    if (!email) {
      alert("Please enter an email.");
      return;
    }
  
    if (!isValidEmail(email)) {
      alert("Please enter a valid email address.");
      return;
    }
  
    try {
      await push(ref(database, 'subscribers'), {
        email,
        subscribedAt: new Date().toISOString(),
      });
  
      alert("Email successfully sent!");

      setEmail('');
    } catch (error) {
      console.error('Error saving email:', error);
    }
  };
  
  useEffect(() => {
  }, [email]);  
  return (
    <footer className={styles.footer}>
      <div className={styles.footerContainer}>
  
        <div className={styles.footerBrand}>
          <h2 className={styles.footerLogo}>INFINITY GAMER</h2>
          <div className={styles.contactInfo}>
            <p><FaMapMarkerAlt /> 101 Wallfusion Lane, Mumbai, Maharashtra</p>
            <p><FaPhone /> +91 9474540466</p>
            <p><FaEnvelope /> support@InfinityGamers.com</p>
          </div>
        </div>

 
        <div className={styles.footerNav}>
          <h3>Quick Links</h3>
          <ul className={styles.footerLinks}>
            <li><Link to="/">Home</Link></li>
            <li><Link to="/About">About</Link></li>
            <li><Link to="/Playstation">Playstation</Link> </li>
            <li><Link to="/XboxShowcase">Xbox</Link> </li>
            <li><Link to="/Console"> Console Bundles</Link></li>
            <li><Link to="/ContactUs">Contact</Link></li>
            {/* <li><a href="#faq">FAQ</a></li> */}
            {/* <li><a href="#support">Support</a></li> */}
          </ul>
        </div>


        <div className={styles.footerExtras}>
          {/* <h3>Subscribe to Our Newsletter</h3>
          <form className={styles.newsletterForm}>
            <input type="email" placeholder="Enter your email" required value={email} onChange={(e) => setEmail(e.target.value)}/>
            <button type="submit"  onClick={handleSubscribe}>Subscribe</button>
          </form> */}
          
  
          <h3>Follow Us</h3>
          <div className={styles.footerSocials}>
            <a href="#" className={styles.socialIcon}><FaFacebook /></a>
            <a href="#" className={styles.socialIcon}><FaTwitter /></a>
            <a href="#" className={styles.socialIcon}><FaInstagram /></a>
            <a href="#" className={styles.socialIcon}><FaLinkedin /></a>
          </div>
        </div>
      </div>


      <button className={styles.backToTop} onClick={() => window.scrollTo({ top: 0, behavior: "smooth" })}>
        ↑ Back to Top
      </button>

  
      <p className={styles.footerCopy}>&copy; {new Date().getFullYear()} INFINITY GAMER. All rights reserved.</p>
    </footer>
  );
};

export default Footer;
