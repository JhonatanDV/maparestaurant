import 'package:flutter/material.dart';
import '../services/restaurant_service.dart';
import '../models/review.dart';

class AddReviewDialog extends StatefulWidget {
  final String restaurantId;

  const AddReviewDialog({
    super.key,
    required this.restaurantId,
  });

  @override
  State<AddReviewDialog> createState() => _AddReviewDialogState();
}

class _AddReviewDialogState extends State<AddReviewDialog> {
  final _formKey = GlobalKey<FormState>();
  final RestaurantService _restaurantService = RestaurantService();
  
  double _rating = 5;
  String _comment = '';

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add Review'),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                5,
                (index) => IconButton(
                  icon: Icon(
                    Icons.star,
                    color: index < _rating ? Colors.amber : Colors.grey,
                  ),
                  onPressed: () => setState(() => _rating = index + 1.0),
                ),
              ),
            ),
            TextFormField(
              decoration: const InputDecoration(labelText: 'Comment'),
              maxLines: 3,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a comment';
                }
                return null;
              },
              onSaved: (value) => _comment = value!,
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _submitReview,
          child: const Text('Submit'),
        ),
      ],
    );
  }

  void _submitReview() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      
      final review = Review(
        id: '',
        restaurantId: widget.restaurantId,
        userId: 'current_user_id', // Get from auth service
        userName: 'User Name', // Get from auth service
        comment: _comment,
        rating: _rating,
        createdAt: DateTime.now(),
      );

      _restaurantService.addReview(review).then((_) {
        Navigator.pop(context);
      }).catchError((error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $error')),
        );
      });
    }
  }
}