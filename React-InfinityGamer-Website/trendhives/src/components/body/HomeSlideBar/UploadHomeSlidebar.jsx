// UploadHomeSlidebar.jsx
import React, { useEffect } from 'react';
import { collection, getDocs, addDoc, deleteDoc, doc } from 'firebase/firestore';
import { db } from '../../../firebase/';

const HomeSlidebar = [
  {
    id: 1,
    image: "https://res.cloudinary.com/do7ttqxgn/image/upload/v1739111465/7456_wwi6bj.jpg",
  },
  {
    id: 2,
    image: "https://res.cloudinary.com/do7ttqxgn/image/upload/v1744531216/1657059_bhw0f4.jpg",
  },
  {
    id: 3,
    image: "https://res.cloudinary.com/do7ttqxgn/image/upload/v1744531215/2919348_fvgcwl.jpg",
  },
  {
    id: 4,
    image: "https://res.cloudinary.com/do7ttqxgn/image/upload/v1744532139/1842091_a8bksz.jpg",
  },
  {
    id: 5,
    image: "https://res.cloudinary.com/do7ttqxgn/image/upload/v1744531222/3450368_k08ie0.jpg",
  },
  {
    id: 6,
    image: "https://res.cloudinary.com/do7ttqxgn/image/upload/v1744531632/1842277_j43f8e.jpg",
  }
];

// Main component
const UploadHomeSlidebar = () => {
  // Clear existing documents in Firestore
  const clearExistingData = async () => {
    const collectionRef = collection(db, 'HomeSlidebar');
    const querySnapshot = await getDocs(collectionRef);
    querySnapshot.forEach(async (docSnapshot) => {
      await deleteDoc(doc(db, 'HomeSlidebar', docSnapshot.id));
    });
  };

  // Upload new JSON data to Firestore
  const uploadData = async () => {
    try {
      await clearExistingData(); // Clear old data first
      const collectionRef = collection(db, 'HomeSlidebar');
      
      for (const bundle of HomeSlidebar) {
        await addDoc(collectionRef, bundle);
      }

      console.log('Data uploaded successfully!');
    } catch (error) {
      console.error('Error uploading data:', error);
    }
  };

  // Automatically run once when the component is mounted
  // useEffect(() => {
  //   uploadData();
  // }, []);

  // return null;
};

export default UploadHomeSlidebar;
