import React, { useState } from 'react';
import styles from './login.module.css';
import {getAuth,signInWithEmailAndPassword,signInWithPopup,GoogleAuthProvider} from 'firebase/auth';
import { useNavigate, Link } from 'react-router-dom';
import { FaGoogle } from 'react-icons/fa';

export default function Login() {
  const navigate = useNavigate();

  const [formData, setFormData] = useState({
    email: '',
    password: '',
  });

  const showDialogBox = (message) => {
    window.alert(message);
  };

  const handleInputChange = (e) => {
    const { id, value } = e.target;
    setFormData({
      ...formData,
      [id]: value,
    });
  };

  const validateInputs = () => {
    const { email, password } = formData;

    if (!/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(email)) {
      showDialogBox('Please enter a valid email address');
      return false;
    }

    if (password.trim() === '') {
      showDialogBox('Please enter your password');
      return false;
    }

    return true;
  };

  const handleSubmit = async (e) => {
    e.preventDefault();

    const isValid = validateInputs();
    if (!isValid) return;

    try {
      const auth = getAuth();
      await signInWithEmailAndPassword(auth, formData.email, formData.password);
      showDialogBox('Login successful!');
      navigate('/', { replace: true });
    } catch (error) {
      showDialogBox('Login failed. Please check your credentials and try again.');
    }
  };

  const handleGoogleSignIn = async () => {
    const auth = getAuth();
    const provider = new GoogleAuthProvider();

    provider.setCustomParameters({
      prompt: 'select_account',
    });

    try {
      await signInWithPopup(auth, provider);
      showDialogBox('Google Sign-In successful!');
      navigate('/', { replace: true });
    } catch (error) {
      showDialogBox('Google Sign-In failed. Please try again.');
    }
  };

  return (
    <div className={styles.pageWrapper}>
    <div className={styles['login-container']}>
      <div className={styles['login-form-container']}>
        <h2>Login</h2>
        <form onSubmit={handleSubmit}>
          <div className={styles['input-group']}>
            <label htmlFor="email">Email</label>
            <div className={styles['input-icon-container']}>
              <input
                type="email"
                id="email"
                value={formData.email}
                onChange={handleInputChange}
                placeholder="Enter your email"
                required
              />
            </div>
          </div>

          <div className={styles['input-group']}>
            <label htmlFor="password">Password</label>
            <div className={styles['input-icon-container']}>
              <input
                type="password"
                id="password"
                value={formData.password}
                onChange={handleInputChange}
                placeholder="Enter your password"
                required
              />
            </div>
          </div>

          <button className={styles['login-btn']} type="submit">
            Login
          </button>
        </form>

        <div className={styles['google-signin-container']}>
          <button className={styles['google-signin-btn']} onClick={handleGoogleSignIn}>
            <FaGoogle className={styles['google-icon']} />
            Sign in with Google
          </button>
        </div>

        <div className={styles['signup-link']}>
          <p>
            Don't have an account? <Link to="/signup" replace>Sign up</Link>
          </p>
        </div>
      </div>
    </div>
    </div>
  );
}






















// import React, { useState } from 'react';
// import './login.module.css';
// import { getAuth, signInWithEmailAndPassword, signInWithPopup, GoogleAuthProvider } from 'firebase/auth';
// import { useNavigate,Link } from 'react-router-dom';
// import { FaGoogle } from 'react-icons/fa';

// export default function Login() {
//   const navigate = useNavigate();

//   const [formData, setFormData] = useState({
//     email: '',
//     password: '',
//   });

//   // Function to show error/warning in a dialog box
//   const showDialogBox = (message) => {
//     window.alert(message);
//   };

//   const handleInputChange = (e) => {
//     const { id, value } = e.target;
//     setFormData({
//       ...formData,
//       [id]: value,
//     });
//   };

//   const validateInputs = () => {
//     const { email, password } = formData;

//     // Email validation
//     if (!/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(email)) {
//       showDialogBox('Please enter a valid email address');
//       return false;
//     }

//     // Password should not be empty
//     if (password.trim() === '') {
//       showDialogBox('Please enter your password');
//       return false;
//     }

//     return true;
//   };

//   const handleSubmit = async (e) => {
//     e.preventDefault();

//     const isValid = validateInputs();
//     if (!isValid) return;

//     try {
//       const auth = getAuth();
//       await signInWithEmailAndPassword(auth, formData.email, formData.password);
//       showDialogBox('Login successful!');
//       navigate('/', { replace: true });
//     } catch (error) {
//       showDialogBox('Login failed. Please check your credentials and try again.');
//     }
//   };

//   const handleGoogleSignIn = async () => {
//     const auth = getAuth();
//     const provider = new GoogleAuthProvider();

//     // Force account selection every time
//     provider.setCustomParameters({
//       prompt: 'select_account'
//     });

//     try {
//       await signInWithPopup(auth, provider);
//       showDialogBox('Google Sign-In successful!');
//       navigate('/', { replace: true });
//     } catch (error) {
//       showDialogBox('Google Sign-In failed. Please try again.');
//     }
//   };


//   return (
//     <div className="login-container">
//       <div className="login-form-container">
//         <h2>Login</h2>
//         <form onSubmit={handleSubmit}>
//           <div className="input-group">
//             <label htmlFor="email">Email</label>
//             <div className="input-icon-container">
//               <input
//                 type="email"
//                 id="email"
//                 value={formData.email}
//                 onChange={handleInputChange}
//                 placeholder="Enter your email"
//                 required
//               />
//             </div>
//           </div>

//           <div className="input-group">
//             <label htmlFor="password">Password</label>
//             <div className="input-icon-container">
//               <input
//                 type="password"
//                 id="password"
//                 value={formData.password}
//                 onChange={handleInputChange}
//                 placeholder="Enter your password"
//                 required
//               />
//             </div>
//           </div>

//           <button className="login-btn" type="submit">
//             Login
//           </button>
//         </form>

//         <div className="google-signin-container">
//           <button className="google-signin-btn" onClick={handleGoogleSignIn}>
//             <FaGoogle className="google-icon" />
//             Sign in with Google
//           </button>
//         </div>

//         <div className="signup-link">
//           <p>
//             Don't have an account? <Link to="/signup" replace>Sign up</Link>
//           </p>
//         </div>
//       </div>
//     </div>
//   );
// }
