import React from "react";
import styles from "./Playstation.module.css";
import PlayStationBanner from "./Banner/Playstationbanner"; 
import Featuredshowcase from "./Featuredshowcase/Featuredshowcase";
import GameCarousel from "./Gamecarousel/Gamecarousel";
import DualSenseSection from "./Dualsensesection/Dualsensesection";
import Footer from "../../components/footer/Footer"
import ConsoleBundle from "../../components/body/Product_Sliders/Consolebundle/Consolebundle";
import Navbar from "../../components/navbar/Navbar";

export default function Playstation() {
  return (
    <div className={styles.playstationPage}>
      <Navbar/>
      <PlayStationBanner/>
      <Featuredshowcase/> 
      <GameCarousel/>
      <DualSenseSection/>
      <ConsoleBundle/>
      <Footer/>
    </div>
  );
}
