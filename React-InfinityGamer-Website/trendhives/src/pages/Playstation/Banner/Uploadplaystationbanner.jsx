
import React, { useEffect } from 'react';
import { collection, getDocs, addDoc, deleteDoc, doc } from 'firebase/firestore';
import { db } from '../../../firebase/';

const playstationbanner = [
    {
        "id": 1,
        "image": "https://res.cloudinary.com/do7ttqxgn/image/upload/v1743927601/231825_vk2q2m.jpg"
    },
    {
        "id": 2,
        "image": "https://res.cloudinary.com/do7ttqxgn/image/upload/v1743923784/528942_dqepda.jpg"
    },
    {
        "id": 3,
        "image": "https://res.cloudinary.com/do7ttqxgn/image/upload/v1743927581/183065_xo1cqt.jpg"
    },
];


const Uploadplaystationbanner = () => {
  
  const clearExistingData = async () => {
    const collectionRef = collection(db, 'playstationbanner');
    const querySnapshot = await getDocs(collectionRef);
    querySnapshot.forEach(async (docSnapshot) => {
      await deleteDoc(doc(db, 'playstationbanner', docSnapshot.id));
    });
  };


  const uploadData = async () => {
    try {
      await clearExistingData(); 
      const collectionRef = collection(db, 'playstationbanner');
      
      for (const bundle of playstationbanner) {
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

  return null;
};

export default Uploadplaystationbanner;
