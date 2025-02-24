import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../state_management/survey_provider.dart';
import 'survey_screen.dart';
import 'package:animate_do/animate_do.dart';
import '../services/api_service.dart';

class FormScreen extends StatefulWidget {
  const FormScreen({Key? key}) : super(key: key);

  @override
  _FormScreenState createState() => _FormScreenState();
}

class _FormScreenState extends State<FormScreen> {
  final TextEditingController memberIdController = TextEditingController();
  final TextEditingController memberNameController = TextEditingController();
  final TextEditingController loanAmountController = TextEditingController();
  final TextEditingController loanDateController = TextEditingController();

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
          backgroundColor: const Color.fromARGB(255, 1, 16, 43),
          elevation: 0,
          iconTheme:
              const IconThemeData(color: Color.fromARGB(255, 255, 255, 255)),
        ),
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FadeInDown(
                child: Text(
                  "Enter Applicant details",
                  style: GoogleFonts.lexendDeca(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                ),
              ),
              const SizedBox(height: 20),
              _buildTextField(memberIdController, "সদস্যর আইডি নম্বর",
                  Icons.perm_identity, TextInputType.number),
              const SizedBox(height: 20),
              _buildTextField(memberNameController, "সদস্যর নাম", Icons.person,
                  TextInputType.text),
              const SizedBox(height: 20),
              _buildTextField(loanAmountController, "আবেদনকৃত ঋণের পরিমাণ",
                  Icons.attach_money, TextInputType.number),
              const SizedBox(height: 20),
              _buildDatePickerField(),
              const SizedBox(height: 30),
              FadeInUp(
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _onStartSurvey,
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
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
      TextEditingController controller, String label, IconData icon,
      [TextInputType keyboardType = TextInputType.text]) {
    return FadeInLeft(
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          prefixIcon: Icon(icon, color: Colors.black54),
          labelText: label,
          labelStyle: GoogleFonts.lexendDeca(color: Colors.black54),
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: const BorderSide(color: Colors.black54),
          ),
        ),
        keyboardType: keyboardType,
        style: GoogleFonts.lexendDeca(color: Colors.black),
      ),
    );
  }

  Widget _buildDatePickerField() {
    return FadeInRight(
      child: TextField(
        controller: loanDateController,
        readOnly: true,
        decoration: InputDecoration(
          prefixIcon: const Icon(Icons.calendar_month, color: Colors.black54),
          labelText: "ঋণ বিতরণের তারিখ",
          labelStyle: GoogleFonts.lexendDeca(color: Colors.black54),
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: const BorderSide(color: Colors.black54),
          ),
        ),
        onTap: _selectDate,
        style: GoogleFonts.lexendDeca(color: Colors.black),
      ),
    );
  }

  Future<void> _selectDate() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (pickedDate != null) {
      setState(() {
        loanDateController.text =
            "${pickedDate.year}-${pickedDate.month}-${pickedDate.day}";
      });
    }
  }

  void _onStartSurvey() {
    String memberId = memberIdController.text.trim();
    String memberName = memberNameController.text.trim();
    String loanDate = loanDateController.text.trim();

    if (memberId.isNotEmpty &&
        memberName.isNotEmpty &&
        loanAmountController.text.isNotEmpty &&
        loanDate.isNotEmpty) {
      if (memberId.length != 12) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("সদস্যর আইডি নম্বর must be 12 digits.")),
        );
        return;
      }

      if (!RegExp(r'^[a-zA-Z\s]+$').hasMatch(memberName)) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text(
                  "সদস্যর নাম cannot contain special characters or numbers.")),
        );
        return;
      }

      try {
        double loanAmount = double.parse(loanAmountController.text.trim());
        if (loanAmount < 5000) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content:
                    Text("আবেদনকৃত ঋণের পরিমাণ must be more than 5000tk.")),
          );
          return;
        }

        // Log form fill-up response
        debugPrint("Form Fill-up Response:");
        debugPrint("Member ID: $memberId");
        debugPrint("Member Name: $memberName");
        debugPrint("Loan Amount: $loanAmount");
        debugPrint("Loan Date: $loanDate");

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SurveyScreen(
              memberId: memberId,
              memberName: memberName,
              branchId:
                  2, // Replace with actual branch ID from login API response
              loanAmount: loanAmount,
              loanDate: loanDate, // Pass loan date if needed
              initialSegmentId: 1, // Start from the first segment
            ),
          ),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text("Invalid input! Please check the fields.")),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill all fields!")),
      );
    }
  }
}
