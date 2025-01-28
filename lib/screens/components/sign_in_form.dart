import 'dart:developer';
import 'package:finscore/api/auth_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:rive/rive.dart';
import 'package:finscore/screens/survey_page.dart';

class SignInForm extends StatefulWidget {
  const SignInForm({super.key});

  @override
  State<SignInForm> createState() => _SignInFormState();
}

class _SignInFormState extends State<SignInForm> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final AuthService authService = AuthService();

  bool isShowingLoading = false;
  bool isShowingConfetti = false;

  SMITrigger? check;
  SMITrigger? error;
  SMITrigger? reset;
  SMITrigger? confetti;

  StateMachineController getRiveController(Artboard artboard) {
    final controller = StateMachineController.fromArtboard(
      artboard,
      "State Machine 1",
    );
    artboard.addController(controller!);
    return controller;
  }

  Future<void> signIn() async {
    if (!(formKey.currentState?.validate() ?? false)) {
      error?.fire();
      return;
    }

    setState(() {
      isShowingLoading = true;
    });

    try {
      final response = await authService.signIn(
        emailController.text,
        passwordController.text,
      );

      if (response['success'] == true) {
        check?.fire();
        setState(() {
          isShowingConfetti = true;
        });

        Future.delayed(const Duration(seconds: 2), () {
          if (mounted) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const SurveyPage()),
            );
          }
        });
      } else {
        throw Exception(response['message'] ?? 'Invalid credentials');
      }
    } catch (e, stackTrace) {
      error?.fire();
      log('Sign-in failed',
          name: 'SignInError', error: e, stackTrace: stackTrace);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString())),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          isShowingLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size.width * 0.4;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Sign In"),
        backgroundColor: const Color.fromARGB(255, 57, 128, 63),
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Email",
                      style:
                          TextStyle(color: Color.fromARGB(255, 233, 230, 230))),
                  Padding(
                    padding: const EdgeInsets.only(top: 8, bottom: 16),
                    child: TextFormField(
                      controller: emailController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Email cannot be empty";
                        }
                        if (!RegExp(r'^[0-9]{4}$').hasMatch(value)) {
                          return "Invalid email format";
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        prefixIcon: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: SvgPicture.asset("assets/icons/email.svg"),
                        ),
                      ),
                    ),
                  ),
                  const Text("Password",
                      style:
                          TextStyle(color: Color.fromARGB(255, 252, 250, 250))),
                  Padding(
                    padding: const EdgeInsets.only(top: 8, bottom: 16),
                    child: TextFormField(
                      controller: passwordController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Password cannot be empty";
                        }
                        return null;
                      },
                      obscureText: true,
                      decoration: InputDecoration(
                        prefixIcon: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: SvgPicture.asset("assets/icons/password.svg"),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8, bottom: 24),
                    child: ElevatedButton.icon(
                      onPressed: signIn,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(255, 57, 128, 63),
                        minimumSize: const Size(double.infinity, 56),
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(25)),
                        ),
                      ),
                      icon: const Icon(
                        CupertinoIcons.arrow_right_circle,
                        color: Color(0xFFFE0037),
                      ),
                      label: const Text("Sign In"),
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (isShowingLoading)
            Positioned(
              top: size,
              left: size,
              child: SizedBox(
                width: size,
                height: size,
                child: RiveAnimation.asset(
                  "assets/RiveAssets/check.riv",
                  onInit: (artboard) {
                    final controller = getRiveController(artboard);
                    check = controller.findSMI("Check") as SMITrigger?;
                    error = controller.findSMI("Error") as SMITrigger?;
                    reset = controller.findSMI("Reset") as SMITrigger?;
                  },
                ),
              ),
            ),
          if (isShowingConfetti)
            Positioned(
              top: size,
              left: size,
              child: SizedBox(
                width: size,
                height: size,
                child: Transform.scale(
                  scale: 7,
                  child: RiveAnimation.asset(
                    "assets/RiveAssets/confetti.riv",
                    onInit: (artboard) {
                      final controller = getRiveController(artboard);
                      confetti = controller.findSMI("Trigger explosion")
                          as SMITrigger?;
                    },
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
