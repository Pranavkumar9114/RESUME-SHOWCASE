import React, { useState, useEffect, useRef } from 'react';
import './navbar.css';
import { FaShoppingCart, FaSignInAlt, FaSearch, FaHeart, FaGift, FaBuilding, FaTractor, FaInfoCircle, FaBlog, FaPlaystation, FaXbox, FaConfluence, FaTools, FaMicrochip, FaUserAlt, FaUser, FaUserCircle, FaShippingFast } from 'react-icons/fa';
import { Link } from "react-router-dom";
import { auth } from "../../firebase";
import { onAuthStateChanged, signOut } from "firebase/auth";

export default function Navbar() {

  const [cartCount, setCartCount] = useState(() => {
    const storedCart = JSON.parse(localStorage.getItem("cartItems")) || [];
    return storedCart.reduce((total, item) => total + (item.quantity || 1), 0);
  });

  useEffect(() => {
    const updateCartCount = () => {
      const storedCart = JSON.parse(localStorage.getItem("cartItems")) || [];
      const total = storedCart.reduce((sum, item) => sum + (item.quantity || 1), 0);
      setCartCount(total);
    };


    window.addEventListener("cartUpdated", updateCartCount);


    return () => {
      window.removeEventListener("cartUpdated", updateCartCount);
    };
  }, []);



  const [isLoggedIn, setIsLoggedIn] = useState(() => {
 
    return localStorage.getItem('isLoggedIn') === 'true';
  });
  const [isHovered, setIsHovered] = useState(false);

 
  useEffect(() => {
    const unsubscribe = onAuthStateChanged(auth, (user) => {
      const loggedIn = !!user;
      setIsLoggedIn(loggedIn);
 
      localStorage.setItem('isLoggedIn', loggedIn.toString());
    });
    return () => unsubscribe();  
  }, []);


  const toggleHover = (hoverState) => {
    setIsHovered(hoverState);
  };

  // Handle Logout
  const handleLogout = async () => {
    try {
      await signOut(auth);
      console.log("Logged out successfully");
      setIsLoggedIn(false);  
      localStorage.removeItem('isLoggedIn');  
    } catch (error) {
      console.error("Logout failed:", error);
    }
  };


  // const [isLoggedIn, setIsLoggedIn] = useState(false);
  // const [isHovered, setIsHovered] = useState(false);

  // // Listen to Firebase Auth state changes
  // useEffect(() => {
  //   const unsubscribe = onAuthStateChanged(auth, (user) => {
  //     setIsLoggedIn(!!user);  // Sets to true if user is logged in, otherwise false
  //   });
  //   return () => unsubscribe();  // Cleanup listener on component unmount
  // }, []);

  // // Toggle hover state for showing/hiding the logout button
  // const toggleHover = (hoverState) => {
  //   setIsHovered(hoverState);
  // };

  // // Handle Logout
  // const handleLogout = async () => {
  //   try {
  //     await signOut(auth);
  //     console.log("Logged out successfully");
  //     setIsLoggedIn(false);  // Update state to reflect logout
  //   } catch (error) {
  //     console.error("Logout failed:", error);
  //   }
  // };



  const [menuOpen, setMenuOpen] = useState(false);
  const [dropdownOpen, setDropdownOpen] = useState({
    newArrivals: false,
    shop: false,
    lookbook: false,
    about: false,
    blog: false,
    sale: false
  });

  // References for menu and hamburger
  const navbarRef = useRef(null);
  const menuRef = useRef(null);

  const toggleMenu = () => {
    setMenuOpen(!menuOpen);
  };

  const toggleDropdown = (menu) => {
    setDropdownOpen((prevState) => {
      const newDropdownState = {
        newArrivals: false,
        shop: false,
        lookbook: false,
        about: false,
        blog: false,
        sale: false,
        [menu]: !prevState[menu] 
      };
      return newDropdownState;
    });
  };


  const handleClickOutside = (event) => {
    if (navbarRef.current && !navbarRef.current.contains(event.target) && !menuRef.current.contains(event.target)) {
      setMenuOpen(false);
    }
  };

  
  useEffect(() => {
    document.addEventListener('mousedown', handleClickOutside); 
    document.addEventListener('touchstart', handleClickOutside); 
    return () => {
      document.removeEventListener('mousedown', handleClickOutside);
      document.removeEventListener('touchstart', handleClickOutside);
    };
  }, []);

  return (
    <header className="navbar" ref={navbarRef}>
      <div className="navbar-container">
 
        <nav className={`navbar-links ${menuOpen ? 'open' : ''}`}>
          <div className="navbar-logo-nav">
            <Link to="/" replace>
              <img src="/assets/logo.png" alt="error" />
            </Link>
          </div>
          <ul>
            <li className="nav-item">
              {/* <a href="#new-arrivals" onClick={() => toggleDropdown('newArrivals')}> */}
              <Link to="/Playstation" onClick={() => toggleDropdown('newArrivals')}>
                <FaPlaystation className='icon' /> PLAYSTATION
              </Link>
              {/* </a> */}
              {/* <div className={`dropdown ${dropdownOpen.newArrivals ? 'open' : ''}`}>
                <ul>
                  <li><a href="#playstation-1">PlayStation 1</a></li>
                  <li><a href="#playstation-2">PlayStation 2</a></li>
                  <li><a href="#playstation-3">PlayStation 3</a></li>
                </ul>
              </div> */}
            </li>
            <li className="nav-item">
              {/* <a href="#shop" onClick={() => toggleDropdown('shop')}> */}
              <Link to="/XboxShowcase" onClick={() => toggleDropdown('shop')}>
                <FaXbox className='icon' /> XBOX
              </Link>
              {/* </a> */}
              {/* <div className={`dropdown ${dropdownOpen.shop ? 'open' : ''}`}>
                <ul>
                  <li><a href="#xbox-1">Xbox One</a></li>
                  <li><a href="#xbox-2">Xbox Series X</a></li>
                </ul>
              </div> */}
            </li>
            <li className="nav-item">
              {/* <a href="#lookbook" onClick={() => toggleDropdown('lookbook')}> */}
              <Link to="/Console">
                <FaConfluence className='icon' /> CONSOLES
              </Link>
              {/* </a> */}
              {/* <div className={`dropdown ${dropdownOpen.lookbook ? 'open' : ''}`}>
                <ul>
                  <li><a href="#console-1">Console 1</a></li>
                  <li><a href="#console-2">Console 2</a></li>
                </ul>
              </div> */}
            </li>
            <li className="nav-item">
              {/* <a href="#about" onClick={() => toggleDropdown('about')}> */}
              <Link to="/GamingAccessoriesPage">
                <FaTools className='icon' /> ACCESSORIES
              </Link>
              {/* </a> */}
              {/* <div className={`dropdown ${dropdownOpen.about ? 'open' : ''}`}>
                <ul>
                  <li><a href="#accessory-1">Accessory 1</a></li>
                  <li><a href="#accessory-2">Accessory 2</a></li>
                </ul>
              </div> */}
            </li>
            <li className="nav-item">
              {/* <a href="#blog" onClick={() => toggleDropdown('blog')}> */}
              <Link to="/PcComponent">
                <FaMicrochip className='icon' /> PC COMPONENTS
              </Link>
              {/* </a> */}
              {/* <div className={`dropdown ${dropdownOpen.blog ? 'open' : ''}`}>
                <ul>
                  <li><a href="#pc-component-1">PC Part 1</a></li>
                  <li><a href="#pc-component-2">PC Part 2</a></li>
                </ul>
              </div> */}
            </li>
            <li className="nav-item">
              <a href="#sale" onClick={() => toggleDropdown('sale')}>
                <FaBuilding className='icon' /> COMPANY
              </a>
              <div className={`dropdown ${dropdownOpen.sale ? 'open' : ''}`}>
                <ul>
                  <li><Link to="/About">About Us</Link></li>
                  <li><Link to="/ContactUs">Contact Us</Link></li>
                  <li><Link to="/PrivacyPolicy">Privacy Policy</Link></li>
                  <li><Link to="/ReturnPolicy">Return Policy</Link></li>
                  <li><Link to="/ShippingPolicy">Shipping Policy</Link></li>
                </ul>
              </div>
            </li>
          </ul>
        </nav>

        {/* Right: Sign In, Search, Wishlist, Cart */}
        <div className="navbar-right">
          <Link to="/Search">
            <FaSearch className='icon' /> Search
          </Link>
          <Link to="/TrackMyOrder">
            <FaShippingFast className='icon' /> Track
          </Link>
          <Link to="/cart" className="cart-icon-wrapper">
            <FaShoppingCart className="icon" /> Cart
            {cartCount > 0 && <span className="cart-badge">{cartCount}</span>}
          </Link>

          {/* <Link to="/cart">
            <FaShoppingCart className="icon" /> Cart
          </Link> */}
        </div>
        <div className='desktop-user-icon-wrapper' >
          {isLoggedIn ? (
            <div
              className="user-icon-wrapper"
              onMouseEnter={() => setIsHovered(true)}
              onMouseLeave={() => setIsHovered(false)}
            >
              <Link to="/Profile">
                <FaUserCircle className='signin-icon' title="Logged In" />
              </Link>
              {isHovered && (
                <button className="logout-button" onClick={handleLogout}>
                  Logout
                </button>
              )}
            </div>
          ) : (
            <Link to="/signup" className='custom-icon'>
              <FaSignInAlt color='coral' /> Signup
            </Link>
          )}
        </div>


        {/* Mobile: Icons and Hamburger Menu */}
        <div className="navbar-mobile-menu" onClick={toggleMenu} ref={menuRef}>
          <span className="hamburger"></span>
        </div>

      </div>

      {/* Slide-out Menu for Mobile */}
      <div className={`navbar-slideout ${menuOpen ? 'open' : ''}`}>
        <div className="slideout-auth-buttons">
          {isLoggedIn ? (
            <div className="user-icon-wrapper">
              <FaUserCircle className='signin-icon' title="Logged In" />
              <button className="logout-button" onClick={handleLogout}>
                Logout
              </button>
            </div>
          ) : (
            <Link to="/signup" className='custom-icon2'>
              Signup
            </Link>
          )}

        </div>
        <ul>
          <li>
            {/* <a href="#new-arrivals" onClick={() => toggleDropdown('newArrivals')}> */}
            <Link to="/Playstation" onClick={() => toggleDropdown('newArrivals')}>
              <FaPlaystation className='icon' /> PLAYSTATION
            </Link>
            {/* </a> */}
            {/* <div className={`dropdown2 ${dropdownOpen.newArrivals ? 'open' : ''}`}>
              <ul>
                <li><a href="#new-arrival-1">New Item 1</a></li>
                <li><a href="#new-arrival-2">New Item 2</a></li>
              </ul>
            </div> */}
          </li>
          <li>
            <Link to="/XboxShowcase" onClick={() => toggleDropdown('shop')}>
              <FaXbox className='icon' /> XBOX
            </Link>
            {/* <a href="#shop" onClick={() => toggleDropdown('shop')}>
              <FaShoppingCart className='icon' /> Shop
            </a>
            <div className={`dropdown2 ${dropdownOpen.shop ? 'open' : ''}`}>
              <ul>
                <li><a href="#shop-1">Shop Item 1</a></li>
                <li><a href="#shop-2">Shop Item 2</a></li>
              </ul>
            </div> */}
          </li>
          <li>
            <Link to="/Console">
              <FaConfluence className='icon' /> CONSOLES
            </Link>
            {/* <a href="#lookbook" onClick={() => toggleDropdown('lookbook')}>
              <FaHeart className='icon' /> Lookbook
            </a>
            <div className={`dropdown2 ${dropdownOpen.lookbook ? 'open' : ''}`}>
              <ul>
                <li><a href="#lookbook-1">Look 1</a></li>
                <li><a href="#lookbook-2">Look 2</a></li>
              </ul>
            </div> */}
          </li>
          <li>
            <Link to="/GamingAccessoriesPage">
              <FaTools className='icon' /> ACCESSORIES
            </Link>
            {/* <a href="#about" onClick={() => toggleDropdown('about')}>
              <FaInfoCircle className='icon' /> About
            </a>
            <div className={`dropdown2 ${dropdownOpen.about ? 'open' : ''}`}>
              <ul>
                <li><a href="#about-us">About Us</a></li>
                <li><a href="#contact">Contact</a></li>
              </ul>
            </div> */}
          </li>
          <li>
            <Link to="/PcComponent">
              <FaMicrochip className='icon' /> PC COMPONENTS
            </Link>
            {/* <a href="#blog" onClick={() => toggleDropdown('blog')}>
              <FaBlog className='icon' /> Blog
            </a>
            <div className={`dropdown2 ${dropdownOpen.blog ? 'open' : ''}`}>
              <ul>
                <li><a href="#blog-1">Blog 1</a></li>
                <li><a href="#blog-2">Blog 2</a></li>
              </ul>
            </div> */}
          </li>
          <li>
            <a href="#sale" onClick={() => toggleDropdown('sale')}>
              <FaGift className='icon' /> ABOUT
            </a>
            <div className={`dropdown2 ${dropdownOpen.sale ? 'open' : ''}`}>
              <ul>
                <li><Link to="/About">About Us</Link></li>
                <li><Link to="/ContactUs">Contact</Link></li>
              </ul>
            </div>
            {/* <a href="#sale" onClick={() => toggleDropdown('sale')}>
              <FaGift className='icon' /> Sale
            </a>
            <div className={`dropdown2 ${dropdownOpen.sale ? 'open' : ''}`}>
              <ul>
                <li><a href="#sale-1">Sale Item 1</a></li>
                <li><a href="#sale-2">Sale Item 2</a></li>
              </ul>
            </div> */}
          </li>
        </ul>
      </div>
    </header>
  );
}
