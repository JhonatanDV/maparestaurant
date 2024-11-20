import React, { useState } from 'react';
import { 
  DialogTitle,
  DialogContent,
  DialogActions,
  Button,
  TextField,
  Rating,
  Box,
  Typography,
  Alert
} from '@mui/material';
import { useRestaurants } from '../context/RestaurantContext';
import { useAuth } from '../context/AuthContext';

function AddReview({ restaurantId, onClose }) {
  const { addReview } = useRestaurants();
  const { currentUser } = useAuth();
  const [rating, setRating] = useState(5);
  const [comment, setComment] = useState('');
  const [error, setError] = useState('');

  const handleSubmit = async () => {
    try {
      await addReview(restaurantId, {
        rating,
        comment,
        userId: currentUser.uid,
        userName: currentUser.email,
      });
      onClose();
    } catch (err) {
      setError('Failed to add review: ' + err.message);
    }
  };

  return (
    <>
      <DialogTitle>Add Review</DialogTitle>
      <DialogContent>
        {error && <Alert severity="error" sx={{ mb: 2 }}>{error}</Alert>}
        <Box sx={{ my: 2 }}>
          <Typography component="legend">Rating</Typography>
          <Rating
            value={rating}
            onChange={(_, newValue) => setRating(newValue)}
            precision={0.5}
          />
        </Box>
        <TextField
          fullWidth
          label="Comment"
          multiline
          rows={4}
          value={comment}
          onChange={(e) => setComment(e.target.value)}
          required
        />
      </DialogContent>
      <DialogActions>
        <Button onClick={onClose}>Cancel</Button>
        <Button 
          onClick={handleSubmit} 
          variant="contained" 
          color="primary"
          disabled={!comment.trim()}
        >
          Submit Review
        </Button>
      </DialogActions>
    </>
  );
}

export default AddReview;