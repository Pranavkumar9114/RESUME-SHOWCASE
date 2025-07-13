import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FeedbackDialog extends StatefulWidget {
  const FeedbackDialog({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _FeedbackDialogState createState() => _FeedbackDialogState();
}

class _FeedbackDialogState extends State<FeedbackDialog> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  int _rating = 0;

  void _submitFeedback() async {
    if (_formKey.currentState!.validate()) {
      try {
     
        await FirebaseFirestore.instance.collection('feedback').add({
          'name': _nameController.text,
          'rating': _rating,
          'timestamp': DateTime.now(),
        });

  
        _nameController.clear();
        setState(() {
          _rating = 0;
        });


        showDialog(
          // ignore: use_build_context_synchronously
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Feedback Sent'),
              content: const Text('Your feedback has been sent successfully.'),
              actions: <Widget>[
                TextButton(
                  child: const Text('OK'),
                  onPressed: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      } catch (e) {

        showDialog(
          // ignore: use_build_context_synchronously
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Error'),
              content: const Text('Failed to send feedback. Please try again later.'),
              actions: <Widget>[
                TextButton(
                  child: const Text('OK'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      }
    }
  }

  Widget _buildStar(int index) {
    return IconButton(
      icon: Icon(
        index < _rating ? Icons.star : Icons.star_border,
        color: Colors.amber,
      ),
      onPressed: () {
        setState(() {
          _rating = index + 1;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Feedback',style: TextStyle(fontWeight: FontWeight.bold),),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Name',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.person),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your name';
                }
                return null;
              },
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(5, (index) => _buildStar(index)),
            ),
          ],
        ),
      ),
      actions: <Widget>[
        TextButton(
          onPressed: _submitFeedback,
          child: const Text('Submit'),
        ),
      ],
    );
  }
}

void showFeedbackDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return const FeedbackDialog();
    },
  );
}
