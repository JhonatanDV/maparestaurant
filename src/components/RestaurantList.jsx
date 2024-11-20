import React from 'react';
import { useRestaurants } from '../context/RestaurantContext';
import RestaurantCard from './RestaurantCard';

function RestaurantList() {
  const { restaurants } = useRestaurants();

  return (
    <div style={{ marginTop: '20px' }}>
      <h2>Restaurants</h2>
      {restaurants.map(restaurant => (
        <RestaurantCard key={restaurant.id} restaurant={restaurant} />
      ))}
    </div>
  );
}

export default RestaurantList;