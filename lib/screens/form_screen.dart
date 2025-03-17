import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../state_management/survey_provider.dart';
import '../state_management/user_provider.dart';
import 'survey_screen.dart';
import 'package:animate_do/animate_do.dart';

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
                fontWeight: FontWeight.bold, color: Colors.white),
          ),
          backgroundColor: const Color(0xFF01102B),
          elevation: 0,
          iconTheme: const IconThemeData(color: Colors.white),
        ),
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FadeInDown(
                child: Text(
                  "Enter Applicant Details",
                  style: GoogleFonts.lexendDeca(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black54),
                ),
              ),
              const SizedBox(height: 20),
              _buildTextField(
                controller: memberIdController,
                label: "সদস্যর আইডি নম্বর",
                icon: Icons.perm_identity,
                keyboardType: TextInputType.number,
                inputFormatters: [
                  LengthLimitingTextInputFormatter(12),
                  FilteringTextInputFormatter.digitsOnly,
                ],
              ),
              const SizedBox(height: 20),
              _buildTextField(
                controller: memberNameController,
                label: "সদস্যর নাম",
                icon: Icons.person,
                keyboardType: TextInputType.text,
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'^[a-zA-Z\s]+$')),
                ],
              ),
              const SizedBox(height: 20),
              _buildLoanAmountField(),
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

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    List<TextInputFormatter>? inputFormatters,
  }) {
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

  Widget _buildLoanAmountField() {
    return FadeInLeft(
      child: TextField(
        controller: loanAmountController,
        decoration: InputDecoration(
          prefixIcon: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Image.asset("assets/logo/taka.png", width: 24, height: 24),
          ),
          labelText: "আবেদনকৃত ঋণের পরিমাণ",
          labelStyle: GoogleFonts.lexendDeca(color: Colors.black54),
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: const BorderSide(color: Colors.black54),
          ),
          errorText: _validateLoanAmount(loanAmountController.text),
        ),
        keyboardType: TextInputType.number,
        style: GoogleFonts.lexendDeca(color: Colors.black),
        inputFormatters: [
          FilteringTextInputFormatter.digitsOnly,
          LengthLimitingTextInputFormatter(7), // Restrict to 7 digits
        ],
        onChanged: (value) {
          setState(() {
            // Trigger validation on change
          });
        },
      ),
    );
  }

  String? _validateLoanAmount(String value) {
    if (value.isEmpty) {
      return "আবেদনকৃত ঋণের পরিমাণ ফাঁকা রাখা যাবে না"; // Loan amount cannot be empty
    }
    int amount = int.tryParse(value) ?? 0;
    if (amount < 5000) {
      return "আবেদনকৃত ঋণের পরিমাণ অন্তত ৫,000 BDT হতে হবে"; // Must be at least 5000 BDT
    }
    if (amount > 2500000) {
      return "সর্বাধিক ঋণের পরিমাণ ২৫,00,000 BDT হতে পারে"; // Max limit is 25,00,000 BDT
    }
    return null; // No error
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

    if (memberId.length != 12) {
      _showError("সদস্যর আইডি নম্বর must be exactly 12 digits.");
      return;
    }

    if (!RegExp(r'^[a-zA-Z\s]+$').hasMatch(memberName)) {
      _showError("সদস্যর নাম cannot contain numbers or special characters.");
      return;
    }

    int loanAmount = int.tryParse(loanAmountController.text.trim()) ?? 0;
    if (loanAmount < 5000 || loanAmount > 2500000) {
      _showError(
          "আবেদনকৃত ঋণের পরিমাণ must be between 5,000 and 25,00,000 BDT.");
      return;
    }

    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final branchId = userProvider.userInfo?['branch_id'] ?? 0;

    Provider.of<SurveyProvider>(context, listen: false).clearResponses();

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SurveyScreen(
          memberId: memberId,
          memberName: memberName,
          branchId: branchId,
          loanAmount: loanAmount.toDouble(),
          loanDate: loanDate,
          initialSegmentId: 1,
        ),
      ),
    );
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }
}
