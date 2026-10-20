import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class DonateButton extends StatelessWidget {
  final Map<String, dynamic> requestData;

  const DonateButton({
    super.key,
    required this.requestData,
  });

  Future<void> donate(BuildContext context) async {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) return;

    await FirebaseFirestore.instance.collection('donation').add({
      "requestId": requestData['requestId'] ?? "",
      "bloodGroup": requestData['bloodGroup'] ?? "",
      "city": requestData['city'] ?? "",
      "hospital": requestData['hospital'] ?? "",
      "donorId": user.uid,
      "timestamp": FieldValue.serverTimestamp(),
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Donation request sent ❤️"),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      icon: const Icon(Icons.volunteer_activism),
      label: const Text("I Want to Donate"),
      onPressed: () => donate(context),
    );
  }
}