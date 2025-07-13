import React from "react";
import { motion } from "framer-motion";
import Navbar from "../../components/navbar/Navbar";
import Promotion from "../../components/body/promotion/Promotion";
import HomeSlideBar from "../../components/body/HomeSlideBar/HomeSlideBar";
import Showcase from "../../components/body/showcase/Showcase";
import Featured from "../../components/body/Product_Sliders/Featured/Featured"
import Preorder from "../../components/body/Product_Sliders/Pre-order/Preorder";
import Exclusivedealdiscount from "../../components/body/Product_Sliders/Exclusivedealdiscount/Exclusivedealdiscount";
import Gamingaccessories from "../../components/body/Product_Sliders/Gamingaccessories/Gamingaccessories"
import Consolebundle from "../../components/body/Product_Sliders/Consolebundle/Consolebundle";
import Footer from "../../components/footer/Footer";


// Memoized Components to Reduce Unnecessary Renders
const MemoizedHomeSlideBar = React.memo(HomeSlideBar);
const MemoizedShowcase = React.memo(Showcase);
const MemoizedFeatured = React.memo(Featured);
const MemoizedPreorder = React.memo(Preorder);
const MemoizedExclusivedealdiscount = React.memo(Exclusivedealdiscount);
const MemoizedGamingaccessories = React.memo(Gamingaccessories);
const MemoizedConsolebundle = React.memo(Consolebundle);
const MemoizedFooter = React.memo(Footer);

export default function Home() {
  return (
    <>
      <Navbar />
      <Promotion />

      <motion.div
        initial={{ opacity: 0, y: 15 }}
        whileInView={{ opacity: 1, y: 0 }}
        transition={{ duration: 0.4, ease: "easeOut" }} 
        viewport={{ amount: 0.2 }}
      >
        <MemoizedHomeSlideBar />
      </motion.div>

      <motion.div
        initial={{ opacity: 0, x: -15 }} 
        whileInView={{ opacity: 1, x: 0 }}
        transition={{ duration: 0.4, ease: "easeOut" }} 
        viewport={{ amount: 0.2 }}
      >
        <MemoizedShowcase />
      </motion.div>

      <motion.div
      >
        <MemoizedFeatured />
      </motion.div>

      <motion.div
      >
        <MemoizedPreorder />
      </motion.div>

      <motion.div
      >
        <MemoizedExclusivedealdiscount />
      </motion.div>

      <motion.div
      >
        <MemoizedGamingaccessories />
      </motion.div>

      <motion.div
      >
        <MemoizedConsolebundle />
      </motion.div>

      <motion.div
        initial={{ opacity: 0, x: -15 }}
        whileInView={{ opacity: 1, x: 0 }}
        transition={{ duration: 0.4, ease: "easeOut" }} 
        viewport={{ amount: 0.2 }}
      >
        <MemoizedFooter />
      </motion.div>

    </>
  );
}
