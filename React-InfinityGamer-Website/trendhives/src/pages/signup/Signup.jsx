import React, { useState } from 'react';
import styles from './signup.module.css';
import { FaUser, FaEnvelope, FaLock, FaGoogle } from 'react-icons/fa';
import {
  getAuth,
  createUserWithEmailAndPassword,
  updateProfile,
  fetchSignInMethodsForEmail,
  GoogleAuthProvider,
  signInWithPopup,
} from 'firebase/auth';
import { db } from '../../firebase';
import { doc, setDoc } from 'firebase/firestore';
import { useNavigate, Link } from 'react-router-dom';

export default function Signup() {
  const navigate = useNavigate();

  const [formData, setFormData] = useState({
    username: '',
    email: '',
    password: '',
    confirmPassword: '',
  });

  const [error, setError] = useState('');
  const [success, setSuccess] = useState('');

  const handleInputChange = (e) => {
    const { name, value } = e.target;
    setFormData({
      ...formData,
      [name]: value,
    });
  };

  const showDialogBox = (message) => {
    window.alert(message);
  };

  const validateInputs = async () => {
    const { username, email, password, confirmPassword } = formData;

    if (!/^[a-zA-Z0-9]{3,}$/.test(username)) {
      showDialogBox('Username should be at least 3 characters and contain no special characters');
      return false;
    }

    if (!/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(email)) {
      showDialogBox('Please enter a valid email address');
      return false;
    }

    try {
      const auth = getAuth();
      const signInMethods = await fetchSignInMethodsForEmail(auth, email);
      if (signInMethods.length > 0) {
        showDialogBox('This email is already registered. Please use a different email or log in.');
        return false;
      }
    } catch (err) {
      showDialogBox('Error checking email. Please try again.');
      return false;
    }

    if (!/^(?=.*[A-Z])(?=.*[0-9])(?=.*[!@#$%^&*])[A-Za-z\d!@#$%^&*]{6,}$/.test(password)) {
      showDialogBox(
        'Password should be at least 6 characters and include one uppercase letter, one number, and one special character'
      );
      return false;
    }

    if (password !== confirmPassword) {
      showDialogBox('Passwords do not match');
      return false;
    }

    return true;
  };

  const handleSubmit = async (e) => {
    e.preventDefault();
    setError('');
    setSuccess('');

    const isValid = await validateInputs();
    if (!isValid) return;

    try {
      const auth = getAuth();
      const userCredential = await createUserWithEmailAndPassword(
        auth,
        formData.email,
        formData.password
      );

      await updateProfile(userCredential.user, {
        displayName: formData.username,
      });

      await setDoc(doc(db, 'users', userCredential.user.uid), {
        username: formData.username,
        email: formData.email,
      });

      setSuccess('Account created successfully!');
      showDialogBox('Account created successfully!');
      navigate('/', { replace: true });
    } catch (error) {
      showDialogBox(error.message);
    }
  };

  const handleGoogleSignIn = async () => {
    const auth = getAuth();
    const provider = new GoogleAuthProvider();
    provider.setCustomParameters({
      prompt: 'select_account',
    });

    try {
      const result = await signInWithPopup(auth, provider);
      const user = result.user;

      const userRef = doc(db, 'users', user.uid);
      await setDoc(
        userRef,
        {
          username: user.displayName,
          email: user.email,
        },
        { merge: true }
      );

      navigate('/', { replace: true });
    } catch (error) {
      showDialogBox('Google Sign-In failed. Please try again.');
    }
  };

  return (
    <div className={styles.pageWrapper}>
    <div className={styles["signup-container"]}>
      <div className={styles["signup-form-container"]}>
        <h2>SIGN UP NOW!</h2>
        <form onSubmit={handleSubmit}>
          <div className={styles["input-group"]}>
            <label htmlFor="username">Username</label>
            <div className={styles["input-icon-container"]}>
              <FaUser className={styles["input-icon"]} />
              <input
                type="text"
                id="username"
                name="username"
                value={formData.username}
                onChange={handleInputChange}
                required
                placeholder="Enter your username"
              />
            </div>
          </div>

          <div className={styles["input-group"]}>
            <label htmlFor="email">Email</label>
            <div className={styles["input-icon-container"]}>
              <FaEnvelope className={styles["input-icon"]} />
              <input
                type="email"
                id="email"
                name="email"
                value={formData.email}
                onChange={handleInputChange}
                required
                placeholder="Enter your email"
              />
            </div>
          </div>

          <div className={styles["input-group"]}>
            <label htmlFor="password">Password</label>
            <div className={styles["input-icon-container"]}>
              <FaLock className={styles["input-icon"]} />
              <input
                type="password"
                id="password"
                name="password"
                value={formData.password}
                onChange={handleInputChange}
                required
                placeholder="Enter your password"
              />
            </div>
          </div>

          <div className={styles["input-group"]}>
            <label htmlFor="confirmPassword">Confirm Password</label>
            <div className={styles["input-icon-container"]}>
              <FaLock className={styles["input-icon"]} />
              <input
                type="password"
                id="confirmPassword"
                name="confirmPassword"
                value={formData.confirmPassword}
                onChange={handleInputChange}
                required
                placeholder="Confirm your password"
              />
            </div>
          </div>

          <button type="submit" className={styles["signup-btn"]}>
            Sign Up
          </button>
        </form>

        <div className={styles["google-signin-container"]}>
          <button onClick={handleGoogleSignIn} className={styles["google-signin-btn"]}>
            <FaGoogle className={styles["google-icon"]} /> Sign In with Google
          </button>
        </div>

        <p className={styles["login-link"]}>
          Already have an account? <Link to="/Login" replace>Login here</Link>
        </p>
      </div>
    </div>
    </div>
  );
}
























// import React, { useState } from 'react';
// import './signup.module.css';
// import { FaUser, FaEnvelope, FaLock, FaGoogle } from 'react-icons/fa';
// import {
//   getAuth,
//   createUserWithEmailAndPassword,
//   updateProfile,
//   fetchSignInMethodsForEmail,
//   GoogleAuthProvider,
//   signInWithPopup,
// } from 'firebase/auth';
// import { db } from '../../firebase';
// import { doc, setDoc } from 'firebase/firestore';
// import { useNavigate,Link } from 'react-router-dom';

// export default function Signup() {
//   const navigate = useNavigate();

//   const [formData, setFormData] = useState({
//     username: '',
//     email: '',
//     password: '',
//     confirmPassword: '',
//   });

//   const [error, setError] = useState('');
//   const [success, setSuccess] = useState('');

//   const handleInputChange = (e) => {
//     const { name, value } = e.target;
//     setFormData({
//       ...formData,
//       [name]: value,
//     });
//   };

//   // Function to show error/warning in a dialog box
//   const showDialogBox = (message) => {
//     window.alert(message);
//   };

//   const validateInputs = async () => {
//     const { username, email, password, confirmPassword } = formData;

//     if (!/^[a-zA-Z0-9]{3,}$/.test(username)) {
//       showDialogBox('Username should be at least 3 characters and contain no special characters');
//       return false;
//     }

//     if (!/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(email)) {
//       showDialogBox('Please enter a valid email address');
//       return false;
//     }

//     try {
//       const auth = getAuth();
//       const signInMethods = await fetchSignInMethodsForEmail(auth, email);
//       if (signInMethods.length > 0) {
//         showDialogBox('This email is already registered. Please use a different email or log in.');
//         return false;
//       }
//     } catch (err) {
//       showDialogBox('Error checking email. Please try again.');
//       return false;
//     }

//     if (!/^(?=.*[A-Z])(?=.*[0-9])(?=.*[!@#$%^&*])[A-Za-z\d!@#$%^&*]{6,}$/.test(password)) {
//       showDialogBox(
//         'Password should be at least 6 characters and include one uppercase letter, one number, and one special character'
//       );
//       return false;
//     }

//     if (password !== confirmPassword) {
//       showDialogBox('Passwords do not match');
//       return false;
//     }

//     return true;
//   };

//   const handleSubmit = async (e) => {
//     e.preventDefault();
//     setError('');
//     setSuccess('');

//     const isValid = await validateInputs();
//     if (!isValid) return;

//     try {
//       const auth = getAuth();
//       const userCredential = await createUserWithEmailAndPassword(
//         auth,
//         formData.email,
//         formData.password
//       );

//       await updateProfile(userCredential.user, {
//         displayName: formData.username,
//       });

//       await setDoc(doc(db, 'users', userCredential.user.uid), {
//         username: formData.username,
//         email: formData.email,
//       });

//       setSuccess('Account created successfully!');
//       showDialogBox('Account created successfully!');

//       navigate('/', { replace: true });
//     } catch (error) {
//       showDialogBox(error.message);
//     }
//   };

//   const handleGoogleSignIn = async () => {
//     const auth = getAuth();
//     const provider = new GoogleAuthProvider();
//     provider.setCustomParameters({
//       prompt: 'select_account', // Always prompt for account selection
//     });
  
//     try {
//       const result = await signInWithPopup(auth, provider);
//       const user = result.user;
  
//       const userRef = doc(db, 'users', user.uid);
//       await setDoc(
//         userRef,
//         {
//           username: user.displayName,
//           email: user.email,
//         },
//         { merge: true }
//       );
  
//       navigate('/', { replace: true });
//     } catch (error) {
//       showDialogBox('Google Sign-In failed. Please try again.');
//     }
//   };
  

//   return (
//     <div className="signup-container">
//       <div className="signup-form-container">
//         <h2>SIGN UP NOW!</h2>
//         <form onSubmit={handleSubmit}>
//           <div className="input-group">
//             <label htmlFor="username">Username</label>
//             <div className="input-icon-container">
//               <FaUser className="input-icon" />
//               <input
//                 type="text"
//                 id="username"
//                 name="username"
//                 value={formData.username}
//                 onChange={handleInputChange}
//                 required
//                 placeholder="Enter your username"
//               />
//             </div>
//           </div>

//           <div className="input-group">
//             <label htmlFor="email">Email</label>
//             <div className="input-icon-container">
//               <FaEnvelope className="input-icon" />
//               <input
//                 type="email"
//                 id="email"
//                 name="email"
//                 value={formData.email}
//                 onChange={handleInputChange}
//                 required
//                 placeholder="Enter your email"
//               />
//             </div>
//           </div>

//           <div className="input-group">
//             <label htmlFor="password">Password</label>
//             <div className="input-icon-container">
//               <FaLock className="input-icon" />
//               <input
//                 type="password"
//                 id="password"
//                 name="password"
//                 value={formData.password}
//                 onChange={handleInputChange}
//                 required
//                 placeholder="Enter your password"
//               />
//             </div>
//           </div>

//           <div className="input-group">
//             <label htmlFor="confirmPassword">Confirm Password</label>
//             <div className="input-icon-container">
//               <FaLock className="input-icon" />
//               <input
//                 type="password"
//                 id="confirmPassword"
//                 name="confirmPassword"
//                 value={formData.confirmPassword}
//                 onChange={handleInputChange}
//                 required
//                 placeholder="Confirm your password"
//               />
//             </div>
//           </div>

//           <button type="submit" className="signup-btn">
//             Sign Up
//           </button>
//         </form>

//         <div className="google-signin-container">
//           <button onClick={handleGoogleSignIn} className="google-signin-btn">
//             <FaGoogle className="google-icon" /> Sign In with Google
//           </button>
//         </div>

//         <p className="login-link">
//           Already have an account? <Link to="/Login" replace>Login here</Link>
//         </p>
//       </div>
//     </div>
//   );
// }
