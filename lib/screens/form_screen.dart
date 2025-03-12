import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../state_management/survey_provider.dart';
import '../state_management/user_provider.dart'; // Import UserProvider
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
  void initState() {
    super.initState();
    // Set the default date as the present date
    loanDateController.text =
        "${DateTime.now().year}-${DateTime.now().month}-${DateTime.now().day}";
  }

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
              _buildTextField(
                memberIdController,
                "সদস্যর আইডি নম্বর",
                Icons.perm_identity,
                TextInputType.number,
                [LengthLimitingTextInputFormatter(12)], // Limit to 12 digits
              ),
              const SizedBox(height: 20),
              _buildTextField(
                memberNameController,
                "সদস্যর নাম",
                Icons.person,
                TextInputType.text,
              ),
              const SizedBox(height: 20),
              _buildTextFieldWithImageIcon(
                loanAmountController,
                "আবেদনকৃত ঋণের পরিমাণ",
                "assets/logo/taka.png",
                TextInputType.number,
              ),
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
    TextEditingController controller,
    String label,
    IconData icon, [
    TextInputType keyboardType = TextInputType.text,
    List<TextInputFormatter>? inputFormatters,
  ]) {
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
        inputFormatters: inputFormatters,
      ),
    );
  }

  Widget _buildTextFieldWithImageIcon(
    TextEditingController controller,
    String label,
    String imagePath, [
    TextInputType keyboardType = TextInputType.text,
  ]) {
    return FadeInLeft(
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          prefixIcon: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Image.asset(imagePath, width: 24, height: 24),
          ),
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

        final userProvider = Provider.of<UserProvider>(context, listen: false);
        final branchId = userProvider.userInfo?['branch_id'];

        // Clear previous survey responses
        final surveyProvider =
            Provider.of<SurveyProvider>(context, listen: false);
        surveyProvider.clearResponses();

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SurveyScreen(
              memberId: memberId,
              memberName: memberName,
              branchId: branchId ??
                  0, // Replace with actual branch ID from login API response
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
