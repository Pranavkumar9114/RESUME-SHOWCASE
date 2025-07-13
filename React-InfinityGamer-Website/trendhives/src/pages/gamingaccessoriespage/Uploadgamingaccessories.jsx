// UploadGamingaccessoriespage.jsx
import React, { useEffect } from 'react';
import { collection, getDocs, addDoc, deleteDoc, doc } from 'firebase/firestore';
import { db } from '../../firebase';

const Gamingaccessoriespage = [
  {
    id: 1,
    title: "Phantom X Gaming Headset",
    price: "1299",
    genre: "FPS / MMO",
    description: "7.1 surround sound with noise-cancelling mic for crystal clear comms.",
    image: "https://res.cloudinary.com/do7ttqxgn/image/upload/v1744187645/1_pfnwn4.jpg",
    About: "Phantom X Gaming Headset offers immersive 7.1 surround sound that enhances gaming experiences, particularly in FPS and MMO genres. The noise-cancelling microphone ensures your communications with teammates are crystal clear, making it perfect for competitive gaming. Comfortable padding and adjustable headbands allow for extended gaming sessions without fatigue.",
    productspecification: {
      compatibility: "PC, Xbox, PlayStation",
      audio: "7.1 surround sound",
      mic: "Noise-cancelling",
      weight: "350g",
      warranty: "1 Year"
    }
  },
  {
    id: 2,
    title: "Viper Pro Gaming Mouse",
    price: "899",
    genre: "FPS / MOBA",
    description: "20K DPI optical sensor with 8 programmable buttons for ultimate precision.",
    image: "https://res.cloudinary.com/do7ttqxgn/image/upload/v1744187645/2_dputeh.jpg",
    About: "The Viper Pro Gaming Mouse is designed for precision and speed, boasting a high-performance 20K DPI optical sensor that provides unmatched accuracy for competitive play. The mouse features 8 programmable buttons allowing for personalized gaming configurations, which makes it ideal for FPS and MOBA genres.",
    productspecification: {
      DPI: "20,000",
      buttons: "8 programmable",
      connection: "Wired",
      weight: "85g",
      warranty: "2 Years"
    }
  },
  {
    id: 3,
    title: "Titan Mechanical Keyboard",
    price: "1499",
    genre: "All Games",
    description: "RGB backlit mechanical switches with N-key rollover and macro support.",
    image: "https://res.cloudinary.com/do7ttqxgn/image/upload/v1744187646/3_m7q1ko.jpg",
    About: "The Titan Mechanical Keyboard is perfect for gamers who prioritize performance and aesthetics, featuring customizable RGB backlighting and mechanical switches for tactile feedback. N-key rollover ensures that every key press is registered accurately, making it suitable for all gaming genres as well as typing tasks.",
    productspecification: {
      switchType: "Mechanical",
      backlight: "RGB",
      keyroll: "N-key rollover",
      dimensions: "430 x 135 x 40 mm",
      warranty: "1 Year"
    }
  },
  {
    id: 4,
    title: "Drift King Racing Wheel",
    price: "1999",
    genre: "Racing",
    description: "Force feedback racing wheel with 900° rotation and premium pedals.",
    image: "https://res.cloudinary.com/do7ttqxgn/image/upload/v1744187649/4_eblgfs.png",
    About: "Drift King Racing Wheel provides an incredibly realistic racing experience with its force feedback feature simulating the feel of real driving. With a 900° rotation angle and premium pedals, it’s designed for immersive gameplay that brings racing games to life.",
    productspecification: {
      rotation: "900°",
      forceFeedback: "Yes",
      pedals: "Premium pedals",
      compatibility: "PC, Xbox, PlayStation",
      warranty: "1 Year"
    }
  },
  {
    id: 5,
    title: "Stealth Gaming Chair",
    price: "2999",
    genre: "Comfort",
    description: "Ergonomic design with lumbar support and 4D adjustable armrests.",
    image: "https://res.cloudinary.com/do7ttqxgn/image/upload/v1744187646/5_vfnax0.webp",
    About: "The Stealth Gaming Chair is crafted for comfort during long gaming sessions, featuring an ergonomic design, lumbar support, and fully adjustable 4D armrests. This chair not only enhances your gaming setup but also promotes better posture and comfort.",
    productspecification: {
      material: "High-density foam",
      adjustments: "4D armrests, tilt mechanism",
      weightCapacity: "120 kg",
      dimensions: "70 x 70 x 130 cm",
      warranty: "2 Years"
    }
  },
  {
    id: 6,
    title: "Command Center XL Mousepad",
    price: "399",
    genre: "All Games",
    description: "Extended mousepad with micro-weave surface for smooth tracking.",
    image: "https://res.cloudinary.com/do7ttqxgn/image/upload/v1744187646/6.1_zensl7.jpg",
    About: "Command Center XL Mousepad is designed for gamers, featuring an extended size that provides ample space for high-speed movements. Its micro-weave surface ensures smooth tracking for both optical and laser mice, making it suitable for all gaming genres.",
    productspecification: {
      dimensions: "800 x 300 mm",
      surface: "Micro-weave",
      material: "Rubber base",
      warranty: "1 Year"
    }
  },
  {
    id: 7,
    title: "ThermaCool Cooling Pad",
    price: "999",
    genre: "Laptop Gaming",
    description: "Triple-fan cooling pad with adjustable height for better airflow.",
    image: "https://res.cloudinary.com/do7ttqxgn/image/upload/v1744187645/7_gtsrtg.webp",
    About: "The ThermaCool Cooling Pad enhances laptop gaming by providing exceptional airflow with its triple-fan design. Adjustable height settings allow users to maintain comfortable viewing angles while keeping their laptops cool during intense gaming sessions.",
    productspecification: {
      fans: "3",
      adjustableHeight: "Yes",
      compatibility: "All laptops",
      dimensions: "400 x 300 x 35 mm",
      warranty: "1 Year"
    }
  },
  {
    id: 8,
    title: "Rogue Stream Mic",
    price: "1199",
    genre: "Streaming / Multiplayer",
    description: "Condenser mic with noise filtering and boom arm for clean voice input.",
    image: "https://res.cloudinary.com/do7ttqxgn/image/upload/v1744187645/8_q085id.jpg",
    About: "The Rogue Stream Mic is perfect for gamers and streamers looking for high-quality audio input. With built-in noise filtering and a boom arm, it ensures that your voice comes through clearly without background distractions, enhancing your streaming experience.",
    productspecification: {
      type: "Condenser",
      filtering: "Noise filtering",
      mount: "Boom arm included",
      frequencyResponse: "20Hz - 20kHz",
      warranty: "1 Year"
    }
  },
  {
    id: 9,
    title: "Firestrike Wired Gamepad",
    price: "1099",
    genre: "Console / PC",
    description: "Ergonomic controller with vibration feedback and responsive triggers.",
    image: "https://res.cloudinary.com/do7ttqxgn/image/upload/v1744187646/9_m5qj1g.webp",
    About: "The Firestrike Wired Gamepad combines ergonomics with functionality, featuring vibration feedback and responsive triggers to enhance your gaming sessions. Compatible with both consoles and PC, it ensures a seamless gaming experience, providing reliable performance for all types of games.",
    productspecification: {
      connection: "Wired",
      compatibility: "PC, Xbox, PlayStation",
      features: "Vibration feedback, responsive triggers",
      dimensions: "160 x 108 x 60 mm",
      warranty: "1 Year"
    }
  },
  {
    id: 10,
    title: "Blaze Wireless Controller",
    price: "1499",
    genre: "Console",
    description: "Dual vibration motors and 10m wireless range with built-in battery.",
    image: "https://res.cloudinary.com/do7ttqxgn/image/upload/v1744187647/10_wwye1h.webp",
    About: "The Blaze Wireless Controller offers freedom of movement with a 10m wireless range, featuring dual vibration motors for an immersive gaming experience. It’s equipped with a built-in rechargeable battery, ensuring you stay connected without interruption during long gaming sessions.",
    productspecification: {
      connection: "Wireless",
      battery: "Rechargeable",
      vibration: "Dual motors",
      compatibility: "PC, Xbox, PlayStation",
      warranty: "1 Year"
    }
  },
  {
    id: 11,
    title: "StrikeForce Joystick",
    price: "1699",
    genre: "Flight / Space Sims",
    description: "Precision flight joystick with throttle slider and customizable buttons.",
    image: "https://res.cloudinary.com/do7ttqxgn/image/upload/v1744187647/11_diycx0.jpg",
    About: "StrikeForce Joystick is tailored for flight and space simulation enthusiasts, featuring a precision control stick and a throttle slider for authentic flying experiences. Customizable buttons allow for personal configuration suited to various flight simulations.",
    productspecification: {
      connection: "USB",
      compatibility: "PC",
      features: "Throttle slider, customizable buttons",
      weight: "1.2 kg",
      warranty: "1 Year"
    }
  },
  {
    id: 12,
    title: "Sniper Elite Gaming Mouse",
    price: "1099",
    genre: "FPS",
    description: "Ultra-light honeycomb shell with 1000Hz polling rate and 6 side buttons.",
    image: "https://res.cloudinary.com/do7ttqxgn/image/upload/v1744187648/12_gnayia.jpg",
    About: "The Sniper Elite Gaming Mouse caters to FPS gamers with its ultra-light honeycomb design that enhances maneuverability. Featuring a 1000Hz polling rate and 6 programmable side buttons, it provides the precision and responsiveness needed for competitive gameplay.",
    productspecification: {
      DPI: "16,000",
      pollingRate: "1000Hz",
      buttons: "6 customizable side buttons",
      connection: "Wired",
      warranty: "1 Year"
    }
  },
  {
    id: 13,
    title: "Armory TKL Keyboard",
    price: "1399",
    genre: "All Games",
    description: "Tenkeyless form factor with red linear switches for fast response.",
    image: "https://res.cloudinary.com/do7ttqxgn/image/upload/v1744187647/13_zqu3ov.webp",
    About: "The Armory TKL Keyboard combines a tenkeyless form factor with red linear switches to provide a fast and responsive typing experience. Its compact design allows for better desk space utilization while maintaining essential features for gamers.",
    productspecification: {
      switchType: "Red linear",
      formFactor: "Tenkeyless",
      backlight: "None",
      dimensions: "360 x 150 x 40 mm",
      warranty: "1 Year"
    }
  },
  {
    id: 14,
    title: "Zero Lag Wired Controller",
    price: "899",
    genre: "Arcade / Fighting",
    description: "Low-latency wired controller with turbo mode and D-pad precision.",
    image: "https://res.cloudinary.com/do7ttqxgn/image/upload/v1744187647/14_jzr1rr.jpg",
    About: "The Zero Lag Wired Controller is engineered for arcade and fighting games, featuring low-latency connections to ensure rapid responses. With a precise D-pad and turbo mode capabilities, it enhances your gameplay with reliability and speed.",
    productspecification: {
      connection: "Wired",
      features: "Turbo mode, D-pad precision",
      compatibility: "PC, Xbox",
      weight: "250g",
      warranty: "1 Year"
    }
  },
  {
    id: 15,
    title: "ProGear Gaming Headphones",
    price: "1499",
    genre: "Multiplayer / FPS",
    description: "Lightweight build with 50mm drivers and retractable mic.",
    image: "https://res.cloudinary.com/do7ttqxgn/image/upload/v1744187647/15_uxyrni.jpg",
    About: "ProGear Gaming Headphones provide comfort without compromising sound quality. With large 50mm drivers, they deliver precise sound reproduction, making them ideal for multiplayer and FPS games. The retractable mic ensures that you can communicate effectively during intense matches.",
    productspecification: {
      type: "Over-ear",
      drivers: "50mm",
      mic: "Retractable",
      connectivity: "3.5mm jack",
      warranty: "1 Year"
    }
  },
  {
    id: 16,
    title: "Falcon Wireless Mouse",
    price: "1299",
    genre: "MOBA / Casual",
    description: "Rechargeable wireless mouse with low latency mode.",
    image: "https://res.cloudinary.com/do7ttqxgn/image/upload/v1744187648/16_zut8e5.jpg",
    About: "The Falcon Wireless Mouse is engineered for versatility, suited for both MOBA games and casual use. It features a low latency mode for instant response times, and its rechargeable battery ensures uninterrupted gameplay for hours on end.",
    productspecification: {
      DPI: "10,000",
      battery: "Rechargeable",
      connection: "Wireless",
      weight: "90g",
      warranty: "1 Year"
    }
  },
  {
    id: 17,
    title: "TurboFire Console Gamepad",
    price: "999",
    genre: "Console / Arcade",
    description: "Responsive analog sticks, vibration motors, and long USB cable.",
    image: "https://res.cloudinary.com/do7ttqxgn/image/upload/v1744187648/17_sj2nst.jpg",
    About: "TurboFire Console Gamepad features responsive analog sticks and built-in vibration motors to enhance gameplay. The long USB cable allows for flexibility in movement, making it suitable for both console and arcade gaming.",
    productspecification: {
      connection: "Wired USB",
      features: "Responsive analog sticks, vibration feedback",
      compatibility: "PC, Xbox, PlayStation",
      warranty: "1 Year"
    }
  },
  {
    id: 18,
    title: "Echo Boom Mic",
    price: "799",
    genre: "Team Games / Streaming",
    description: "Compact desktop mic with crisp audio and flexible tripod mount.",
    image: "https://res.cloudinary.com/do7ttqxgn/image/upload/v1744187648/18_u67alx.jpg",
    About: "Echo Boom Mic is designed for streamers and gamers looking for high-quality audio. Its compact design fits perfectly on desks, while the flexible tripod mount allows for customizable positioning, delivering crisp audio for all your streaming needs.",
    productspecification: {
      type: "Dynamic",
      compatibility: "PC, Mac",
      frequencyResponse: "20Hz - 20kHz",
      warranty: "1 Year"
    }
  },
  {
    id: 19,
    title: "Battlezone Mechanical Keyboard",
    price: "1599",
    genre: "FPS / MOBA",
    description: "Blue clicky switches with anti-ghosting and macro support.",
    image: "https://res.cloudinary.com/do7ttqxgn/image/upload/v1744187649/19_jtdltu.webp",
    About: "Battlezone Mechanical Keyboard features tactile blue clicky switches that provide satisfying feedback during gameplay. With anti-ghosting technology and programmable macro support, it is designed for competitive gamers who demand performance and precision.",
    productspecification: {
      switchType: "Blue clicky",
      backlight: "None",
      antiGhosting: "Yes",
      dimensions: "400 x 160 x 40 mm",
      warranty: "1 Year"
    }
  },
  {
    id: 20,
    title: "SniperPad Pro Mousepad",
    price: "499",
    genre: "All Games",
    description: "Non-slip base and water-resistant surface for consistent control.",
    image: "https://res.cloudinary.com/do7ttqxgn/image/upload/v1744187649/20_hbmqyu.jpg",
    About: "SniperPad Pro Mousepad is crafted for all gaming needs, featuring a water-resistant surface and a non-slip base for superior control. It's designed to withstand intense movements and provide consistent tracking for both casual and competitive gamers.",
    productspecification: {
      dimensions: "800 x 400 mm",
      surface: "Water-resistant fabric",
      base: "Non-slip rubber",
      warranty: "1 Year"
    }
  },
];

// const Gamingaccessoriespage = [
//   {
//     id: 1,
//     title: "Phantom X Gaming Headset",
//     price: "1299",
//     genre: "FPS / MMO",
//     description: "7.1 surround sound with noise-cancelling mic for crystal clear comms.",
//     image: "https://res.cloudinary.com/do7ttqxgn/image/upload/v1744187645/1_pfnwn4.jpg",
//   },
//   {
//     id: 2,
//     title: "Viper Pro Gaming Mouse",
//     price: "899",
//     genre: "FPS / MOBA",
//     description: "20K DPI optical sensor with 8 programmable buttons for ultimate precision.",
//     image: "https://res.cloudinary.com/do7ttqxgn/image/upload/v1744187645/2_dputeh.jpg",
//   },
//   {
//     id: 3,
//     title: "Titan Mechanical Keyboard",
//     price: "1499",
//     genre: "All Games",
//     description: "RGB backlit mechanical switches with N-key rollover and macro support.",
//     image: "https://res.cloudinary.com/do7ttqxgn/image/upload/v1744187646/3_m7q1ko.jpg",
//   },
//   {
//     id: 4,
//     title: "Drift King Racing Wheel",
//     price: "1999",
//     genre: "Racing",
//     description: "Force feedback racing wheel with 900° rotation and premium pedals.",
//     image: "https://res.cloudinary.com/do7ttqxgn/image/upload/v1744187649/4_eblgfs.png",
//   },
//   {
//     id: 5,
//     title: "Stealth Gaming Chair",
//     price: "2999",
//     genre: "Comfort",
//     description: "Ergonomic design with lumbar support and 4D adjustable armrests.",
//     image: "https://res.cloudinary.com/do7ttqxgn/image/upload/v1744187646/5_vfnax0.webp",
//   },
//   {
//     id: 6,
//     title: "Command Center XL Mousepad",
//     price: "399",
//     genre: "All Games",
//     description: "Extended mousepad with micro-weave surface for smooth tracking.",
//     image: "https://res.cloudinary.com/do7ttqxgn/image/upload/v1744187646/6.1_zensl7.jpg",
//   },
//   {
//     id: 7,
//     title: "ThermaCool Cooling Pad",
//     price: "999",
//     genre: "Laptop Gaming",
//     description: "Triple-fan cooling pad with adjustable height for better airflow.",
//     image: "https://res.cloudinary.com/do7ttqxgn/image/upload/v1744187645/7_gtsrtg.webp",
//   },
//   {
//     id: 8,
//     title: "Rogue Stream Mic",
//     price: "1199",
//     genre: "Streaming / Multiplayer",
//     description: "Condenser mic with noise filtering and boom arm for clean voice input.",
//     image: "https://res.cloudinary.com/do7ttqxgn/image/upload/v1744187645/8_q085id.jpg",
//   },
//   {
//     id: 9,
//     title: "Firestrike Wired Gamepad",
//     price: "1099",
//     genre: "Console / PC",
//     description: "Ergonomic controller with vibration feedback and responsive triggers.",
//     image: "https://res.cloudinary.com/do7ttqxgn/image/upload/v1744187646/9_m5qj1g.webp",
//   },
//   {
//     id: 10,
//     title: "Blaze Wireless Controller",
//     price: "1499",
//     genre: "Console",
//     description: "Dual vibration motors and 10m wireless range with built-in battery.",
//     image: "https://res.cloudinary.com/do7ttqxgn/image/upload/v1744187647/10_wwye1h.webp",
//   },
//   {
//     id: 11,
//     title: "StrikeForce Joystick",
//     price: "1699",
//     genre: "Flight / Space Sims",
//     description: "Precision flight joystick with throttle slider and customizable buttons.",
//     image: "https://res.cloudinary.com/do7ttqxgn/image/upload/v1744187647/11_diycx0.jpg",
//   },
//   {
//     id: 12,
//     title: "Sniper Elite Gaming Mouse",
//     price: "1099",
//     genre: "FPS",
//     description: "Ultra-light honeycomb shell with 1000Hz polling rate and 6 side buttons.",
//     image: "https://res.cloudinary.com/do7ttqxgn/image/upload/v1744187648/12_gnayia.jpg",
//   },
//   {
//     id: 13,
//     title: "Armory TKL Keyboard",
//     price: "1399",
//     genre: "All Games",
//     description: "Tenkeyless form factor with red linear switches for fast response.",
//     image: "https://res.cloudinary.com/do7ttqxgn/image/upload/v1744187647/13_zqu3ov.webp",
//   },
//   {
//     id: 14,
//     title: "Zero Lag Wired Controller",
//     price: "899",
//     genre: "Arcade / Fighting",
//     description: "Low-latency wired controller with turbo mode and D-pad precision.",
//     image: "https://res.cloudinary.com/do7ttqxgn/image/upload/v1744187647/14_jzr1rr.jpg",
//   },
//   {
//     id: 15,
//     title: "ProGear Gaming Headphones",
//     price: "1499",
//     genre: "Multiplayer / FPS",
//     description: "Lightweight build with 50mm drivers and retractable mic.",
//     image: "https://res.cloudinary.com/do7ttqxgn/image/upload/v1744187647/15_uxyrni.jpg",
//   },
//   {
//     id: 16,
//     title: "Falcon Wireless Mouse",
//     price: "1299",
//     genre: "MOBA / Casual",
//     description: "Rechargeable wireless mouse with low latency mode.",
//     image: "https://res.cloudinary.com/do7ttqxgn/image/upload/v1744187648/16_zut8e5.jpg",
//   },
//   {
//     id: 17,
//     title: "TurboFire Console Gamepad",
//     price: "999",
//     genre: "Console / Arcade",
//     description: "Responsive analog sticks, vibration motors, and long USB cable.",
//     image: "https://res.cloudinary.com/do7ttqxgn/image/upload/v1744187648/17_sj2nst.jpg",
//   },
//   {
//     id: 18,
//     title: "Echo Boom Mic",
//     price: "799",
//     genre: "Team Games / Streaming",
//     description: "Compact desktop mic with crisp audio and flexible tripod mount.",
//     image: "https://res.cloudinary.com/do7ttqxgn/image/upload/v1744187648/18_u67alx.jpg",
//   },
//   {
//     id: 19,
//     title: "Battlezone Mechanical Keyboard",
//     price: "1599",
//     genre: "FPS / MOBA",
//     description: "Blue clicky switches with anti-ghosting and macro support.",
//     image: "https://res.cloudinary.com/do7ttqxgn/image/upload/v1744187649/19_jtdltu.webp",
//   },
//   {
//     id: 20,
//     title: "SniperPad Pro Mousepad",
//     price: "499",
//     genre: "All Games",
//     description: "Non-slip base and water-resistant surface for consistent control.",
//     image: "https://res.cloudinary.com/do7ttqxgn/image/upload/v1744187649/20_hbmqyu.jpg",
//   },
// ];

const UploadGamingaccessoriespage = () => {

  const clearExistingData = async () => {
    const collectionRef = collection(db, 'Gamingaccessoriespage');
    const querySnapshot = await getDocs(collectionRef);
    querySnapshot.forEach(async (docSnapshot) => {
      await deleteDoc(doc(db, 'Gamingaccessoriespage', docSnapshot.id));
    });
  };


  const uploadData = async () => {
    try {
      await clearExistingData(); 
      const collectionRef = collection(db, 'Gamingaccessoriespage');

      for (const bundle of Gamingaccessoriespage) {
        await addDoc(collectionRef, bundle);
      }

      console.log('Data uploaded successfully!');
    } catch (error) {
      console.error('Error uploading data:', error);
    }
  };

  // Automatically run once when the component is mounted
  // useEffect(() => {
  //     uploadData();
  // }, []);

  // return null;
};

export default UploadGamingaccessoriespage;
