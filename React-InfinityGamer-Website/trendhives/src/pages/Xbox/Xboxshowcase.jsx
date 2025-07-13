import React, { useState, useRef, useEffect,useContext } from "react";
import styles from "./Xboxshowcase.module.css";
import { collection, getDocs } from "firebase/firestore";
import { db } from "../../firebase"; // adjust path based on your project structure
import Navbar from "../../components/navbar/Navbar";
import { ChevronLeft, ChevronRight, GamepadIcon, Zap, Monitor, FastForward, Download, Facebook, Twitter, Instagram, Youtube, } from "lucide-react";
import Footer from "../../components/footer/Footer";
import { CartContext } from "../../pages/addtocart/CartContext"; // Import CartContext
import { useNavigate } from "react-router-dom"; // Import useNavigate

export default function XboxShowcase() {
  const { addToCart } = useContext(CartContext); // Access addToCart function
  const [xboxfeaturedgames, setxboxfeaturedgames] = useState([]);
  const [loading, setLoading] = useState(true);

  const [currentSlide, setCurrentSlide] = useState(0);
  const [isDragging, setIsDragging] = useState(false);
  const [startX, setStartX] = useState(0);

  const navigate = useNavigate(); // Initialize useNavigate


  const [isVisible, setIsVisible] = useState({
    hero: false,
    featured: false,
    carousel: false,
    gamepass: false,
    performance: false,
    testimonials: false,
  });

  const heroRef = useRef(null);
  const featuredRef = useRef(null);
  const carouselRef = useRef(null);
  const gamepassRef = useRef(null);
  const performanceRef = useRef(null);
  const testimonialsRef = useRef(null);
  const sliderRef = useRef(null);

  useEffect(() => {
    const fetchxboxfeaturedgames = async () => {
      try {
        const querySnapshot = await getDocs(collection(db, "xboxfeaturedgames"));
        const games = querySnapshot.docs.map(doc => ({ id: doc.id, ...doc.data() }));
        setxboxfeaturedgames(games);
      } catch (error) {
        console.error("Error fetching featured games:", error);
      } finally {
        setLoading(false);
      }
    };

    fetchxboxfeaturedgames();
  }, []);

  const carouselGames = [
    {
      id: 1,
      title: "Halo Infinite",
      image: "https://res.cloudinary.com/do7ttqxgn/image/upload/v1744034162/663562_tlk0mx.png",
      description: "Master Chief returns in the next chapter of the legendary franchise.",
      releaseDate: "Available Now",
      exclusive: true,
    },
    {
      id: 2,
      title: "Forza Horizon 5",
      image: "https://res.cloudinary.com/do7ttqxgn/image/upload/v1744034160/6070336_q97wfk.jpg",
      description: "Experience an ever-evolving open world racing festival in Mexico.",
      releaseDate: "Available Now",
      exclusive: true,
    },
    {
      id: 3,
      title: "Starfield",
      image: "https://res.cloudinary.com/do7ttqxgn/image/upload/v1744034161/9968366_h1uppa.jpg",
      description: "Embark on an epic journey through the stars in this new space RPG.",
      releaseDate: "Available Now",
      exclusive: true,
    },
    {
      id: 4,
      title: "Fable",
      image: "https://res.cloudinary.com/do7ttqxgn/image/upload/v1744034163/13364562_a0awpp.jpg",
      description: "Return to the fantasy world in this reimagining of the beloved RPG series.",
      releaseDate: "Coming Soon",
      exclusive: true,
    },
    {
      id: 5,
      title: "Perfect Dark",
      image: "https://res.cloudinary.com/do7ttqxgn/image/upload/v1744034161/12671010_rlxsb5.jpg",
      description: "A spy thriller set in a near-future world of corporate intrigue.",
      releaseDate: "Coming Soon",
      exclusive: true,
    },
  ];

  const testimonials = [
    {
      id: 1,
      quote:
        "Xbox Series X is the most powerful console we've ever tested. Games look and perform better than ever before.",
      author: "Tech Gaming Magazine",
      rating: 5,
    },
    {
      id: 2,
      quote: "Game Pass is revolutionary. It's changed how I discover and play games completely.",
      author: "Sarah J., Xbox Player",
      rating: 5,
    },
    {
      id: 3,
      quote: "The backward compatibility is flawless. My entire game library looks and plays better on Series X.",
      author: "Gaming Authority",
      rating: 4.5,
    },
  ];

  const performanceFeatures = [
    {
      id: 1,
      title: "120 FPS Gaming",
      description: "Experience ultra-smooth gameplay with support for up to 120 frames per second.",
      icon: <Zap className={styles.featureIcon} />,
    },
    {
      id: 2,
      title: "Ray Tracing",
      description:
        "Immerse yourself in realistic lighting, shadows, and reflections with hardware-accelerated ray tracing.",
      icon: <Monitor className={styles.featureIcon} />,
    },
    {
      id: 3,
      title: "Fast Resume",
      description: "Switch between multiple games instantly and resume exactly where you left off.",
      icon: <FastForward className={styles.featureIcon} />,
    },
    {
      id: 4,
      title: "Smart Delivery",
      description: "Automatically get the best version of your game for your console, at no additional cost.",
      icon: <Download className={styles.featureIcon} />,
    },
  ];

  const nextSlide = () => {
    setCurrentSlide((prev) => (prev === carouselGames.length - 1 ? 0 : prev + 1));
  };

  const prevSlide = () => {
    setCurrentSlide((prev) => (prev === 0 ? carouselGames.length - 1 : prev - 1));
  };

  const handleDragStart = (e) => {
    setIsDragging(true);
    if ("touches" in e) {
      setStartX(e.touches[0].clientX);
    } else {
      setStartX(e.clientX);
    }
  };

  const handleDragMove = (e) => {
    if (!isDragging) return;

    let currentX;
    if ("touches" in e) {
      currentX = e.touches[0].clientX;
    } else {
      currentX = e.clientX;
    }

    const diff = startX - currentX;

    if (diff > 50) {
      nextSlide();
      setIsDragging(false);
    } else if (diff < -50) {
      prevSlide();
      setIsDragging(false);
    }
  };

  const handleDragEnd = () => {
    setIsDragging(false);
  };

  const renderStars = (rating) => {
    const stars = [];
    const fullStars = Math.floor(rating);
    const hasHalfStar = rating % 1 !== 0;

    for (let i = 0; i < fullStars; i++) {
      stars.push(
        <span key={`star-${i}`} className={styles.star}>
          ★
        </span>,
      );
    }

    if (hasHalfStar) {
      stars.push(
        <span key="half-star" className={styles.star}>
          ★
        </span>,
      );
    }

    const emptyStars = 5 - stars.length;
    for (let i = 0; i < emptyStars; i++) {
      stars.push(
        <span key={`empty-star-${i}`} className={styles.emptyStar}>
          ★
        </span>,
      );
    }

    return stars;
  };

  useEffect(() => {
    const observer = new IntersectionObserver((entries) => {
      entries.forEach((entry) => {
        if (entry.target === heroRef.current && entry.isIntersecting) {
          setIsVisible((prev) => ({ ...prev, hero: true }));
        } else if (entry.target === featuredRef.current && entry.isIntersecting) {
          setIsVisible((prev) => ({ ...prev, featured: true }));
        } else if (entry.target === carouselRef.current && entry.isIntersecting) {
          setIsVisible((prev) => ({ ...prev, carousel: true }));
        } else if (entry.target === gamepassRef.current && entry.isIntersecting) {
          setIsVisible((prev) => ({ ...prev, gamepass: true }));
        } else if (entry.target === performanceRef.current && entry.isIntersecting) {
          setIsVisible((prev) => ({ ...prev, performance: true }));
        } else if (entry.target === testimonialsRef.current && entry.isIntersecting) {
          setIsVisible((prev) => ({ ...prev, testimonials: true }));
        }
      });
    }, { threshold: 0.1 });

    if (heroRef.current) observer.observe(heroRef.current);
    if (featuredRef.current) observer.observe(featuredRef.current);
    if (carouselRef.current) observer.observe(carouselRef.current);
    if (gamepassRef.current) observer.observe(gamepassRef.current);
    if (performanceRef.current) observer.observe(performanceRef.current);
    if (testimonialsRef.current) observer.observe(testimonialsRef.current);

    return () => {
      if (heroRef.current) observer.unobserve(heroRef.current);
      if (featuredRef.current) observer.unobserve(featuredRef.current);
      if (carouselRef.current) observer.unobserve(carouselRef.current);
      if (gamepassRef.current) observer.unobserve(gamepassRef.current);
      if (performanceRef.current) observer.unobserve(performanceRef.current);
      if (testimonialsRef.current) observer.unobserve(testimonialsRef.current);
    };
  }, []);

  useEffect(() => {
    const interval = setInterval(() => {
      nextSlide();
    }, 5000);
    return () => clearInterval(interval);
  }, [currentSlide]);

  useEffect(() => {
    const handleKeyDown = (e) => {
      if (e.key === "ArrowLeft") {
        prevSlide();
      } else if (e.key === "ArrowRight") {
        nextSlide();
      }
    };

    window.addEventListener("keydown", handleKeyDown);
    return () => {
      window.removeEventListener("keydown", handleKeyDown);
    };
  }, []);

  const scrollDown = () => {
    window.scrollBy({ top: 800, behavior: 'smooth' });
  };

  const handleCardClick = (game) => {
    navigate("/XboxShowcaseDescription", { state: { game } });
  };


  return (
    <><><Navbar /></>
      <main className={styles.container}>
        <section ref={heroRef} className={`${styles.hero} ${isVisible.hero ? styles.visible : ""}`}>
          <div className={styles.heroOverlay}></div>
          <div className={styles.heroContent}>
            <h1 className={styles.title}>
              <span className={styles.titleLine}>POWER YOUR</span>
              <span className={styles.titleLine}>DREAMS</span>
            </h1>
            <p className={styles.tagline}>Beyond All Limits</p>
            <p className={styles.subtitle}>
              Experience next-generation gaming with the most powerful Xbox ever. Immerse yourself in true 4K gaming with
              up to 120 FPS, lightning-fast load times, and access to hundreds of high-quality games.
            </p>
            <div className={styles.heroCta}>
              <button className={styles.ctaButton}>
                <span className={styles.ctaText} onClick={scrollDown}>Explore Xbox Series X</span>
                <span className={styles.ctaGlow}></span>
              </button>
            </div>
          </div>
          <div className={styles.heroImageContainer}>
            <div className={styles.heroImage}>
              <img
                src="https://res.cloudinary.com/do7ttqxgn/image/upload/v1744034927/1584759_rjkrpd.jpg"
                alt="Xbox Series X console"
                className={styles.consoleImage} />
              <div className={styles.consoleGlow}></div>
            </div>
          </div>
          <div className={styles.scrollIndicator}>
            <div className={styles.scrollArrow}></div>
            <span className={styles.scrollText}>Scroll to explore</span>
          </div>
        </section>

        <section ref={featuredRef} className={`${styles.featuredSection} ${isVisible.featured ? styles.visible : ""}`}>
          <div className={styles.sectionHeader}>
            <h2 className={styles.sectionTitle}>Featured Games</h2>
            <p className={styles.sectionSubtitle}>Discover the latest and greatest titles on Xbox</p>
          </div>

          <div className={styles.gamesGrid}>
            {xboxfeaturedgames.map((game, index) => (
              <div key={game.id} className={styles.gameCard} style={{ animationDelay: `${index * 0.1}s` }} onClick={() => handleCardClick(game)}>
                <div className={styles.gameImageContainer}>
                  <img
                    src={game.image || "/placeholder.svg"}
                    alt={`${game.title} cover art`}
                    className={styles.gameCardImage} />
                  {game.exclusive && <div className={styles.exclusiveBadge}>Xbox Exclusive</div>}
                </div>
                <div className={styles.gameCardContent}>
                  <h3 className={styles.gameCardTitle}>{game.title}</h3>
                  <p className={styles.gameCardGenre}>{game.genre}</p>
                  <p className={styles.gameCardGenre}>{game.price}</p>
                  <p className={styles.gameCardDescription}>{game.description || "An epic gaming experience awaits you."}</p>
                  <p className={styles.gameCardPlatform}>{game.platform}</p>
                  <button className={styles.addToCartButton}                 onClick={(e) => {
                  e.stopPropagation(); // Prevent navigation on button click
                  addToCart({
                    id: game.id,
                    name: game.title,
                    price: game.price,
                    image: game.image,
                  });
                }}>Add to Cart</button>
                </div>
                <div className={styles.gameCardGlow}></div>
              </div>
            ))}
          </div>
        </section>


        <section ref={carouselRef} className={`${styles.carouselSection} ${isVisible.carousel ? styles.visible : ""}`}>
          <div className={styles.sectionHeader}>
            <h2 className={styles.sectionTitle}>Top Games</h2>
            <p className={styles.sectionSubtitle}>Experience the best of Xbox gaming</p>
          </div>
          <div className={styles.carouselContainer}>
            <button
              className={`${styles.carouselButton} ${styles.prevButton}`}
              onClick={prevSlide}
              aria-label="Previous game"
            >
              <ChevronLeft size={24} />
            </button>

            <div
              ref={sliderRef}
              className={styles.carousel}
              onMouseDown={handleDragStart}
              onMouseMove={handleDragMove}
              onMouseUp={handleDragEnd}
              onMouseLeave={handleDragEnd}
              onTouchStart={handleDragStart}
              onTouchMove={handleDragMove}
              onTouchEnd={handleDragEnd}
            >
              {carouselGames.map((game, index) => (
                <div
                  key={game.id}
                  className={`${styles.slide} ${index === currentSlide ? styles.activeSlide : ""}`}
                  style={{ transform: `translateX(${100 * (index - currentSlide)}%)` }}
                  aria-hidden={index !== currentSlide}
                >
                  <div className={styles.slideImageWrapper}>
                    <img
                      src={game.image || "/placeholder.svg"}
                      alt={`${game.title} game screenshot`}
                      className={styles.slideImage} />
                    {game.exclusive && <div className={styles.exclusiveBanner}>Xbox Exclusive</div>}
                  </div>
                  <div className={styles.slideInfo}>
                    <h3 className={styles.slideTitle}>{game.title}</h3>
                    <p className={styles.slideDescription}>{game.description}</p>
                    <div className={styles.slideMetadata}>
                      <span className={styles.releaseDate}>{game.releaseDate}</span>
                      {/* <button className={styles.slideDetailsButton}>Learn More</button> */}
                    </div>
                  </div>
                </div>
              ))}
            </div>

            <button
              className={`${styles.carouselButton} ${styles.nextButton}`}
              onClick={nextSlide}
              aria-label="Next game"
            >
              <ChevronRight size={24} />
            </button>
          </div>

          <div className={styles.indicators} role="tablist">
            {carouselGames.map((_, index) => (
              <button
                key={index}
                className={`${styles.indicator} ${index === currentSlide ? styles.activeIndicator : ""}`}
                onClick={() => setCurrentSlide(index)}
                aria-label={`Go to slide ${index + 1}`}
                aria-selected={index === currentSlide}
                role="tab" />
            ))}
          </div>
        </section>

        <section ref={gamepassRef} className={`${styles.gamePassSection} ${isVisible.gamepass ? styles.visible : ""}`}>
          <div className={styles.gamePassPattern}></div>
          <div className={styles.gamePassContent}>
            <div className={styles.gamePassLogoContainer}>
              <div className={styles.gamePassLogo}>
                <GamepadIcon size={48} />
                <span className={styles.gamePassText}>XBOX GAME PASS</span>
              </div>
              <div className={styles.gamePassGlow}></div>
            </div>
            <h2 className={styles.gamePassTitle}>Unlimited Access to Over 100 High-Quality Games</h2>
            <p className={styles.gamePassDescription}>
              Join Xbox Game Pass and get immediate access to a massive library of games, including day one releases from
              Xbox Game Studios. Play across devices with cloud gaming, enjoy exclusive member discounts, and experience
              new games added all the time.
            </p>
            <ul className={styles.gamePassFeatures}>
              <li className={styles.gamePassFeature}>
                <span className={styles.featureCheck}>✓</span>
                Play across console, PC, and mobile devices
              </li>
              <li className={styles.gamePassFeature}>
                <span className={styles.featureCheck}>✓</span>
                New games added all the time
              </li>
              <li className={styles.gamePassFeature}>
                <span className={styles.featureCheck}>✓</span>
                Xbox Game Studios titles the same day as release
              </li>
              <li className={styles.gamePassFeature}>
                <span className={styles.featureCheck}>✓</span>
                Member discounts and deals
              </li>
            </ul>
            <button className={styles.gamePassButton}>
              <a
                href="https://www.xbox.com/xbox-game-pass"
                target="_blank"
                rel="noopener noreferrer"
                className={styles.buttonText}
              >
                Join Xbox Game Pass
              </a>
              <span className={styles.buttonBorder}></span>
            </button>
          </div>
        </section>

        <section ref={performanceRef} className={`${styles.performanceSection} ${isVisible.performance ? styles.visible : ""}`}>
          <div className={styles.sectionHeader}>
            <h2 className={styles.sectionTitle}>Performance & Innovation</h2>
            <p className={styles.sectionSubtitle}>Cutting-edge technology for next-gen gaming</p>
          </div>
          <div className={styles.performanceGrid}>
            {performanceFeatures.map((feature, index) => (
              <div key={feature.id} className={styles.performanceCard} style={{ animationDelay: `${index * 0.15}s` }}>
                <div className={styles.performanceIconContainer}>{feature.icon}</div>
                <h3 className={styles.performanceTitle}>{feature.title}</h3>
                <p className={styles.performanceDescription}>{feature.description}</p>
              </div>
            ))}
          </div>
        </section>

        <section ref={testimonialsRef} className={`${styles.testimonialsSection} ${isVisible.testimonials ? styles.visible : ""}`}>
          <div className={styles.sectionHeader}>
            <h2 className={styles.sectionTitle}>What People Are Saying</h2>
            <p className={styles.sectionSubtitle}>Hear from the Xbox community</p>
          </div>
          <div className={styles.testimonialsGrid}>
            {testimonials.map((testimonial, index) => (
              <div key={testimonial.id} className={styles.testimonialCard} style={{ animationDelay: `${index * 0.2}s` }}>
                <div className={styles.testimonialRating}>{renderStars(testimonial.rating)}</div>
                <blockquote className={styles.testimonialQuote}>"{testimonial.quote}"</blockquote>
                <p className={styles.testimonialAuthor}>— {testimonial.author}</p>
              </div>
            ))}
          </div>
        </section>

        <><Footer /></>

        {/* <footer className={styles.footer}>
        <div className={styles.footerContent}>
          <div className={styles.footerTop}>
            <div className={styles.footerLogo}>
              <span className={styles.xboxLogo}>XBOX</span>
            </div>
            <nav className={styles.footerNav}>
              <a href="#" className={styles.footerLink}>
                Home
              </a>
              <a href="#" className={styles.footerLink}>
                Game Pass
              </a>
              <a href="#" className={styles.footerLink}>
                Games
              </a>
              <a href="#" className={styles.footerLink}>
                Support
              </a>
              <a href="#" className={styles.footerLink}>
                Privacy
              </a>
            </nav>
          </div>
          <div className={styles.footerBottom}>
            <div className={styles.socialLinks}>
              <a href="#" className={styles.socialLink} aria-label="Facebook">
                <Facebook size={20} />
              </a>
              <a href="#" className={styles.socialLink} aria-label="Twitter">
                <Twitter size={20} />
              </a>
              <a href="#" className={styles.socialLink} aria-label="Instagram">
                <Instagram size={20} />
              </a>
              <a href="#" className={styles.socialLink} aria-label="YouTube">
                <Youtube size={20} />
              </a>
            </div>
            <p className={styles.copyright}>
              © {new Date().getFullYear()} Microsoft Corporation. All rights reserved.
            </p>
          </div>
        </div>
      </footer> */}
      </main></>
  );
}