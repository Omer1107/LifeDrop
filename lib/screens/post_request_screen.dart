import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lifedrop/widgets/lifedrop_appbar.dart';

class PostRequestScreen extends StatefulWidget {
  const PostRequestScreen({super.key});

  @override
  State<PostRequestScreen> createState() => _PostRequestScreenState();
}

class _PostRequestScreenState extends State<PostRequestScreen> {
  final nameController = TextEditingController();
  final bloodController = TextEditingController();
  final hospitalController = TextEditingController();
  final cityController = TextEditingController();
  final contactController = TextEditingController();

  String urgency = "Normal";
  bool isLoading = false;

  Future<void> postRequest() async {
    if (nameController.text.isEmpty ||
        bloodController.text.isEmpty ||
        hospitalController.text.isEmpty ||
        cityController.text.isEmpty ||
        contactController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill all fields")),
      );
      return;
    }

    setState(() => isLoading = true);

    try {
      await FirebaseFirestore.instance.collection('request').add({
        'name': nameController.text.trim(),
        'bloodGroup': bloodController.text.trim(),
        'hospital': hospitalController.text.trim(),
        'city': cityController.text.trim(),
        'contact': contactController.text.trim(),
        'urgency': urgency,
        'userId': FirebaseAuth.instance.currentUser?.uid,
        'createdAt': FieldValue.serverTimestamp(),
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Blood Request Posted Successfully ❤️"),
        ),
      );

      nameController.clear();
      bloodController.clear();
      hospitalController.clear();
      cityController.clear();
      contactController.clear();

      setState(() => urgency = "Normal");
    } finally {
      setState(() => isLoading = false);
    }
  }

  Widget _buildField(
    TextEditingController controller,
    String label, [
    TextInputType type = TextInputType.text,
  ]) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: TextField(
        controller: controller,
        keyboardType: type,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.white),
          ),
          filled: true,
          fillColor: Colors.white,
        ),
      ),
    );
  }

  @override
  void dispose() {
    nameController.dispose();
    bloodController.dispose();
    hospitalController.dispose();
    cityController.dispose();
    contactController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.red,
      extendBodyBehindAppBar: true,

      appBar: const LifeDropAppBar(
        title: "Post Blood Request",
      ),

      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.red, Colors.deepOrange],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),

        child: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: constraints.maxHeight,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [

                        const SizedBox(height: 20),

                        // 🔴 HEADER
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(18),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: Colors.white.withOpacity(0.25),
                            ),
                          ),
                          child: const Text(
                            "Post Blood Request\nFind donors in your city",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              height: 1.4,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),

                        const SizedBox(height: 20),

                        // 🧾 FORM CONTAINER
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Colors.red, Colors.deepOrange],
                            ),
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.15),
                                blurRadius: 10,
                                offset: const Offset(0, 5),
                              ),
                            ],
                          ),
                          child: Column(
                            children: [

                              _buildField(
                                nameController,
                                "Patient Name",
                              ),
                              const SizedBox(height: 12),

                              _buildField(
                                bloodController,
                                "Blood Group Needed",
                              ),
                              const SizedBox(height: 12),

                              _buildField(
                                hospitalController,
                                "Hospital Name",
                              ),
                              const SizedBox(height: 12),

                              _buildField(
                                cityController,
                                "City",
                              ),
                              const SizedBox(height: 12),

                              _buildField(
                                contactController,
                                "Contact Number",
                                TextInputType.phone,
                              ),

                              const SizedBox(height: 16),

                              // ⚡ URGENCY DROPDOWN
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: DropdownButtonHideUnderline(
                                  child: DropdownButton<String>(
                                    value: urgency,
                                    isExpanded: true,
                                    items: const [
                                      DropdownMenuItem(
                                        value: "Normal",
                                        child: Text("Normal"),
                                      ),
                                      DropdownMenuItem(
                                        value: "Urgent",
                                        child: Text("Urgent"),
                                      ),
                                      DropdownMenuItem(
                                        value: "Emergency",
                                        child: Text("Emergency"),
                                      ),
                                    ],
                                    onChanged: (value) {
                                      setState(
                                        () => urgency = value!,
                                      );
                                    },
                                  ),
                                ),
                              ),

                              const SizedBox(height: 20),

                              // 🔘 BUTTON
                              SizedBox(
                                width: double.infinity,
                                height: 52,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor:
                                        Colors.white.withOpacity(0.9),
                                    foregroundColor: Colors.red,
                                    elevation: 0,
                                    shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(12),
                                    ),
                                  ),
                                  onPressed:
                                      isLoading ? null : postRequest,
                                  child: isLoading
                                      ? const SizedBox(
                                          height: 20,
                                          width: 20,
                                          child:
                                              CircularProgressIndicator(
                                            color: Colors.red,
                                            strokeWidth: 2,
                                          ),
                                        )
                                      : const Text(
                                          "POST REQUEST",
                                          style: TextStyle(
                                            fontWeight:
                                                FontWeight.bold,
                                            letterSpacing: 1,
                                          ),
                                        ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 30),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}