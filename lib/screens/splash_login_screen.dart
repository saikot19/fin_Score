/*import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/api_service.dart';
import '../state_management/user_provider.dart';
import 'form_screen.dart';
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
    Future.delayed(const Duration(seconds: 3), () {
      setState(() => showLoginScreen = true);
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    setState(() => isLoading = true);
    final userData = await ApiService.login(
      emailController.text.trim(),
      passwordController.text.trim(),
    );
    setState(() => isLoading = false);

    if (userData != null) {
      setState(() => showTick = true);
      await Future.delayed(const Duration(seconds: 2));
      Provider.of<UserProvider>(context, listen: false)
          .login(userData['id'], userData['branch_id']);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => FormScreen()),
      );
    } else {
      setState(() => showCross = true);
      await Future.delayed(const Duration(seconds: 2));
      setState(() => showCross = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Login failed. Check your credentials!")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              const Color.fromARGB(255, 52, 32, 124),
              const Color.fromARGB(255, 0, 0, 0)
            ],
          ),
        ),
        child: Center(
          child: showLoginScreen ? _buildLoginScreen() : _buildSplashScreen(),
        ),
      ),
    );
  }

  Widget _buildSplashScreen() {
    return Center(
      child: FadeTransition(
        opacity: _logoAnimation,
        child: Image.asset('assets/logo/PNG transparent-8.png', height: 150),
      ),
    );
  }

  Widget _buildLoginScreen() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          FadeTransition(
            opacity: _formAnimation,
            child:
                Image.asset('assets/logo/PNG transparent-8.png', height: 250),
          ),
          const SizedBox(height: 20),
          Text(
            "Login",
            style: GoogleFonts.lexendDeca(
              fontWeight: FontWeight.bold,
              fontSize: 24,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 20),
          TextField(
            controller: emailController,
            decoration: InputDecoration(
              prefixIcon: const Icon(Icons.email,
                  color: Color.fromARGB(255, 255, 255, 255)),
              labelText: "Email",
              labelStyle: GoogleFonts.lexendDeca(fontWeight: FontWeight.normal),
              filled: true,
              fillColor: Colors.black54,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            style: GoogleFonts.lexendDeca(color: Colors.white),
          ),
          const SizedBox(height: 20),
          TextField(
            controller: passwordController,
            obscureText: true,
            decoration: InputDecoration(
              prefixIcon: const Icon(Icons.lock,
                  color: Color.fromARGB(255, 255, 255, 255)),
              labelText: "Password",
              labelStyle: GoogleFonts.lexendDeca(fontWeight: FontWeight.normal),
              filled: true,
              fillColor: Colors.black54,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            style: GoogleFonts.lexendDeca(color: Colors.white),
          ),
          const SizedBox(height: 20),
          isLoading
              ? const CircularProgressIndicator()
              : ElevatedButton(
                  onPressed: _login,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green.shade800,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 50, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text("Login",
                      style: GoogleFonts.lexendDeca(
                          fontWeight: FontWeight.bold,
                          textStyle: const TextStyle(color: Colors.white))),
                ),
          if (showTick)
            Animate(
              effects: [FadeEffect(duration: 1.seconds)],
              child:
                  const Icon(Icons.check_circle, color: Colors.green, size: 60),
            ),
          if (showCross)
            Animate(
              effects: [FadeEffect(duration: 1.seconds)],
              child: const Icon(Icons.cancel, color: Colors.red, size: 60),
            ),
        ],
      ),
    );
  }
}*/
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../services/api_service.dart';
import '../state_management/user_provider.dart';
import 'form_screen.dart';
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
    Future.delayed(const Duration(seconds: 3), () {
      setState(() => showLoginScreen = true);
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    setState(() => isLoading = true);

    final apiService = ApiService(); // Create an instance of ApiService

    final userData = await apiService.login(
      emailController.text.trim(),
      passwordController.text.trim(),
    );

    setState(() => isLoading = false);

    if (userData != null) {
      setState(() => showTick = true);
      await Future.delayed(const Duration(seconds: 2));
      Provider.of<UserProvider>(context, listen: false)
          .login(userData['id'], userData['branch_id']);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => FormScreen()),
      );
    } else {
      setState(() => showCross = true);
      await Future.delayed(const Duration(seconds: 2));
      setState(() => showCross = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Login failed. Check your credentials!")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  const Color.fromARGB(255, 52, 32, 124),
                  const Color.fromARGB(255, 0, 0, 0)
                ],
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
          SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0, 0.5), // Start slightly lower
              end: Offset.zero,
            ).animate(CurvedAnimation(
              parent: _controller,
              curve: Curves.easeOut,
            )),
            child: Opacity(
              opacity: 0.7,
              child: Column(
                children: [
                  Text(
                    "V.1.0.1",
                    style: GoogleFonts.lexendDeca(
                      fontSize: 10,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    "Copyright © 2025, CDIP ITS",
                    style: GoogleFonts.lexendDeca(
                      fontSize: 10,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoginScreen() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        FadeTransition(
          opacity: _formAnimation,
          child: Image.asset('assets/logo/PNG transparent-8.png', height: 250),
        ),
        Expanded(
          child: Animate(
            effects: [
              FadeEffect(duration: 500.ms),
              SlideEffect(begin: Offset(0, 1), end: Offset(0, 0))
            ],
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              width: double.infinity,
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 255, 255, 255),
                borderRadius: BorderRadius.circular(30),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 100),
                  Text(
                    "Login",
                    style: GoogleFonts.lexendDeca(
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TextField(
                          controller: emailController,
                          decoration: InputDecoration(
                            prefixIcon:
                                const Icon(Icons.email, color: Colors.black54),
                            labelText: "Email",
                            labelStyle: GoogleFonts.lexendDeca(
                                fontWeight: FontWeight.normal),
                            filled: true,
                            fillColor: Colors.grey[200],
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                              borderSide: BorderSide.none,
                            ),
                          ),
                          style: GoogleFonts.lexendDeca(color: Colors.black),
                        ),
                        const SizedBox(height: 20),
                        TextField(
                          controller: passwordController,
                          obscureText: true,
                          decoration: InputDecoration(
                            prefixIcon:
                                const Icon(Icons.lock, color: Colors.black54),
                            labelText: "Password",
                            labelStyle: GoogleFonts.lexendDeca(
                                fontWeight: FontWeight.normal),
                            filled: true,
                            fillColor: Colors.grey[200],
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                              borderSide: BorderSide.none,
                            ),
                          ),
                          style: GoogleFonts.lexendDeca(color: Colors.black),
                        ),
                        const SizedBox(height: 30),
                        isLoading
                            ? const CircularProgressIndicator()
                            : ElevatedButton(
                                onPressed: _login,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.green.shade800,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 100, vertical: 15),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                ),
                                child: Text("Login",
                                    style: GoogleFonts.lexendDeca(
                                        fontWeight: FontWeight.bold,
                                        textStyle: const TextStyle(
                                            color: Colors.white))),
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
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
