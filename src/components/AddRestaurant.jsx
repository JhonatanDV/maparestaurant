import React, { useState } from 'react';
import { TextField, Button, Box, Alert } from '@mui/material';
import { useRestaurants } from '../context/RestaurantContext';
import { useAuth } from '../context/AuthContext';

function AddRestaurant() {
  const { addRestaurant } = useRestaurants();
  const { currentUser } = useAuth();
  const [error, setError] = useState('');
  const [formData, setFormData] = useState({
    name: '',
    description: '',
    latitude: '',
    longitude: '',
  });

  const handleSubmit = async (e) => {
    e.preventDefault();
    try {
      await addRestaurant({
        ...formData,
        rating: 0,
        reviewCount: 0,
        ownerId: currentUser.uid,
        ownerEmail: currentUser.email,
        latitude: parseFloat(formData.latitude),
        longitude: parseFloat(formData.longitude),
        createdAt: new Date().toISOString(),
      });
      setFormData({ name: '', description: '', latitude: '', longitude: '' });
      setError('');
    } catch (err) {
      setError('Failed to add restaurant: ' + err.message);
    }
  };

  const handleChange = (e) => {
    setFormData({ ...formData, [e.target.name]: e.target.value });
  };

  return (
    <Box component="form" onSubmit={handleSubmit}>
      {error && <Alert severity="error" sx={{ mb: 2 }}>{error}</Alert>}
      <TextField
        fullWidth
        label="Restaurant Name"
        name="name"
        value={formData.name}
        onChange={handleChange}
        margin="normal"
        required
      />
      <TextField
        fullWidth
        label="Description"
        name="description"
        value={formData.description}
        onChange={handleChange}
        margin="normal"
        multiline
        rows={3}
        required
      />
      <TextField
        fullWidth
        label="Latitude"
        name="latitude"
        type="number"
        value={formData.latitude}
        onChange={handleChange}
        margin="normal"
        required
      />
      <TextField
        fullWidth
        label="Longitude"
        name="longitude"
        type="number"
        value={formData.longitude}
        onChange={handleChange}
        margin="normal"
        required
      />
      <Button
        type="submit"
        variant="contained"
        color="primary"
        fullWidth
        style={{ marginTop: '20px' }}
      >
        Add Restaurant
      </Button>
    </Box>
  );
}

export default AddRestaurant;