// UploadShowcase.jsx
import React, { useEffect } from 'react';
import { collection, getDocs, addDoc, deleteDoc, doc } from 'firebase/firestore';
import { db } from '../../../firebase/';

const Showcase = [
    {
        "id": 1,
        "name": "PlayStation",
        "description": "Experience next-gen gaming with ultra-fast loading and stunning visuals.",
        "image": "https://res.cloudinary.com/do7ttqxgn/image/upload/v1738941863/3852996_nuijuh.jpg",
        "color": "red"
    },
    {
        "id": 2,
        "name": "Xbox",
        "description": "The most powerful Xbox ever with 4K gaming and immersive experience.",
        "image": "https://res.cloudinary.com/do7ttqxgn/image/upload/v1738941864/211140_e1csjf.jpg",
        "color": "green"
    },
    {
        "id": 3,
        "name": "Consoles",
        "description": "Play anywhere, anytime with the versatile hybrid gaming console.",
        "image": "https://res.cloudinary.com/do7ttqxgn/image/upload/v1738941864/3881710_p2i3to.jpg",
        "color": "red"
    },
    {
        "id": 4,
        "name": "PC Components",
        "description": "Play anywhere, anytime with the versatile hybrid gaming console.",
        "image": "https://res.cloudinary.com/do7ttqxgn/image/upload/v1738941863/117776_nq9sls.jpg",
        "color": "green"
    }
];

// Main component
const UploadShowcase = () => {
    // Clear existing documents in Firestore
    const clearExistingData = async () => {
        const collectionRef = collection(db, 'Showcase');
        const querySnapshot = await getDocs(collectionRef);
        querySnapshot.forEach(async (docSnapshot) => {
            await deleteDoc(doc(db, 'Showcase', docSnapshot.id));
        });
    };

    // Upload new JSON data to Firestore
    const uploadData = async () => {
        try {
            await clearExistingData(); // Clear old data first
            const collectionRef = collection(db, 'Showcase');

            for (const bundle of Showcase) {
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

export default UploadShowcase;
