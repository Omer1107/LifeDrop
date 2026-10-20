import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lifedrop/widgets/lifedrop_appbar.dart';

class FeedScreen extends StatelessWidget {
  const FeedScreen({super.key});

  Color getUrgencyColor(String urgency) {
    switch (urgency) {
      case "Emergency":
        return Colors.red;
      case "Urgent":
        return Colors.orange;
      default:
        return Colors.green;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      extendBodyBehindAppBar: true,

      appBar: const LifeDropAppBar(
        title: "Blood Requests Feed",
      ),

      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.red, Colors.deepOrange],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),

        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('request')
              .orderBy('createdAt', descending: true)
              .snapshots(),

          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(color: Colors.white),
              );
            }

            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return const Center(
                child: Text(
                  "No blood requests found",
                  style: TextStyle(color: Colors.white),
                ),
              );
            }

            final requests = snapshot.data!.docs;

            return ListView.builder(
              itemCount: requests.length,
              itemBuilder: (context, index) {
                var data =
                    requests[index].data() as Map<String, dynamic>;

                String urgency = data['urgency'] ?? "Normal";

                return Card(
                  margin: const EdgeInsets.all(10),

                  color: Colors.white.withOpacity(0.95),

                  child: Padding(
                    padding: const EdgeInsets.all(10),

                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: getUrgencyColor(urgency),
                        child: const Icon(
                          Icons.bloodtype,
                          color: Colors.white,
                        ),
                      ),

                      title: Text(
                        "${data['bloodGroup']} Needed",
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Patient: ${data['name']}"),
                          Text("Hospital: ${data['hospital']}"),
                          Text("City: ${data['city']}"),
                          Text("Contact: ${data['contact']}"),
                        ],
                      ),

                      trailing: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: getUrgencyColor(urgency),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          urgency,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}