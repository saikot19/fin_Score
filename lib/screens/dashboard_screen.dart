import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../state_management/survey_provider.dart';
import '../widgets/survey_overview_widget.dart'; // Updated import
import '../widgets/user_info_card_widget.dart';
import 'form_screen.dart';
import 'package:animate_do/animate_do.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  late Future<void> _fetchSurveysFuture;

  @override
  void initState() {
    super.initState();
    _fetchSurveysFuture = _fetchSurveys();
  }

  Future<void> _fetchSurveys() async {
    final surveyProvider = Provider.of<SurveyProvider>(context, listen: false);
    await surveyProvider.fetchSurveys(2); // Replace with actual branch ID
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => SurveyProvider(),
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            "Home",
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
        body: FutureBuilder<void>(
          future: _fetchSurveysFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text("Error: ${snapshot.error}"));
            } else {
              return Column(
                children: [
                  const UserInfoCard(), // Added UserInfoCard at the top
                  const SizedBox(height: 20),
                  const SurveyOverviewWidget(), // Added SurveyOverviewWidget
                ],
              );
            }
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
      ),
    );
  }
}
