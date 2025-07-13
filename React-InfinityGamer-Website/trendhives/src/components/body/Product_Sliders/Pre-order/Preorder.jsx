import React, { useEffect, useState, useContext } from "react";
import styles from "./Preorder.module.css"; 
import { FontAwesomeIcon } from "@fortawesome/react-fontawesome";
import { faShoppingBag } from "@fortawesome/free-solid-svg-icons";
import { collection, getDocs } from "firebase/firestore";
import { db } from "../../../../firebase/"; 
import { CartContext } from "../../../../pages/addtocart/CartContext"; 
import { useNavigate } from "react-router-dom";

const Preorder = () => {
  const { addToCart } = useContext(CartContext); 
  const [products, setProducts] = useState([]); 
  const navigate = useNavigate();

  useEffect(() => {
    const fetchProducts = async () => {
      try {
        const collectionRef = collection(db,'Preorder');
        const querySnapshot = await getDocs(collectionRef);
        const fetchedProducts = querySnapshot.docs.map((doc) => ({
          id: doc.id,
          ...doc.data(),
        }));
        setProducts(fetchedProducts);
      } catch (error) {
        console.error("Error fetching preorder products:", error);
      }
    };

    fetchProducts();
  }, []);

const handleShopNow = (productName) => {
  navigate("/preorder", { state: { productName } });
};

  return (
    <div className={styles["preorder-container"]}>
      <h2 className={styles["preorder-title"]}>
        <FontAwesomeIcon icon={faShoppingBag} /> PREORDER NOW
      </h2>
      <div className={styles["preorder-grid"]}>
        {products.map((product) => (
          <div key={product.id} className={styles["preorder-card"]}>
            <img
              src={product.image}
              alt={product.name}
              className={styles["preorder-image"]}
            />
            <div className={styles["preorder-content"]}>
              <h3 className={styles["preorder-game-name"]}>
                {product.name}
              </h3>
              <p className={styles["preorder-description"]}>
                {product.description}
              </p>
              <span className={styles["preorder-price"]}>
                {product.price}
              </span>
              <button
                className={styles["preorder-btn"]}
                onClick={() => handleShopNow(product.name)}
                // onClick={
                //   handleShopNow
                //   // addToCart({
                //   //   id: product.id,
                //   //   name: product.name,
                //   //   price: product.price,
                //   //   image: product.image,
                //   // })
                // }
              >
                PreOrder Now!
              </button>
            </div>
          </div>
        ))}
      </div>
    </div>
  );
};

export default Preorder;
