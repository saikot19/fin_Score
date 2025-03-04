import 'package:finscore/widgets/survey_overview_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../state_management/survey_provider.dart';
import '../widgets/user_info_card_widget.dart';
import 'form_screen.dart';
import 'survey_list_screen.dart'
    as survey_list; // Import SurveyListScreen with alias
import 'package:animate_do/animate_do.dart';
import '../services/api_service.dart'; // Import ApiService

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  late Future<void> _fetchSurveysFuture;
  final ApiService _apiService =
      ApiService(); // Create an instance of ApiService

  @override
  void initState() {
    super.initState();
    _fetchSurveysFuture = _fetchSurveys();
  }

  Future<void> _fetchSurveys() async {
    try {
      // Fetch branchId and userId from the API
      final userInfo = await _apiService.fetchUserInfo();
      final branchId = userInfo['branch_id'];
      final userId = userInfo['user_id'];

      final surveyProvider =
          Provider.of<SurveyProvider>(context, listen: false);
      await surveyProvider.fetchSurveys(branchId, userId);
    } catch (e) {
      debugPrint("Error fetching user info: $e");
    }
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
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ChangeNotifierProvider.value(
                            value: Provider.of<SurveyProvider>(context,
                                listen: false),
                            child: const survey_list
                                .SurveyListScreen(), // Use alias
                          ),
                        ),
                      );
                    },
                    child:
                        const SurveyOverviewWidget(), // Added SurveyOverviewWidget
                  ),
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const FormScreen()),
                            );
                          },
                          icon: const Icon(Icons.add, color: Colors.white),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green.shade800,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 80, vertical: 15),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                          label: Text(
                            "Add Survey",
                            style: GoogleFonts.lexendDeca(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const Spacer(),
                ],
              );
            }
          },
        ),
      ),
    );
  }
}
