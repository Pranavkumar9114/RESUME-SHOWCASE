// UploadGamingaccessories.jsx
import React, { useEffect } from 'react';
import { collection, getDocs, addDoc, deleteDoc, doc } from 'firebase/firestore';
import { db } from '../../../../firebase/';

const Gamingaccessories = [
    {
        "id": "1",
        "name": "Razer BlackShark V2 Pro",
        "description": "Wireless gaming headset with THX Spatial Audio.",
        "about": "The Razer BlackShark V2 Pro is a wireless gaming headset that combines ergonomic design with exceptional audio capabilities. Engineered with advanced 50mm custom drivers, it delivers immersive sound through THX Spatial Audio technology, enhancing your gaming experience. The headset is designed to ensure comfort during long gaming sessions with its plush memory foam ear cushions and adjustable headband. \n\nWhat sets the BlackShark V2 Pro apart is its ability to provide precise audio cues, essential for competitive gaming. The wireless connection ensures you remain untethered from your setup, while the long battery life gives you the freedom to game for hours at a stretch. If you’re serious about getting the best audio performance in your games, this headset will elevate your experience significantly. \n\nCustomizability is another strong point; you can adjust sound profiles and even control the microphone sensitivity through the Razer Synapse software. This means you can tailor the audio experience to suit your game type or personal preference. Whether you are immersed in an action-packed title or engaging in a narrative-driven adventure, the BlackShark V2 Pro is versatile enough to adapt to your needs.",
        "price": "₹1799",
        "rating": "4.8",
        "image": "https://res.cloudinary.com/do7ttqxgn/image/upload/v1739601543/1_p0tyaz.jpg",
        "productSpecification": {
            "type": "Gaming Headset",
            "connection": "Wireless",
            "driverSize": "50mm",
            "batteryLife": "20 hours",
            "compatibility": "PC, PlayStation, Xbox"
        }
    },
    {
        "id": "2",
        "name": "Logitech G Pro X Superlight",
        "description": "Ultra-lightweight wireless gaming mouse.",
        "about": "The Logitech G Pro X Superlight represents the pinnacle of esports mouse design, engineered for competitive gaming. Weighing in at just 63 grams, this ultra-lightweight mouse allows for swift movements and effortless flicks, making it a favorite among professional gamers. The HERO 25K sensor provides exceptional precision, tracking up to 25,600 DPI, making it highly adaptable for different styles of gaming. \n\nOne of the standout features of the G Pro X Superlight is its LIGHTSPEED wireless technology. This technology ensures a totally lag-free connection, providing a seamless experience whether you’re in casual matches or high-stakes tournaments. The long battery life means less time worrying about charging and more time focused on your games. \n\nErgonomics play a crucial role in the design of the G Pro X Superlight. With its comfortable shape designed for palm grips, you can play for extended periods without discomfort. The customizable buttons let you program commands, making it versatile for different game genres like FPS or MOBA. With RGB lighting that can be personalized through Logitech's software, this mouse can become a stylish addition to your gaming setup.",
        "price": "₹1499",
        "rating": "4.7",
        "image": "https://res.cloudinary.com/do7ttqxgn/image/upload/v1739601536/2_djrzr2.webp",
        "productSpecification": {
            "type": "Gaming Mouse",
            "sensor": "HERO 25K",
            "weight": "63 grams",
            "DPI": "25,600",
            "compatibility": "PC, Mac"
        }
    },
    {
        "id": "3",
        "name": "Corsair K100 RGB Keyboard",
        "description": "Mechanical keyboard with iCUE control and OPX switches.",
        "about": "The Corsair K100 RGB Keyboard is a high-performance mechanical keyboard that distinguishes itself with its customizable OPX switches and iCUE control software. Designed for both gamers and content creators, it features an ultra-fast response time that minimizes keypress lag, giving you a competitive edge in fast-paced games. \n\nIn addition to its performance capabilities, the K100 boasts striking RGB lighting that can be customized for different key zones. With thousands of color options and effects available, you can create a lighting profile that matches your gaming ambiance or personal aesthetic. This makes the keyboard not just a tool, but also a statement piece for your gaming setup. \n\nDurability is another important aspect of the K100; it’s built with aircraft-grade aluminum for longevity, making it suitable for extensive use. The onboard profiles allow you to save settings directly to the keyboard, so your favorite configurations are always within reach, even when switching between devices. Whether you are gaming, streaming, or simply typing, the K100 RGB provides an unparalleled experience.",
        "price": "₹2299",
        "rating": "4.9",
        "image": "https://res.cloudinary.com/do7ttqxgn/image/upload/v1739601538/3_wl5amk.jpg",
        "productSpecification": {
            "type": "Mechanical Keyboard",
            "switchType": "OPX Optical",
            "RGB": "Yes, customizable",
            "material": "Aircraft-grade aluminum",
            "compatibility": "PC, Mac"
        }
    },
    {
        "id": "4",
        "name": "SteelSeries QcK Prism XL",
        "description": "RGB gaming mouse pad with dynamic lighting effects.",
        "about": "The SteelSeries QcK Prism XL mouse pad is a gaming essential that combines functionality with aesthetic appeal. Featuring a large surface area, it accommodates both high and low-sensitivity players, while its smooth fabric surface optimizes tracking accuracy for both optical and laser mice. \n\nOne of the standout features is the customizable RGB lighting. With various lighting effects available through SteelSeries Engine software, you can sync the mouse pad with other RGB peripherals for a unified look. This not only enhances your aesthetic setup but also creates a more immersive gaming environment. \n\nThe surface material of the QcK Prism XL is designed for durability, ensuring that it withstands the wear and tear of competitive gaming. Easy to clean and maintain, you can keep it looking fresh even after intense gaming sessions. Its anti-slip rubber base also guarantees stability, minimizing unwanted movement during gameplay. This makes it an excellent choice for serious gamers looking for both performance and style.",
        "price": "₹6999",
        "rating": "4.6",
        "image": "https://res.cloudinary.com/do7ttqxgn/image/upload/v1739601537/4_bhd3fq.png",
        "productSpecification": {
            "type": "Gaming Mouse Pad",
            "size": "XL",
            "RGB": "Yes, customizable",
            "material": "Cloth surface with anti-slip rubber base",
            "compatibility": "All mouse types"
        }
    },
    {
        "id": "5",
        "name": "Elgato Stream Deck MK.2",
        "description": "Customizable LCD control panel for streamers.",
        "about": "The Elgato Stream Deck MK.2 is an innovative control panel designed to elevate your streaming experience to the next level. With 15 customizable LCD keys, you can easily manage your stream, switch scenes, adjust audio settings, and launch media within seconds. The intuitive interface allows streamers to assign commands through simple drag-and-drop functionality, making it user-friendly for both beginners and professionals. \n\nAdditionally, the Stream Deck MK.2 supports various integrations with popular streaming software such as OBS Studio, Streamlabs, and more, allowing for seamless transitions and improved workflow. The compact design not only saves space on your desk but also makes it portable, so you can take it on the go for different streaming setups. \n\nWhat makes the Elgato Stream Deck MK.2 particularly appealing is its versatility. Beyond streaming, it can be used for video editing and content creation tasks, enabling you to program shortcuts for your favorite software like Adobe Premiere Pro and Photoshop. With customizable faceplates, you can personalize the appearance of your Stream Deck to match your style or setup.",
        "price": "₹14999",
        "rating": "4.8",
        "image": "https://res.cloudinary.com/do7ttqxgn/image/upload/v1739601538/5_ijkwad.jpg",
        "productSpecification": {
            "type": "Streaming Control Panel",
            "buttons": "15 customizable keys",
            "compatibility": "PC, Mac",
            "softwareIntegration": "OBS Studio, Streamlabs, etc.",
            "portability": "Yes"
        }
    },
    {
        "id": "6",
        "name": "HyperX Cloud II Wireless",
        "description": "Comfortable wireless gaming headset with 7.1 surround sound.",
        "about": "The HyperX Cloud II Wireless provides an exceptional audio experience, designed specifically for gamers who seek comfort and clarity. With 7.1 virtual surround sound technology, the headset allows you to pinpoint in-game audio cues accurately, enhancing your competitive edge during gameplay. \n\nComfort is paramount with the Cloud II Wireless; it features memory foam ear cushions and an adjustable headband, allowing for extended wear without fatigue. The wireless connectivity ensures freedom of movement, and the long-lasting battery life keeps you connected throughout marathon gaming sessions. Additionally, the headset is equipped with a detachable noise-canceling microphone, ensuring clear communication with teammates. \n\nIn terms of durability, the HyperX Cloud II Wireless is built to last, with a construction that can withstand the rigors of gaming. It’s also compatible across multiple platforms, making it a versatile choice for gamers, streamers, and content creators alike. Whether you're playing FPS, MMO, or any genre, this headset adapts to your needs, delivering immersive sound and comfort.",
        "price": "₹15999",
        "rating": "4.7",
        "image": "https://res.cloudinary.com/do7ttqxgn/image/upload/v1739601538/6_jv24nk.webp",
        "productSpecification": {
            "type": "Gaming Headset",
            "connection": "Wireless",
            "soundTechnology": "7.1 Virtual Surround Sound",
            "batteryLife": "30 hours",
            "compatibility": "PC, PS4, Xbox One, Mac"
        }
    },
    {
        "id": "7",
        "name": "Asus ROG Chakram",
        "description": "Customizable wireless gaming mouse with joystick control.",
        "about": "The Asus ROG Chakram stands out as a revolutionary gaming mouse that merges customization with advanced technology. At the heart of the Chakram is a unique joystick control feature, offering gamers additional ways to interact with their games. Whether you're navigating through menus or executing commands, this joystick adds versatility to your setup. \n\nEquipped with a 16,000 DPI optical sensor, the Chakram delivers incredibly responsive tracking with pinpoint accuracy, which is essential for competitive gaming. The customizable buttons allow you to set up different configurations for different games, ensuring you have the tools needed at your fingertips. Plus, its wireless capabilities provide a lag-free experience, enabling users to enjoy movement freedom without sacrificing performance. \n\nBuilt for comfort, the ergonomic design fits naturally in your hand, reducing strain during long gaming sessions. The Chakram also features customizable RGB lighting that can be synced with other ROG products, enhancing your aesthetic setup. Whether for casual play or high-stakes competition, the Asus ROG Chakram is engineered to meet the demands of serious gamers.",
        "price": "₹1999",
        "rating": "4.5",
        "image": "https://res.cloudinary.com/do7ttqxgn/image/upload/v1739601538/7_osgyls.jpg",
        "productSpecification": {
            "type": "Gaming Mouse",
            "sensor": "Optical",
            "DPI": "16,000",
            "batteryLife": "Up to 100 hours",
            "compatibility": "PC, Mac"
        }
    },
    {
        "id": "8",
        "name": "Razer Tartarus Pro",
        "description": "Gaming keypad with adjustable actuation switches.",
        "about": "The Razer Tartarus Pro gaming keypad is specifically designed for gamers who demands quick access to multiple commands. It features an impressive 32 customizable keys, all equipped with Razer's innovative adjustable actuation switches, allowing you to set your desired sensitivity for each key. This customization is invaluable for fast-paced gaming environments where every millisecond counts. \n\nBeyond its premium keys, the Tartarus Pro also offers an ergonomic wrist rest, ensuring comfort during long gaming sessions. With its fully customizable RGB lighting, you can personalize the gaming keypad to match your style or setup, immersing yourself further into your gaming experience. \n\nThe keypad is compatible with Razer's Synapse software, which allows further customization of macros and settings. This level of control makes it ideal for MMO gamers or anyone who needs to manage multiple commands swiftly and efficiently. The layout is designed to minimize finger movement, providing a seamless gaming experience, whether you are engaging in intense battles or exploring vast game worlds.",
        "price": "₹1299",
        "rating": "4.6",
        "image": "https://res.cloudinary.com/do7ttqxgn/image/upload/v1739601538/8_ajj7z9.jpg",
        "productSpecification": {
            "type": "Gaming Keypad",
            "keys": "32 customizable keys",
            "actuation": "Adjustable",
            "RGB": "Yes, customizable",
            "compatibility": "PC, Mac"
        }
    },
    {
        "id": "9",
        "name": "SteelSeries Arctis Pro Wireless",
        "description": "High-fidelity gaming headset with dual wireless system.",
        "about": "The SteelSeries Arctis Pro Wireless is designed for serious gamers who require high-fidelity audio and versatility. Featuring a dual-wireless system that connects via both Bluetooth and a low-latency wireless transmitter, this headset ensures that you can enjoy top-tier audio quality without being tethered to your gaming setup. \n\nThe premium speaker drivers provide rich, detailed sound that elevates your gaming experience, making it feel more immersive and engaging. Equipped with DTS Headphone:X v2.0 surround sound technology, you can hear even the faintest audio cues, giving you a competitive edge in gameplay. \n\nComfort is not overlooked with the Arctis Pro; the soft-touch materials and adjustable headband provide a comfortable fit for prolonged gaming sessions. The headset also comes with a retractable microphone that offers exceptional clarity and can easily be stowed away when not in use. This combination of performance, comfort, and advanced features makes the Arctis Pro Wireless a top choice for gamers looking for the best in audio.",
        "price": "₹32999",
        "rating": "4.8",
        "image": "https://res.cloudinary.com/do7ttqxgn/image/upload/v1739601537/9_dq9xah.jpg",
        "productSpecification": {
            "type": "Gaming Headset",
            "connection": "Dual Wireless (Bluetooth and low-latency)",
            "soundTechnology": "DTS Headphone:X v2.0",
            "batteryLife": "20 hours",
            "compatibility": "PC, PS4, Xbox One"
        }
    },
    {
        "id": "10",
        "name": "Corsair MM700 RGB",
        "description": "Extended mouse pad with dynamic RGB lighting.",
        "about": "The Corsair MM700 RGB is not just a mouse pad; it's an essential gaming accessory that enhances both your gameplay and your gaming space. With its large dimensions, it accommodates both your keyboard and mouse, allowing you to have a seamless experience during intense gaming sessions. The surface is optimized for precision tracking, ensuring that your mouse glides smoothly over it. \n\nOne of the standout features of the MM700 is the dynamic RGB lighting. The customizable RGB zones along the edges can sync with other Corsair RGB products, allowing you to create a cohesive lighting setup that enhances your gaming atmosphere. With Corsair's iCUE software, you have the ability to personalize lighting effects to fit your mood or gaming style. \n\nThe durability of the material ensures that this mouse pad can withstand the rigors of gaming. The anti-slip rubber base provides stability, preventing unwanted movements during gameplay. It’s easy to clean, making maintenance hassle-free. For gamers looking to enhance their setup with a touch of style, the Corsair MM700 RGB is an excellent addition.",
        "price": "₹599",
        "rating": "4.5",
        "image": "https://res.cloudinary.com/do7ttqxgn/image/upload/v1739601539/10_hpvgxm.jpg",
        "productSpecification": {
            "type": "Gaming Mouse Pad",
            "size": "Extended",
            "RGB": "Yes, customizable",
            "material": "Cloth surface with anti-slip rubber base",
            "compatibility": "All mouse types"
        }
    },
    {
        "id": "11",
        "name": "Elgato Wave:3",
        "description": "Premium microphone with Clipguard technology.",
        "about": "The Elgato Wave:3 is a premium USB microphone specifically engineered for streamers, podcasters, and content creators. Equipped with Clipguard technology, it prevents distortion by automatically adjusting the gain when it detects high audio levels, ensuring your voice remains clear and professional without interruptions. \n\nWith its sleek, compact design, the Wave:3 is not only functional but also aesthetically pleasing, making it a stylish addition to your streaming setup. The integrated digital mixing software allows you to control audio levels from both your microphone and other sources, making it easier to set the perfect balance while streaming or recording. \n\nThe microphone offers versatile mounting options, including a universal stand, which enhances its adaptability for different recording environments. Its cardioid pickup pattern captures sound directly in front while minimizing background noise, ensuring your voice remains the focal point. For anyone serious about audio quality in their content, the Elgato Wave:3 represents an excellent investment.",
        "price": "₹15999",
        "rating": "4.7",
        "image": "https://res.cloudinary.com/do7ttqxgn/image/upload/v1739601538/11_kthupz.webp",
        "productSpecification": {
            "type": "USB Microphone",
            "pickupPattern": "Cardioid",
            "features": "Clipguard technology",
            "compatibility": "PC, Mac",
            "mountOptions": "Universal stand included"
        }
    },
    {
        "id": "12",
        "name": "Logitech G923 Racing Wheel",
        "description": "TrueForce feedback racing wheel for immersive driving.",
        "about": "The Logitech G923 Racing Wheel is crafted for racing enthusiasts, featuring TrueForce force feedback technology that simulates real-world driving. With its sleek design, the wheel provides a realistic experience, allowing you to feel the road and all its variables while driving. The high-quality materials used in construction make it not just durable but also aesthetically pleasing. \n\nThe racing wheel is equipped with responsive buttons and a responsive clutch, designed to enhance your immersion in racing games. The force feedback is adjustable, enabling you to customize your experience to match specific racing titles. Compatible across multiple platforms, it offers versatility, whether you are playing on PC, Xbox, or PlayStation. \n\nWith its easy setup and integration, you can be racing in no time. The G923 also supports various racing games, allowing for a customizable experience that's ideal for players of all skill levels. This wheel will immerse you deeper into the racing world, making each racing session feel authentic.",
        "price": "₹3999",
        "rating": "4.6",
        "image": "https://res.cloudinary.com/do7ttqxgn/image/upload/v1739601539/12_mx8nro.jpg",
        "productSpecification": {
            "type": "Racing Wheel",
            "feedbackTechnology": "TrueForce Feedback",
            "compatibility": "PC, Xbox, PlayStation",
            "buttons": "Responsive buttons and clutch",
            "setup": "Easy installation"
        }
    },
    {
        "id": "13",
        "name": "NZXT Kraken Z63",
        "description": "Liquid cooler with customizable LCD display.",
        "about": "The NZXT Kraken Z63 is a cutting-edge liquid cooler designed to keep your CPU temperatures in check while adding an aesthetic flair to your gaming rig. Featuring a customizable LCD display, users can show real-time data like temperatures or even custom images, making your build uniquely yours. \n\nWith its dual 140mm fans, the Kraken Z63 maintains low temperatures while minimizing noise levels, which is crucial for those who prefer a quieter system. Its efficient cooling performance ensures that high-performance CPUs run optimally while enabling higher overclocking potential. \n\nInstallation is straightforward, with a user-friendly design that simplifies setup on a range of sockets. The Kraken Z63 is also compatible with NZXT's CAM software, allowing you to fine-tune fan speeds and pump performance, giving you total control over your cooling solution. For anyone looking to balance performance with visual flair, the NZXT Kraken Z63 is an exceptional choice.",
        "price": "₹24999",
        "rating": "4.8",
        "image": "https://res.cloudinary.com/do7ttqxgn/image/upload/v1739601539/13_f12dnf.jpg",
        "productSpecification": {
            "type": "Liquid CPU Cooler",
            "fanSize": "Dual 140mm",
            "LCD": "Customizable display",
            "compatibility": "Intel and AMD sockets",
            "software": "NZXT CAM software"
        }
    },
    {
        "id": "14",
        "name": "Astro A50 Wireless",
        "description": "Wireless gaming headset with charging base.",
        "about": "The Astro A50 Wireless headset is engineered for gamers who demand high-quality audio and comfort during long play sessions. Offering a wireless solution with a sleek charging base, the A50 delivers excellent sound quality, making it ideal for both gameplay and multimedia. \n\nEquipped with Dolby Digital Surround Sound, the A50 gives you an immersive gaming experience, allowing you to hear environmental sounds and pinpoint audio cues accurately. Its plush ear cushions and adjustable headband provide comfort that lasts, enabling prolonged use without discomfort. \n\nCustomizable EQ settings allow you to fine-tune the audio to match different game genres or personal preferences, ensuring that your audio experience is tailored just for you. The integrated microphone delivers clear communication, and its retractable design ensures it’s discreet when not in use. The Astro A50 is a must-have for any serious gamer looking to elevate their audio experience.",
        "price": "₹29999",
        "rating": "4.7",
        "image": "https://res.cloudinary.com/do7ttqxgn/image/upload/v1739601539/14_qgztwt.jpg",
        "productSpecification": {
            "type": "Wireless Gaming Headset",
            "features": "Dolby Digital Surround Sound",
            "chargingBase": "Included",
            "batteryLife": "15 hours",
            "compatibility": "PC, PlayStation"
        }
    },
    {
        "id": "15",
        "name": "Glorious Model O Wireless",
        "description": "Ultra-lightweight wireless gaming mouse.",
        "about": "The Glorious Model O Wireless is engineered for competitive gamers, featuring a lightweight design that allows for rapid and agile movements. Weighing under 70 grams, it enables gamers to achieve precise aim without straining. The innovative honeycomb design not only reduces weight but also enhances airflow for added comfort. \n\nThis mouse is powered by Glorious' advanced wireless technology, providing a lag-free connection that doesn’t compromise performance. The high-precision sensor captures movements with incredible accuracy, making it suitable for both fast-paced FPS and MOBA gaming. \n\nWith customizable RGB lighting, the Model O Wireless caters to both functionality and aesthetic, letting you create a personalized look for your setup. The durability of the materials used ensures longevity, making the Model O a reliable choice for those who take their gaming seriously. For players looking for speed, precision, and a comfortable grip, the Glorious Model O Wireless is an excellent fit.",
        "price": "₹7999",
        "rating": "4.6",
        "image": "https://res.cloudinary.com/do7ttqxgn/image/upload/v1739601539/15_yfwtbi.jpg",
        "productSpecification": {
            "type": "Gaming Mouse",
            "sensor": "Optical",
            "DPI": "19,000",
            "weight": "69 grams",
            "compatibility": "PC, Mac"
        }
    },
    {
        "id": "16",
        "name": "AverMedia Live Gamer Portable 2 Plus",
        "description": "External capture card for streaming and recording.",
        "about": "The AverMedia Live Gamer Portable 2 Plus is an external capture card that simplifies the process of capturing and streaming gameplay. Designed for versatility, it supports up to 1080p60 capture, providing high-quality video output without taxing your gaming performance. \n\nWith built-in hardware encoding, it minimizes the impact on your game while capturing stunning videos. It's also equipped with a microSD slot, allowing you to record without a PC, making it an ideal solution for console gamers. This feature is particularly useful for those who want a portable option for capturing gameplay on the go. \n\nSetting up the Live Gamer Portable 2 Plus is straightforward, and it’s compatible with popular streaming platforms such as OBS and XSplit. The compact design makes it easy to take to events or gaming tournaments, ensuring that you’re always ready to share your gameplay. For anyone serious about capturing their gaming moments with ease, the AverMedia Live Gamer Portable 2 Plus is an invaluable tool.",
        "price": "₹14999",
        "rating": "4.5",
        "image": "https://res.cloudinary.com/do7ttqxgn/image/upload/v1739601540/16_dgm8rj.jpg",
        "productSpecification": {
            "type": "Capture Card",
            "maxCaptureResolution": "1080p60",
            "encoding": "Hardware encoding",
            "microSDSlot": "Yes",
            "compatibility": "PC, Console"
        }
    },
    {
        "id": "17",
        "name": "BenQ Zowie XL2546K",
        "description": "240Hz gaming monitor with DyAc technology.",
        "about": "The BenQ Zowie XL2546K is a top-tier gaming monitor designed specifically for professional esports gaming. Featuring a rapid 240Hz refresh rate and DyAc technology, it offers an unparalleled level of fluidity and clarity in gameplay. This allows you to track fast-moving objects on the screen with ease, enhancing your overall gaming performance. \n\nDesigned with ergonomics in mind, the XL2546K allows for extensive customization of height and tilt, ensuring you'll have the best viewing angle for comfortable gameplay. The monitor’s fast response time minimizes motion blur, giving you the competitive edge during high-stakes games. \n\nAdditionally, the Black Equalizer feature enhances visibility in darker scenes without overexposing brighter areas, allowing you to see opponents hiding in shadows. The monitor supports a variety of input options, making it easy to connect to your gaming setup. For serious gamers looking to improve their play, the BenQ Zowie XL2546K is an excellent investment.",
        "price": "₹49999",
        "rating": "4.7",
        "image": "https://res.cloudinary.com/do7ttqxgn/image/upload/v1739601540/17_ujsrpy.jpg",
        "productSpecification": {
            "type": "Gaming Monitor",
            "refreshRate": "240Hz",
            "responseTime": "1ms",
            "DyAcTechnology": "Yes",
            "compatibility": "PC, Consoles"
        }
    },
    {
        "id": "18",
        "name": "Secretlab Titan Evo 2022",
        "description": "Ergonomic gaming chair with adjustable lumbar support.",
        "about": "The Secretlab Titan Evo 2022 is a premier gaming chair that combines luxury with ergonomic design, tailored for long hours of gaming. Featuring a high-quality build, it supports a weight capacity of up to 390 lbs, providing stability and comfort throughout your gaming sessions. \n\nWhat sets this chair apart is its adjustable lumbar support and memory foam head pillow, offering customizable comfort that caters to your personal preferences. The multi-tilt mechanism ensures that you can find your ideal sitting angle, making it practical for both gaming and working. \n\nCrafted with premium materials, including breathable fabric and cold-cured foam, the Secretlab Titan Evo maintains its form and comfort over extended periods. The chair also features a sleek design with various color options, allowing you to match it with your gaming setup. Elevate your gaming experience with the Secretlab Titan Evo 2022, the perfect balance of style, comfort, and functionality.",
        "price": "₹54999",
        "rating": "4.9",
        "image": "https://res.cloudinary.com/do7ttqxgn/image/upload/v1739601540/18_dpukh0.webp",
        "productSpecification": {
            "type": "Gaming Chair",
            "weightCapacity": "390 lbs",
            "lumbarSupport": "Adjustable",
            "material": "Cold-cured foam",
            "design": "Stylish and ergonomic"
        }
    },
    {
        "id": "19",
        "name": "Blue Yeti X",
        "description": "Professional USB microphone for streaming and podcasting.",
        "about": "The Blue Yeti X microphone is designed for content creators who demand professional audio quality. With its four pickup patterns including cardioid, omnidirectional, bidirectional, and stereo, it's remarkably versatile for different recording scenarios. This makes it a go-to choice for streamers, podcasters, and musicians alike. \n\nIts advanced LED metering provides visual feedback, ensuring you monitor your audio levels effectively. With easy-to-use controls, you can adjust gain and mute directly from the microphone, offering ease and convenience during live sessions. \n\nConstructed with high-quality materials, the Blue Yeti X is not only durable but also sleek in design, adding an element of professionalism to your setup. Whether you're engaged in a solo podcast or hosting live interviews, this microphone delivers crisp, clear audio—an essential tool for those looking to elevate their content creation to the next level.",
        "price": "₹16999",
        "rating": "4.7",
        "image": "https://res.cloudinary.com/do7ttqxgn/image/upload/v1739601540/19_nw3ntp.jpg",
        "productSpecification": {
            "type": "USB Microphone",
            "pickupPatterns": "Cardioid, Omnidirectional, Bidirectional, Stereo",
            "features": "LED metering, gain control",
            "compatibility": "PC, Mac",
            "usage": "Podcasting, Streaming, Recording"
        }
    },
    {
        "id": "20",
        "name": "Elgato Key Light",
        "description": "Adjustable studio light for professional streaming.",
        "about": "The Elgato Key Light is an excellent lighting solution for streamers and content creators seeking to enhance their on-camera appearance. Adjustable brightness and color temperature ensure that you can tailor the lighting to suit your environment and personal preferences, providing a professional quality that’s often found in high-budget production studios. \n\nWith a sleek, modern design, the Key Light easily integrates into your setup and can be mounted on a desk or wall. The wireless control through the Elgato software makes it easy to change settings on-the-fly without interrupting your stream or video recording session. \n\nEnergy-efficient LED lights provide excellent illumination while being gentle on your power consumption, allowing you to reduce costs while maintaining a vibrant, well-lit space. For anyone serious about creating high-quality content, the Elgato Key Light is a must-have, greatly enhancing the overall production value of your streams.",
        "price": "₹1999",
        "rating": "4.8",
        "image": "https://res.cloudinary.com/do7ttqxgn/image/upload/v1739601540/20_hgmbnf.jpg",
        "productSpecification": {
            "type": "Studio Light",
            "brightness": "Adjustable",
            "colorTemperature": "Adjustable",
            "control": "Wireless via Elgato software",
            "energyEfficiency": "Yes"
        }
    },
    {
        "id": "21",
        "name": "Razer Seiren X",
        "description": "Compact USB microphone for streaming.",
        "about": "The Razer Seiren X is a compact USB microphone specifically designed for streamers who want top-notch audio quality without sacrificing desk space. Equipped with a supercardioid pickup pattern, it minimizes background noise, ensuring your vocals are clear and focused during streams or recordings. \n\nIts shock mount provides additional protection against unintentional movement, safeguarding your audio clarity during sessions. The compact design does not compromise on performance; it offers professional-quality sound in a streamlined form. \n\nThe Razer Seiren X is also simple to set up—just plug and play—and it integrates seamlessly with popular streaming software. The aesthetic design complements the Razer product line, making it a stylish addition to your streaming setup. For anyone looking for high-quality audio in a compact format, the Seiren X delivers on all fronts.",
        "price": "₹9999",
        "rating": "4.6",
        "image": "https://res.cloudinary.com/do7ttqxgn/image/upload/v1739601540/21_pbonad.jpg",
        "productSpecification": {
            "type": "USB Microphone",
            "pickupPattern": "Supercardioid",
            "features": "Shock mount included",
            "compatibility": "PC, Mac",
            "usage": "Streaming, Recording"
        }
    },
    {
        "id": "22",
        "name": "Corsair Virtuoso RGB Wireless",
        "description": "Premium wireless gaming headset with immersive sound.",
        "about": "The Corsair Virtuoso RGB Wireless headset is crafted for gamers who refuse to compromise on audio quality. With high-fidelity audio drivers, it delivers immersive sound across the frequency spectrum, enabling you to hear subtle details in your games that others might miss. \n\nThe headset features dual wireless connectivity options, allowing you to switch between low-latency 2.4GHz wireless and Bluetooth, making it versatile for gaming and multimedia use. Its luxurious design includes plush memory foam ear pads and a lightweight build, ensuring comfort even during long gaming sessions. \n\nThe customizable RGB lighting enhances the aesthetic appeal of your setup, and the detachable broadcast-quality microphone ensures that communication with teammates is crystal clear. With Corsair's iCUE software, you can customize sound profiles and lighting, making it adaptable to your individual gaming style. For anyone serious about gaming audio, the Virtuoso RGB is an exceptional choice.",
        "price": "₹17999",
        "rating": "4.7",
        "image": "https://res.cloudinary.com/do7ttqxgn/image/upload/v1739601540/22_trtivj.webp",
        "productSpecification": {
            "type": "Wireless Gaming Headset",
            "connection": "Dual Wireless (Bluetooth and low-latency)",
            "audioDrivers": "High-fidelity",
            "batteryLife": "20 hours",
            "compatibility": "PC, PlayStation, Xbox"
        }
    },
    {
        "id": "23",
        "name": "Logitech StreamCam",
        "description": "Full HD webcam with versatile mounting options.",
        "about": "The Logitech StreamCam is a versatile webcam designed for streamers, content creators, and anyone looking to enhance their video quality. With full HD capabilities, it provides crisp, clear video and features smart autofocus to ensure you are always in focus, even as you move around. \n\nIts dual built-in microphones capture high-quality audio, ensuring that your voice is heard clearly by your audience. The StreamCam is compatible with popular streaming platforms and includes versatile mounting options, allowing you to position it at the perfect angle. \n\nWith software integration for features like background replacement and other effects, the Logitech StreamCam is perfect for dynamic broadcasts or video calls. Whether you're gaming, hosting a podcast, or creating vlogs, this webcam elevates the experience, making it a must-have tool for anyone serious about video production.",
        "price": "₹16999",
        "rating": "4.5",
        "image": "https://res.cloudinary.com/do7ttqxgn/image/upload/v1739601541/23_l4wzad.webp",
        "productSpecification": {
            "type": "Webcam",
            "resolution": "Full HD 1080p",
            "features": "Smart autofocus, dual microphones",
            "compatibility": "PC, Mac",
            "mountingOptions": "Versatile mounting"
        }
    },
    {
        "id": "24",
        "name": "Razer Naga Pro",
        "description": "Modular wireless gaming mouse with swappable side plates.",
        "about": "The Razer Naga Pro is a modular gaming mouse designed for gamers who require a high level of customization. With swappable side plates featuring different button configurations, the Naga Pro can easily adapt to various gaming genres, from MMO to FPS. \n\nEquipped with Razer's HyperSpeed wireless technology, it guarantees a lag-free gaming experience and features a 16,000 DPI optical sensor for precise tracking. This makes it ideal for competitive play. Additionally, its ergonomic design ensures comfort during marathon gaming sessions, keeping your hand relaxed even after hours of intense use. \n\nWith customizable RGB lighting and extensive software support through Razer Synapse, you can tailor the Naga Pro to match your setup and gaming style. The Naga Pro is not just a tool for gaming; it’s a versatile peripheral that enhances your overall gaming experience, making it a top choice for serious gamers.",
        "price": "₹1499",
        "rating": "4.6",
        "image": "https://res.cloudinary.com/do7ttqxgn/image/upload/v1739601541/24_qph67o.jpg",
        "productSpecification": {
            "type": "Gaming Mouse",
            "sensor": "Optical",
            "DPI": "16,000",
            "batteryLife": "100 hours",
            "compatibility": "PC, Mac"
        }
    },
    {
        "id": "25",
        "name": "Elgato Cam Link 4K",
        "description": "External capture device for cameras and streaming.",
        "about": "The Elgato Cam Link 4K is an external capture device that allows you to turn your DSLR, camcorder, or action camera into a high-quality webcam for streaming or video conferences. It supports up to 4K resolution at 30 fps or 1080p at 60 fps, ensuring your video quality is top-notch. \n\nCompact in size, the Cam Link is easy to set up and allows you to capture stunning video without the need for high-end webcams. Plug-and-play functionality means you can quickly connect and start streaming to your platform of choice. \n\nElgato's software integration allows you to customize your stream and add other elements, making your production more dynamic. Whether you're a content creator, streamer, or just looking for better video quality for your meetings, the Cam Link 4K provides a seamless and high-quality solution.",
        "price": "₹12999",
        "rating": "4.8",
        "image": "https://res.cloudinary.com/do7ttqxgn/image/upload/v1739601542/25_iqnju7.png",
        "productSpecification": {
            "type": "Capture Device",
            "maxResolution": "4K at 30 fps",
            "features": "Plug-and-play",
            "compatibility": "PC, Mac",
            "recording": "Supports DSLR, camcorders, action cameras"
        }
    },
    {
        "id": "26",
        "name": "Corsair HS80 RGB Wireless",
        "description": "Comfortable gaming headset with Dolby Atmos support.",
        "about": "The Corsair HS80 RGB Wireless headset is designed for gamers who want premium sound quality and comfort. With Dolby Atmos support, this wireless headset provides an immersive audio experience, enabling you to clearly understand in-game audio cues and give you an advantage in competitive play. \n\nComfort is a significant focus; with memory foam ear pads and an adjustable headband, it ensures that you can play for hours on end without discomfort. The wireless functionality gives you the freedom to move around while remaining connected, and the long battery life ensures you won’t have to cut your gaming sessions short. \n\nWith customizable RGB lighting and a sleek design, you can tailor the headset to match your gaming setup. The integrated microphone features noise cancellation to improve communication clarity with your teammates. The Corsair HS80 RGB Wireless sets a high standard for gaming headsets that prioritize both performance and style.",
        "price": "₹14999",
        "rating": "4.7",
        "image": "https://res.cloudinary.com/do7ttqxgn/image/upload/v1739601542/26_cpgmnf.jpg",
        "productSpecification": {
            "type": "Wireless Gaming Headset",
            "soundTechnology": "Dolby Atmos",
            "batteryLife": "20 hours",
            "compatibility": "PC, PS4, Xbox",
            "RGB": "Yes, customizable"
        }
    },
    {
        "id": "27",
        "name": "Asus ROG Swift PG259QN",
        "description": "360Hz gaming monitor with NVIDIA G-SYNC support.",
        "about": "The Asus ROG Swift PG259QN is a cutting-edge gaming monitor designed for the most demanding gamers. With an astonishing 360Hz refresh rate, it ensures that every frame is displayed fluidly, providing a significant edge in competitive gaming. The monitor also features NVIDIA G-SYNC support, eliminating screen tearing and minimizing stutter, delivering an incredibly smooth gaming experience. \n\nWith a sleek design and customizable RGB lighting, the PG259QN enhances your gaming setup visually. It’s designed for flexibility, with height, tilt, and swivel adjustments to ensure that you find the most comfortable viewing angle. \n\nEquipped with advanced technologies such as HDR and a fast response time, this monitor produces stunning visuals that bring out the finest details in all types of games. For gamers seeking the pinnacle of performance and an immersive experience, the Asus ROG Swift PG259QN is a top choice. Whether in intense FPS matches or exploring expansive open-world games, this monitor delivers unmatched performance.",
        "price": "₹69999",
        "rating": "4.9",
        "image": "https://res.cloudinary.com/do7ttqxgn/image/upload/v1739601542/27_qu58he.webp",
        "productSpecification": {
            "type": "Gaming Monitor",
            "refreshRate": "360Hz",
            "responseTime": "1ms",
            "GSyncSupport": "Yes",
            "size": "24.5 inches"
        }
    },
    {
        "id": "28",
        "name": "SteelSeries Apex Pro",
        "description": "Mechanical keyboard with adjustable actuation points.",
        "about": "The SteelSeries Apex Pro is an innovative mechanical keyboard that offers customizable actuation points, allowing players to adjust the sensitivity of each key. This unique feature makes it suitable for a variety of gaming genres, enhancing performance and tailoring the typing and gaming experience to individual preferences. \n\nIts durable construction and aircraft-grade aluminum frame ensure longevity and stability during intense gaming sessions. The customizable RGB lighting allows you to personalize your keyboard, creating an atmospheric setup that reflects your gaming style. \n\nThe Apex Pro also features a wrist rest for added comfort and customizable macro keys, making it perfect for both casual gamers and competitive players. Its high-speed performance and adaptability ensure that you'll always have what you need at your fingertips. For gamers looking to enhance their gameplay experience with innovative technology, the SteelSeries Apex Pro is an unbeatable choice.",
        "price": "₹1999",
        "rating": "4.8",
        "image": "https://res.cloudinary.com/do7ttqxgn/image/upload/v1739601543/28_luhs6u.jpg",
        "productSpecification": {
            "type": "Mechanical Keyboard",
            "actuationPoints": "Adjustable",
            "RGB": "Yes, customizable",
            "material": "Aluminum frame",
            "compatibility": "PC, Mac"
        }
    },
    {
        "id": "29",
        "name": "Logitech Brio Ultra HD Webcam",
        "description": "4K webcam with HDR and Windows Hello support.",
        "about": "The Logitech Brio Ultra HD Webcam is engineered for professionals seeking the best in video quality. With 4K resolution and HDR support, you can expect stunning clarity and vibrant colors during streams and video conferences. This advanced webcam is ideal for content creators, gamers, and business professionals alike. \n\nThe Brio features Windows Hello support, allowing secure facial recognition login, enhancing both convenience and security. Its versatile mounting options mean you can easily position the camera for optimal framing in any environment. \n\nWith built-in dual microphones for high-quality audio capture, the Brio ensures you are heard as clearly as you are seen. Its smart light correction adjusts to different lighting conditions, making it useful in any setting. If you demand top performance from your webcam, the Logitech Brio Ultra HD is arguably one of the best options available.",
        "price": "₹19999",
        "rating": "4.6",
        "image": "https://res.cloudinary.com/do7ttqxgn/image/upload/v1739601543/29_tbxjra.png",
        "productSpecification": {
            "type": "Webcam",
            "resolution": "4K",
            "HDR": "Yes",
            "features": "Windows Hello support",
            "compatibility": "PC, Mac"
        }
    },
    {
        "id": "30",
        "name": "Elgato Green Screen",
        "description": "Collapsible green screen for streaming and content creation.",
        "about": "The Elgato Green Screen is the perfect tool for streamers and content creators looking to elevate their production quality. Its collapsible design allows you to set it up quickly and easily, providing a professional backdrop for your streams or recordings without taking up much space. \n\nCrafted with a wrinkle-resistant fabric, it ensures a smooth appearance that looks great on camera. The green screen is also portable, making it an excellent option for content creators who travel or attend events. \n\nWith the ability to achieve a clean chroma key effect, you can easily remove the background of your videos, opening up a world of creativity for visual effects and environments. For anyone serious about content creation, the Elgato Green Screen is an invaluable addition that enhances your streaming setup significantly.",
        "price": "₹15999",
        "rating": "4.7",
        "image": "https://res.cloudinary.com/do7ttqxgn/image/upload/v1739601543/30_tsat79.jpg",
        "productSpecification": {
            "type": "Green Screen",
            "size": "80 x 60 inches",
            "material": "Wrinkle-resistant fabric",
            "portability": "Collapsible",
            "compatibility": "Streaming and video production"
        }
    }
];


const UploadGamingaccessories = () => {

    const clearExistingData = async () => {
        const collectionRef = collection(db, 'Gamingaccessories');
        const querySnapshot = await getDocs(collectionRef);
        querySnapshot.forEach(async (docSnapshot) => {
            await deleteDoc(doc(db, 'Gamingaccessories', docSnapshot.id));
        });
    };


    const uploadData = async () => {
        try {
            await clearExistingData();
            const collectionRef = collection(db, 'Gamingaccessories');

            for (const bundle of Gamingaccessories) {
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

export default UploadGamingaccessories;
