import 'package:flutter/material.dart';
class MyProfile extends StatefulWidget {
  const MyProfile({super.key});

  @override
  State<MyProfile> createState() => _MyProfileState();
}

class _MyProfileState extends State<MyProfile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff353537),
      body: Column(
        children: [
          Container(
            height: 360,
            width: double.infinity,
            decoration: const BoxDecoration(
              color: Color(0xff7C53FB),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(35),
                bottomRight: Radius.circular(35),
              ),
            ),
            child: Stack(
              children: [
                Positioned(
                  top: -20,
                  right: -20,
                  child: CircleAvatar(
                    radius: 60,
                    backgroundColor: Colors.white.withOpacity(0.05),
                  ),
                ),
                Positioned(
                  bottom: -20,
                  left: -10,
                  child: CircleAvatar(
                    radius: 40,
                    backgroundColor: Colors.white.withOpacity(0.05),
                  ),
                ),
                Align(
                  alignment: Alignment.center,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const CircleAvatar(
                        radius: 43,
                        backgroundColor: Colors.white,
                        child: CircleAvatar(
                          radius: 40,
                          backgroundImage: AssetImage('assets/images/profile.jpg'),
                        ),
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        "Salonee Shrestha",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        "+977 9748012345",
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  top: 50,
                  right: 25,
                  child: Icon(Icons.more_horiz, color: Colors.white, size: 30),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),
          Expanded(
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 20),
              decoration: const BoxDecoration(
                color: Colors.black45,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(35),
                  topRight: Radius.circular(35),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 10),
                  const Text(
                    "Account Overview",
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w600,
                      color: Colors.white70,
                    ),
                  ),
                  const SizedBox(height: 20),

                  _menuItem(Icons.person_outline, "My Profile"),
                  _menuItem(Icons.shopping_bag_outlined, "My Orders"),
                  _menuItem(Icons.history, "Refund"),
                  _menuItem(Icons.lock_outline, "Change Password"),
                  _menuItem(Icons.language_outlined, "Change Language"),
                  const Spacer(),
                  Container(height: 4),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _menuItem(IconData icon, String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 14),
      child: Row(
        children: [
          Icon(icon, size: 24, color: Colors.white),
          const SizedBox(width: 18),
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.white,
            ),
          ),
          const Spacer(),
          const Icon(Icons.arrow_forward_ios,
              size: 16, color: Colors.white),
        ],
      ),
    );
  }
}
