import 'package:flutter/material.dart';
import 'profile_ui.dart';
import 'my_saved.dart';
import 'search_page.dart';
import 'api_service.dart';
import 'Register_page.dart';

final ApiService api = ApiService();

class HomePagem extends StatelessWidget {
  const HomePagem({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      // ---------------- APP BAR ----------------
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,

        title: Image.asset("Image/Logo.png", height: 45),

        actions: [
          IconButton(
            icon: const Icon(Icons.favorite_border, color: Colors.blue),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => MySavedServicesPage()),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.person_outline, color: Colors.blue),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => PatientProfileScreen()),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.blue),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => RegisterPage(api: api)),
              );
            },
          ),
          const SizedBox(width: 10),
        ],
      ),

      // ---------------- BODY ----------------
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset("Image/vectors.png", fit: BoxFit.fitWidth),
          ),

          Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 80, top: 20),
                child: Image.asset(
                  "Image/landframe.png",
                  height: 250,
                  fit: BoxFit.contain,
                ),
              ),
              const SizedBox(height: 30),

              // -------- SEARCH BUTTON --------
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    side: BorderSide(color: Colors.blue, width: 2),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => ServicesPage(api: api)),
                    );
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(Icons.search, color: Colors.blue),
                      SizedBox(width: 10),
                      Text(
                        "ابحث عن خدمة",
                        style: TextStyle(
                          color: Colors.blue,
                          fontSize: 17,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const Spacer(),

              // HOSPITAL IMAGE STICKED TO BOTTOM
              Padding(
                padding: const EdgeInsets.only(bottom: 30),
                child: Image.asset(
                  "Image/Hos.png",
                  height: 250,
                  fit: BoxFit.contain,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ----------------- DUMMY PAGES (Replace with your real pages) --------------
class SarahPage extends StatelessWidget {
  const SarahPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Center(child: Text("Sarah Page")));
  }
}

class FavPage extends StatelessWidget {
  const FavPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Center(child: Text("Favorites Page")));
  }
}

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Center(child: Text("Profile Page")));
  }
}
