import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
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
      create: (_) => SurveyProvider(), // Initialize provider
      child: Scaffold(
        appBar: AppBar(title: const Text("Participant Details")),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextField(
                controller: memberIdController,
                decoration: const InputDecoration(labelText: "Member ID"),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: branchIdController,
                decoration: const InputDecoration(labelText: "Branch ID"),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: loanAmountController,
                decoration:
                    const InputDecoration(labelText: "Applied Loan Amount"),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
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
                      const SnackBar(content: Text("Please fill all fields!")),
                    );
                  }
                },
                child: const Text("Start Survey"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
