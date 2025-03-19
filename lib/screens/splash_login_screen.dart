import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/api_service.dart';
import '../state_management/user_provider.dart';
import 'dashboard_screen.dart';
import 'package:google_fonts/google_fonts.dart';

class SplashLoginScreen extends StatefulWidget {
  const SplashLoginScreen({super.key});

  @override
  _SplashLoginScreenState createState() => _SplashLoginScreenState();
}

class _SplashLoginScreenState extends State<SplashLoginScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _logoAnimation;
  late Animation<double> _formAnimation;
  bool showLoginScreen = false;
  bool showTick = false;
  bool showCross = false;
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool isLoading = false;
  bool _isLoginButtonEnabled = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    );

    _logoAnimation = CurvedAnimation(parent: _controller, curve: Curves.easeIn);
    _formAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    _controller.forward();
    _checkLoginStatus();

    emailController.addListener(_validateInput);
    passwordController.addListener(_validateInput);
  }

  @override
  void dispose() {
    _controller.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future<void> _checkLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
    if (isLoggedIn) {
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => DashboardScreen(
            email: prefs.getString('userEmail') ?? '',
            password: '',
          ),
        ),
      );
    } else {
      Future.delayed(const Duration(seconds: 3), () {
        if (!mounted) return;
        setState(() => showLoginScreen = true);
      });
    }
  }

  void _validateInput() {
    setState(() {
      _isLoginButtonEnabled =
          emailController.text.isNotEmpty && passwordController.text.isNotEmpty;
    });
  }

  Future<void> _login() async {
    setState(() => isLoading = true);
    final apiService = ApiService();
    final userData = await apiService.login(
      emailController.text.trim(),
      passwordController.text.trim(),
    );

    setState(() => isLoading = false);
    if (userData != null) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isLoggedIn', true);
      await prefs.setString('userEmail', emailController.text.trim());

      setState(() => showTick = true);
      await Future.delayed(const Duration(seconds: 2));

      if (!mounted) return;
      Provider.of<UserProvider>(context, listen: false).login(
        userData['user_id'],
        userData['branch_id'],
        userData['user_name'],
        userData['branch_name'],
      );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => DashboardScreen(
            email: emailController.text.trim(),
            password: passwordController.text.trim(),
          ),
        ),
      );
    } else {
      setState(() => showCross = true);
      await Future.delayed(const Duration(seconds: 2));
      if (!mounted) return;
      setState(() => showCross = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Login failed. Check your credentials!")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFF022873), Colors.black],
              ),
            ),
          ),
          Center(
            child: showLoginScreen ? _buildLoginScreen() : _buildSplashScreen(),
          ),
        ],
      ),
    );
  }

  Widget _buildSplashScreen() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          FadeTransition(
            opacity: _logoAnimation,
            child:
                Image.asset('assets/logo/PNG transparent-8.png', height: 250),
          ),
          const SizedBox(height: 30),
          Opacity(
            opacity: 0.7,
            child: Column(
              children: [
                Text(
                  "V.1.2.0",
                  style:
                      GoogleFonts.lexendDeca(fontSize: 10, color: Colors.white),
                ),
                const SizedBox(height: 5),
                Text(
                  "Copyright © 2025, CDIP ITS",
                  style:
                      GoogleFonts.lexendDeca(fontSize: 10, color: Colors.white),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoginScreen() {
    double screenWidth = MediaQuery.of(context).size.width;

    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          FadeTransition(
            opacity: _formAnimation,
            child:
                Image.asset('assets/logo/PNG transparent-8.png', height: 200),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Animate(
              effects: [
                FadeEffect(duration: 500.ms),
                SlideEffect(begin: Offset(0, 1), end: Offset(0, 0))
              ],
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: screenWidth * 0.1),
                padding: const EdgeInsets.all(20),
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Column(
                  children: [
                    const SizedBox(height: 50),
                    Text(
                      "Login",
                      style: GoogleFonts.lexendDeca(
                        fontWeight: FontWeight.bold,
                        fontSize: 24,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextField(
                      controller: emailController,
                      style: const TextStyle(color: Colors.black),
                      decoration: InputDecoration(
                        prefixIcon:
                            const Icon(Icons.email, color: Colors.black54),
                        labelText: "User Name",
                        labelStyle: GoogleFonts.lexendDeca(),
                        filled: true,
                        fillColor: Colors.grey[200],
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextField(
                      controller: passwordController,
                      obscureText: true,
                      style: const TextStyle(color: Colors.black),
                      decoration: InputDecoration(
                        prefixIcon:
                            const Icon(Icons.lock, color: Colors.black54),
                        labelText: "Password",
                        labelStyle: GoogleFonts.lexendDeca(),
                        filled: true,
                        fillColor: Colors.grey[200],
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),
                    SizedBox(
                      width: screenWidth * 0.8,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: _isLoginButtonEnabled ? _login : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green.shade800,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        child: Text(
                          "Login",
                          style: GoogleFonts.lexendDeca(
                            fontWeight: FontWeight.bold,
                            textStyle: const TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    if (showTick)
                      const Icon(Icons.check_circle,
                          color: Colors.green, size: 60),
                    if (showCross)
                      const Icon(Icons.cancel, color: Colors.red, size: 60),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
