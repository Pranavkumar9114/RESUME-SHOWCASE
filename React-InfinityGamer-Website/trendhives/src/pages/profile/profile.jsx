import { useState, useEffect } from "react";
import { getAuth, signOut,onAuthStateChanged } from "firebase/auth";
import {
  getFirestore,
  doc,
  getDoc,
  setDoc,
  updateDoc,
  serverTimestamp,
} from "firebase/firestore";
import styles from "./profile.module.css";
import Navbar from "../../components/navbar/Navbar";
import { useNavigate } from "react-router-dom";


const convertToBase64 = (file) => {
  return new Promise((resolve, reject) => {
    const reader = new FileReader();
    reader.readAsDataURL(file);
    reader.onload = () => resolve(reader.result);
    reader.onerror = (error) => reject(error);
  });
};

const Profile = () => {
const navigate = useNavigate();
  const [user, setUser] = useState(null);
  const [profileData, setProfileData] = useState({
    fullName: "",
    username: "",
    bio: "",
    photoURL: "",
    email: "",
    lastUpdated: null,
  });
  const [isEditing, setIsEditing] = useState(false);
  const [isLoading, setIsLoading] = useState(true);
  const [isSaving, setIsSaving] = useState(false);
  const [message, setMessage] = useState({ text: "", type: "" });
  const [imageFile, setImageFile] = useState(null);
  const [imagePreview, setImagePreview] = useState(null);

  const auth = getAuth();
  const db = getFirestore();

  useEffect(() => {
    const unsubscribe = onAuthStateChanged(auth, async (currentUser) => {
      if (!currentUser) {
        setUser(null);
        setIsLoading(false);
        return;
      }
  
      setUser(currentUser);
  
      try {
        const userDocRef = doc(db, "profile", currentUser.uid);
        const userDoc = await getDoc(userDocRef);
  
        if (userDoc.exists()) {
          const userData = userDoc.data();
          setProfileData({
            fullName: userData.fullName || "",
            username: userData.username || "",
            bio: userData.bio || "",
            photoURL: userData.photoURL || "",
            email: currentUser.email || "",
            lastUpdated: userData.lastUpdated
              ? userData.lastUpdated.toDate()
              : null,
          });
        } else {

          setProfileData({
            fullName: currentUser.displayName || "",
            username: "",
            bio: "",
            photoURL: "",
            email: currentUser.email || "",
            lastUpdated: null,
          });
        }
      } catch (error) {
        setMessage({ text: `Error fetching profile: ${error.message}`, type: "error" });
      } finally {
        setIsLoading(false);
      }
    });
  
    return () => unsubscribe(); // Clean up listener on unmount
  }, []);

//   useEffect(() => {
//     const fetchUserData = async () => {
//       setIsLoading(true);
//       try {
//         const currentUser = auth.currentUser;
//         if (!currentUser) {
//           setIsLoading(false);
//           return;
//         }

//         setUser(currentUser);

//         const userDocRef = doc(db, "profile", currentUser.uid);
//         const userDoc = await getDoc(userDocRef);

//         if (userDoc.exists()) {
//           const userData = userDoc.data();
//           setProfileData({
//             fullName: userData.fullName || "",
//             username: userData.username || "",
//             bio: userData.bio || "",
//             photoURL: userData.photoURL || "",
//             email: currentUser.email || "",
//             lastUpdated: userData.lastUpdated
//               ? userData.lastUpdated.toDate()
//               : null,
//           });
//         } else {
//           setProfileData({
//             fullName: currentUser.displayName || "",
//             username: "",
//             bio: "",
//             photoURL: "",
//             email: currentUser.email || "",
//             lastUpdated: null,
//           });
//         }
//       } catch (error) {
//         setMessage({ text: `Error fetching profile: ${error.message}`, type: "error" });
//       } finally {
//         setIsLoading(false);
//       }
//     };

//     fetchUserData();
//   }, []);

  const handleInputChange = (e) => {
    const { name, value } = e.target;
    setProfileData((prev) => ({ ...prev, [name]: value }));
  };

  const handleImageChange = (e) => {
    if (e.target.files && e.target.files[0]) {
      const file = e.target.files[0];
      setImageFile(file);

      const reader = new FileReader();
      reader.onload = (event) => {
        setImagePreview(event.target.result);
      };
      reader.readAsDataURL(file);
    }
  };

  const validateForm = () => {
    if (!profileData.fullName.trim()) {
      setMessage({ text: "Full name cannot be empty", type: "error" });
      return false;
    }
    if (!profileData.username.trim()) {
      setMessage({ text: "Username cannot be empty", type: "error" });
      return false;
    }
    return true;
  };

  const handleSaveProfile = async (e) => {
    e.preventDefault();

    if (!validateForm()) return;

    setIsSaving(true);
    setMessage({ text: "", type: "" });

    try {
      const currentUser = auth.currentUser;
      if (!currentUser) throw new Error("No user logged in");

      let photoURL = profileData.photoURL;

      if (imageFile) {
        photoURL = await convertToBase64(imageFile);
      }

      const userDocRef = doc(db, "profile", currentUser.uid);
      await setDoc(userDocRef, {
        fullName: profileData.fullName,
        username: profileData.username,
        bio: profileData.bio,
        photoURL,
        lastUpdated: serverTimestamp(),
      }, { merge: true })      

      setProfileData((prev) => ({
        ...prev,
        photoURL,
        lastUpdated: new Date(),
      }));

      setMessage({ text: "Profile updated successfully!", type: "success" });
      setIsEditing(false);
      setImageFile(null);
      setImagePreview(null);
    } catch (error) {
      setMessage({ text: `Error updating profile: ${error.message}`, type: "error" });
    } finally {
      setIsSaving(false);
    }
  };

  const handleSignOut = async () => {
    try {
      await signOut(auth);
      navigate("/");
    } catch (error) {
      setMessage({
        text: `Error signing out: ${error.message}`,
        type: "error",
      });
    }
  };
  

  if (isLoading) {
    return (
      <div className={styles.loadingContainer}>
        <div className={styles.spinner}></div>
        <p>Loading profile...</p>
      </div>
    );
  }

  if (!user) {
    return (
      <div className={styles.container}>
        <p>Please sign in to view your profile.</p>
      </div>
    );
  }

  return (
    <>
    <div>
        <><Navbar/></>
    </div>
    <div className={styles.container}>
      <div className={styles.profileCard}>
        <div className={styles.header}>
          <h1>User Profile</h1>
          <div className={styles.actions}>
            <button
              className={styles.editButton}
              onClick={() => setIsEditing(!isEditing)}
            >
              {isEditing ? "Cancel" : "Edit Profile"}
            </button>
            <button className={styles.signOutButton} onClick={handleSignOut}>
              Sign Out
            </button>
          </div>
        </div>

        {message.text && (
          <div className={`${styles.message} ${styles[message.type]}`}>
            {message.text}
          </div>
        )}

        <form onSubmit={handleSaveProfile} className={styles.profileForm}>
          <div className={styles.profileContent}>
            <div className={styles.imageSection}>
              <div className={styles.profileImageContainer}>
                <img
                  src={imagePreview || profileData.photoURL || "/default-avatar.png"}
                  className={styles.profileImage}
                />
                {isEditing && (
                  <div className={styles.imageUpload}>
                    <label htmlFor="photo-upload" className={styles.uploadButton}>
                      Change Photo
                    </label>
                    <input
                      id="photo-upload"
                      type="file"
                      accept="image/*"
                      onChange={handleImageChange}
                      className={styles.fileInput}
                    />
                  </div>
                )}
              </div>
            </div>

            <div className={styles.detailsSection}>
              <div className={styles.formGroup}>
                <label htmlFor="fullName">Full Name</label>
                <input
                  type="text"
                  id="fullName"
                  name="fullName"
                  value={profileData.fullName}
                  onChange={handleInputChange}
                  disabled={!isEditing}
                  className={styles.input}
                  required
                />
              </div>

              <div className={styles.formGroup}>
                <label htmlFor="username">Username</label>
                <input
                  type="text"
                  id="username"
                  name="username"
                  value={profileData.username}
                  onChange={handleInputChange}
                  disabled={!isEditing}
                  className={styles.input}
                  required
                />
              </div>

              <div className={styles.formGroup}>
                <label htmlFor="email">Email</label>
                <input
                  type="email"
                  id="email"
                  value={profileData.email}
                  className={styles.input}
                  disabled
                />
              </div>

              <div className={styles.formGroup}>
                <label htmlFor="bio">Bio</label>
                <textarea
                  id="bio"
                  name="bio"
                  value={profileData.bio}
                  onChange={handleInputChange}
                  disabled={!isEditing}
                  className={styles.textarea}
                  rows={4}
                />
              </div>
            </div>
          </div>

          {isEditing && (
            <div className={styles.formActions}>
              <button
                type="submit"
                className={styles.saveButton}
                disabled={isSaving}
              >
                {isSaving ? (
                  <>
                    <span className={styles.spinnerSmall}></span>
                    Saving...
                  </>
                ) : (
                  "Save Profile"
                )}
              </button>
            </div>
          )}

          {profileData.lastUpdated && (
            <div className={styles.lastUpdated}>
              Last updated: {profileData.lastUpdated.toLocaleString()}
            </div>
          )}
        </form>
      </div>
    </div>
    </>
  );
};

export default Profile;
