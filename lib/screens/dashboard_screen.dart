import 'package:finscore/widgets/survey_overview_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../state_management/survey_provider.dart';
import '../widgets/user_info_card_widget.dart';
import 'form_screen.dart';
import 'survey_list_screen.dart' as survey_list;
import 'splash_login_screen.dart';

class DashboardScreen extends StatefulWidget {
  final String email;
  final String password;

  const DashboardScreen({Key? key, required this.email, required this.password})
      : super(key: key);

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  late Future<void> _fetchSurveysFuture;

  @override
  void initState() {
    super.initState();
    _fetchSurveysFuture = _loginAndFetchSurveys();
  }

  Future<void> _loginAndFetchSurveys() async {
    try {
      final surveyProvider =
          Provider.of<SurveyProvider>(context, listen: false);

      // Check if already logged in to avoid unnecessary API calls
      SharedPreferences prefs = await SharedPreferences.getInstance();
      bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

      if (!isLoggedIn) {
        await surveyProvider.login(widget.email, widget.password);
        await prefs.setBool('isLoggedIn', true); // Persist login
      }

      WidgetsBinding.instance.addPostFrameCallback((_) {
        surveyProvider.fetchSurveys();
      });
    } catch (e) {
      debugPrint("Error during login and fetching surveys: $e");
    }
  }

  Future<void> _refreshSurveys() async {
    try {
      final surveyProvider =
          Provider.of<SurveyProvider>(context, listen: false);
      await surveyProvider.refreshSurveys();
    } catch (e) {
      debugPrint("Error during refreshing surveys: $e");
    }
  }

  Future<void> _logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('isLoggedIn'); // Clear login state
    await prefs.remove('email'); // Remove stored email
    await prefs.remove('password'); // Remove stored password

    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const SplashLoginScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
        actions: [
          IconButton(
            icon:
                const Icon(Icons.logout, color: Color.fromARGB(255, 255, 1, 1)),
            onPressed: _logout, // Logout function
          ),
        ],
      ),
      body: FutureBuilder<void>(
        future: _fetchSurveysFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else {
            return RefreshIndicator(
              onRefresh: _refreshSurveys,
              child: ListView(
                padding: const EdgeInsets.all(16.0),
                children: [
                  const UserInfoCard(),
                  const SizedBox(height: 20),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ChangeNotifierProvider.value(
                            value: Provider.of<SurveyProvider>(context,
                                listen: false),
                            child: const survey_list.SurveyListScreen(),
                          ),
                        ),
                      );
                    },
                    child: const SurveyOverviewWidget(),
                  ),
                  const SizedBox(height: 20),
                  Align(
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
                  const SizedBox(height: 20),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
