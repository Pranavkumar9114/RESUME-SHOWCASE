import React, { useContext, useEffect, useState } from "react";
import styles from "./Featured.module.css"; 
import { FontAwesomeIcon } from "@fortawesome/react-fontawesome";
import { faGamepad } from "@fortawesome/free-solid-svg-icons";
import { CartContext } from "../../../../pages/addtocart/CartContext";
import { collection, getDocs } from "firebase/firestore";
import { db } from "../../../../firebase/";
import { faPlaystation } from "@fortawesome/free-brands-svg-icons";
import { useNavigate } from "react-router-dom"; 

export default function FeaturedGames() {
  const { addToCart } = useContext(CartContext);
  const [games, setGames] = useState([]);
  const navigate = useNavigate();

  useEffect(() => {
    const fetchGames = async () => {
      try {
        const collectionRef = collection(db,'Featured');
        const querySnapshot = await getDocs(collectionRef);
        const fetchedGames = querySnapshot.docs.map((doc) => ({
          id: doc.id,
          ...doc.data(),
        }));
        setGames(fetchedGames);
      } catch (error) {
        console.error("Error fetching games:", error);
      }
    };

    fetchGames();
  }, []);

  const handleCardClick = (game) => {
    navigate("/FeaturedDescription", { state: { game } });
  };

  return (
    <div className={styles.container}>
      <h2 className={styles.title}>
        <FontAwesomeIcon icon={faGamepad} /> FEATURED GAMES
      </h2>
      <div className={styles.grid}>
        {games.map((game) => (
          <div
            key={game.id}
            className={styles.card}
            onClick={() => handleCardClick(game)}
          >
            <img src={game.image} alt={game.title} className={styles.image} />
            <div className={styles.content}>
              <h3 className={styles["game-title"]}>
                <FontAwesomeIcon icon={faPlaystation} /> {game.title}
              </h3>
              <p className={styles.description}>{game.description}</p>

              <div className={styles["price-section"]}>
                <span className={styles.price}>{game.price}</span>
              </div>

              <button
                className={styles["shop-btn"]}
                onClick={(e) => {
                  e.stopPropagation();
                  addToCart({
                    id: game.id,
                    name: game.title,
                    price: game.price,
                    image: game.image,
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
