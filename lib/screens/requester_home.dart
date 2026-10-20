import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lifedrop/widgets/lifedrop_appbar.dart';
import 'package:lifedrop/screens/post_request_screen.dart';

class RequesterHome extends StatefulWidget {
  const RequesterHome({super.key});

  @override
  State<RequesterHome> createState() => _RequesterHomeState();
}

class _RequesterHomeState extends State<RequesterHome> {
  String city = '';
  String bloodGroup = '';

  @override
  Widget build(BuildContext context) {
    Query query = FirebaseFirestore.instance.collection('users');

    if (city.isNotEmpty) {
      query = query.where('city', isEqualTo: city);
    }

    if (bloodGroup.isNotEmpty) {
      query = query.where('bloodGroup', isEqualTo: bloodGroup);
    }

    return Scaffold(
      backgroundColor: Colors.transparent,
      extendBodyBehindAppBar: true,

      appBar: const LifeDropAppBar(title: "Find Donors"),

      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.red,
        child: const Icon(Icons.bloodtype),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const PostRequestScreen(),
            ),
          );
        },
      ),

      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.red, Colors.deepOrange],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),

        child: Column(
          children: [

            // 🔴 HEADER (kept same)
            Container(
              width: double.infinity,
              margin: const EdgeInsets.fromLTRB(12, 90, 12, 12),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.15),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: Colors.white.withOpacity(0.25),
                ),
              ),
              child: const Text(
                "Find Blood Donors ❤️\nSave lives in your city",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  height: 1.4,
                ),
              ),
            ),

            // 🔍 FILTER (NOW BLENDED WITH BACKGROUND)
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 12),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.12),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: Colors.white.withOpacity(0.25),
                ),
              ),
              child: Column(
                children: [

                  // 🏙 CITY FIELD
                  TextField(
                    onChanged: (val) =>
                        setState(() => city = val.trim()),
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: "City",
                      hintStyle: const TextStyle(color: Colors.white70),
                      filled: true,
                      fillColor: Colors.white.withOpacity(0.08),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 10,
                      ),
                    ),
                  ),

                  const SizedBox(height: 10),

                  // 🩸 BLOOD GROUP DROPDOWN
                  DropdownButtonFormField<String>(
                    value: bloodGroup.isEmpty ? null : bloodGroup,
                    dropdownColor: Colors.red.shade300,
                    decoration: InputDecoration(
                      labelText: "Blood Group",
                      labelStyle: const TextStyle(color: Colors.white),
                      filled: true,
                      fillColor: Colors.white.withOpacity(0.08),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    style: const TextStyle(color: Colors.white),
                    items: const [
                      DropdownMenuItem(value: "A+", child: Text("A+")),
                      DropdownMenuItem(value: "A-", child: Text("A-")),
                      DropdownMenuItem(value: "B+", child: Text("B+")),
                      DropdownMenuItem(value: "B-", child: Text("B-")),
                      DropdownMenuItem(value: "AB+", child: Text("AB+")),
                      DropdownMenuItem(value: "AB-", child: Text("AB-")),
                      DropdownMenuItem(value: "O+", child: Text("O+")),
                      DropdownMenuItem(value: "O-", child: Text("O-")),
                    ],
                    onChanged: (value) {
                      setState(() {
                        bloodGroup = value ?? '';
                      });
                    },
                  ),
                ],
              ),
            ),

            const SizedBox(height: 10),

            // 👥 DONOR LIST
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: query.snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState ==
                      ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(color: Colors.white),
                    );
                  }

                  if (!snapshot.hasData ||
                      snapshot.data!.docs.isEmpty) {
                    return const Center(
                      child: Text(
                        "No donors found",
                        style: TextStyle(color: Colors.white),
                      ),
                    );
                  }

                  final users = snapshot.data!.docs;

                  return ListView.builder(
                    itemCount: users.length,
                    itemBuilder: (context, index) {
                      final data =
                          users[index].data() as Map<String, dynamic>;

                      return Card(
                        margin: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        elevation: 3,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Row(
                            children: [

                              Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: Colors.red.shade100,
                                  shape: BoxShape.circle,
                                ),
                                child: Text(
                                  data['bloodGroup'] ?? 'O+',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.red,
                                  ),
                                ),
                              ),

                              const SizedBox(width: 12),

                              Expanded(
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  children: [

                                    Text(
                                      data['name'] ?? 'Unknown',
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),

                                    const SizedBox(height: 4),

                                    Text(
                                      "📍 ${data['city'] ?? 'N/A'}",
                                      style: TextStyle(
                                        color: Colors.black
                                      ),
                                    ),

                                    const SizedBox(height: 6),

                                    Text(
                                      "📞 ${data['contact'] ?? 'N/A'}",
                                      style: TextStyle(
                                        color: Colors.black
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}