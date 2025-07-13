import React, { useContext } from "react";
import styles from "./ExclusivedealdiscountDescription.module.css";
import { useLocation, useNavigate } from "react-router-dom";
import { CartContext } from "../../../../pages/addtocart/CartContext";
import { FaStar } from "react-icons/fa";

export default function ExclusivedealdiscountDescription() {
    const location = useLocation();
    const navigate = useNavigate();
    const { addToCart } = useContext(CartContext);

    const item = location.state?.deal;

    if (!item) {
        return (
            <div className={styles["not-found"]}>
                <h2>Deal Not Found</h2>
                <button onClick={() => navigate("/")}>Go Back</button>
            </div>
        );
    }

    return (
        <div className={styles["description-container"]}>

            <button className={styles["go-back"]} onClick={() => navigate(-1)}>
                ← Back
            </button>

  
            <div className={styles["image-container"]}>
                <img src={item.image} alt={item.title} />
            </div>


            <div className={styles["details-container"]}>

                <h2 className={styles["product-title"]}>{item.title}</h2>


                <h3 className={styles["section-title"]}>Description</h3>
                <p className={styles["description"]}>{item.description}</p>

                <h3 className={styles["section-title"]}>About</h3>
                <p className={styles["description"]}>{item.about}</p>


                <h3 className={styles["section-title"]}>Rating</h3>
                <div className={styles["rating"]}>
                    <FaStar color="gold" />
                    <span>{item.rating} / 5</span>
                </div>

 
                <h3 className={styles["section-title"]}>Price</h3>
                <div className={styles["price-container"]}>
    
                    <div className={styles["price-box"]}>
                        <h4 className={styles["price-heading"]}>Original Price:</h4>
                        <span className={styles["original-price"]}>
                        ₹{item.originalPrice.toFixed(2)}
                        </span>
                    </div>

                    <div className={styles["price-box"]}>
                        <h4 className={styles["price-heading"]}>Discounted Price:</h4>
                        <span className={styles["discounted-price"]}>
                        ₹{((item.originalPrice * (1 - item.discount / 100)).toFixed(2))}
                        </span>
                    </div>
                </div>


                <button
                    className={styles["add-to-cart"]}
                    onClick={() =>
                        addToCart({
                            id: item.id,
                            name: item.title,
                            price: (item.originalPrice - (item.originalPrice * item.discount) / 100).toFixed(2),
                            image: item.image,
                        })
                    }
                >
                    Add to Cart
                </button>

                {item.productSpecification && Object.keys(item.productSpecification).length > 0 ? (
                    <div className={styles["product-specs"]}>
                        <h3 className={styles["section-title"]}>Product Specifications</h3>
                        <ul>
                            {Object.entries(item.productSpecification).map(([key, value]) => (
                                <li key={key}>
                                    <strong>{key.replace(/_/g, " ")}:</strong> {value}
                                </li>
                            ))}
                        </ul>
                    </div>
                ) : (
                    <p className={styles["no-specs"]}>No specifications available</p>
                )}
            </div>
        </div>
    );
}
