import React, { useEffect, useState } from "react";
import { collection, getDocs } from "firebase/firestore";
import { db } from "../../../firebase";
import styles from "./Playstationbanner.module.css";

export default function Playstationbanner() {
  const [images, setImages] = useState([]);
  const [currentIndex, setCurrentIndex] = useState(0);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    const fetchImages = async () => {
      const querySnapshot = await getDocs(collection(db, "playstationbanner"));
      const fetchedImages = querySnapshot.docs.map((doc) => doc.data().image);
      setImages(fetchedImages);
      setLoading(false);
    };

    fetchImages();
  }, []);

  useEffect(() => {
    if (images.length > 0) {
      const interval = setInterval(() => {
        setCurrentIndex((prevIndex) =>
          prevIndex === images.length - 1 ? 0 : prevIndex + 1
        );
      }, 4000);
      return () => clearInterval(interval);
    }
  }, [images]);

  const handleScroll = () => {
    window.scrollBy({ top: 550, behavior: "smooth" });
  };

  return (
    <div className={styles.heroBanner}>
      {loading ? (
        <div className={styles.loading}>Loading...</div>
      ) : (
        <>
          <div
            className={styles.slider}
            style={{
              transform: `translateX(-${currentIndex * 100}%)`,
            }}
          >
            {images.map((img, index) => (
              <div
                key={index}
                className={styles.slide}
                style={{ backgroundImage: `url(${img})` }}
              />
            ))}
          </div>
          <div className={styles.overlay}></div>
          <div className={styles.content}>
            <h1 className={styles.title}>PLAYSTATION</h1>
            <p className={styles.description}>
              Immerse yourself in lightning-fast loading, stunning 4K graphics,
              and next-gen gameplay.
            </p>
            <button className={styles.cta} onClick={handleScroll}>
              Explore PS5
            </button>
          </div>
        </>
      )}
    </div>
  );
}
