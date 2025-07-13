import React, { useEffect } from 'react';
import { collection, getDocs, addDoc, deleteDoc, doc } from 'firebase/firestore';
import { db } from '../../../../firebase';

const consoleBundles = [
    {
        "id": 1,
        "name": "PlayStation 5 Digital Edition Bundle",
        "image": "https://res.cloudinary.com/do7ttqxgn/image/upload/v1739549799/7_s5cufs.jpg",
        "price": "₹59999",
        "rating": "4.7",
        "details": "PS5 Digital Edition, DualSense Controller, and Spider-Man 2.",
        "about": "The PlayStation 5 Digital Edition Bundle is a complete package for gamers who want to immerse themselves in next-gen gaming. This bundle includes the iconic PS5 Digital Edition, which offers lightning-fast load times, stunning graphics, and innovative gameplay features. With no disc drive, it encourages a fully digital experience, making it easy to download and play your favorite titles.\n\nAccompanying the console is the DualSense Controller, which revolutionizes gaming with haptic feedback and adaptive triggers, allowing for a truly immersive experience. Feel the impact of every action and enjoy enhanced gameplay that responds to your every move.\n\nThis bundle also includes the highly acclaimed game, Spider-Man 2, which showcases the capabilities of the PS5 and offers an engaging storyline along with beautiful graphics that draw you deeper into the Marvel universe. Whether you're an avid gamer or new to the PlayStation family, this bundle is the perfect way to kickstart your gaming journey.",
        "productSpecification": {
            "type": "Gaming Console",
            "Storage": "825GB SSD",
            "Resolution": "Up to 4K",
            "HDR": "Yes",
            "Included Accessories": "DualSense Controller"
        }
    },
    {
        "id": 2,
        "name": "Xbox Series S Starter Pack",
        "image": "https://res.cloudinary.com/do7ttqxgn/image/upload/v1739549799/id_8_ezagc3.jpg",
        "price": "₹39999",
        "rating": "4.5",
        "details": "Xbox Series S, Controller, and 3-Month Game Pass.",
        "about": "The Xbox Series S Starter Pack is the ideal setup for gamers looking to enter the next generation of gaming without breaking the bank. Compact and powerful, the Xbox Series S delivers stunning performance and fast load times, promising an immersive and seamless gaming experience with up to 1440p resolution.\n\nThis starter pack includes a wireless controller designed for comfort and responsive gameplay. With an ergonomic grip and customizable buttons, it's perfect for extended gaming sessions. The bundle also includes a 3-Month Xbox Game Pass subscription, granting access to a vast library of games, including new releases and classic favorites.\n\nWhether you're playing solo or with friends, the Xbox Series S Starter Pack transforms your gaming experience with its diverse offerings. It's an excellent choice for both novice gamers and seasoned players seeking a compact console with extensive capabilities.",
        "productSpecification": {
            "type": "Gaming Console",
            "Storage": "512GB SSD",
            "Resolution": "Up to 1440p",
            "HDR": "Yes",
            "Included Accessories": "Wireless Controller"
        }
    },
    {
        "id": 3,
        "name": "Nintendo Switch OLED Deluxe Set",
        "image": "https://res.cloudinary.com/do7ttqxgn/image/upload/v1739549799/9_ycj4sn.jpg",
        "price": "₹39999",
        "rating": "4.8",
        "details": "Nintendo Switch OLED, Pro Controller, and Zelda: TOTK.",
        "about": "The Nintendo Switch OLED Deluxe Set is a versatile gaming system that offers the freedom to play at home or on the go. The OLED model features a vibrant 7-inch screen, which provides more vivid colors and sharper contrast, enhancing your gaming experience. The increased battery life allows for longer gameplay sessions, making it perfect for portable play.\n\nAccompanying the Switch is the Pro Controller, which brings an ergonomic design and improved accuracy, elevating your playing comfort, whether you're on the couch or out and about. With the included game, Zelda: Tears of the Kingdom, you can dive into a stunning world full of adventure and exploration, showcasing the capabilities of this fantastic console.\n\nThis deluxe set is perfect for gamers who appreciate flexibility, quality, and immersive gameplay, allowing you to enjoy the best of Nintendo's offerings in an elegant package.",
        "productSpecification": {
            "type": "Handheld Console",
            "Display": "7-inch OLED",
            "Storage": "64GB",
            "Resolution": "720p (handheld) / 1080p (docked)",
            "Included Accessories": "Pro Controller"
        }
    },
    {
        "id": 4,
        "name": "PC Gaming Master Pack",
        "image": "https://res.cloudinary.com/do7ttqxgn/image/upload/v1739549799/id_10_qh1tzt.webp",
        "price": "₹19999",
        "rating": "4.9",
        "details": "High-end Gaming PC, HD Screen, RTX 4070, RGB Keyboard & Mouse.",
        "about": "The PC Gaming Master Pack is the all-in-one solution for gamers who demand high performance and stunning visuals. This set includes a high-end gaming PC equipped with the powerful RTX 4070 graphics card, ensuring you can run the latest games at ultra settings with smooth frame rates. Experience cutting-edge graphics and seamless gameplay that elevate your gaming sessions.\n\nThe bundle also features an HD monitor that delivers crystal-clear visuals, enhancing your gameplay experience across all genres. The inclusion of an RGB mechanical keyboard and mouse provides a stylish touch to your setup while also offering rapid responsiveness and customizable lighting options.\n\nWhether you're into competitive gaming or immersive single-player experiences, this master pack has everything you need to create an extraordinary gaming environment that stands out.",
        "productSpecification": {
            "type": "Gaming PC",
            "CPU": "Intel Core i7",
            "GPU": "NVIDIA RTX 4070",
            "RAM": "16GB",
            "Storage": "1TB SSD",
            "Included Accessories": "RGB Keyboard, RGB Mouse"
        }
    },
    {
        "id": 5,
        "name": "VR Gaming Experience Set",
        "image": "https://res.cloudinary.com/do7ttqxgn/image/upload/v1739549799/11_dhta5h.jpg",
        "price": "₹69999",
        "rating": "4.7",
        "details": "Meta Quest 3, Controllers, and 3 VR Games.",
        "about": "Dive into the world of virtual reality with the VR Gaming Experience Set, featuring the cutting-edge Meta Quest 3. This standalone VR headset provides a unique immersive experience that transports you into virtual worlds without the need for an additional gaming PC.\n\nThe set includes ergonomic controllers for intuitive interactions, allowing you to navigate and play VR games comfortably. Additionally, you will receive three highly acclaimed VR games that fully utilize the Quest 3's capabilities, providing hours of engaging gameplay, exploration, and enjoyment.\n\nPerfect for both casual gamers and VR enthusiasts, this set is the ultimate gateway to the exciting realm of VR gaming, making it a must-have for anyone looking to elevate their gaming experiences.",
        "productSpecification": {
            "type": "VR Headset",
            "Resolution": "1832 x 1920 per eye",
            "Tracking": "Inside-out",
            "Field of View": "120 degrees",
            "Compatibility": "Standalone"
        }
    },
    {
        "id": 6,
        "name": "PlayStation 5 Racing Bundle",
        "image": "https://res.cloudinary.com/do7ttqxgn/image/upload/v1739549802/id_12_xyxyt3.jpg",
        "price": "₹19999",
        "rating": "4.4",
        "details": "PS5 THRUSTMASTER",
        "about": "The PlayStation 5 Racing Bundle takes your racing games to the next level with a complete setup designed for adrenaline-filled experiences. This bundle includes the PS5 console and a THRUSTMASTER racing wheel, enhancing your immersion in racing titles with precise steering and responsiveness.\n\nWith the added benefit of realistic force feedback, feel every turn and bump as you race against your friends or the AI. The PS5's advanced capabilities ensure stunning graphics and seamless gameplay, making each race a thrilling adventure. Built for comfort, the racing wheel's ergonomic design allows for extended gaming sessions without fatigue.\n\nWhether you're a casual player or a hardcore racing fan, this bundle offers an unparalleled experience that elevates your racing games to a professional level.",
        "productSpecification": {
            "type": "Racing Wheel Bundle",
            "Compatibility": "PlayStation 5",
            "Features": "Force Feedback, Adjustable Sensitivity",
            "Included Accessories": "THRUSTMASTER Racing Wheel"
        }
    },
    {
        "id": 7,
        "name": "Xbox Series X Combo",
        "image": "https://res.cloudinary.com/do7ttqxgn/image/upload/v1739550254/id_13_ke2rhv.jpg",
        "price": "₹8999",
        "rating": "4.8",
        "details": "Xbox Series X, Elite Controller.",
        "about": "The Xbox Series X Combo provides everything a gamer needs for the ultimate gaming experience. This bundle includes the powerful Xbox Series X, known for its stunning graphics and swift performance, making it the most powerful console on the market today.\n\nPaired with an Elite Controller, which offers customizable button mapping and adjustable thumbsticks, you can tailor your gameplay for maximum precision. The combination of these two products guarantees a significant edge in competitive gaming, providing unrivaled control and comfort.\n\nWith vast storage options and backwards compatibility with a massive library of games, this combo is perfect for both new and returning players, ensuring you have access to iconic titles along with the latest releases.",
        "productSpecification": {
            "type": "Gaming Console",
            "Storage": "1TB SSD",
            "Resolution": "Up to 4K",
            "HDR": "Yes",
            "Included Accessories": "Elite Controller"
        }
    },
    {
        "id": 8,
        "name": "PlayStation 5 XR Edition",
        "image": "https://res.cloudinary.com/do7ttqxgn/image/upload/v1739550259/id_14_newwdn.png",
        "price": "₹199999",
        "rating": "4.7",
        "details": "PS5, PlayStation VR2, PlayStation VR2 Controllers and Elite Controller.",
        "about": "Experience the future of gaming with the PlayStation 5 XR Edition, which combines the power of the PS5 with the immersive technology of PlayStation VR2. This bundle is designed for those who seek a comprehensive gaming experience that transcends traditional gaming.\n\nThe PS5 provides spectacular graphics and ultra-fast loading times, while the VR2 headset immerses you in virtual worlds like never before. Coupled with the VR2 Controllers, you'll engage in VR gameplay that feels intuitive and responsive.\n\nIn addition, the bundle includes an Elite Controller, offering customizable controls and enhanced precision for a versatile gaming experience both in traditional and VR settings. The PlayStation 5 XR Edition is the ultimate bundle for gamers ready to embrace the next level of interactive entertainment.",
        "productSpecification": {
            "type": "Gaming Console Bundle",
            "Storage": "825GB SSD",
            "VR Headset": "PlayStation VR2",
            "Included Accessories": "Elite Controller",
            "Compatibility": "PlayStation 5"
        }
    },
    {
        "id": 9,
        "name": "Nintendo Switch Multiplayer Set",
        "image": "https://res.cloudinary.com/do7ttqxgn/image/upload/v1739550255/id_15_anunt5.jpg",
        "price": "₹49999",
        "rating": "4.6",
        "details": "Nintendo Switch OLED, 4 Exclusive Games.",
        "about": "The Nintendo Switch Multiplayer Set is perfect for family fun and social gaming sessions. Featuring the Nintendo Switch OLED console, this set emphasizes portable gaming with a vibrant display and an impressive library of exclusive games.\n\nIncluded in the bundle are four exclusive titles that bring the magic of Nintendo to life, offering exciting adventures, multiplayer challenges, and fun-filled experiences for players of all ages. The OLED model provides hours of uninterrupted gameplay, whether you are playing at home on the TV or on-the-go.\n\nIdeal for parties or multiplayer gaming nights, the Nintendo Switch Multiplayer Set ensures everyone can join in on the fun. It's a fantastic gift for gamers seeking a console that delivers both personal enjoyment and social interaction.",
        "productSpecification": {
            "type": "Handheld Console",
            "Display": "7-inch OLED",
            "Storage": "64GB",
            "Resolution": "720p (handheld) / 1080p (docked)",
            "Included Accessories": "4 Exclusive Games"
        }
    },
    {
        "id": 10,
        "name": "PC Gaming Ultra Pack",
        "image": "https://res.cloudinary.com/do7ttqxgn/image/upload/v1739550256/id_16_xsfqrc.jpg",
        "price": "₹199999",
        "rating": "4.9",
        "details": "High End CPU, 4K Monitor, Gaming Mat, RGB Keyboard & Mouse.",
        "about": "The PC Gaming Ultra Pack is engineered for hardcore gamers who refuse to compromise on performance. Central to this bundle is a high-end CPU that powers demanding games with ease, supported by a stunning 4K monitor that brings out every detail and color in high fidelity.\n\nAdditionally, the set includes a spacious gaming mat, ergonomic RGB keyboard, and precision RGB mouse, creating an environment tailored for seamless gameplay. With customizable RGB lighting, you can easily personalize your setup to reflect your gaming style.\n\nWhether you're exploring expansive worlds or battling it out in competitive gaming, this ultra pack covers all aspects of high-performance gaming, promising an unparalleled experience that keeps you ahead of the competition.",
        "productSpecification": {
            "type": "Gaming Setup",
            "CPU": "Intel Core i9",
            "Monitor": "4K Resolution",
            "RAM": "32GB",
            "Included Accessories": "Gaming Mat, RGB Keyboard, RGB Mouse"
        }
    },
    {
        "id": 11,
        "name": "Steam Deck Ultimate Bundle",
        "image": "https://res.cloudinary.com/do7ttqxgn/image/upload/v1739550256/id_17_tq7lwi.jpg",
        "price": "₹399999",
        "rating": "4.7",
        "details": "Steam Deck, SNES controller, wireless controller, SanDisk SSD, USB-C hub, microSD card, Anker power bank, Anker adapter, yellow USB-C cable, wireless earbuds case, sunglasses.",
        "about": "The Steam Deck Ultimate Bundle is an all-inclusive package for gamers who crave versatility and convenience. Featuring the powerful Steam Deck, this handheld console allows you to access your entire Steam library on the go, bringing your favorite PC games anywhere.\n\nThis bundle takes it a step further by including additional controllers for enhanced gameplay options, as well as a SanDisk SSD for expanded storage, USB-C hub for connectivity, and an Anker power bank for extended gaming sessions. Every component in this bundle has been curated to elevate your gaming experience, making it ultra-convenient and portable.\n\nDesigned for on-the-go gaming, the Steam Deck Ultimate Bundle is perfect for players who enjoy flexibility without sacrificing performance, offering a comprehensive gaming setup that fits in your backpack.",
        "productSpecification": {
            "type": "Handheld Gaming Console",
            "Storage": "512GB SSD",
            "Display": "7-inch",
            "Controls": "SNES controller, wireless controller, touchscreen",
            "Compatibility": "Steam Library"
        }
    },
    {
        "id": 12,
        "name": "Meta Quest 3 Ultimate VR Set",
        "image": "https://res.cloudinary.com/do7ttqxgn/image/upload/v1739550257/id_18_edhm42.webp",
        "price": "₹299999",
        "rating": "4.7",
        "details": "VR headset, upgraded controller grip covers, VR facial interface cover, head strap with built-in headphones, charging dock, and VR controllers.",
        "about": "The Meta Quest 3 Ultimate VR Set brings a comprehensive virtual reality experience to your home. Everything you need for immersive gaming is included, with a VR headset that features upgraded optics for clearer visuals and an immersive experience.\n\nIncluded are enhanced controller grip covers and a facial interface cover to ensure comfort during extended gaming sessions. The head strap comes equipped with built-in headphones, allowing for high-quality audio to accompany your VR adventures.\n\nAlso bundled is a charging dock and the necessary VR controllers, providing a complete package that’s ready to transport you into other worlds. With the Meta Quest 3 Ultimate set, embark on countless exciting adventures in virtual reality.",
        "productSpecification": {
            "type": "VR Headset",
            "Resolution": "1832 x 1920 per eye",
            "Tracking": "Inside-out",
            "Included Accessories": "Charging dock, upgraded controllers",
            "Compatibility": "Standalone"
        }
    },
    {
        "id": 13,
        "name": "Razer Ultimate Gamer Kit",
        "image": "https://res.cloudinary.com/do7ttqxgn/image/upload/v1739550258/id_19_l95dvt.webp",
        "price": "₹19999",
        "rating": "4.9",
        "details": "Gaming monitor, RGB mechanical keyboard, RGB gaming mouse, extended RGB mouse pad, dual speakers, and a monitor stand.",
        "about": "The Razer Ultimate Gamer Kit brings everything needed for a complete gaming setup in one package. At the heart of this kit is a high-performance gaming monitor that ensures exceptional visuals, delivering clarity and smooth frame rates for all your gaming needs.\n\nIn addition, this kit includes an RGB mechanical keyboard and a responsive RGB gaming mouse, both designed for optimal performance and comfort during long gaming sessions. An extended RGB mouse pad adds a touch of style while providing ample space to maneuver your mouse.\n\nAlso included are dual speakers that offer outstanding sound quality, creating an immersive audio environment. This complete gamer kit harmonizes performance, aesthetics, and functionality, making it a perfect choice for both casual and serious gamers aiming to elevate their gaming experience.",
        "productSpecification": {
            "type": "Gaming Setup",
            "Monitor Size": "27 inch",
            "Keyboard": "RGB Mechanical",
            "Mouse": "RGB Gaming Mouse",
            "Included Accessories": "Dual Speakers, Monitor Stand"
        }
    },
    {
        "id": 14,
        "name": "Alienware Pro Gaming Rig",
        "image": "https://res.cloudinary.com/do7ttqxgn/image/upload/v1739550259/id_20_g5bfq1.jpg",
        "price": "₹299999",
        "rating": "4.9",
        "details": "Alienware gaming monitor, Alienware desktop PC, RGB mechanical keyboard, wireless gaming mouse, and gaming headset with a microphone.",
        "about": "The Alienware Pro Gaming Rig is the epitome of high-performance gaming equipment. This powerhouse includes an Alienware desktop PC, known for its exceptional graphics and processing capabilities, making it capable of handling any game at max settings without any lag.\n\nComplementing the powerful desktop is an Alienware gaming monitor that delivers stunning visuals, paired with an RGB mechanical keyboard and a wireless gaming mouse optimized for speed and precision. Whether you're immersed in single-player narratives or competing in online multiplayer battles, this setup gives you the edge you need.\n\nAlso included is a high-quality gaming headset with a microphone, ensuring clear communication with teammates during intense gaming sessions. The Alienware Pro Gaming Rig is designed for gamers seeking top-tier performance, aesthetics, and function all in one package.",
        "productSpecification": {
            "type": "Gaming Setup",
            "CPU": "Intel Core i7",
            "GPU": "NVIDIA RTX 3080",
            "RAM": "32GB",
            "Included Accessories": "Alienware Monitor, RGB Keyboard, Wireless Mouse, Gaming Headset"
        }
    }
];

const UploadConsoleBundles = () => {

    const clearExistingData = async () => {
        const collectionRef = collection(db, 'consoleBundles');
        const querySnapshot = await getDocs(collectionRef);
        querySnapshot.forEach(async (docSnapshot) => {
            await deleteDoc(doc(db, 'consoleBundles', docSnapshot.id));
        });
    };


    const uploadData = async () => {
        try {
            await clearExistingData(); 
            const collectionRef = collection(db, 'consoleBundles');

            for (const bundle of consoleBundles) {
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

export default UploadConsoleBundles;
