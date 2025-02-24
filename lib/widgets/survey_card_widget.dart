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

    return Card(
      margin: const EdgeInsets.all(10),
      color: const Color.fromARGB(255, 209, 238, 216),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("SL No: $index", style: textStyle),
            Text("Branch Name: ${survey['branch_name']}", style: textStyle),
            Text("Member Code: ${survey['member_id']}", style: textStyle),
            Text("Entry Date: ${survey['start_date']}", style: textStyle),
            Text("Entry Time: ${survey['created_at']}", style: textStyle),
            Text("Applied Loan Amount: ${survey['applied_loan_amount']}",
                style: textStyle),
            Text("Score: ${survey['scoreTotal']}", style: textStyle),
            Text("Status: ${survey['status'] == 2 ? 'Completed' : 'Pending'}",
                style: textStyle),
          ],
        ),
      ),
    );
  }
}
