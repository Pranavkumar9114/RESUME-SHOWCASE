import React, { useEffect, useState, useContext } from "react";
import styles from "./SearchPage.module.css";
import { useNavigate } from "react-router-dom";
import { FontAwesomeIcon } from "@fortawesome/react-fontawesome";
import { faSearch } from "@fortawesome/free-solid-svg-icons";
import { collection, getDocs } from "firebase/firestore";
import { db } from "../../firebase/";
import Navbar from "../../components/navbar/Navbar";
import { CartContext } from "../../pages/addtocart/CartContext";

const collectionsToSearch = [
  "Exclusivedealdiscount",
  "Featured",
  "Gamingaccessories",
  "consoleBundles",
];

const SearchPage = () => {
  const navigate = useNavigate();
  const { addToCart } = useContext(CartContext);
  const [products, setProducts] = useState([]);
  const [filteredProducts, setFilteredProducts] = useState([]);
  const [searchTerm, setSearchTerm] = useState("");
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    const fetchProducts = async () => {
      try {
        setLoading(true);
        let combinedProducts = [];

        for (const collectionName of collectionsToSearch) {
          const collectionRef = collection(db, collectionName);
          const querySnapshot = await getDocs(collectionRef);

          const fetchedProducts = querySnapshot.docs.map((doc) => {
            const data = doc.data();
            let product = { id: `${collectionName}-${doc.id}`, collectionName };

            switch (collectionName) {
              case "consoleBundles":
                product = {
                  ...product,
                  name: data.name,
                  image: data.image,
                  price: data.price,
                  rating: data.rating,
                  details: data.details,
                  about: data.about,
                  productSpecification: data.productSpecification
                };
                break;

              case "Featured":
                product = {
                  ...product,
                  title: data.title,
                  description: data.description,
                  image: data.image,
                  price: data.price,
                  About: data.About,
                  productspecification: data.productspecification
                };
                break;

              case "Gamingaccessories":
                product = {
                  ...product,
                  name: data.name,
                  description: data.description,
                  price: data.price,
                  rating: data.rating,
                  image: data.image,
                  about: data.about,
                  productSpecification: data.productSpecification
                };
                break;

              case "Exclusivedealdiscount":
                product = {
                  ...product,
                  title: data.title,
                  description: data.description,
                  image: data.image,
                  discount: data.discount,
                  rating: data.rating,
                  originalPrice: data.originalPrice,
                  about: data.about,
                  productSpecification: data.productSpecification
                };
                break;

              default:
                break;
            }

            return product;
          });

          combinedProducts = [...combinedProducts, ...fetchedProducts];
        }

        const calculatedProducts = combinedProducts.map((product) => {
          if (
            product.collectionName === "Exclusivedealdiscount" &&
            product.originalPrice &&
            product.discount
          ) {
            const calculatedPrice =
              product.originalPrice -
              (product.originalPrice * product.discount) / 100;
            return {
              ...product,
              price: calculatedPrice.toFixed(2), 
            };
          }
          return product;
        });

        setProducts(calculatedProducts);
        setLoading(false);
      } catch (error) {
        console.error("Error fetching products:", error);
        setLoading(false);
      }
    };

    fetchProducts();
  }, []);


  const handleSearch = (event) => {
    const keyword = event.target.value.toLowerCase();
    setSearchTerm(keyword);

    const filtered = products.filter(
      (product) =>
        product.title?.toLowerCase().includes(keyword) ||
        product.name?.toLowerCase().includes(keyword) ||
        product.description?.toLowerCase().includes(keyword)
    );

    setFilteredProducts(filtered);
  };

  const consoleBundlesClick = (bundle) => {
    navigate(`/ConsoleBundleDescription`, { state: { bundle } }); 
  };
  const FeaturedClick = (game) => {
    navigate(`/FeaturedDescription`, { state: { game } }); 
  };
  const GamingAccessoriesClick = (item) => {
    navigate(`/GamingAccessoriesDescription`, { state: { item } });
  };
  const ExclusivedealdiscountClick = (deal) => {
    navigate(`/ExclusivedealdiscountDescription`, { state: { deal } }); 
  };

  const renderProductCard = (product) => {
    const handleAddToCart = () => {
      addToCart({
        id: product.id,
        name: product.name || product.title,
        image: product.image,
        price: product.price,
        collectionName: product.collectionName,
      });
    };
    switch (product.collectionName) {
      case "consoleBundles":
        return (
          <div
            key={product.id}
            className={styles["product-card"]}
            onClick={() => consoleBundlesClick(product)}
          >
            <img
              src={product.image}
              alt={product.name}
              className={styles["product-image"]}
            />
            <h3 className={styles["product-title"]}>{product.name}</h3>
            <p className={styles["product-details"]}>{product.details}</p>
            <span className={styles["product-rating"]}>
              Rating: {product.rating}
            </span>
            <span className={styles["product-price"]}>
              Price: {product.price}
            </span>
            <button className={styles["add-to-cart-button"]} onClick={handleAddToCart}>
              Add to Cart
            </button>
          </div>
        );

      case "Featured":
        return (
          <div
            key={product.id}
            className={styles["product-card"]}
            onClick={() => FeaturedClick(product)}
          >
            <img
              src={product.image}
              alt={product.title}
              className={styles["product-image"]}
            />
            <h3 className={styles["product-title"]}>{product.title}</h3>
            <p className={styles["product-description"]}>
              {product.description}
            </p>
            <span className={styles["product-price"]}>
              Price: {product.price}
            </span>
            <button className={styles["add-to-cart-button"]} onClick={handleAddToCart}>
              Add to Cart
            </button>
          </div>
        );

      case "Gamingaccessories":
        return (
          <div
            key={product.id}
            className={styles["product-card"]}
            onClick={() => GamingAccessoriesClick(product)}
          >
            <img
              src={product.image}
              alt={product.name}
              className={styles["product-image"]}
            />
            <h3 className={styles["product-title"]}>{product.name}</h3>
            <p className={styles["product-description"]}>
              {product.description}
            </p>
            <span className={styles["product-rating"]}>
              Rating: {product.rating}
            </span>
            <span className={styles["product-price"]}>
              Price: {product.price}
            </span>
            <button className={styles["add-to-cart-button"]} onClick={handleAddToCart}>
              Add to Cart
            </button>
          </div>
        );

      case "Exclusivedealdiscount":
        return (
          <div key={product.id} className={styles["product-card"]}
            onClick={() => ExclusivedealdiscountClick(product)}
          >

            <img
              src={product.image}
              alt={product.title}
              className={styles["product-image"]}
            />
            <h3 className={styles["product-title"]}>{product.title}</h3>
            <p className={styles["product-description"]}>
              {product.description}
            </p>
            <span className={styles["product-rating"]}>
              Rating: {product.rating}
            </span>
            <span className={styles["product-price"]}>
              Price: ₹{product.price}
            </span>
            <button className={styles["add-to-cart-button"]} onClick={handleAddToCart}>
              Add to Cart
            </button>
          </div>
        );


      default:
        return null;
    }
  };

  return (
    <><>
      <Navbar />
    </><div className={styles["search-container"]}>
        <div className={styles["search-bar"]}>
          <input
            type="text"
            placeholder="Search for products..."
            value={searchTerm}
            onChange={handleSearch}
            className={styles["search-input"]} />
          <FontAwesomeIcon icon={faSearch} className={styles["search-icon"]} />
        </div>
        <div className={styles["results-grid"]}>
          {loading ? (
            <div className={styles["results-loading"]}>
              <div className={styles["spinner"]}></div>
            </div>
          ) : searchTerm && filteredProducts.length > 0 ? (
            filteredProducts.map((product) => renderProductCard(product))
          ) : searchTerm && filteredProducts.length === 0 ? (
            <p className={styles["no-results"]}>No products found.</p>
          ) : (
            <p className={styles["no-results"]}>Search is now available! Start typing to find products.</p>
          )}
        </div>

      </div></>
  );
};

export default SearchPage;
