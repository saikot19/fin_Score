import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../state_management/survey_provider.dart';
import '../services/api_service.dart';
import '../widgets/survey_card_widget.dart';
import '../widgets/bottom_nav_bar_widget.dart';
import 'form_screen.dart';
import 'package:animate_do/animate_do.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  late Future<List<Map<String, dynamic>>> _completedSurveys;

  @override
  void initState() {
    super.initState();
    _completedSurveys = _fetchCompletedSurveys();
  }

  Future<List<Map<String, dynamic>>> _fetchCompletedSurveys() async {
    final apiService = ApiService();
    return await apiService
        .fetchCompletedSurveys(2); // Replace with actual branch ID
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => SurveyProvider(),
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            "Dashboard",
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
        body: FutureBuilder<List<Map<String, dynamic>>>(
          future: _completedSurveys,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text("Error: ${snapshot.error}"));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text("No completed surveys found."));
            } else {
              return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  final survey = snapshot.data![index];
                  return SurveyCard(
                    survey: survey,
                    index: index + 1, // SL No
                  );
                },
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

          backgroundColor: Color.fromARGB(255, 20, 92,
              37), // Change this to your desired color const Color.fromARGB(255, 255, 255, 255)),
        ),
        bottomNavigationBar: BottomNavBar(),
      ),
    );
  }
}
