import 'package:flutter/material.dart';
import 'package:mobile/config/app_pages.dart';
import 'package:mobile/pages/update_user_profile.dart';
import 'package:mobile/models/user.dart';
import 'package:mobile/services/app_state.dart';
import 'package:provider/provider.dart';

class Userprofilecard extends StatelessWidget {
  const Userprofilecard({
    super.key,
    required this.userId,
    required this.email,
    required this.name,
    this.profileImageUrl, // Optional profile image URL
  });

  final int userId;
  final String email;
  final String name;
  final String? profileImageUrl;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Navigate to UpdateUserProfilePage when the card is tapped
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => UpdateUserProfilePage(),
            fullscreenDialog: true,
          ),
        );
      },
      child: Card(
        margin: EdgeInsets.all(10.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Container(
            height: 80,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Text content on the left
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 10), // Space between name and email
                      Text(
                        email, // needs to be replaced with username
                        style: TextStyle(
                          fontSize: 16.0,
                          color: Colors.black54,
                        ),
                      ),
                    ],
                  ),
                ),
                // Profile picture on the right
                CircleAvatar(
                  radius: 30.0,
                  backgroundImage: profileImageUrl != null
                      ? NetworkImage(profileImageUrl!)
                      : AssetImage('assets/default_profile.png')
                          as ImageProvider, // Default image if no URL
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
