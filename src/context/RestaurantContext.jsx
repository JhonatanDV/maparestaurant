import React, { createContext, useState, useContext, useEffect } from 'react';
import { db } from '../firebase';
import { collection, onSnapshot, addDoc, updateDoc, doc } from 'firebase/firestore';

const RestaurantContext = createContext();

export function useRestaurants() {
  return useContext(RestaurantContext);
}

export function RestaurantProvider({ children }) {
  const [restaurants, setRestaurants] = useState([]);

  useEffect(() => {
    const unsubscribe = onSnapshot(collection(db, 'restaurants'), (snapshot) => {
      setRestaurants(snapshot.docs.map(doc => ({ id: doc.id, ...doc.data() })));
    });

    return () => unsubscribe();
  }, []);

  const addRestaurant = async (restaurantData) => {
    await addDoc(collection(db, 'restaurants'), restaurantData);
  };

  const addReview = async (restaurantId, reviewData) => {
    const restaurantRef = doc(db, 'restaurants', restaurantId);
    const review = {
      ...reviewData,
      createdAt: new Date().toISOString(),
    };

    await addDoc(collection(db, 'reviews'), review);
    
    // Update restaurant rating
    const restaurant = restaurants.find(r => r.id === restaurantId);
    const newRating = (restaurant.rating * restaurant.reviewCount + review.rating) / (restaurant.reviewCount + 1);
    
    await updateDoc(restaurantRef, {
      rating: newRating,
      reviewCount: restaurant.reviewCount + 1,
    });
  };

  const value = {
    restaurants,
    addRestaurant,
    addReview,
  };

  return (
    <RestaurantContext.Provider value={value}>
      {children}
    </RestaurantContext.Provider>
  );
}