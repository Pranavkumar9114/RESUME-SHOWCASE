import { useEffect, useRef, useState } from "react"
import styles from "./About.module.css"
import Footer from "../../components/footer/Footer"
import Navbar from "../../components/navbar/Navbar"
import { Link } from "react-router-dom";


const About = () => {
  const [isVisible, setIsVisible] = useState({
    hero: false,
    story: false,
    mission: false,
    unique: false,
    products: false,
    cta: false,
  })

  const sectionRefs = {
    hero: useRef(null),
    story: useRef(null),
    mission: useRef(null),
    unique: useRef(null),
    products: useRef(null),
    cta: useRef(null),
  }

  useEffect(() => {
    const observerOptions = {
      root: null,
      rootMargin: "0px",
      threshold: 0.1,
    }

    const observers = []

    Object.entries(sectionRefs).forEach(([key, ref]) => {
      const observer = new IntersectionObserver((entries) => {
        entries.forEach((entry) => {
          if (entry.isIntersecting) {
            setIsVisible((prev) => ({ ...prev, [key]: true }))
            observer.unobserve(entry.target)
          }
        })
      }, observerOptions)

      if (ref.current) {
        observer.observe(ref.current)
        observers.push(observer)
      }
    })

    return () => {
      observers.forEach((observer) => observer.disconnect())
    }
  }, [])

  const productCategories = [
    { name: "PlayStation", icon: "🎮" },
    { name: "Xbox", icon: "🎯" },
    { name: "Bundles", icon: "📦" },
    { name: "Accessories", icon: "🎧" },
    { name: "PC Components", icon: "💻" },
    { name: "Featured Games", icon: "🏆" },
  ]

  return (
    <div className={styles.aboutContainer}>
        <><Navbar/></>
      <section ref={sectionRefs.hero} className={`${styles.heroSection} ${isVisible.hero ? styles.visible : ""}`}>
        <h1 className={styles.title}>
          <span className={styles.welcomeText}>Welcome to</span>
          <span className={styles.brandName}>INFINITY GAMER</span>
        </h1>
        <div className={styles.heroUnderline}></div>
      </section>

      <section ref={sectionRefs.story} className={`${styles.storySection} ${isVisible.story ? styles.visible : ""}`}>
        <h2>Our Story</h2>
        <p>
          Founded by passionate gamers in 2025, INFINITY GAMER was born from a simple idea: create the gaming store we
          always wanted to shop at. What started as a small online shop run from a garage has grown into a community of
          millions of gamers worldwide.
        </p>
        <p>
          Our founders, Alex and Jamie, met during a gaming tournament and bonded over their shared frustration with
          existing gaming retailers. They envisioned a platform that truly understood gamers' needs - and INFINITY GAMER
          was born.
        </p>
      </section>

      <section
        ref={sectionRefs.mission}
        className={`${styles.missionSection} ${isVisible.mission ? styles.visible : ""}`}
      >
        <h2>Our Mission & Values</h2>
        <div className={styles.valuesContainer}>
          <div className={styles.valueCard}>
            <h3>Community First</h3>
            <p>We build everything with our gaming community in mind, listening to feedback and evolving constantly.</p>
          </div>
          <div className={styles.valueCard}>
            <h3>Quality Guaranteed</h3>
            <p>Every product we sell undergoes rigorous testing to ensure it meets our high standards.</p>
          </div>
          <div className={styles.valueCard}>
            <h3>Accessibility</h3>
            <p>We believe gaming should be for everyone, regardless of experience level or background.</p>
          </div>
        </div>
      </section>

      <section ref={sectionRefs.unique} className={`${styles.uniqueSection} ${isVisible.unique ? styles.visible : ""}`}>
        <h2>What Makes Us Unique</h2>
        <div className={styles.uniquePoints}>
          <div className={styles.uniquePoint}>
            <span className={styles.uniqueIcon}>🔍</span>
            <h3>Curated Selection</h3>
            <p>We personally test and select every product in our inventory.</p>
          </div>
          <div className={styles.uniquePoint}>
            <span className={styles.uniqueIcon}>🛠️</span>
            <p>Free tech support for all purchases, because we know gaming tech can be complex.</p>
          </div>
          <div className={styles.uniquePoint}>
            <span className={styles.uniqueIcon}>🎁</span>
            <h3>Loyalty Rewards</h3>
            <p>Our points system rewards you for every purchase, review, and community contribution.</p>
          </div>
          <div className={styles.uniquePoint}>
            <span className={styles.uniqueIcon}>🌍</span>
            <h3>Global Gaming Events</h3>
            <p>We host and sponsor gaming tournaments and meetups around the world.</p>
          </div>
        </div>
      </section>

      <section
        ref={sectionRefs.products}
        className={`${styles.productsSection} ${isVisible.products ? styles.visible : ""}`}
      >
        <h2>Explore Our Categories</h2>
        <div className={styles.categoriesGrid}>
          {productCategories.map((category, index) => (
            <div key={index} className={styles.categoryCard} style={{ animationDelay: `${index * 0.1}s` }}>
              <span className={styles.categoryIcon}>{category.icon}</span>
              <h3>{category.name}</h3>
            </div>
          ))}
        </div>
      </section>

      <section ref={sectionRefs.cta} className={`${styles.ctaSection} ${isVisible.cta ? styles.visible : ""}`}>
        <h2 className={styles.ctaTitle}>Level Up Your Setup Today!</h2>
        <p>Join thousands of gamers who've transformed their gaming experience with INFINITY GAMER.</p>
        <Link to="/" replace>
        <button className={styles.ctaButton}>Shop Now</button>
        </Link>
      </section>
      <><Footer/></>
{/* 
      <footer className={styles.footer}>
        <p>© {new Date().getFullYear()} INFINITY GAMER. All rights reserved.</p>
      </footer> */}
    </div>
  )
}

export default About
