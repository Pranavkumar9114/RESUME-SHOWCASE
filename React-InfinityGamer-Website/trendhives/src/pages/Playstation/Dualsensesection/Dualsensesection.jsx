import React, { useEffect, useState } from "react";
import styles from "./Dualsensesection.module.css";

const imageUrls = [
  "https://res.cloudinary.com/do7ttqxgn/image/upload/v1743926399/9267475_yfuwxy.jpg",
  "https://res.cloudinary.com/do7ttqxgn/image/upload/v1743926399/8845040_rcxodn.jpg",
  "https://res.cloudinary.com/do7ttqxgn/image/upload/v1743926399/7762966_chedp3.png",
];

export default function PlayStationShowcase() {
  const [currentImageIndex, setCurrentImageIndex] = useState(0);
  const [fade, setFade] = useState(true);

  useEffect(() => {
    const interval = setInterval(() => {
      setFade(false);
      setTimeout(() => {
        setCurrentImageIndex((prevIndex) => (prevIndex + 1) % imageUrls.length);
        setFade(true);
      }, 500); 
    }, 3500);

    return () => clearInterval(interval);
  }, []);

  return (
    <section className={styles.dualsense}>
      <div className={styles.wrapper}>
        <div className={styles.text}>
          <h2 className={styles.title}>Discover the Power of PlayStation</h2>
          <p className={styles.description}>
            From legendary exclusives to next-gen performance, PlayStation redefines what gaming can be. 
            Experience stunning visuals, lightning-fast loading, and immersive gameplay with the PS5 and the iconic DualSense controller.
          </p>
        </div>
        <div className={styles.imageContainer}>
          <img
            key={currentImageIndex}
            src={imageUrls[currentImageIndex]}
            alt="PlayStation Showcase"
            className={`${styles.image} ${fade ? styles.fadeIn : styles.fadeOut}`}
          />
        </div>
      </div>
    </section>
  );
}
