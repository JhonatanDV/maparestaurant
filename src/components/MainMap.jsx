import React from 'react';
import { MapContainer, TileLayer, Marker, Popup, useMap } from 'react-leaflet';
import { Icon } from 'leaflet';
import 'leaflet/dist/leaflet.css';
import RestaurantList from './RestaurantList';
import AddRestaurant from './AddRestaurant';
import { useRestaurants } from '../context/RestaurantContext';
import { useAuth } from '../context/AuthContext';
import { Button, AppBar, Toolbar, Typography } from '@mui/material';

const customIcon = new Icon({
  iconUrl: 'https://raw.githubusercontent.com/pointhi/leaflet-color-markers/master/img/marker-icon-2x-red.png',
  iconSize: [25, 41],
  iconAnchor: [12, 41]
});

function MainMap() {
  const { restaurants } = useRestaurants();
  const { currentUser, logout } = useAuth();

  const handleLogout = async () => {
    try {
      await logout();
    } catch (error) {
      console.error('Error logging out:', error);
    }
  };

  return (
    <div style={{ height: '100vh', display: 'flex', flexDirection: 'column' }}>
      <AppBar position="static">
        <Toolbar>
          <Typography variant="h6" style={{ flexGrow: 1 }}>
            Restaurant Map
          </Typography>
          <Typography variant="body1" style={{ marginRight: 20 }}>
            {currentUser?.email}
          </Typography>
          <Button color="inherit" onClick={handleLogout}>
            Logout
          </Button>
        </Toolbar>
      </AppBar>
      
      <div style={{ display: 'flex', flex: 1 }}>
        <div style={{ width: '300px', padding: '20px', borderRight: '1px solid #ccc', overflowY: 'auto' }}>
          <AddRestaurant />
          <RestaurantList />
        </div>
        
        <MapContainer
          center={[51.505, -0.09]}
          zoom={13}
          style={{ flex: 1, height: '100%' }}
        >
          <TileLayer
            url="https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png"
            attribution='&copy; <a href="https://www.openstreetmap.org/copyright">OpenStreetMap</a> contributors'
          />
          {restaurants.map(restaurant => (
            <Marker
              key={restaurant.id}
              position={[restaurant.latitude, restaurant.longitude]}
              icon={customIcon}
            >
              <Popup>
                <div>
                  <h3>{restaurant.name}</h3>
                  <p>{restaurant.description}</p>
                  <p>Rating: {restaurant.rating.toFixed(1)} ({restaurant.reviewCount} reviews)</p>
                </div>
              </Popup>
            </Marker>
          ))}
        </MapContainer>
      </div>
    </div>
  );
}

export default MainMap;