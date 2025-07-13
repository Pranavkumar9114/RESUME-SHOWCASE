import React from 'react';
import styles from './Featuredshowcase.module.css';

export default function Featuredshowcase() {
  const features = [
    {
      title: 'Fast Loading',
      description: 'Experience lightning-fast loading with the PS5 console.',
      image: 'https://cdn-icons-png.flaticon.com/512/2165/2165004.png', 
    },
    {
      title: 'Immersive Gameplay',
      description: 'Enjoy next-gen gameplay with stunning 4K graphics.',
      image: 'https://cdn-icons-png.flaticon.com/512/2920/2920257.png',
    },
    {
      title: 'Adaptive Triggers',
      description: 'Feel the tension of your in-game actions with the DualSense controller.',
      image: 'https://cdn-icons-png.flaticon.com/512/2025/2025064.png',
    },
    {
      title: 'Haptic Feedback',
      description: 'Experience realistic sensations through the DualSense controller.',
      image: 'https://cdn-icons-png.flaticon.com/512/2088/2088617.png',
    },
  ];

  return (
    <div className={styles.featureShowcase}>
      <h2 className={styles.title}>PLAYSTATION FEATURES</h2>
      <div className={styles.features}>
        {features.map((feature, index) => (
          <div key={index} className={styles.feature} style={{ animationDelay: `${index * 0.3}s` }}>
            <img src={feature.image} alt={feature.title} className={styles.image} />
            <h3 className={styles.featureTitle}>{feature.title}</h3>
            <p className={styles.featureDescription}>{feature.description}</p>
          </div>
        ))}
      </div>
    </div>
  );
}
