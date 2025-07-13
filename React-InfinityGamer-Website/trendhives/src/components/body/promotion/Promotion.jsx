import React from "react";
import "./promotion.css";

export default function Promotion() {

  const isMobile = () => window.innerWidth <= 768; 

  const handleScroll = () => {
    const scrollValue = isMobile() ? 840 : 750; 
    window.scrollTo({
      top: window.scrollY + scrollValue,
      behavior: "smooth",
    });
  };

  return (
    <div className="promotion-container">
      <video className="promo-video" autoPlay loop muted playsInline preload="auto">
        <source src="https://res.cloudinary.com/do7ttqxgn/video/upload/v1699999999/ngsdlurocrxykgzluf6u.mp4" type="video/mp4" />
      </video>

      <div className="navbar-logo">
        <img src="/assets/logo.png" alt="error" />
      </div>

      <div className="promo-text">
        <h1>Exclusive Offer!</h1>
        <p>Get up to 50% off on selected items</p>
       
        <button className="promo-btn" onClick={handleScroll}>
          Shop Now
        </button>
      </div>
    </div>
  );
}
