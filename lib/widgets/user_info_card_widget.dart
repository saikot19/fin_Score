import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:animate_do/animate_do.dart';
import '../state_management/user_provider.dart';
import 'package:google_fonts/google_fonts.dart';

class UserInfoCard extends StatelessWidget {
  const UserInfoCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final userInfo = userProvider.userInfo;

    return FadeIn(
      child: Card(
        margin: const EdgeInsets.all(10),
        color: const Color.fromARGB(255, 255, 255, 255),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        elevation: 5,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: const Color.fromARGB(255, 255, 255, 255),
                    child: const Icon(
                      Icons.person,
                      size: 40,
                      color: Color.fromARGB(255, 0, 0, 0),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    "User Information",
                    style: GoogleFonts.lexendDeca(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Text(
                "Name: ${userInfo?['user_name'] ?? 'N/A'}",
                style: GoogleFonts.lexendDeca(
                  fontSize: 16,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                "Branch: ${userInfo?['branch_name'] ?? 'N/A'}",
                style: GoogleFonts.lexendDeca(
                  fontSize: 16,
                  color: Colors.black,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
