import React, { useEffect, useState, useMemo } from "react";
import Slider from "react-slick";
import { FontAwesomeIcon } from "@fortawesome/react-fontawesome";
import { faChevronLeft, faChevronRight } from "@fortawesome/free-solid-svg-icons";
import "./homeslidebar.css";
import { collection, getDocs } from "firebase/firestore";
import { db } from "../../../firebase/";

const Arrow = ({ onClick, direction }) => (
  <div className={`arrow arrow-${direction}`} onClick={onClick}>
    <FontAwesomeIcon icon={direction === "right" ? faChevronRight : faChevronLeft} />
  </div>
);

const HomeSlideBar = () => {
  const [slides, setSlides] = useState([]);

  useEffect(() => {
    const fetchSlides = async () => {
      const collectionRef = collection(db, "HomeSlidebar");
      const querySnapshot = await getDocs(collectionRef);
      const fetchedSlides = querySnapshot.docs.map((doc) => {
        const data = doc.data();
  
        const img = new Image();
        img.src = data.image;
  
        return {
          id: doc.id,
          ...data,
        };
      });
  
      setSlides(fetchedSlides);
    };
  
    fetchSlides();
  }, []);
  

  const settings = useMemo(
    () => ({
      dots: true,
      infinite: true,
      speed: 800,
      slidesToShow: 1,
      slidesToScroll: 1,
      autoplay: true,
      autoplaySpeed: 3500,
      arrows: true,
      nextArrow: <Arrow direction="right" />,
      prevArrow: <Arrow direction="left" />,
      lazyLoad: "progressive",
      fade: true,
      cssEase: "ease-in-out",
    }),
    []
  );

  return (
    <div className="home-slider-bar">
      <Slider {...settings}>
        {slides.map(({ id, image }) => (
          <div key={id} className="slide">
            <div className="ken-burns">
              <img
                src={image}
                alt={`Slide ${id}`}
                className="slide-image"
                loading="earger"
              />
            </div>
          </div>
        ))}
      </Slider>
    </div>
  );
};

export default HomeSlideBar;

















// import React, { useEffect, useState, useMemo } from "react";
// import Slider from "react-slick";
// import { FontAwesomeIcon } from "@fortawesome/react-fontawesome";
// import { faChevronLeft, faChevronRight } from "@fortawesome/free-solid-svg-icons";
// import "./homeslidebar.css";
// import { collection, getDocs } from "firebase/firestore";
// import { db } from "../../../firebase/";

// const Arrow = ({ onClick, direction }) => (
//   <div className={`arrow arrow-${direction}`} onClick={onClick}>
//     <FontAwesomeIcon icon={direction === "right" ? faChevronRight : faChevronLeft} />
//   </div>
// );

// const getLowResUrl = (url) => {
//   const parts = url.split("/upload/");
//   return parts.length === 2
//     ? `${parts[0]}/upload/w_100,q_10,e_blur:200/${parts[1]}`
//     : url;
// };

// const HomeSlideBar = () => {
//   const [slides, setSlides] = useState([]);

//   useEffect(() => {
//     const fetchSlides = async () => {
//       const collectionRef = collection(db, "HomeSlidebar");
//       const querySnapshot = await getDocs(collectionRef);
//       const fetchedSlides = querySnapshot.docs.map((doc) => {
//         const data = doc.data();
//         return {
//           id: doc.id,
//           ...data,
//           lowRes: getLowResUrl(data.image),
//         };
//       });
//       setSlides(fetchedSlides);
//     };

//     fetchSlides();
//   }, []);

//   const settings = useMemo(
//     () => ({
//       dots: true,
//       infinite: true,
//       speed: 800,
//       slidesToShow: 1,
//       slidesToScroll: 1,
//       autoplay: true,
//       autoplaySpeed: 3500,
//       arrows: true,
//       nextArrow: <Arrow direction="right" />,
//       prevArrow: <Arrow direction="left" />,
//       lazyLoad: "progressive",
//       fade: true,
//       cssEase: "ease-in-out",
//     }),
//     []
//   );

//   return (
//     <div className="home-slider-bar">
//       <Slider {...settings}>
//         {slides.map(({ id, image, lowRes }) => (
//           <div key={id} className="slide">
//             <div className="ken-burns">
//               <img
//                 src={lowRes}
//                 data-src={image}
//                 alt={`Slide ${id}`}
//                 className="slide-image blur-up"
//                 loading="lazy"
//                 onLoad={(e) => {
//                   const img = e.target;
//                   img.src = img.dataset.src;
//                   img.classList.remove("blur-up");
//                 }}
//               />
//             </div>
//           </div>
//         ))}
//       </Slider>
//     </div>
//   );
// };

// export default HomeSlideBar;
