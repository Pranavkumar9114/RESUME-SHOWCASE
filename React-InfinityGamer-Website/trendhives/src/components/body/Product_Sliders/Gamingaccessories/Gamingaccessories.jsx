import React, { useEffect, useState, useContext } from "react";
import styles from "./Gamingaccessories.module.css"; // Import CSS module
import { FaStar } from "react-icons/fa";
import { FontAwesomeIcon } from "@fortawesome/react-fontawesome";
import { faBoxOpen } from "@fortawesome/free-solid-svg-icons";
import { CartContext } from "../../../../pages/addtocart/CartContext"; 
import { collection, getDocs } from "firebase/firestore";
import { db } from "../../../../firebase/"; 
import { useNavigate } from "react-router-dom"; 

export default function GamingAccessories() {
  const { addToCart } = useContext(CartContext);
  const [accessories, setAccessories] = useState([]); 
  const navigate = useNavigate();

  useEffect(() => {
    const fetchAccessories = async () => {
      try {
        const collectionRef = collection(db, "Gamingaccessories");
        const querySnapshot = await getDocs(collectionRef);
        const fetchedAccessories = querySnapshot.docs.map((doc) => ({
          id: doc.id,
          ...doc.data(),
        }));
        setAccessories(fetchedAccessories);
      } catch (error) {
        console.error("Error fetching accessories:", error);
      }
    };

    fetchAccessories();
  }, []);

  const handleCardClick = (item) => {
    navigate("/GamingAccessoriesDescription", { state: { item } });
  };

  return (
    <div className={styles["gaming-accessories"]}>
      <h2>
        <FontAwesomeIcon icon={faBoxOpen} /> Best Gaming Accessories for Pro Gamers
      </h2>
      <div className={styles["accessories-grid"]}>
        {accessories.map((item) => (
          <div
            key={item.id}
            className={styles["accessory-card"]}
            onClick={() => handleCardClick(item)} 
          >
            <span className={styles["rating"]}>
              <FaStar color="yellow" /> {item.rating}
            </span>
            <img src={item.image} alt={item.name} />
            <div className={styles["accessory-info"]}>
              <h3>{item.name}</h3>
              <p>{item.description}</p>
              <div className={styles["price-button"]}>
                <span className={styles["price"]}>{item.price}</span>
                <button
                  className={styles["buy-now"]}
                  onClick={(e) => {
                    e.stopPropagation(); 
                    addToCart({
                      id: item.id,
                      name: item.name,
                      price: `${item.price}`,
                      image: item.image,
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
    </div>
  );
}
