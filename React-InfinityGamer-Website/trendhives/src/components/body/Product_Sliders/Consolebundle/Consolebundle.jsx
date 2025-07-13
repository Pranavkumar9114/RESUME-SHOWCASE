import React, { useContext, useEffect, useState } from "react";
import styles from "./ConsoleBundle.module.css";
import { FaStar } from "react-icons/fa";
import { useNavigate } from "react-router-dom";
import { CartContext } from "../../../../pages/addtocart/CartContext";
import { collection, getDocs } from "firebase/firestore";
import { db } from "../../../../firebase/";

export default function ConsoleBundle() {
  const { addToCart } = useContext(CartContext);
  const [bundlesData, setBundlesData] = useState([]);
  const navigate = useNavigate();

  useEffect(() => {
    const fetchData = async () => {
      try {
        const collectionRef = collection(db, "consoleBundles");
        const querySnapshot = await getDocs(collectionRef);
        const fetchedData = querySnapshot.docs.map((doc) => ({
          id: doc.id,
          ...doc.data(),
        }));
        setBundlesData(fetchedData);
      } catch (error) {
        console.error("Error fetching console bundles:", error);
      }
    };

    fetchData();
  }, []);

  const handleCardClick = (bundle) => {
    navigate("/ConsoleBundleDescription", { state: { bundle } });
  };

  return (
    <section className={styles.consoleBundles}>
      <h2 className={styles.sectionTitle}>Console Bundles</h2>
      <div className={styles.bundleGrid}>
        {bundlesData.map((bundle) => (
          <div
            key={bundle.id}
            className={styles.bundleCard}
            onClick={() => handleCardClick(bundle)}
          >
            <span className={styles.bundleRating}>
              <FaStar color="yellow" /> {bundle.rating}
            </span>
            <img src={bundle.image} alt={bundle.name} className={styles.bundleImage} />
            <div className={styles.bundleContent}>
              <h3 className={styles.bundleTitle}>{bundle.name}</h3>
              <p className={styles.bundleDescription}>{bundle.details}</p>
              <div className={styles.bundleFooter}>
                <span className={styles.bundlePrice}>{bundle.price}</span>
                <button
                  className={styles.bundleButton}
                  onClick={(e) => {
                    e.stopPropagation();
                    addToCart({
                      id: bundle.id,
                      name: bundle.name,
                      price: bundle.price,
                      image: bundle.image,
                    });
                  }}
                >
                  Add To Cart
                </button>
              </div>
            </div>
          </div>
        ))}
      </div>
    </section>
  );
}
