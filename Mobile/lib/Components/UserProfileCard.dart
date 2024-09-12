import 'dart:math';
import 'package:flutter/material.dart';
import 'package:mobile/pages/update_user_profile.dart';

class Userprofilecard extends StatelessWidget {
  const Userprofilecard({
    super.key,
    this.userId,
    this.email,
    required this.name,
    this.profileImageUrl, // Optional profile image URL
    required this.page,
    this.points,
    this.colorScheme = const [
      Color.fromRGBO(194, 232, 255, 77),
      Color.fromRGBO(137, 213, 107, 1),
      Color.fromRGBO(240, 110, 81, 1),
    ],
  });

  final int? userId;
  final String? email;
  final String name;
  final String? profileImageUrl;
  final String page;
  final int? points;
  final List<Color> colorScheme;

  Color _getRandomColor() {
    final random = Random();
    int index = random.nextInt(colorScheme.length);
    return colorScheme[index];
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: page == 'user_profile'
          ? () {
              // Navigate to UpdateUserProfilePage when the card is tapped
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => UpdateUserProfilePage(),
                ),
              );
            }
          : null,
      child: Card(
        color: _getRandomColor(),
        margin: EdgeInsets.all(10.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: SizedBox(
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
                      const SizedBox(
                          height: 10), // Space between name and email
                      Text(
                        (email != null && email!.isNotEmpty)
                            ? email!
                            : points.toString(),
                        style: const TextStyle(
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
                      : const AssetImage('assets/default_profile.png')
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
