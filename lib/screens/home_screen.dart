import 'package:flutter/material.dart';
import 'feed_screen.dart';
import 'post_request_screen.dart';
import 'requester_home.dart';
import 'login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  late final Animation<double> _headerFade;
  late final Animation<Offset> _headerSlide;

  late final List<Animation<double>> _cardFade;
  late final List<Animation<Offset>> _cardSlide;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 550),
      vsync: this,
    );

    _headerFade = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.0, 0.35, curve: Curves.easeOut),
    );

    _headerSlide = Tween<Offset>(
      begin: const Offset(0, 0.2),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.35, curve: Curves.easeOut),
      ),
    );

    _cardFade = List.generate(3, (index) {
      final start = 0.3 + index * 0.12;
      return CurvedAnimation(
        parent: _controller,
        curve: Interval(start, start + 0.35, curve: Curves.easeOut),
      );
    });

    _cardSlide = List.generate(3, (index) {
      final start = 0.3 + index * 0.12;
      return Tween<Offset>(
        begin: const Offset(0, 0.2),
        end: Offset.zero,
      ).animate(
        CurvedAnimation(
          parent: _controller,
          curve: Interval(start, start + 0.35, curve: Curves.easeOut),
        ),
      );
    });

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void logout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const LoginScreen()),
      (route) => false,
    );
  }

  void _pushPage(Widget page) {
    Navigator.of(context).push(
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 300),
        pageBuilder: (_, animation, _) =>
            FadeTransition(opacity: animation, child: page),
        transitionsBuilder: (_, animation, _, child) {
          final slide = Tween<Offset>(
            begin: const Offset(0.1, 0),
            end: Offset.zero,
          ).animate(animation);

          return SlideTransition(
            position: slide,
            child: child,
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      extendBodyBehindAppBar: true,

      appBar: AppBar(
        title: const Text("LifeDrop Home"),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => logout(context),
          )
        ],
      ),

      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.red, Colors.deepOrange],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),

        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 90, 16, 16),
          child: Column(
            children: [

              // 🔴 HEADER
              FadeTransition(
                opacity: _headerFade,
                child: SlideTransition(
                  position: _headerSlide,
                  child: Container(
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
                      "Welcome to LifeDrop ❤️\nSave lives with one tap",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        height: 1.4,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // 📦 CARDS
              Expanded(
                child: ListView(
                  children: [

                    _buildCard(
                      0,
                      Icons.bloodtype,
                      "Blood Feed",
                      "View all active blood requests",
                      () => _pushPage(const FeedScreen()),
                    ),

                    _buildCard(
                      1,
                      Icons.add_circle,
                      "Post Request",
                      "Request blood instantly",
                      () => _pushPage(const PostRequestScreen()),
                    ),

                    _buildCard(
                      2,
                      Icons.search,
                      "Find Donors",
                      "Search by city & blood group",
                      () => _pushPage(const RequesterHome()),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // 🎯 CLEAN PROFESSIONAL CARD
  Widget _buildCard(
    int index,
    IconData icon,
    String title,
    String subtitle,
    VoidCallback onTap,
  ) {
    final colors = [
      Colors.red,
      Colors.deepOrange,
      Colors.green,
    ];

    final color = colors[index];

    return FadeTransition(
      opacity: _cardFade[index],
      child: SlideTransition(
        position: _cardSlide[index],
        child: Container(
          margin: const EdgeInsets.only(bottom: 14),

          child: InkWell(
            borderRadius: BorderRadius.circular(16),
            onTap: onTap,

            child: Container(
              padding: const EdgeInsets.all(16),

              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),

                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.10),
                    blurRadius: 16,
                    offset: const Offset(0, 6),
                  )
                ],
              ),

              child: Row(
                children: [

                  // ICON
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(icon, color: color, size: 24),
                  ),

                  const SizedBox(width: 14),

                  // TEXT
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [

                        Text(
                          title,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),

                        const SizedBox(height: 4),

                        Text(
                          subtitle,
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  ),

                  Icon(
                    Icons.arrow_forward_ios,
                    size: 16,
                    color: Colors.grey.shade400,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}