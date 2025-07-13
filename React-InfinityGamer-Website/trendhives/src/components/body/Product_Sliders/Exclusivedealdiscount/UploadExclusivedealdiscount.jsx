// UploadExclusivedealdiscount.jsx
import React, { useEffect } from 'react';
import { collection, getDocs, addDoc, deleteDoc, doc } from 'firebase/firestore';
import { db } from '../../../../firebase/';

const Exclusivedealdiscount = [
    {
        "id": 1,
        "title": "NVIDIA RTX 4090 Graphics Card",
        "description": "Ultimate 4K gaming with ray tracing support.",
        "image": "https://res.cloudinary.com/do7ttqxgn/image/upload/v1739552791/id_1_kf6bq9.webp",
        "discount": 10,
        "rating": 5.0,
        "originalPrice": 189999,
        "about": "The NVIDIA RTX 4090 Graphics Card is designed for serious gamers who demand the best performance. With its advanced architecture and cutting-edge technology, it handles the most graphically intense games with ease. Experience breathtaking visuals and frame rates at 4K resolutions, allowing you to enjoy every detail in your gaming environment.\n\nIt's not just about raw power; the RTX 4090 also boasts advanced features such as real-time ray tracing and DLSS, providing enhanced graphical fidelity and smoother gameplay. Whether you're playing single-player games or engaging in competitive multiplayer action, this graphics card ensures an immersive experience.\n\nCooling and durability are also top-notch, ensuring that the card can sustain extended gaming sessions without compromising performance. The RTX 4090 is a top-tier investment for any gaming rig, enabling you to experience the future of gaming today.",
        "productSpecification": {
            "type": "Graphics Card",
            "GPU Architecture": "Ada Lovelace",
            "VRAM": "24GB GDDR6X",
            "Ray Tracing": "Yes",
            "DLSS": "Yes"
        }
    },
    {
        "id": 2,
        "title": "AMD RX 7900 XTX Graphics Card",
        "description": "High-performance gaming with FSR and ray tracing.",
        "image": "https://res.cloudinary.com/do7ttqxgn/image/upload/v1739552793/id_2_xvpqsl.jpg",
        "discount": 12,
        "rating": 4.9,
        "originalPrice": 129999,
        "about": "Experience high-performance gaming with the AMD RX 7900 XTX Graphics Card. It's designed to tackle the latest games while offering enhanced frame rates and stunning visuals. Featuring AMD's RDNA 3 architecture, it provides improved performance per watt and seamless multitasking capabilities.\n\nRay tracing and FidelityFX Super Resolution (FSR) bring your gaming worlds to life with remarkable detail and clarity. Whether you're immersed in a complex open-world environment or engaging in fast-paced shooter gameplay, the RX 7900 XTX delivers an exceptional experience, making it an excellent choice for gamers and content creators alike.\n\nAdditionally, its robust cooling solutions ensure optimal performance during extended gaming sessions. This card stands out for its value and performance, making it a great addition to any modern gaming setup.",
        "productSpecification": {
            "type": "Graphics Card",
            "GPU Architecture": "RDNA 3",
            "VRAM": "20GB GDDR6",
            "Ray Tracing": "Yes",
            "FSR Support": "Yes"
        }
    },
    {
        "id": 3,
        "title": "Intel Core i9-14900K Processor",
        "description": "Top-tier CPU for extreme gaming performance.",
        "image": "https://res.cloudinary.com/do7ttqxgn/image/upload/v1739552793/id_3_hnkkn3.jpg",
        "discount": 15,
        "rating": 4.9,
        "originalPrice": 79999,
        "about": "The Intel Core i9-14900K Processor represents the pinnacle of CPU technology for gamers and content creators alike. With its impressive multi-core performance and high clock speeds, this processor is capable of handling the most demanding tasks, from gaming to video rendering with unmatched efficiency.\n\nFeaturing Intel's latest architecture, the i9-14900K excels in both single-threaded and multi-threaded applications, ensuring top-tier performance in virtually all scenarios. Innovations such as Thermal Velocity Boost allow for dynamic performance enhancements, making it an ideal choice for enthusiasts looking to push their systems to the limit.\n\nPaired with sufficient cooling, the i9-14900K ensures stability and performance under pressure, making it a must-have for building a high-end gaming rig. Elevate your gaming and productivity with this processor that promises cutting-edge performance.",
        "productSpecification": {
            "type": "Processor",
            "Cores": 24,
            "Threads": 32,
            "Base Clock Speed": "3.0 GHz",
            "Max Turbo Boost": "5.8 GHz",
            "Socket": "LGA 1700"
        }
    },
    {
        "id": 4,
        "title": "AMD Ryzen 9 7950X Processor",
        "description": "Blazing-fast multi-core processor for gaming.",
        "image": "https://res.cloudinary.com/do7ttqxgn/image/upload/v1739552794/id_4_gsdyxy.jpg",
        "discount": 14,
        "rating": 4.8,
        "originalPrice": 75999,
        "about": "The AMD Ryzen 9 7950X Processor is a revolutionary chip that sets a new standard in performance for gamers and power users. With its 16 cores and 32 threads, this processor is designed to tackle workload challenges with incredible speed and efficiency.\n\nThanks to AMD's Zen 4 architecture, the Ryzen 9 7950X delivers outstanding performance not just for gaming, but also for content creation and heavy multitasking environments. The remarkable power management features ensure that you get the best performance without sacrificing energy efficiency.\n\nThis processor is built for future-proofing; support for the latest technologies such as PCIe 5.0 and DDR5 RAM allows you to take full advantage of modern components. Elevate your build and enjoy the next-level performance that the Ryzen 9 7950X offers.",
        "productSpecification": {
            "type": "Processor",
            "Cores": 16,
            "Threads": 32,
            "Base Clock Speed": "4.5 GHz",
            "Max Boost Clock": "5.7 GHz",
            "Socket": "AM5"
        }
    },
    {
        "id": 5,
        "title": "Corsair Vengeance RGB DDR5 RAM",
        "description": "Fast DDR5 RAM with stunning RGB lighting.",
        "image": "https://res.cloudinary.com/do7ttqxgn/image/upload/v1739552795/id_5_qyyzpf.jpg",
        "discount": 18,
        "rating": 4.9,
        "originalPrice": 25999,
        "about": "Corsair's Vengeance RGB DDR5 RAM is engineered for gamers who desire both performance and aesthetics. This memory kit not only delivers high speeds and bandwidth, making it perfect for gaming and resource-intensive applications, but it also features dynamic RGB lighting that adds a vibrant touch to your build.\n\nWith speeds up to 6000 MHz, this RAM is designed to enhance the overall performance of your system, ensuring faster load times and efficient multitasking. Its high-quality build ensures durability and stability, allowing you to push your system to its limits without fear of failure.\n\nCompatible with the latest Intel and AMD platforms, the Vengeance RGB DDR5 RAM is a great choice for enthusiasts looking to elevate their gaming experience both in terms of speed and visual flair.",
        "productSpecification": {
            "type": "RAM",
            "Capacity": "16GB",
            "Speed": "6000 MHz",
            "Form Factor": "DIMM",
            "RGB": "Yes"
        }
    },
    {
        "id": 6,
        "title": "G.Skill Trident Z5 RGB DDR5 RAM",
        "description": "High-speed gaming RAM with vibrant RGB effects.",
        "image": "https://res.cloudinary.com/do7ttqxgn/image/upload/v1739552796/id_6_nshase.jpg",
        "discount": 20,
        "rating": 4.9,
        "originalPrice": 27999,
        "about": "The G.Skill Trident Z5 RGB DDR5 RAM is a top-tier memory option for gamers and content creators seeking unmatched performance and stunning design. Engineered with high-speed capabilities, this RAM allows for seamless gaming and smooth multitasking across demanding applications.\n\nThis high-performance memory offers excellent overclocking potential, enabling users to push their hardware to achieve the best performance possible. The customizable RGB lighting provides an eye-catching appearance, enhancing your system's overall aesthetics while syncing with your other components.\n\nWith superior build quality and compatibility with the latest motherboards, the Trident Z5 is a perfect choice for those looking to elevate their gaming rig and achieve both high speeds and stunning visuals.",
        "productSpecification": {
            "type": "RAM",
            "Capacity": "32GB",
            "Speed": "7000 MHz",
            "Form Factor": "DIMM",
            "RGB": "Yes"
        }
    },
    {
        "id": 7,
        "title": "Samsung 990 Pro NVMe SSD 2TB",
        "description": "Ultra-fast SSD for seamless gaming experience.",
        "image": "https://res.cloudinary.com/do7ttqxgn/image/upload/v1739552798/id_7_ycyziq.webp",
        "discount": 15,
        "rating": 4.9,
        "originalPrice": 39999,
        "about": "The Samsung 990 Pro NVMe SSD 2TB is a game changer when it comes to storage solutions for gamers and professionals alike. With lightning-fast read and write speeds, it eliminates lag and loading times, providing a seamless gaming experience that keeps you immersed in your gameplay.\n\nUtilizing the latest PCIe 4.0 interface, this SSD delivers remarkable performance improvements over traditional storage devices. Its massive 2TB capacity allows you to store a vast library of games and media while maintaining stunning performance.\n\nMoreover, the sleek design and integrated heat spreader ensure consistent performance even during extensive usage. Upgrade to the Samsung 990 Pro for a faster and more reliable storage solution, and elevate your gaming and productivity to the next level.",
        "productSpecification": {
            "type": "SSD",
            "Capacity": "2TB",
            "Form Factor": "M.2 NVMe",
            "Interface": "PCIe 4.0",
            "Sequential Read Speed": "7,000 MB/s"
        }
    },
    {
        "id": 8,
        "title": "WD Black SN850X NVMe SSD",
        "description": "High-speed storage with gaming optimization.",
        "image": "https://res.cloudinary.com/do7ttqxgn/image/upload/v1739552799/id_8_qlhenj.jpg",
        "discount": 17,
        "rating": 4.8,
        "originalPrice": 28999,
        "about": "The WD Black SN850X NVMe SSD is crafted for gamers who demand the ultimate performance from their storage solutions. With remarkable speeds and optimization for gaming, this SSD ensures you experience reduced load times and improved responsiveness in all your favorite titles.\n\nEquipped with the latest PCIe Gen4 technology, this drive not only boosts performance for gaming applications but also excels in creative workloads. The generous capacity provides ample space for your games, applications, and creative projects without compromising speed.\n\nThe WD Black SN850X features a sleek design that fits well into any gaming setup, ensuring that aesthetics are covered while providing high-performance capabilities. Experience the benefits of modern storage technology with a drive designed specifically for gamers.",
        "productSpecification": {
            "type": "SSD",
            "Capacity": "1TB",
            "Form Factor": "M.2 NVMe",
            "Interface": "PCIe 4.0",
            "Sequential Read Speed": "7,000 MB/s"
        }
    },
    {
        "id": 9,
        "title": "Corsair RM1000x Power Supply",
        "description": "Fully modular 1000W PSU for stability.",
        "image": "https://res.cloudinary.com/do7ttqxgn/image/upload/v1739552800/id_9_u19wqi.webp",
        "discount": 10,
        "rating": 4.8,
        "originalPrice": 18999,
        "about": "The Corsair RM1000x Power Supply is designed for high-performance builds requiring stable and reliable power delivery. With a fully modular design, this PSU allows for flexible cable management, ensuring a clean and organized build while improving airflow within your case.\n\nOffering 1000W of power, the RM1000x supports even the most powerful components, making it ideal for gaming rigs that demand high efficiency and reliability. Its 80 PLUS Gold certification guarantees exceptional efficiency, helping to reduce energy costs and heat output.\n\nBuilt with high-quality components and advanced technology, this power supply ensures long-lasting performance and peace of mind. Choose the Corsair RM1000x for a dependable power solution that complements your gaming setup.",
        "productSpecification": {
            "type": "Power Supply Unit",
            "Wattage": "1000W",
            "Modularity": "Fully Modular",
            "Efficiency Rating": "80 PLUS Gold",
            "Cooling": "Active PFC"
        }
    },
    {
        "id": 10,
        "title": "EVGA SuperNOVA 1000 G7 Power Supply",
        "description": "Reliable 1000W PSU for gaming builds.",
        "image": "https://res.cloudinary.com/do7ttqxgn/image/upload/v1739552802/id_10_df3gqh.png",
        "discount": 12,
        "rating": 4.8,
        "originalPrice": 199999,
        "about": "The EVGA SuperNOVA 1000 G7 Power Supply is an exceptional option for gamers and power users alike. Designed to deliver reliable and efficient power, this PSU is essential for any high-performance gaming rig. With its 1000W capacity, it ensures that even the most demanding components receive consistent and stable power.\n\nThis power supply features a fully modular design, allowing for flexible and neat cable management that enhances airflow and aesthetics. It is also 80 PLUS Gold certified, meaning it operates at high energy efficiency, reducing both your electricity bill and heat output.\n\nWith advanced protection features and a solid warranty, the EVGA SuperNOVA 1000 G7 is a trusted choice for building or upgrading your gaming setup. Ensure stability and reliability in your power solution with this premium PSU.",
        "productSpecification": {
            "type": "Power Supply Unit",
            "Wattage": "1000W",
            "Modularity": "Fully Modular",
            "Efficiency Rating": "80 PLUS Gold",
            "Cooling": "Active PFC"
        }
    },
    {
        "id": 11,
        "title": "ASUS ROG Maximus Z790 Hero Motherboard",
        "description": "Premium Intel motherboard for high-end gaming.",
        "image": "https://res.cloudinary.com/do7ttqxgn/image/upload/v1739552803/id_11_ps4rxw.png",
        "discount": 15,
        "rating": 4.9,
        "originalPrice": 69999,
        "about": "The ASUS ROG Maximus Z790 Hero Motherboard is engineered for high-end gaming and overclocking. This motherboard is built to support the latest Intel processors, making it an ideal choice for performance-driven builds. With features such as robust power delivery systems and advanced cooling solutions, it ensures your system performs at its best under any conditions.\n\nDesigned with gamers in mind, the ROG Maximus Z790 Hero is packed with premium features, including PCIe 5.0 support and enhanced networking capabilities. This motherboard is built for speed and responsiveness, making it perfect for competitive gaming scenarios.\n\nThe intuitive UEFI BIOS interface and customizable RGB lighting provide a user-friendly experience and aesthetic flair. Elevate your gaming rig with this premium motherboard that offers top-tier performance and flexibility.",
        "productSpecification": {
            "type": "Motherboard",
            "Socket": "LGA 1700",
            "Chipset": "Z790",
            "RAM Slots": "4 x DDR5",
            "PCIe Slots": "4 x PCIe 5.0",
            "Networking": "Wi-Fi 6E"
        }
    },
    {
        "id": 12,
        "title": "MSI MEG X670E ACE Motherboard",
        "description": "High-performance motherboard for AMD Ryzen builds.",
        "image": "https://res.cloudinary.com/do7ttqxgn/image/upload/v1739552804/id_12_sv3ic8.png",
        "discount": 14,
        "rating": 4.8,
        "originalPrice": 59999,
        "about": "The MSI MEG X670E ACE Motherboard is designed for enthusiasts and gamers who demand nothing but the best in performance and features. This motherboard supports the latest AMD Ryzen processors and is built upon advanced technology to deliver exceptional overclocking capabilities and stability.\n\nThe X670E ACE features a wealth of connectivity options, including PCIe 5.0 slots and high-speed USB ports. Customizable cooling solutions and robust power delivery ensure that your system runs smoothly even during intense gaming and multitasking sessions.\n\nWith a stylish design and user-friendly BIOS settings, this motherboard makes it easy for gamers to tailor their experience. Embrace the future of gaming with the MSI MEG X670E ACE and unlock your system’s full potential.",
        "productSpecification": {
            "type": "Motherboard",
            "Socket": "AM5",
            "Chipset": "X670E",
            "RAM Slots": "4 x DDR5",
            "PCIe Slots": "4 x PCIe 5.0",
            "Networking": "Wi-Fi 6E"
        }
    },
    {
        "id": 13,
        "title": "Corsair iCUE H150i Cooling System",
        "description": "Efficient AIO liquid cooling with RGB.",
        "image": "https://res.cloudinary.com/do7ttqxgn/image/upload/v1739552805/id_13_c28aiw.jpg",
        "discount": 20,
        "rating": 4.9,
        "originalPrice": 29999,
        "about": "The Corsair iCUE H150i Cooling System is designed for gamers seeking superior cooling performance for their CPUs. This All-in-One (AIO) liquid cooler offers exceptional thermal management, ensuring that your system maintains optimal temperatures even during demanding gaming sessions.\n\nWith customizable RGB lighting and a dynamic cooling performance, the H150i adds a visual flair to your build while effectively preventing overheating. Its user-friendly software lets you monitor and tweak the cooling performance to suit your needs, keeping your CPU cool and stable.\n\nEasy to install and compatible with the latest Intel and AMD sockets, the Corsair iCUE H150i is a must-have for anyone looking to enhance their cooling capabilities while maintaining style.",
        "productSpecification": {
            "type": "CPU Cooler",
            "Cooling Type": "AIO Liquid Cooling",
            "Radiator Size": "360mm",
            "RGB Lighting": "Yes",
            "Compatibility": "Intel and AMD"
        }
    },
    {
        "id": 14,
        "title": "Noctua NH-D15 Air Cooler",
        "description": "Top-tier air cooling for silent operation.",
        "image": "https://res.cloudinary.com/do7ttqxgn/image/upload/v1739552806/id_14_vhzxyt.jpg",
        "discount": 18,
        "rating": 4.9,
        "originalPrice": 19999,
        "about": "The Noctua NH-D15 Air Cooler sets the standard for air cooling performance, known for its exceptional cooling capabilities and whisper-quiet operation. Featuring dual fans and a large heatsink, it efficiently dissipates heat while maintaining low noise levels, making it ideal for gamers who prioritize silent operation.\n\nIts renowned compatibility with a wide range of sockets makes installation easy, ensuring that it fits in most setups without hassle. The NH-D15 is built with high-quality materials, providing long-lasting durability and reliable performance.\n\nWith simple installation options and impressive cooling performance, the Noctua NH-D15 is a favorite among enthusiasts looking for top-tier air cooling solutions.",
        "productSpecification": {
            "type": "Air Cooler",
            "Compatibility": "Intel and AMD",
            "Fan Size": "140mm",
            "Heat Pipes": "6",
            "Noise Level": "Max 24.6 dBA"
        }
    },
    {
        "id": 15,
        "title": "Lian Li O11 Dynamic EVO Case",
        "description": "Spacious, RGB-compatible case for gaming builds.",
        "image": "https://res.cloudinary.com/do7ttqxgn/image/upload/v1739552807/id_15_bvu9fy.png",
        "discount": 15,
        "rating": 4.9,
        "originalPrice": 169999,
        "about": "The Lian Li O11 Dynamic EVO Case offers a perfect blend of style and functionality for gamers looking to build their ideal PC. With its spacious interior and modular design, this case accommodates high-end components and custom cooling solutions with ease.\n\nDesigned for optimal airflow, the O11 Dynamic EVO ensures that your components stay cool while providing ample space for cable management. The tempered glass panels showcase your build beautifully and allow for various RGB lighting configurations to complement your setup.\n\nWhether you're a casual gamer or a hardcore enthusiast, this case enhances your gaming experience while maintaining a clean and visually appealing aesthetic.",
        "productSpecification": {
            "type": "PC Case",
            "Dimensions": "272 × 443 × 466mm",
            "Cooling Options": "Air and Liquid",
            "Material": "Aluminum and Glass",
            "Compatibility": "E-ATX, ATX, Micro-ATX"
        }
    },
    {
        "id": 16,
        "title": "NZXT H9 Flow PC Case",
        "description": "Stylish and airflow-optimized RGB gaming case.",
        "image": "https://res.cloudinary.com/do7ttqxgn/image/upload/v1739552808/id_16_fznfas.avif",
        "discount": 12,
        "rating": 4.8,
        "originalPrice": 14999,
        "about": "The NZXT H9 Flow PC Case is designed for gamers who appreciate aesthetics without compromising on performance. This case features a sleek, modern design that enhances the overall build quality, while supporting optimal airflow for effective cooling.\n\nAmple space for fans and radiators ensures that your components remain cool, even during the most demanding gaming sessions. The sleek glass panels provide a stunning view of your internal components while supporting RGB lighting to add a unique touch to your setup.\n\nWith easy installation features and a user-friendly design, the H9 Flow makes it convenient for gamers and PC builders to create the perfect system according to their personal style.",
        "productSpecification": {
            "type": "PC Case",
            "Dimensions": "231 × 485 × 490mm",
            "Cooling Options": "Air and Liquid",
            "Material": "Steel and Glass",
            "Compatibility": "E-ATX, ATX, Micro-ATX, Mini-ITX"
        }
    },
    {
        "id": 17,
        "title": "Logitech G Pro X Superlight Mouse",
        "description": "Ultra-lightweight wireless gaming mouse.",
        "image": "https://res.cloudinary.com/do7ttqxgn/image/upload/v1739552810/id_17_trqzxc.webp",
        "discount": 25,
        "rating": 4.9,
        "originalPrice": 1599,
        "about": "The Logitech G Pro X Superlight Mouse is a professional-grade wireless gaming mouse engineered for competitive gamers. Weighing in at under 63 grams, it offers incredible responsiveness and speed, enhancing your in-game performance and allowing for swift maneuvers.\n\nThe HERO 25K sensor delivers precise tracking and a smooth experience, fitted with customizable DPI settings to suit your playstyle. Its wireless functionality ensures you can enjoy freedom of movement without compromising on performance.\n\nBuilt with durability in mind, the Superlight features a sleek design and premium construction, ensuring it stands up to rigorous use. Take your gaming to the next level with this high-performance mouse designed for champions.",
        "productSpecification": {
            "type": "Gaming Mouse",
            "Weight": "63g",
            "Sensor": "HERO 25K",
            "DPI": "25,600",
            "Wireless Connectivity": "LIGHTSPEED"
        }
    },
    {
        "id": 18,
        "title": "Razer DeathAdder V3 Pro Mouse",
        "description": "Ergonomic wireless gaming mouse with speed.",
        "image": "https://res.cloudinary.com/do7ttqxgn/image/upload/v1739552811/id_18_ld2ufw.jpg",
        "discount": 20,
        "rating": 4.9,
        "originalPrice": 14999,
        "about": "The Razer DeathAdder V3 Pro Mouse is a top choice for esports competitors and gamers seeking precision and comfort. Renowned for its ergonomic design, the DeathAdder V3 Pro offers exceptional grip and support during intense gaming sessions, reducing fatigue.\n\nFeaturing advanced optical sensors and customizable DPI settings, this mouse is optimized for speed and accuracy, allowing for enhanced gameplay responsiveness. The wireless connectivity ensures freedom of movement with minimal latency, meeting the demands of competitive gameplay.\n\nAdditionally, the lightweight construction and customizable RGB lighting allow users to personalize their setup while enjoying a high-performance product that excels in every aspect.",
        "productSpecification": {
            "type": "Gaming Mouse",
            "Weight": "63g",
            "Sensor": "Focus Pro 30K",
            "DPI": "30,000",
            "Wireless Connectivity": "Razer HyperSpeed"
        }
    },
    {
        "id": 19,
        "title": "SteelSeries Apex Pro TKL Keyboard",
        "description": "Adjustable switches for ultimate typing experience.",
        "image": "https://res.cloudinary.com/do7ttqxgn/image/upload/v1739552813/id_19_rgndxt.png",
        "discount": 18,
        "rating": 4.9,
        "originalPrice": 29999,
        "about": "The SteelSeries Apex Pro TKL Keyboard is perfect for gamers who demand customizability and performance from their peripherals. This keyboard features adjustable switches, allowing users to tailor the actuation point for each key, providing a unique typing experience that matches individual preferences.\n\nCrafted with a compact design, the TKL version saves space on your desk without sacrificing functionality. The durable aluminum frame and RGB lighting create an attractive and sturdy addition to any setup, supporting gaming excellence with every keystroke.\n\nWhether you're playing tactical FPS games or writing, the Apex Pro TKL adapts to your style, making it a versatile choice for gamers and professionals alike.",
        "productSpecification": {
            "type": "Keyboard",
            "Switch Type": "Adjustable Mechanical",
            "Key Switch Lifespan": "100 million key presses",
            "Lighting": "RGB",
            "Layout": "TenKeyLess"
        }
    },
    {
        "id": 20,
        "title": "Xbox Elite Series 2 Controller",
        "description": "Pro-level controller with swappable components.",
        "image": "https://res.cloudinary.com/do7ttqxgn/image/upload/v1739552813/id_20_wm6omn.jpg",
        "discount": 22,
        "rating": 4.8,
        "originalPrice": 18999,
        "about": "The Xbox Elite Series 2 Controller is designed for gamers who want a professional-grade experience. With a robust array of customizable features, this controller allows you to adjust sensitivity, switch out thumbsticks, and configure the layout to fit your gameplay style seamlessly.\n\nDesigned with comfort and durability in mind, the Elite Series 2 provides a premium feel with textured grips and adjustable tension thumbsticks for optimal control during gaming. The rechargeable battery offers up to 40 hours of playtime, ensuring extended periods of gaming without interruptions.\n\nEnhance your gameplay with this elite controller, delivering precision and customization for a competitive edge in your favorite titles.",
        "productSpecification": {
            "type": "Game Controller",
            "Connectivity": "Wireless and Wired",
            "Battery Life": "Up to 40 hours",
            "Customizable Components": "Yes",
            "Compatibility": "Xbox and PC"
        }
    },
    {
        "id": 21,
        "title": "PlayStation DualSense Edge Controller",
        "description": "Advanced PS5 controller with adaptive triggers.",
        "image": "https://res.cloudinary.com/do7ttqxgn/image/upload/v1739552815/id_21_adbfib.jpg",
        "discount": 15,
        "rating": 4.7,
        "originalPrice": 29999,
        "about": "The PlayStation DualSense Edge Controller represents the future of gaming. Built specifically for the PS5, this controller offers unique features such as haptic feedback and adaptive triggers that provide immersive gaming experiences that respond dynamically to in-game actions.\n\nIts ergonomic design ensures comfort during lengthy gaming sessions, while customizable buttons give players the ability to adjust the layout according to their preferences. The DualSense Edge elevates traditional gameplay by incorporating sensory feedback, providing a connection to the game that feels natural and intuitive.\n\nWhether you're playing action-packed titles or exploring immersive worlds, the DualSense Edge delivers an exceptional level of control and responsiveness, setting new standards for gaming peripherals.",
        "productSpecification": {
            "type": "Game Controller",
            "Connectivity": "Wireless",
            "Haptic Feedback": "Yes",
            "Adaptive Triggers": "Yes",
            "Compatibility": "PlayStation 5"
        }
    },
    {
        "id": 22,
        "title": "Elgato 4K60 Pro Capture Card",
        "description": "High-quality 4K streaming and recording card.",
        "image": "https://res.cloudinary.com/do7ttqxgn/image/upload/v1739552817/id_22_vqdqr8.png",
        "discount": 20,
        "rating": 4.9,
        "originalPrice": 25999,
        "about": "The Elgato 4K60 Pro Capture Card is essential for content creators and streamers looking to capture and broadcast their gameplay at the highest quality. Supporting up to 4K resolution at 60 frames per second, this capture card delivers stunning visuals and smooth performance.\n\nFeaturing low-latency technology ensures that your streams are responsive and lag-free, which is critical for maintaining viewer engagement. The easy setup and powerful software make it a favorite among enthusiasts and professionals alike.\n\nElevate your streaming setup with the Elgato 4K60 Pro Capture Card, providing you with the tools needed to create high-quality content seamlessly.",
        "productSpecification": {
            "type": "Capture Card",
            "Max Resolution": "4K",
            "Max Frame Rate": "60 fps",
            "Interface": "PCIe",
            "Compatibility": "PC, Mac"
        }
    },
    {
        "id": 23,
        "title": "Logitech BRIO 4K Webcam",
        "description": "Ultra HD webcam for professional streaming.",
        "image": "https://res.cloudinary.com/do7ttqxgn/image/upload/v1739552817/id_23_mqgf4y.jpg",
        "discount": 25,
        "rating": 4.8,
        "originalPrice": 15999,
        "about": "The Logitech BRIO 4K Webcam is designed to bring your video communication to the next level. With ultra HD 4K resolution, it provides crystal-clear image quality for streaming, video conferences, or recording content. This webcam is perfect for professionals who need reliable performance in various settings.\n\nEquipped with features like HDR and autofocus, the BRIO ensures that you always look your best on camera, even in challenging lighting conditions. Compatible with major video calling platforms, setup is seamless and hassle-free, allowing you to focus on what matters: your content.\n\nBoost your streaming or conferencing experience with the Logitech BRIO 4K Webcam, crafted for high-quality video and reliable performance.",
        "productSpecification": {
            "type": "Webcam",
            "resolution": "4K",
            "HDR": "Yes",
            "features": "Windows Hello support",
            "compatibility": "PC, Mac"
        }
    },
    {
        "id": 24,
        "title": "Shure SM7B Microphone",
        "description": "Industry-standard mic for studio-quality sound.",
        "image": "https://res.cloudinary.com/do7ttqxgn/image/upload/v1739552818/id_24_tnxw9i.jpg",
        "discount": 10,
        "rating": 4.9,
        "originalPrice": 49999,
        "about": "The Shure SM7B Microphone is an industry-standard choice for musicians, podcasters, and streamers who demand the highest audio quality. Recognized for its versatility and robust build, the SM7B excels in various recording scenarios, delivering clear and natural sound.",
        "productSpecification": {
            "type": "Microphone",
            "Type": "Dynamic",
            "Frequency Response": "50 Hz - 20 kHz",
            "Connector": "XLR",
            "Compatibility": "Professional Audio Equipment"
        }
    },
    {
        "id": 25,
        "title": "Meta Quest 3 VR Headset",
        "description": "Advanced standalone VR headset for gaming.",
        "image": "https://res.cloudinary.com/do7ttqxgn/image/upload/v1739552820/id_25_ua4tli.webp",
        "discount": 12,
        "rating": 4.8,
        "originalPrice": 59999,
        "about": "The Meta Quest 3 VR Headset is at the forefront of virtual reality technology, designed for immersive gaming experiences without the need for a computer. This standalone headset offers a library of games and applications packed with stunning visuals and interactive gameplay.\n\nFeaturing advanced tracking and hand recognition technology, the Quest 3 creates a fully interactive virtual environment that responds to your movements with precision. The comfortable design ensures a smooth and enjoyable experience, even during long gaming sessions.\n\nUnlock the potential of virtual reality with the Meta Quest 3, allowing you to experience gaming like never before, all in a portable and user-friendly package.",
        "productSpecification": {
            "type": "VR Headset",
            "Resolution": "1832 x 1920 per eye",
            "Tracking": "Inside-out",
            "Field of View": "120 degrees",
            "Compatibility": "Standalone"
        }
    }
];

const UploadExclusivedealdiscount = () => {

    const clearExistingData = async () => {
        const collectionRef = collection(db, 'Exclusivedealdiscount');
        const querySnapshot = await getDocs(collectionRef);
        querySnapshot.forEach(async (docSnapshot) => {
            await deleteDoc(doc(db, 'Exclusivedealdiscount', docSnapshot.id));
        });
    };

    const uploadData = async () => {
        try {
            await clearExistingData(); 
            const collectionRef = collection(db, 'Exclusivedealdiscount');

            for (const bundle of Exclusivedealdiscount) {
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

export default UploadExclusivedealdiscount;
