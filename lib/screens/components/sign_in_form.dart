import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:rive/rive.dart';

class SignInForm extends StatefulWidget{
  const SignInForm({
    Key? key,
  }) : super(key: key);

  @override
  State<SignInForm> createState() => _SignInFormState();
}

class _SignInFormState extends State<SignInForm> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  bool isShowingLoading = false;

  late SMITrigger check;
  late SMITrigger error;
  late SMITrigger reset;

  StateMachineController getRiveController(Artboard artboard) {
    StateMachineController? controller = 
    StateMachineController.fromArtboard(artboard, "State Machine 1");

    artboard.addController(controller!);
    return controller;
    
  }
   

  
@override
Widget build(BuildContext context) {
    return Stack(
      children: [
        Form(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Email",
                style: TextStyle(color: Colors.black54),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8, bottom: 16),
                child: TextFormField(
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "";
                    }
                    return null;
                  },
                  onSaved: (email) {},
                  decoration: InputDecoration(
                    prefixIcon: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: SvgPicture.asset("assets/icons/email.svg"),
                    ),
                  ),
                ),
              ),
              const Text(
                "Password",
                style: TextStyle(color: Colors.black54),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8, bottom: 16),
                child: TextFormField(
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "";
                    }
                    return null;
                  },
                  onSaved: (password) {},
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
                  onPressed: () {
                    setState(() {
                      isShowingLoading = true;
                    });
                   Future.delayed(const Duration(seconds: 1), () {
                     if (formKey.currentState!.validate()) {
                      check.fire();
                    } else {
                      error.fire();
                      Future.delayed(
                        Duration(seconds: 2),
                        () {
                          reset.fire();
                          setState(() {
                            isShowingLoading = false;
                          });
                        },
                        
                      )
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 57, 128, 63),
                    minimumSize: const Size(double.infinity, 56),
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10),
                        topRight: Radius.circular(25),
                        bottomRight: Radius.circular(25),
                        bottomLeft: Radius.circular(25),
                      ),
                    ),
                  ),
                  icon: const Icon(
                    CupertinoIcons.arrow_right,
                    color: Color(0xFFFE0037),
                  ),
                  label: const Text("Sign In"),
                ),
              ),
            ],
          ),
        ),
        isShowingLoading
        ? CustomPositioned(
          
          child: RiveAnimation.asset(
            "assets/RiveAssets/check.riv",
             onInit: (artboard) {
              StateMachineController controller = getRiveController(artboard);
              check = controller.findSMI("Check") as SMITrigger;
              error = controller.findSMI("Error") as SMITrigger;
              reset = controller.findSMI("Reset") as SMITrigger;
            },
          ),
          size: 100.0,
        )

          
      ],
    );
  }
}

class CustomPositioned extends StatelessWidget {
  const CustomPositioned({
    Key? key,
    required this.child,
    required this.size,
  }) : super(key: key);
  final Widget child;
  final double size;

  @override
  Widget build(BuildContext context) {
    return  Positioned.fill(
          child:Column(
            children: [
              Spacer(),
              SizedBox(
                width: size,
                height: size,
                child: child),
                Spacer(flex: 2),
              )
            ],
          ),
        );
  }
}