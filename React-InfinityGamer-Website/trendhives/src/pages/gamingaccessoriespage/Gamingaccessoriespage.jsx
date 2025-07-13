import React, { useState,useEffect,useContext } from "react";
import styles from "./Gamingaccessoriespage.module.css"
import Navbar from "../../components/navbar/Navbar"
import Footer from "../../components/footer/Footer"
import { collection, getDocs } from "firebase/firestore";
import { db } from "../../firebase";
import { CartContext } from "../../pages/addtocart/CartContext"; 
import GamingAccessories from "../../components/body/Product_Sliders/Gamingaccessories/Gamingaccessories";
import { useNavigate } from "react-router-dom";

const GamingAccessoriesPage = () => {
    const { addToCart } = useContext(CartContext);
    const [gamingaccessoriespage, setGamingaccessoriespage] = useState([]);
    const [loading, setLoading] = useState(true);

    const navigate = useNavigate();


  useEffect(() => {
    const fetchGamingaccessoriespage = async () => {
      try {
        const querySnapshot = await getDocs(collection(db, "Gamingaccessoriespage"));
        const games = querySnapshot.docs.map(doc => ({ id: doc.id, ...doc.data() }));
        setGamingaccessoriespage(games);
      } catch (error) {
        console.error("Error fetching featured games:", error);
      } finally {
        setLoading(false);
      }
    };

    fetchGamingaccessoriespage();
  }, []);

  const handleCardClick = (product) => {
    navigate("/Gamingaccessoriespagedescription", { state: { product } });
  };

  return (
    <div className={styles.container}>
        <><Navbar/></>
      {/* Banner Section */}
      <section className={styles.banner}>
  <video
    autoPlay
    muted
    loop
    playsInline
    className={styles.bannerVideo}
  >
    <source src="https://res.cloudinary.com/do7ttqxgn/video/upload/v1744131776/61755-500762205_gnp8fk.mp4" type="video/mp4" />
    Your browser does not support the video tag.
  </video>

  <div className={styles.bannerOverlay}>
    <h1 className={styles.bannerTitle}>GEAR UP FOR BATTLE</h1>
    <h2 className={styles.bannerSubtitle}>Top-Tier Gaming Accessories Across Every Genre</h2>
  </div>
</section>


      {/* Features Section */}
      <section className={styles.featuresSection}>
        <div className={styles.featureCard}>
          <div className={styles.featureIcon}>🎧</div>
          <h3 className={styles.featureTitle}>Immersive Audio</h3>
          <p className={styles.featureDescription}>Experience 3D sound like never before</p>
        </div>
        <div className={styles.featureCard}>
          <div className={styles.featureIcon}>⚡</div>
          <h3 className={styles.featureTitle}>Lightning Response</h3>
          <p className={styles.featureDescription}>Zero lag, instant reaction time</p>
        </div>
        <div className={styles.featureCard}>
          <div className={styles.featureIcon}>🔥</div>
          <h3 className={styles.featureTitle}>Pro-Grade Gear</h3>
          <p className={styles.featureDescription}>Equipment trusted by esports champions</p>
        </div>
        <div className={styles.featureCard}>
          <div className={styles.featureIcon}>🛡️</div>
          <h3 className={styles.featureTitle}>Built To Last</h3>
          <p className={styles.featureDescription}>Durable construction for intense gaming sessions</p>
        </div>
      </section>

      {/* Product List Section */}
      <section className={styles.productsSection}>
        <h2 className={styles.sectionTitle}>ELITE GAMING GEAR</h2>
        <div className={styles.productsGrid}>
          {gamingaccessoriespage.map((product) => (
            <div key={product.id} className={styles.productCard} onClick={() => handleCardClick(product)}>
              <div className={styles.productImageContainer}>
                <img src={product.image || "/placeholder.svg"} alt={product.title} className={styles.productImage} />
              </div>
              <div className={styles.productInfo}>
                <h3 className={styles.productTitle}>{product.title}</h3>
                <div className={styles.productGenre}>{product.genre}</div>
                <p className={styles.productDescription}>{product.description}</p>
                <div className={styles.productFooter}>
                  <span className={styles.productPrice}>₹{product.price}</span>
                  <button className={styles.addToCartButton} onClick={(e) => {
                  e.stopPropagation(); 
                  addToCart({
                    id: product.id,
                    name: product.title,
                    price: product.price,
                    image: product.image,
                  });
                }}>
                    ADD TO CART
                  </button>
                </div>
              </div>
            </div>
          ))}
        </div>
      </section>

      <><GamingAccessories/></>

      {/* Footer Call-to-Action */}
      {/* <section className={styles.ctaSection}>
        <h2 className={styles.ctaTitle}>JOIN THE GUILD</h2>
        <p className={styles.ctaDescription}>Subscribe for exclusive deals and early access to new gear</p>
        <div className={styles.ctaForm}>
          <input type="email" placeholder="Enter your email" className={styles.ctaInput} />
          <button className={styles.ctaButton}>SUBSCRIBE</button>
        </div>
      </section> */}
      <><Footer/></>
    </div>
  )
}

export default GamingAccessoriesPage
