import React from 'react';
import { BrowserRouter as Router, Route, Routes } from 'react-router-dom';
import Home from './pages/Home/Home';
import Signup from './pages/signup/Signup';
import Login from './pages/login/Login';
import 'slick-carousel/slick/slick.css'; 
import 'slick-carousel/slick/slick-theme.css';  
import CartPage from './pages/addtocart/CartPage';
import { CartProvider } from './pages/addtocart/CartContext'
import UploadConsoleBundles from './components/body/Product_Sliders/Consolebundle/UploadConsoleBundles';
import UploadHomeSlidebar from './components/body/HomeSlideBar/UploadHomeslidebar/';
import UploadExclusivedealdiscount from './components/body/Product_Sliders/Exclusivedealdiscount/UploadExclusivedealdiscount';
import UploadFeatured from './components/body/Product_Sliders/Featured/UploadFeatured';
import UploadGamingaccessories from './components/body/Product_Sliders/Gamingaccessories/UploadGamingaccessories';
import UploadPreorder from './components/body/Product_Sliders/Pre-order/UploadPreorder';
import UploadShowcase from './components/body/showcase/UploadShowcase';
import SearchPage from './pages/Searchpage/SearchPage';
import PreorderPage from './components/body/Product_Sliders/Pre-order/Preorderpage/Preorderpage';
import FeaturedDescription from './components/body/Product_Sliders/Featured/FeaturedDescription';
import GamingAccessoriesDescription from './components/body/Product_Sliders/Gamingaccessories/GamingAcessoriesDescription';
import ExclusivedealdiscountDescription from './components/body/Product_Sliders/Exclusivedealdiscount/ExclusivedealdiscountDescription';
import ConsoleBundleDescription from './components/body/Product_Sliders/Consolebundle/ConsoleBundleDescription';
import Playstation from './pages/Playstation/Playstation';
import Uploadplaystationbanner from './pages/Playstation/Banner/UploadPlaystationbanner/';
import XboxShowcase from './pages/Xbox/xboxshowcase/';
import Uploadxboxfeaturedgames from './pages/Xbox/Uploadxboxfeaturedgames';
import PcComponent from './pages/Pccomponents/Pccomponent/';
import UploadPcComponentCategories from './pages/PcComponents/UploadPcComponent';
import Console from './pages/Consoles/Console';
import GamingAccessoriesPage from './pages/gamingaccessoriespage/gamingaccessoriespage/';
import UploadGamingaccessoriespage from './pages/gamingaccessoriespage/Uploadgamingaccessories';
import About from './pages/About/About';
import ContactUs from './pages/Contactus/Contactus';
import Checkout from './pages/Checkout/Checkout';
import PrivacyPolicy from './pages/PrivacyPolicy/PrivacyPolicy';
import ReturnPolicy from './pages/ReturnPolicy/ReturnPolicy';
import ShippingPolicy from './pages/ShippingPolicy/ShippingPolicy';
import TrackMyOrder from './pages/Trackmyorder/Trackmyorder';
import XboxShowcaseDescription from './pages/Xbox/Xboxshowcasedescription';
import Gamingaccessoriespagedescription from './pages/gamingaccessoriespage/Gamingaccessoriespagedescription';
import PcComponentdescription from './pages/PcComponents/PcComponentdescription'
import Profile from './pages/profile/profile';

function App() {
  return (
    <CartProvider>
      <Router>
        <UploadConsoleBundles/>
        <UploadHomeSlidebar/>
        <UploadExclusivedealdiscount/>
        <UploadFeatured/>
        <UploadGamingaccessories/>
        <UploadPreorder/>
        <UploadShowcase/>
        <Uploadplaystationbanner/>
        <Uploadxboxfeaturedgames/>
        <UploadPcComponentCategories/>
        <UploadGamingaccessoriespage/>
        <Routes>
          <Route path="/" element={<Home />} />
          <Route path="/signup" element={<Signup />} />
          <Route path="/login" element={<Login />} />
          <Route path="/cart" element={<CartPage />} />
          <Route path="/Search" element={<SearchPage />} />
          <Route path="/preorder" element={<PreorderPage />} />
          <Route path="/FeaturedDescription" element={<FeaturedDescription />} />
          <Route path="/GamingAccessoriesDescription" element={<GamingAccessoriesDescription />} />
          <Route path="/ExclusivedealdiscountDescription" element={<ExclusivedealdiscountDescription />} />
          <Route path="/ConsoleBundleDescription" element={<ConsoleBundleDescription />} />
          <Route path="/Playstation" element={<Playstation />} />
          <Route path="/XboxShowcase" element={<XboxShowcase />} />
          <Route path="/PcComponent" element={<PcComponent />} />
          <Route path="/Console" element={<Console/>} />
          <Route path="/GamingAccessoriesPage" element={<GamingAccessoriesPage/>} />
          <Route path="/About" element={<About/>} />
          <Route path="/ContactUs" element={<ContactUs/>} />
          <Route path="/Checkout" element={<Checkout/>} />
          <Route path="/PrivacyPolicy" element={<PrivacyPolicy/>} />
          <Route path="/ReturnPolicy" element={<ReturnPolicy/>} />
          <Route path="/ShippingPolicy" element={<ShippingPolicy/>} />
          <Route path="/TrackMyOrder" element={<TrackMyOrder/>} />
          <Route path="/XboxShowcaseDescription" element={<XboxShowcaseDescription/>} />
          <Route path="/Gamingaccessoriespagedescription" element={<Gamingaccessoriespagedescription/>} />
          <Route path="/PcComponentdescription" element={<PcComponentdescription/>} />
          <Route path="/Profile" element={<Profile/>} />
        </Routes>
      </Router>
    </CartProvider>
  );
}

export default App;
