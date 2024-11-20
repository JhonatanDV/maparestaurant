import React, { useState } from 'react';
import { Card, CardContent, Typography, Rating, Button, Dialog } from '@mui/material';
import AddReview from './AddReview';

function RestaurantCard({ restaurant }) {
  const [open, setOpen] = useState(false);

  return (
    <>
      <Card style={{ marginBottom: '10px' }}>
        <CardContent>
          <Typography variant="h6">{restaurant.name}</Typography>
          <Typography variant="body2" color="textSecondary">
            {restaurant.description}
          </Typography>
          <Rating value={restaurant.rating} readOnly precision={0.5} />
          <Typography variant="body2">
            ({restaurant.reviewCount} reviews)
          </Typography>
          <Button
            variant="contained"
            color="primary"
            size="small"
            onClick={() => setOpen(true)}
            style={{ marginTop: '10px' }}
          >
            Add Review
          </Button>
        </CardContent>
      </Card>

      <Dialog open={open} onClose={() => setOpen(false)}>
        <AddReview restaurantId={restaurant.id} onClose={() => setOpen(false)} />
      </Dialog>
    </>
  );
}

export default RestaurantCard;