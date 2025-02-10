import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../state_management/survey_provider.dart';
import 'survey_screen.dart';

class FormScreen extends StatefulWidget {
  @override
  _FormScreenState createState() => _FormScreenState();
}

class _FormScreenState extends State<FormScreen> {
  final TextEditingController memberIdController = TextEditingController();
  final TextEditingController branchIdController = TextEditingController();
  final TextEditingController loanAmountController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => SurveyProvider(),
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            "Participant Details",
            style: GoogleFonts.lexendDeca(
                fontWeight: FontWeight.bold,
                color: const Color.fromARGB(255, 255, 255, 255)),
          ),
          backgroundColor: const Color.fromARGB(255, 9, 12, 82),
          elevation: 0,
          iconTheme: const IconThemeData(color: Colors.black),
        ),
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Enter your details",
                style: GoogleFonts.lexendDeca(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: memberIdController,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.person, color: Colors.black54),
                  labelText: "Member ID",
                  labelStyle: GoogleFonts.lexendDeca(color: Colors.black54),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: const BorderSide(color: Colors.black54),
                  ),
                ),
                keyboardType: TextInputType.number,
                style: GoogleFonts.lexendDeca(color: Colors.black),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: branchIdController,
                decoration: InputDecoration(
                  prefixIcon:
                      const Icon(Icons.account_tree, color: Colors.black54),
                  labelText: "Branch ID",
                  labelStyle: GoogleFonts.lexendDeca(color: Colors.black54),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: const BorderSide(color: Colors.black54),
                  ),
                ),
                keyboardType: TextInputType.number,
                style: GoogleFonts.lexendDeca(color: Colors.black),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: loanAmountController,
                decoration: InputDecoration(
                  prefixIcon:
                      const Icon(Icons.monetization_on, color: Colors.black54),
                  labelText: "Applied Loan Amount",
                  labelStyle: GoogleFonts.lexendDeca(color: Colors.black54),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: const BorderSide(color: Colors.black54),
                  ),
                ),
                keyboardType: TextInputType.number,
                style: GoogleFonts.lexendDeca(color: Colors.black),
              ),
              const SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    if (memberIdController.text.isNotEmpty &&
                        branchIdController.text.isNotEmpty &&
                        loanAmountController.text.isNotEmpty) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SurveyScreen(
                            memberId: memberIdController.text,
                            branchId: int.parse(branchIdController.text),
                            loanAmount: double.parse(loanAmountController.text),
                          ),
                        ),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text("Please fill all fields!")),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green.shade800,
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    "Start Survey",
                    style: GoogleFonts.lexendDeca(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
