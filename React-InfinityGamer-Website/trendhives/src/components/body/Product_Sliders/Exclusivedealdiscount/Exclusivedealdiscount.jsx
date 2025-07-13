import React, { useContext, useEffect, useState } from "react";
import { useNavigate } from "react-router-dom"; 
import style from "./Exclusivedealdiscount.module.css";
import { FaStar } from "react-icons/fa"; 
import { FontAwesomeIcon } from "@fortawesome/react-fontawesome";
import { faTags } from "@fortawesome/free-solid-svg-icons";
import { CartContext } from "../../../../pages/addtocart/CartContext"; 
import { collection, getDocs } from "firebase/firestore";
import { db } from "../../../../firebase/"; 

export default function Exclusivedealdiscount() {
  const { addToCart } = useContext(CartContext); 
  const [deals, setDeals] = useState([]); 
  const navigate = useNavigate(); 

  useEffect(() => {
    const fetchDeals = async () => {
      try {
        const collectionRef = collection(db, "Exclusivedealdiscount");
        const querySnapshot = await getDocs(collectionRef);
        const fetchedDeals = querySnapshot.docs.map((doc) => ({
          id: doc.id,
          ...doc.data(),
        }));
        setDeals(fetchedDeals);
      } catch (error) {
        console.error("Error fetching deals:", error);
      }
    };

    fetchDeals();
  }, []);

  const handleCardClick = (deal) => {
    navigate("/ExclusivedealdiscountDescription", { state: { deal } });
  };

  return (
    <div className={style.exclusiveDeals}>
      <h2 className={style.exclusiveTitle}>
        <FontAwesomeIcon icon={faTags} /> Exclusive Deals & Discounts
      </h2>
      <div className={style.dealsContainer}>
        {deals.map((deal) => (
          <div
            className={style.dealCard}
            key={deal.id}
            onClick={() => handleCardClick(deal)} 
            style={{ cursor: "pointer" }}
          >
            <img src={deal.image} alt={deal.title} className={style.dealImage} />
            <div className={style.dealInfo}>
              <h3 className={style.dealTitle}>{deal.title}</h3>
              <p className={style.dealDescription}>{deal.description}</p>

              <div className={style.dealRating}>
                {[...Array(5)].map((_, i) => (
                  <FaStar key={i} color={i < deal.rating ? "#ffcc00" : "#ccc"} />
                ))}
                <span className={style.ratingScore}>{deal.rating}/5</span>
              </div>

              <div className={style.dealPricing}>
                <span className={style.originalPrice}>₹{deal.originalPrice}</span>
                <span className={style.discountedPrice}>
                ₹{(deal.originalPrice - (deal.originalPrice * deal.discount) / 100).toFixed(2)}
                </span>
              </div>

              <button
                className={style.dealButton}
                onClick={(e) => {
                  e.stopPropagation();
                  addToCart({
                    id: deal.id,
                    name: deal.title,
                    price: `₹${(deal.originalPrice - (deal.originalPrice * deal.discount) / 100).toFixed(2)}`,
                    image: deal.image,
                  });
                }}
              >
                Add to Cart
              </button>
            </div>
          </div>
        ))}
      </div>
    </div>
  );
}
