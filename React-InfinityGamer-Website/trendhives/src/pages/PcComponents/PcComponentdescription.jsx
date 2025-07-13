import React, { useContext } from "react";
import { useLocation, useNavigate } from "react-router-dom";
import styles from "./PcComponentdescription.module.css"; 
import { FontAwesomeIcon } from "@fortawesome/react-fontawesome";
import { faPlaystation } from "@fortawesome/free-brands-svg-icons";
import { CartContext } from "../../pages/addtocart/CartContext";
import { faComputer } from "@fortawesome/free-solid-svg-icons";

export default function PcComponentdescription() {
  const navigate = useNavigate();
  const location = useLocation();
  const { addToCart } = useContext(CartContext); 
  const product = location.state?.product;


  if (!product) {
    navigate("/");
    return null;
  }

  return (
    <div className={styles.container}>
      <button className={styles.backBtn} onClick={() => navigate(-1)}>
        &larr; Back
      </button>
      <div className={styles.mainContent}>
        <div className={styles.imageContainer}>
          <img src={product.image} alt={product.title} className={styles.image} />
        </div>
        <div className={styles.textContent}>
          <h2 className={styles.title}>
       
            {product.name}
          </h2>

      
          <div className={styles.descriptionSection}>
            <h3>Description</h3>
            <p className={styles.description}>{product.description}</p>
          </div>

          <div className={styles.aboutSection}>
            <h3>About</h3>
            <p className={styles.about}>{product.About}</p>
          </div>

   
          <div className={styles.price}>Price: {product.price}</div>

    
          <div className={styles.addToCart}>
            <button
              className={styles.cartBtn}
              onClick={() =>
                addToCart({
                  id: product.id,
                  name: product.title,
                  price: product.price,
                  image: product.image,
                })
              }
            >
              Add to Cart
            </button>
          </div>


          <div className={styles.productSpec}>
            <h3>Product Specifications</h3>
            <ul>
              {product.productspecification &&
                Object.entries(product.productspecification).map(([key, value]) => (
                  <li key={key}>
                    <strong>{key.replace(/([A-Z])/g, " $1").replace(/^./, str => str.toUpperCase())}:</strong> {value}
                  </li>
                ))}
            </ul>
          </div>

        </div>
      </div>
    </div>
  );
}
