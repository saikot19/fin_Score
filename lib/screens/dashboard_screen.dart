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
  final String? email;
  final String? password;

  const DashboardScreen({Key? key, this.email, this.password})
      : super(key: key);

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  late Future<void> _initFuture;

  @override
  void initState() {
    super.initState();
    _initFuture = _initialize();
  }

  Future<void> _initialize() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

    // Show splash screen animation
    await Future.delayed(
        const Duration(seconds: 3)); // Simulate splash screen delay

    if (!isLoggedIn) {
      // If user is not logged in, navigate to SplashLoginScreen
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const SplashLoginScreen()),
      );
      return;
    }

    // If logged in, proceed with survey fetch
    await _fetchSurveys();
  }

  Future<void> _fetchSurveys() async {
    try {
      final surveyProvider =
          Provider.of<SurveyProvider>(context, listen: false);
      WidgetsBinding.instance.addPostFrameCallback((_) {
        surveyProvider.fetchSurveys();
      });
    } catch (e) {
      debugPrint("Error fetching surveys: $e");
    }
  }

  Future<void> _refreshSurveys() async {
    try {
      final surveyProvider =
          Provider.of<SurveyProvider>(context, listen: false);
      await surveyProvider.refreshSurveys();
    } catch (e) {
      debugPrint("Error refreshing surveys: $e");
    }
  }

  Future<void> _logout() async {
    final shouldLogout = await _showLogoutConfirmationDialog();
    if (shouldLogout) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.remove('isLoggedIn');
      await prefs.remove('email');
      await prefs.remove('password');

      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const SplashLoginScreen()),
        );
      }
    }
  }

  Future<bool> _showLogoutConfirmationDialog() async {
    return await showDialog<bool>(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text("Logout"),
              content: const Text("Do you want to logout?"),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: const Text("No"),
                ),
                TextButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  child: const Text("Yes"),
                ),
              ],
            );
          },
        ) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
      future: _initFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // Show splash/loading screen while checking login status
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        return Scaffold(
          appBar: AppBar(
            title: Text(
              "Dashboard",
              style: GoogleFonts.lexendDeca(
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            backgroundColor: const Color.fromARGB(255, 1, 16, 43),
            elevation: 0,
            iconTheme: const IconThemeData(
              color: Color.fromARGB(255, 153, 182, 160),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.logout,
                    color: Color.fromARGB(255, 255, 1, 1)),
                onPressed: _logout,
              ),
            ],
          ),
          body: RefreshIndicator(
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
          ),
        );
      },
    );
  }
}
