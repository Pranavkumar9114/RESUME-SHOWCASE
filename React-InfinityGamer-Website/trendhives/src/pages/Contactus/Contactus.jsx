import React, { useState } from "react";
import styles from "./ContactUs.module.css";
import { database } from "../../firebase"; 
import { ref, push } from "firebase/database";
import Navbar from "../../components/navbar/Navbar";

function ContactUs() {
  const [formData, setFormData] = useState({
    name: "",
    email: "",
    subject: "",
    message: "",
  });

  const handleChange = (e) => {
    setFormData((prev) => ({
      ...prev,
      [e.target.id]: e.target.value,
    }));
  };

  const handleSubmit = (e) => {
    e.preventDefault();


    const contactRef = ref(database, "contacts");
    push(contactRef, formData)
      .then(() => {
        alert("Message sent successfully!");
        setFormData({ name: "", email: "", subject: "", message: "" });
      })
      .catch((error) => {
        console.error("Error sending message:", error);
        alert("Error sending message. Please try again.");
      });
  };

  return (
    <>
    <div>
      <Navbar />
    </div>
    <div className={styles.container}>
      <div className={styles.formWrapper}>
        <h1 className={styles.title}>
          CONTACT <span className={styles.highlight}>US</span>
        </h1>
        <p className={styles.subtitle}>We'd love to hear from you. Drop us a message and we'll get back to you soon.</p>

        <form className={styles.form} onSubmit={handleSubmit}>
          <div className={styles.inputGroup}>
            <label htmlFor="name" className={styles.label}>NAME</label>
            <input
              type="text"
              id="name"
              className={styles.input}
              placeholder="Enter your name"
              value={formData.name}
              onChange={handleChange}
              required
            />
          </div>

          <div className={styles.inputGroup}>
            <label htmlFor="email" className={styles.label}>EMAIL</label>
            <input
              type="email"
              id="email"
              className={styles.input}
              placeholder="Enter your email"
              value={formData.email}
              onChange={handleChange}
              required
            />
          </div>

          <div className={styles.inputGroup}>
            <label htmlFor="subject" className={styles.label}>SUBJECT</label>
            <input
              type="text"
              id="subject"
              className={styles.input}
              placeholder="What's this about?"
              value={formData.subject}
              onChange={handleChange}
              required
            />
          </div>

          <div className={styles.inputGroup}>
            <label htmlFor="message" className={styles.label}>MESSAGE</label>
            <textarea
              id="message"
              className={styles.textarea}
              placeholder="Tell us what's on your mind..."
              rows="5"
              value={formData.message}
              onChange={handleChange}
              required
            ></textarea>
          </div>

          <button type="submit" className={styles.button}>
            <span className={styles.buttonText}>SEND MESSAGE</span>
          </button>
        </form>
      </div>
    </div>
    </>
  );
}

export default ContactUs;
