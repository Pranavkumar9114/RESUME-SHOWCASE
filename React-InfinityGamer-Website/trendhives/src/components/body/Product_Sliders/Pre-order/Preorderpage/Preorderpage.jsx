import React, { useState } from "react";
import { collection, addDoc } from "firebase/firestore";
import { db } from "../../../../../firebase";
import styles from "./PreorderPage.module.css";
import { useLocation } from "react-router-dom";

const PreorderPage = () => {
    const location = useLocation();
    const productName = location.state?.productName || "No product selected";

    const [name, setName] = useState("");
    const [email, setEmail] = useState("");
    const [product, setProduct] = useState(productName);
    const [quantity, setQuantity] = useState(1);
    const [loading, setLoading] = useState(false);
    const [success, setSuccess] = useState(false);

    const handleSubmit = async (e) => {
        e.preventDefault();
        setLoading(true);
        try {
            await addDoc(collection(db, "preordersform"), {
                name,
                email,
                product,
                quantity,
                timestamp: new Date(),
            });
            setSuccess(true);
            setName("");
            setEmail("");
            setQuantity(1);
        } catch (error) {
            console.error("Error adding document: ", error);
        }
        setLoading(false);
    };

    return (
        <div className={styles.container}>
            <h2 className={styles.title}>Preorder Form</h2>
            <form onSubmit={handleSubmit}>
                <div className={styles.formGroup}>
                    <label className={styles.label}>Name:</label>
                    <input
                        type="text"
                        value={name}
                        onChange={(e) => setName(e.target.value)}
                        required
                        className={styles.input}
                    />
                </div>
                <div className={styles.formGroup}>
                    <label className={styles.label}>Email:</label>
                    <input
                        type="email"
                        value={email}
                        onChange={(e) => setEmail(e.target.value)}
                        required
                        className={styles.input}
                    />
                </div>
                <div className={styles.formGroup}>
                    <label className={styles.label}>Product:</label>
                    <input
                        type="text"
                        value={product}
                        onChange={(e) => setProduct(e.target.value)}
                        readOnly 
                        required
                        className={styles.input}
                    />
                </div>
                <div className={styles.formGroup}>
                    <label className={styles.label}>Quantity:</label>
                    <input
                        type="number"
                        value={quantity}
                        onChange={(e) => setQuantity(e.target.value)}
                        min="1"
                        required
                        className={styles.input}
                    />
                </div>
                <button
                    type="submit"
                    disabled={loading}
                    className={styles.button}
                >
                    {loading ? "Submitting..." : "Submit Preorder"}
                </button>
            </form>
            {success && (
                <p className={styles.successMessage}>
                    Preorder submitted successfully!
                </p>
            )}
        </div>
    );
};

export default PreorderPage;
