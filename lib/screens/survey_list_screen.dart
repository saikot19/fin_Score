import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../widgets/survey_card_widget.dart';
import 'form_screen.dart';

class SurveyListScreen extends StatelessWidget {
  final List<Map<String, dynamic>> surveys;

  const SurveyListScreen({Key? key, required this.surveys}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Survey List",
          style: GoogleFonts.lexendDeca(
              fontWeight: FontWeight.bold,
              color: const Color.fromARGB(255, 255, 255, 255)),
        ),
        backgroundColor: const Color.fromARGB(255, 1, 16, 43),
        elevation: 0,
        iconTheme: const IconThemeData(
          color: Color.fromARGB(255, 153, 182, 160),
        ),
      ),
      body: ListView.builder(
        itemCount: surveys.length,
        itemBuilder: (context, index) {
          final survey = surveys[index];
          return SurveyCard(
            survey: survey,
            index: index + 1, // SL No
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => FormScreen()),
          );
        },
        child: const Icon(Icons.add),
        backgroundColor: const Color.fromARGB(255, 20, 92, 37),
      ),
    );
  }
}
