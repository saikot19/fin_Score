import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SurveyCard extends StatelessWidget {
  final Map<String, dynamic> survey;
  final int index;

  const SurveyCard({
    Key? key,
    required this.survey,
    required this.index,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textStyle = GoogleFonts.lexendDeca(
      fontWeight: FontWeight.normal,
      color: const Color.fromARGB(255, 0, 0, 0),
    );

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SurveyDetailScreen(survey: survey),
          ),
        );
      },
      child: Card(
        margin: const EdgeInsets.all(10),
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        elevation: 5,
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Member ID: ${survey['member_id']}",
                style: textStyle.copyWith(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                "Disburse Date: ${survey['start_date']}",
                style: textStyle.copyWith(
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 5),
              Text(
                "Status: ${survey['status'] == 2 ? 'Completed' : 'Pending'}",
                style: textStyle.copyWith(
                  color: survey['status'] == 2 ? Colors.green : Colors.red,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SurveyDetailScreen extends StatelessWidget {
  final Map<String, dynamic> survey;

  const SurveyDetailScreen({Key? key, required this.survey}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textStyle = GoogleFonts.lexendDeca(
      fontWeight: FontWeight.normal,
      color: const Color.fromARGB(255, 0, 0, 0),
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text("Survey Details"),
        backgroundColor: const Color.fromARGB(255, 1, 16, 43),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(10),
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25),
            ),
            color: const Color.fromARGB(255, 240, 240, 240),
            elevation: 10,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "ID: ${survey['id']}",
                    style: textStyle.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text("Branch ID: ${survey['branch_id']}", style: textStyle),
                  const SizedBox(height: 10),
                  Text("Member ID: ${survey['member_id']}", style: textStyle),
                  const SizedBox(height: 10),
                  Text("Member Name: ${survey['member_name']}",
                      style: textStyle),
                  const SizedBox(height: 10),
                  Text("Applied Loan Amount: ${survey['applied_loan_amount']}",
                      style: textStyle),
                  const SizedBox(height: 10),
                  Text("Disburse Date: ${survey['start_date']}",
                      style: textStyle),
                  const SizedBox(height: 10),
                  Text(
                      "Status: ${survey['status'] == 2 ? 'Completed' : 'Pending'}",
                      style: textStyle.copyWith(
                        color:
                            survey['status'] == 2 ? Colors.green : Colors.red,
                      )),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
