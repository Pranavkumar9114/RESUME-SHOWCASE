import React from "react";
import { Link } from "react-router-dom"; 
import "./showcase.css";
import products from "./Showcase.json";

export default function Showcase() {
  return (
    <div className="showcase-container">
      {products.map((product) => (
        <div key={product.id} className={`product-card ${product.color}`}>
          <img src={product.image} alt={product.name} className="product-image" />
          <h2 className="product-title">{product.name}</h2>
          <p className="product-description">{product.description}</p>

   
          <Link to={product.link} className="product-button-link">
            Learn More
          </Link>
        </div>
      ))}
    </div>
  );
}
