// UploadPreorder.jsx
import React, { useEffect } from 'react';
import { collection, getDocs, addDoc, deleteDoc, doc } from 'firebase/firestore';
import { db } from '../../../../firebase/';

const Preorder = [
    {
        "id": 1,
        "name": "PlayStation 5 Pro",
        "description": "Next-gen console with enhanced graphics and performance.",
        "price": "₹59999",
        "rating": "5.0",
        "image": "https://res.cloudinary.com/do7ttqxgn/image/upload/v1739604579/1_e4dwpq.jpg"
    },
    {
        "id": 2,
        "name": "Xbox Series X Elite",
        "description": "Upgraded version with faster loading times and more storage.",
        "price": "₹6999",
        "rating": "4.9",
        "image": "https://res.cloudinary.com/do7ttqxgn/image/upload/v1739604581/2_ah088g.png"
    },
    {
        "id": 3,
        "name": "NVIDIA RTX 5090",
        "description": "Upcoming graphics card with unprecedented performance.",
        "price": "₹19999",
        "rating": "5.0",
        "image": "https://res.cloudinary.com/do7ttqxgn/image/upload/v1739604580/3_kbdusa.webp"
    },
    {
        "id": 4,
        "name": "Razer Project Hazel",
        "description": "Smart mask with RGB lighting and voice projection.",
        "price": "₹2999",
        "rating": "4.7",
        "image": "https://res.cloudinary.com/do7ttqxgn/image/upload/v1739604579/4_mz4vin.jpg"
    },
    {
        "id": 5,
        "name": "Apple AR Glasses",
        "description": "Augmented reality glasses with seamless integration with iOS.",
        "price": "₹9999",
        "rating": "4.8",
        "image": "https://res.cloudinary.com/do7ttqxgn/image/upload/v1739604579/5_la9yrz.webp"
    },
    {
        "id": 6,
        "name": "ASUS ROG Strix RTX 4090",
        "description": "Top-tier graphics card with ray tracing and AI-enhanced graphics.",
        "price": "₹17999",
        "rating": "4.9",
        "image": "https://res.cloudinary.com/do7ttqxgn/image/upload/v1739604751/6_cvtdjf.webp"
    },
    {
        "id": 7,
        "name": "Alienware Aurora R15",
        "description": "High-performance gaming desktop with liquid cooling.",
        "price": "₹39999",
        "rating": "4.9",
        "image": "https://res.cloudinary.com/do7ttqxgn/image/upload/v1739605454/7-2_q7qqr1.webp"
    },
    {
        "id": 8,
        "name": "ASUS ROG Swift OLED Monitor",
        "description": "Gaming monitor with 4K resolution and 240Hz refresh rate.",
        "price": "₹129999",
        "rating": "5.0",
        "image": "https://res.cloudinary.com/do7ttqxgn/image/upload/v1739604581/8_p7rie8.png"
    },
    {
        "id": 9,
        "name": "Logitech G Pro X 2",
        "description": "Wireless gaming headset with advanced noise cancellation.",
        "price": "₹2499",
        "rating": "4.8",
        "image": "https://res.cloudinary.com/do7ttqxgn/image/upload/v1739604580/9_nows4x.webp"
    },
    {
        "id": 10,
        "name": "DJI Phantom 5",
        "description": "Next-gen drone with enhanced camera and flight stability.",
        "price": "₹24999",
        "rating": "4.9",
        "image": "https://res.cloudinary.com/do7ttqxgn/image/upload/v1739604580/10_nxlhzp.jpg"
    },
    {
        "id": 11,
        "name": "GoPro Hero 12",
        "description": "Action camera with 8K recording and improved stabilization.",
        "price": "₹4999",
        "rating": "4.8",
        "image": "https://res.cloudinary.com/do7ttqxgn/image/upload/v1739604581/11_q7t9uk.avif"
    },
    {
        "id": 12,
        "name": "Intel Core i9-14900K",
        "description": "Next-gen processor with exceptional performance for gaming and productivity.",
        "price": "₹49999",
        "rating": "4.9",
        "image": "https://res.cloudinary.com/do7ttqxgn/image/upload/v1739604581/12_wjtepb.jpg"
    },
    {
        "id": 13,
        "name": "Elgato Stream Deck XL",
        "description": "Advanced customizable control panel for professional streamers.",
        "price": "₹19999",
        "rating": "5.0",
        "image": "https://res.cloudinary.com/do7ttqxgn/image/upload/v1739604582/13_stigak.jpg"
    },
    {
        "id": 14,
        "name": "Meta Quest 4",
        "description": "Next-gen VR headset with improved resolution and tracking.",
        "price": "₹7999",
        "rating": "4.9",
        "image": "https://res.cloudinary.com/do7ttqxgn/image/upload/v1739604586/14_n0szb4.png"
    },
    {
        "id": 15,
        "name": "Sony Alpha ZV-1 II",
        "description": "Vlogging camera with advanced autofocus and 4K HDR recording.",
        "price": "₹9999",
        "rating": "4.8",
        "image": "https://res.cloudinary.com/do7ttqxgn/image/upload/v1739604582/15_gy6vgd.jpg"
    },
    {
        "id": 16,
        "name": "HyperX Cloud Alpha 2",
        "description": "Gaming headset with dual-chamber drivers and virtual 7.1 surround sound.",
        "price": "₹1999",
        "rating": "4.9",
        "image": "https://res.cloudinary.com/do7ttqxgn/image/upload/v1739604583/16_jjccnm.jpg"
    },
    {
        "id": 17,
        "name": "LG OLED Flex",
        "description": "Bendable OLED TV with adjustable curvature for immersive viewing.",
        "price": "₹29999",
        "rating": "5.0",
        "image": "https://res.cloudinary.com/do7ttqxgn/image/upload/v1739604583/17_bxbdkq.jpg"
    },
    {
        "id": 18,
        "name": "Razer Blade 18",
        "description": "High-end gaming laptop with 18-inch display and RTX 4090 GPU.",
        "price": "₹49999",
        "rating": "5.0",
        "image": "https://res.cloudinary.com/do7ttqxgn/image/upload/v1739604584/18_lgbjru.jpg"
    },
    {
        "id": 19,
        "name": "Samsung Odyssey Ark",
        "description": "Curved gaming monitor with Quantum Mini-LED technology.",
        "price": "₹29999",
        "rating": "4.9",
        "image": "https://res.cloudinary.com/do7ttqxgn/image/upload/v1739604586/19_frnhat.jpg"
    },
    {
        "id": 20,
        "name": "Valve Deckard VR",
        "description": "Advanced VR headset with modular design and wireless capabilities.",
        "price": "₹19999",
        "rating": "5.0",
        "image": "https://res.cloudinary.com/do7ttqxgn/image/upload/v1739604579/5_la9yrz.webp"
    }

];

// Main component
const UploadPreorder = () => {
    // Clear existing documents in Firestore
    const clearExistingData = async () => {
        const collectionRef = collection(db, 'Preorder');
        const querySnapshot = await getDocs(collectionRef);
        querySnapshot.forEach(async (docSnapshot) => {
            await deleteDoc(doc(db, 'Preorder', docSnapshot.id));
        });
    };

    const uploadData = async () => {
        try {
            await clearExistingData(); 
            const collectionRef = collection(db, 'Preorder');

            for (const bundle of Preorder) {
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

export default UploadPreorder;
