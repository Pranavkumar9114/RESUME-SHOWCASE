import React from "react";
import styles from "./ExclusiveTitles.module.css";

const games = [
  { title: "Returnal", image: "/images/returnal.jpg", rating: "9.0", platform: "PS5" },
  { title: "Demon's Souls", image: "/images/demonsouls.jpg", rating: "8.5", platform: "PS5" },
  { title: "Astro's Playroom", image: "/images/astro.jpg", rating: "8.0", platform: "PS5" },
];

export default function Exclusivetitles() {
  return (
    <section className={styles.exclusiveSection}>
      <h2>Exclusive Titles</h2>
      <div className={styles.grid}>
        {games.map((game, index) => (
          <div className={styles.card} key={index}>
            <img src={game.image} alt={game.title} />
            <div className={styles.details}>
              <h3>{game.title}</h3>
              <p>Rating: {game.rating}</p>
              <p>Platform: {game.platform}</p>
            </div>
          </div>
        ))}
      </div>
    </section>
  );
}
