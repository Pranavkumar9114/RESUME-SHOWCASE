import { useState } from "react";
import styles from "./Console.module.css";
import ConsoleBundle from "../../components/body/Product_Sliders/Consolebundle/Consolebundle";
import Footer from "../../components/footer/Footer";
import Navbar from "../../components/navbar/Navbar";

const Console = () => {
    // State for image gallery
    const [activeImageIndex, setActiveImageIndex] = useState(0)

    // State for FAQ toggles
    const [expandedFaqs, setExpandedFaqs] = useState({})

    // Mock data for the console
    const consoleData = {
        name: "Consoles Bundle",
        tagline: "Experience next-gen gaming with unmatched performance, stunning visuals, and smooth gameplay — all in one powerful bundle. The future of gaming starts here.",
        images: [
            { id: 1, alt: "NexGen X5000 Front View", src: "/placeholder.svg?height=400&width=600" },
            { id: 2, alt: "NexGen X5000 Side View", src: "/placeholder.svg?height=400&width=600" },
            { id: 3, alt: "NexGen X5000 Back View", src: "/placeholder.svg?height=400&width=600" },
            { id: 4, alt: "NexGen X5000 Controller", src: "/placeholder.svg?height=400&width=600" },
        ],
        price: 499.99,
        availability: "In Stock",
        features: [
            "8K Gaming Support",
            "Ray Tracing Technology",
            "1TB SSD Storage",
            "Wireless Controller with Haptic Feedback",
            "Voice Command Support",
            "Backward Compatibility with Previous Generation Games",
        ],
        specifications: [
            { name: "Processor", value: "Custom AMD Zen 3, 8 cores @ 3.8GHz" },
            { name: "Graphics", value: "Custom RDNA 2, 16GB GDDR6" },
            { name: "Storage", value: "1TB Custom NVMe SSD" },
            { name: "Memory", value: "16GB GDDR6" },
            { name: "Video Output", value: "8K @ 60fps, 4K @ 120fps" },
            { name: "Audio", value: "3D Tempest AudioTech" },
            { name: "Connectivity", value: "Wi-Fi 6, Bluetooth 5.1, USB-C, HDMI 2.1" },
            { name: "Dimensions", value: "30cm × 24cm × 10cm" },
            { name: "Weight", value: "4.5kg" },
        ],
        reviews: [
            {
                id: 1,
                name: "Alex Johnson",
                rating: 5,
                text: "The best console I've ever owned. Graphics are mind-blowing and load times are practically non-existent.",
            },
            {
                id: 2,
                name: "Sarah Miller",
                rating: 4,
                text: "Great performance and game selection. Controller battery life could be better.",
            },
            {
                id: 3,
                name: "David Chen",
                rating: 5,
                text: "Absolutely worth every penny. The haptic feedback on the controller adds a whole new dimension to gaming.",
            },
            {
                id: 4,
                name: "Emma Wilson",
                rating: 4,
                text: "Fantastic console but still waiting for more exclusive titles to really showcase its capabilities.",
            },
        ],
        faqs: [
            {
                id: 1,
                question: "Does it include any games?",
                answer:
                    "The NexGen X5000 comes with a digital copy of 'Astro's Playroom' pre-installed. Additional games are sold separately.",
            },
            {
                id: 2,
                question: "Can I play my old games on this console?",
                answer:
                    "Yes, the NexGen X5000 is backward compatible with 90% of previous generation titles, with enhanced performance on select games.",
            },
            {
                id: 3,
                question: "What's the warranty period?",
                answer:
                    "The console comes with a 1-year limited hardware warranty. Extended warranty options are available at checkout.",
            },
            {
                id: 4,
                question: "How many controllers are included?",
                answer:
                    "One wireless controller is included with the console. Additional controllers can be purchased separately.",
            },
            {
                id: 5,
                question: "Does it support VR?",
                answer: "Yes, the NexGen X5000 is compatible with our NextVision VR headset, sold separately.",
            },
        ],
        warranty: "1-year limited hardware warranty. Extended warranty options available.",
        support: "24/7 customer support via email, or phone.",
    }


    const toggleFaq = (id) => {
        setExpandedFaqs((prev) => ({
            ...prev,
            [id]: !prev[id],
        }))
    }


    const renderStars = (rating) => {
        return "★".repeat(rating) + "☆".repeat(5 - rating)
    }

    return (
        <div className={styles.productPage}>
            <><Navbar/></>
       
            <div className={styles.bannerbundle}>
                <section
                    className={styles.banner}
                    style={{
                        position: 'relative',
                        overflow: 'hidden',
                    }}
                >
           
                    <div
                        style={{
                            position: 'absolute',
                            top: 0,
                            left: 0,
                            right: 0,
                            bottom: 0,
                            backgroundImage: 'url("https://res.cloudinary.com/do7ttqxgn/image/upload/v1744263253/692809_ht4jw0.jpg")',
                            backgroundSize: 'cover',
                            backgroundPosition: 'center',
                            backgroundRepeat: 'no-repeat',
                            filter: 'blur(8px)',
                            zIndex: 0,
                        }}
                    ></div>

              
                    <div
                        className={styles.bannerContent}
                        style={{
                            position: 'relative',
                            zIndex: 1,
                        }}
                    >
                        <h1 className={styles.bannerTitle}>{consoleData.name}</h1>
                        <p className={styles.bannerTagline}>{consoleData.tagline}</p>
                        <button
                            className={styles.ctaButton}
                            onClick={() => window.scrollBy({ top: 800, behavior: 'smooth' })}
                        >
                            Discover Now
                        </button>

                    </div>
                </section>


                <><ConsoleBundle /></>
            </div>

            {/* <header className={styles.header}>
                <h1 className={styles.productTitle}>{consoleData.name}</h1>
                <p className={styles.tagline}>{consoleData.tagline}</p>
            </header>

            <section className={styles.mainContent}>
                <div className={styles.imageGallery}>
                    <div className={styles.mainImage}>
                        <img
                            src={consoleData.images[activeImageIndex].src || "/placeholder.svg"}
                            alt={consoleData.images[activeImageIndex].alt}
                        />
                    </div>
                    <div className={styles.thumbnails}>
                        {consoleData.images.map((image, index) => (
                            <div
                                key={image.id}
                                className={`${styles.thumbnail} ${index === activeImageIndex ? styles.activeThumbnail : ""}`}
                                onClick={() => setActiveImageIndex(index)}
                            >
                                <img src={image.src || "/placeholder.svg"} alt={`Thumbnail ${index + 1}`} />
                            </div>
                        ))}
                    </div>
                </div>

                <div className={styles.productInfo}>
                    <div className={styles.pricing}>
                        <span className={styles.price}>${consoleData.price}</span>
                        <span className={styles.availability}>{consoleData.availability}</span>
                    </div>

                    <div className={styles.actions}>
                        <button className={`${styles.button} ${styles.buyNow}`}>Buy Now</button>
                        <button className={`${styles.button} ${styles.addToCart}`}>Add to Cart</button>
                    </div>

                    <div className={styles.features}>
                        <h2>Key Features</h2>
                        <ul>
                            {consoleData.features.map((feature, index) => (
                                <li key={index}>{feature}</li>
                            ))}
                        </ul>
                    </div>
                </div>
            </section>

            <section className={styles.specifications}>
                <h2>Technical Specifications</h2>
                <table className={styles.specsTable}>
                    <tbody>
                        {consoleData.specifications.map((spec, index) => (
                            <tr key={index}>
                                <th>{spec.name}</th>
                                <td>{spec.value}</td>
                            </tr>
                        ))}
                    </tbody>
                </table>
            </section> */}

            {/* <section className={styles.reviews}>
                <h2>Customer Reviews</h2>
                <div className={styles.reviewsList}>
                    {consoleData.reviews.map((review) => (
                        <div key={review.id} className={styles.review}>
                            <div className={styles.reviewHeader}>
                                <span className={styles.reviewerName}>{review.name}</span>
                                <span className={styles.rating}>{renderStars(review.rating)}</span>
                            </div>
                            <p className={styles.reviewText}>{review.text}</p>
                        </div>
                    ))}
                </div>
            </section> */}

            <section className={styles.faqs}>
                <h2>Frequently Asked Questions</h2>
                <div className={styles.faqsList}>
                    {consoleData.faqs.map((faq) => (
                        <div key={faq.id} className={styles.faqItem}>
                            <div className={styles.faqQuestion} onClick={() => toggleFaq(faq.id)}>
                                <h3>{faq.question}</h3>
                                <span className={styles.faqToggle}>{expandedFaqs[faq.id] ? "−" : "+"}</span>
                            </div>
                            {expandedFaqs[faq.id] && (
                                <div className={styles.faqAnswer}>
                                    <p>{faq.answer}</p>
                                </div>
                            )}
                        </div>
                    ))}
                </div>
            </section>

            <section className={styles.support}>
                <h2>Warranty & Support</h2>
                <div className={styles.supportInfo}>
                    <div className={styles.warranty}>
                        <h3>Warranty</h3>
                        <p>{consoleData.warranty}</p>
                    </div>
                    <div className={styles.customerSupport}>
                        <h3>Customer Support</h3>
                        <p>{consoleData.support}</p>
                    </div>
                </div>
            </section>

            {/* <footer className={styles.footer}>
        <div className={styles.footerContent}>
          <div className={styles.copyright}>© 2025 NexGen Gaming. All rights reserved.</div>
          <div className={styles.legalLinks}>
            <span>Privacy Policy</span>
            <span>Terms of Service</span>
            <span>Return Policy</span>
          </div>
        </div>
      </footer> */}
            <div className={styles.footer}>

                <><Footer /></>
            </div>
        </div>
    )
}

export default Console
