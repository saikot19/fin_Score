import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../state_management/user_provider.dart';
import '../widgets/bottom_nav_bar_widget.dart';
import 'package:animate_do/animate_do.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final userInfo = userProvider.userInfo;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "User Info",
          style: GoogleFonts.lexendDeca(
              fontWeight: FontWeight.bold,
              color: const Color.fromARGB(255, 255, 255, 255)),
        ),
        backgroundColor: const Color.fromARGB(255, 1, 16, 43),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FadeInDown(
              child: Text(
                "User Information",
                style: GoogleFonts.lexendDeca(
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                    color: Colors.black),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              "User Name: ${userInfo['user_name'] ?? ''}",
              style: GoogleFonts.lexendDeca(fontSize: 16, color: Colors.black),
            ),
            const SizedBox(height: 10),
            Text(
              "Branch Name: ${userInfo['branch_name'] ?? ''}",
              style: GoogleFonts.lexendDeca(fontSize: 16, color: Colors.black),
            ),
            const SizedBox(height: 10),
            Text(
              "User ID: ${userInfo['user_id'] ?? ''}",
              style: GoogleFonts.lexendDeca(fontSize: 16, color: Colors.black),
            ),
            const SizedBox(height: 10),
            Text(
              "Branch ID: ${userInfo['branch_id'] ?? ''}",
              style: GoogleFonts.lexendDeca(fontSize: 16, color: Colors.black),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavBar(),
    );
  }
}
