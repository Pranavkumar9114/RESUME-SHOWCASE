import React, { useState, useRef, useEffect, useContext } from "react";
import styles from "./PcComponent.module.css"
import { collection, getDocs } from "firebase/firestore";
import { db, database } from "../../firebase"; 
import Footer from "../../components/footer/Footer";
import Navbar from "../../components/navbar/Navbar";
import { CartContext } from "../../pages/addtocart/CartContext"; 
import { useNavigate } from "react-router-dom"; 
import { ref, push } from "firebase/database";

const PcComponent = () => {
    const { addToCart } = useContext(CartContext); 
    const [PcComponentCategories, setPcComponentCategories] = useState([]);
    const [loading, setLoading] = useState(true);
    const [darkMode, setDarkMode] = useState(true)
    const [expandedFaq, setExpandedFaq] = useState(null)
    const videoRef = useRef(null);
    const sourceRef = useRef(null);
    const [currentIndex, setCurrentIndex] = useState(0);
    const [isFading, setIsFading] = useState(false);

    const toggleDarkMode = () => {
        setDarkMode(!darkMode)
    }

    const toggleFaq = (index) => {
        setExpandedFaq(expandedFaq === index ? null : index)
    }

    const navigate = useNavigate();

    // Product data
    useEffect(() => {
        const fetchPcComponentCategories = async () => {
            try {
                const querySnapshot = await getDocs(collection(db, "PcComponentCategories"));
                const games = querySnapshot.docs.map(doc => ({ id: doc.id, ...doc.data() }));
                setPcComponentCategories(games);
            } catch (error) {
                console.error("Error fetching featured games:", error);
            } finally {
                setLoading(false);
            }
        };

        fetchPcComponentCategories();
    }, []);

    const bestSellers = [
        {
            id: 1,
            name: "RTX 4090 Ti Supernova",
            price: "₹1999.99",
            image: "/placeholder.svg?height=200&width=200",
            rating: 4.9,
            sales: 1245,
        },
        {
            id: 5,
            name: "Ryzen 9 7950X",
            price: "₹549.99",
            image: "/placeholder.svg?height=200&width=200",
            rating: 4.8,
            sales: 2341,
        },
        {
            id: 8,
            name: "Corsair Dominator DDR5-7200",
            price: "₹249.99",
            image: "/placeholder.svg?height=200&width=200",
            rating: 4.7,
            sales: 1876,
        },
        {
            id: 10,
            name: "Samsung 990 PRO",
            price: "₹229.99",
            image: "/placeholder.svg?height=200&width=200",
            rating: 4.9,
            sales: 3210,
        },
    ]

    const reviews = [
        {
            id: 1,
            name: "Alex Johnson",
            rating: 5,
            text: "The RTX 4090 Ti transformed my gaming experience. Incredible performance and the build quality is exceptional.",
        },
        {
            id: 2,
            name: "Sarah Miller",
            rating: 4,
            text: "Ryzen 9 7950X is a beast for content creation. My render times are cut in half compared to my previous setup.",
        },
        {
            id: 3,
            name: "David Chen",
            rating: 5,
            text: "The Samsung 990 PRO is lightning fast. Boot times are practically non-existent now. Worth every penny!",
        },
    ]

    const faqs = [
        {
            id: 1,
            question: "What's the difference between DDR4 and DDR5 RAM?",
            answer:
                "DDR5 offers higher bandwidth, better power efficiency, and higher capacity modules compared to DDR4. It's the latest generation of memory technology designed for newer motherboards and processors.",
        },
        {
            id: 2,
            question: "Do I need a PCIe 4.0 SSD?",
            answer:
                "PCIe 4.0 SSDs offer significantly faster read/write speeds compared to PCIe 3.0 models. If you frequently transfer large files or want the best gaming load times, a PCIe 4.0 SSD is worth considering.",
        },
        {
            id: 3,
            question: "How do I know if components are compatible?",
            answer:
                "Check motherboard socket type for CPU compatibility, RAM type/speed support, and PCIe version compatibility for GPUs and SSDs. Our product pages list all compatibility requirements.",
        },
        {
            id: 4,
            question: "What PSU wattage do I need?",
            answer:
                "Calculate your system's power requirements by adding up component TDPs, then add 20-30% headroom. High-end GPUs like the RTX 4090 typically require at least an 850W PSU.",
        },
        {
            id: 5,
            question: "Do you offer assembly services?",
            answer:
                "Yes! We offer professional PC building services with any purchase of components. Our technicians will assemble, test, and optimize your system for an additional fee.",
        },
    ]

    const features = [
        {
            id: 1,
            icon: "🚀",
            title: "Premium Performance",
            description: "Cutting-edge components that deliver unmatched speed and reliability",
        },
        {
            id: 2,
            icon: "🛡️",
            title: "3-Year Warranty",
            description: "Extended protection on all premium components for peace of mind",
        },
        {
            id: 3,
            icon: "🔧",
            title: "Expert Support",
            description: "24/7 technical assistance from certified PC building professionals",
        },
        { id: 4, icon: "🚚", title: "Fast Shipping", description: "Free next-day delivery on orders over $500" },
    ]

    const videoUrls = [
        "https://res.cloudinary.com/do7ttqxgn/video/upload/v1744039486/vecteezy_nvidia-logo-animation_50733667_b3jj1w.mp4",
        "https://res.cloudinary.com/do7ttqxgn/video/upload/v1744039835/vecteezy_intel-logo-animation_50733679_hy3c47.mp4",
        "https://res.cloudinary.com/do7ttqxgn/video/upload/v1744039824/vecteezy_amd-logo-animation_50733692_pjvk9p.mp4"
    ];
    useEffect(() => {
        const videoElement = videoRef.current;

        const handleVideoEnd = () => {
            setIsFading(true); 

            setTimeout(() => {
         
                const nextIndex = (currentIndex + 1) % videoUrls.length;
                setCurrentIndex(nextIndex);

                if (sourceRef.current && videoElement) {
                    sourceRef.current.src = videoUrls[nextIndex];
                    videoElement.load();
                    videoElement.play();
                }

                setIsFading(false); 
            }, 800); 
        };

        videoElement.addEventListener("ended", handleVideoEnd);
        return () => {
            videoElement.removeEventListener("ended", handleVideoEnd);
        };
    }, [currentIndex]);

    const handleCardClick = (product) => {
        navigate("/PcComponentdescription", { state: { product } });
    };


    const [email, setEmail] = useState('');

 
    const isValidEmail = (email) => {
      const emailRegex = /^[a-zA-Z0-9._-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$/;
      return emailRegex.test(email);
    };
  
    const handleSubscribe = async () => {
      if (!email) {
        alert("Please enter an email.");
        return;
      }
  
      if (!isValidEmail(email)) {
        alert("Please enter a valid email address.");
        return;
      }
  
      try {

        await push(ref(database, 'subscribers'), {
          email,
          subscribedAt: new Date().toISOString(),
        });
  
      
        alert("Email successfully sent!");
  
   
        setEmail('');
      } catch (error) {
        console.error('Error saving email:', error);
      }
    };
  
   
    useEffect(() => {
    }, [email]);  


    return (
        <div className={`${styles.container} ${darkMode ? styles.darkMode : ""}`}>

            <><Navbar /></>

            {/* Hero Section */}
            <section className={styles.hero}>
                <video
                    ref={videoRef}
                    className={`${styles.videoBackground} ${isFading ? styles.fadeOut : styles.fadeIn}`}
                    autoPlay
                    muted
                    playsInline
                    preload="auto"
                >
                    <source ref={sourceRef} src={videoUrls[currentIndex]} type="video/mp4" />
                    Your browser does not support the video tag.
                </video>

                <div className={styles.heroContent}>
                    <h1>Elite PC Components</h1>
                    <p>Build your dream machine with premium parts designed for power users</p>
                    <button className={styles.ctaButton}>Shop Now</button>
                </div>
            </section>

            {/* Features Section */}
            <section className={styles.features}>
                {features.map((feature) => (
                    <div key={feature.id} className={styles.featureCard}>
                        <div className={styles.featureIcon}>{feature.icon}</div>
                        <h3>{feature.title}</h3>
                        <p>{feature.description}</p>
                    </div>
                ))}
            </section>

            {/* Categories Section */}
            <section id="categories" className={styles.categories}>
                <h2>COMPONENT CATEGORIES</h2>
                <div className={styles.categoriesGrid}>
                    {PcComponentCategories.map((category) => (
                        <div key={category.id} className={styles.categoryCard}>
                            <div className={styles.categoryHeader}>
                                <span className={styles.categoryIcon}>{category.icon}</span>
                                <h3>{category.name}</h3>
                            </div>
                            <div className={styles.productsGrid}>
                                {category.products.map((product) => (
                                    <div key={product.id} className={styles.productCard} onClick={() => handleCardClick(product)}>
                                        <img src={product.image || "/placeholder.svg"} alt={product.name} />
                                        <h4>{product.name}</h4>
                                        <p className={styles.productSpecs}>{product.description}</p>
                                        <p className={styles.productSpecs}>{product.specs}</p>
                                        <div className={styles.productFooter}>
                                            <span className={styles.productPrice}>{product.price}</span>
                                            <button className={styles.addToCartButton} onClick={(e) => {
                                                e.stopPropagation();
                                                addToCart({
                                                    id: product.id,
                                                    name: product.name,
                                                    price: product.price,
                                                    image: product.image,
                                                });
                                            }}>Add to Cart</button>
                                        </div>
                                    </div>
                                ))}
                            </div>
                        </div>
                    ))}
                </div>
            </section>

            {/* Best Sellers Section */}
            {/* <section id="bestsellers" className={styles.bestSellers}>
                <h2>Best Sellers</h2>
                <div className={styles.bestSellersGrid}>
                    {bestSellers.map((product) => (
                        <div key={product.id} className={styles.bestSellerCard}>
                            <div className={styles.bestSellerBadge}>Top Rated</div>
                            <img src={product.image || "/placeholder.svg"} alt={product.name} />
                            <h3>{product.name}</h3>
                            <div className={styles.bestSellerRating}>
                                {"★".repeat(Math.floor(product.rating))}
                                {product.rating % 1 !== 0 ? "½" : ""}
                                {"☆".repeat(5 - Math.ceil(product.rating))}
                                <span>{product.rating.toFixed(1)}</span>
                            </div>
                            <p className={styles.bestSellerSales}>{product.sales}+ sold this month</p>
                            <div className={styles.bestSellerFooter}>
                                <span className={styles.bestSellerPrice}>{product.price}</span>
                                {/* <button className={styles.viewDetailsButton}>View Details</button> */}
            {/* </div>
                        </div>
                    ))}
                </div>
            </section> */}

            {/* Reviews Section */}
            {/* <section id="reviews" className={styles.reviews}>
                <h2>Customer Reviews</h2>
                <div className={styles.reviewsGrid}>
                    {reviews.map((review) => (
                        <div key={review.id} className={styles.reviewCard}>
                            <div className={styles.reviewHeader}>
                                <h3>{review.name}</h3>
                                <div className={styles.reviewRating}>
                                    {"★".repeat(review.rating)}
                                    {"☆".repeat(5 - review.rating)}
                                </div>
                            </div>
                            <p className={styles.reviewText}>"{review.text}"</p>
                        </div>
                    ))}
                </div>
            </section> */}

            {/* FAQ Section */}
            <section id="faq" className={styles.faq}>
                <h2>Frequently Asked Questions</h2>
                <div className={styles.faqList}>
                    {faqs.map((faq, index) => (
                        <div key={faq.id} className={styles.faqItem}>
                            <div className={styles.faqQuestion} onClick={() => toggleFaq(index)}>
                                <h3>{faq.question}</h3>
                                <span className={styles.faqToggle}>{expandedFaq === index ? "−" : "+"}</span>
                            </div>
                            <div className={`${styles.faqAnswer} ${expandedFaq === index ? styles.expanded : ""}`}>
                                <p>{faq.answer}</p>
                            </div>
                        </div>
                    ))}
                </div>
            </section>

            {/* CTA Banner */}
            <section className={styles.ctaBanner}>
                <div className={styles.ctaBannerContent}>
                    <h2>Ready to Build Your Dream PC?</h2>
                    <p>Sign up for exclusive deals and early access to new components</p>
                    <div className={styles.ctaForm}>
                        <input type="email" placeholder="Enter your email"  value={email} onChange={(e) => setEmail(e.target.value)}/>
                        <button className={styles.ctaButton} onClick={handleSubscribe}>Subscribe</button>
                    </div>
                </div>
            </section>

            <><Footer /></>

            {/* Footer */}
            {/* <footer className={styles.footer}>
        <div className={styles.footerContent}>
          <div className={styles.footerLogo}>TechElite</div>
          <div className={styles.footerLinks}>
            <div className={styles.footerColumn}>
              <h4>Company</h4>
              <ul>
                <li>
                  <a href="#">About Us</a>
                </li>
                <li>
                  <a href="#">Careers</a>
                </li>
                <li>
                  <a href="#">Blog</a>
                </li>
                <li>
                  <a href="#">Press</a>
                </li>
              </ul>
            </div>
            <div className={styles.footerColumn}>
              <h4>Support</h4>
              <ul>
                <li>
                  <a href="#">Contact Us</a>
                </li>
                <li>
                  <a href="#">Help Center</a>
                </li>
                <li>
                  <a href="#">Returns</a>
                </li>
                <li>
                  <a href="#">Warranty</a>
                </li>
              </ul>
            </div>
            <div className={styles.footerColumn}>
              <h4>Legal</h4>
              <ul>
                <li>
                  <a href="#">Privacy Policy</a>
                </li>
                <li>
                  <a href="#">Terms of Service</a>
                </li>
                <li>
                  <a href="#">Cookie Policy</a>
                </li>
                <li>
                  <a href="#">Accessibility</a>
                </li>
              </ul>
            </div>
          </div>
        </div>
        <div className={styles.footerBottom}>
          <p>© 2025 TechElite. All rights reserved.</p>
        </div>
      </footer> */}
        </div>
    )
}

export default PcComponent

