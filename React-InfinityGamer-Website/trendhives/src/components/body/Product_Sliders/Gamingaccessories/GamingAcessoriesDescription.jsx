import React, { useContext } from "react";
import styles from "./GamingAccessoriesDescription.module.css";
import { useLocation, useNavigate } from "react-router-dom";
import { CartContext } from "../../../../pages/addtocart/CartContext";
import { FaStar } from "react-icons/fa";

export default function GamingAccessoriesDescription() {
    const location = useLocation();
    const navigate = useNavigate();
    const { addToCart } = useContext(CartContext);


    const item = location.state?.item;

    if (!item) {
        return (
            <div className={styles["not-found"]}>
                <h2>Item Not Found</h2>
                <button onClick={() => navigate("/GamingAccessories")}>Go Back</button>
            </div>
        );
    }

    return (
        <div className={styles["description-container"]}>
      
            <button className={styles["go-back"]} onClick={() => navigate(-1)}>
                ← Back
            </button>

      
            <div className={styles["image-container"]}>
                <img src={item.image} alt={item.name} />
            </div>

      
            <div className={styles["details-container"]}>

                <h2 className={styles["product-title"]}>{item.name}</h2>


                <h3 className={styles["section-title"]}>Description</h3>
                <p className={styles["description"]}>{item.description}</p>
                <h3 className={styles["section-title"]}>About</h3>
                {item.about && <p className={styles["description"]}>{item.about}</p>}

                <h3 className={styles["section-title"]}>Rating</h3>
                <div className={styles["rating"]}>
                    <FaStar color="gold" />
                    <span>{item.rating} / 5</span>
                </div>

                <h3 className={styles["section-title"]}>Price</h3>
                <div className={styles["price"]}>{item.price}</div>

                <button
                    className={styles["add-to-cart"]}
                    onClick={() =>
                        addToCart({
                            id: item.id,
                            name: item.name,
                            price: `$${item.price}`,
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
