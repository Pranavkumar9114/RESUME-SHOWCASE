import React, { useContext } from "react";
import { useLocation, useNavigate } from "react-router-dom";
import styles from "./FeaturedDescription.module.css"; // Using CSS Modules
import { FontAwesomeIcon } from "@fortawesome/react-fontawesome";
import { faPlaystation } from "@fortawesome/free-brands-svg-icons";
import { CartContext } from "../../../../pages/addtocart/CartContext"; // Import CartContext

export default function FeaturedDescription() {
  const navigate = useNavigate();
  const location = useLocation();
  const { addToCart } = useContext(CartContext); // Access addToCart function
  const game = location.state?.game; // Access the game object passed via state

  // Redirect if no game data is found
  if (!game) {
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
          <img src={game.image} alt={game.title} className={styles.image} />
        </div>
        <div className={styles.textContent}>
          <h2 className={styles.title}>
            <FontAwesomeIcon icon={faPlaystation} className={styles.icon} /> 
            {game.title}
          </h2>

          {/* Description Section */}
          <div className={styles.descriptionSection}>
            <h3>Description</h3>
            <p className={styles.description}>{game.description}</p>
          </div>

          {/* About Section */}
          <div className={styles.aboutSection}>
            <h3>About</h3>
            <p className={styles.about}>{game.About}</p>
          </div>

          {/* Price Section */}
          <div className={styles.price}>Price: {game.price}</div>

          {/* Add to Cart / Buy Now Section */}
          <div className={styles.addToCart}>
            <button
              className={styles.cartBtn}
              onClick={() =>
                addToCart({
                  id: game.id,
                  name: game.title,
                  price: game.price,
                  image: game.image,
                })
              }
            >
              Add to Cart
            </button>
          </div>

          {/* Product Specifications Section */}
          <div className={styles.productSpec}>
            <h3>Product Specifications</h3>
            <ul>
              {game.productspecification &&
                Object.entries(game.productspecification).map(([key, value]) => (
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
