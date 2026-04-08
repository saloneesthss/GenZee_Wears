import 'package:flutter/material.dart';
import 'package:genzee_wears/bottom_navigation.dart';
import 'package:genzee_wears/constants/app_routes.dart';
import 'package:genzee_wears/constants/app_text_styles.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool isObscure = true;
  final formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xff7C53FB),
              Color(0xff3c1d99),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 35, top: 40, bottom: 30),
                child: const Text(
                  "Hello\nSign in!",
                  style: TextStyle(
                    fontSize: 34,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(40),
                      topRight: Radius.circular(40),
                    ),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 30,
                    vertical: 35,
                  ),
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Form(
                      key: formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Gmail",
                            style: TextStyle(
                              color: Color(0xff9b4dff),
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          TextFormField(
                            controller: emailController,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Please enter your email";
                              } else if (!value.contains('@')) {
                                return "Please enter a valid email";
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                              hintText: "example@gmail.com",
                              enabledBorder: const UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.black26),
                              ),
                              focusedBorder: const UnderlineInputBorder(
                                borderSide: BorderSide(color: Color(0xff9b4dff)),
                              ),
                            ),
                          ),
                          const SizedBox(height: 25),
                          const Text(
                            "Password",
                            style: TextStyle(
                              color: Color(0xff9b4dff),
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          TextFormField(
                            controller: passwordController,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your password';
                              } else if (value.length < 8) {
                                return 'Password must be at least 8 characters';
                              }
                              return null;
                            },
                            obscureText: isObscure,
                            decoration: InputDecoration(
                              hintText: "••••••••",
                              suffixIcon: IconButton(
                                  padding: EdgeInsets.zero,
                                  onPressed: () {
                                    setState(() {
                                      isObscure = !isObscure;
                                    });
                                  },
                                  icon: Icon(isObscure ? Icons.visibility_off : Icons.visibility),
                                  color: Colors.grey[700]
                              ),
                              enabledBorder: const UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.black26),
                              ),
                              focusedBorder: const UnderlineInputBorder(
                                borderSide: BorderSide(color: Color(0xff9b4dff)),
                              ),
                            ),
                          ),
                          const SizedBox(height: 15),
                          Align(
                            alignment: Alignment.centerRight,
                            child: Text(
                              "Forgot password?",
                              style: TextStyle(
                                color: Color(0xff9b4dff),
                                fontSize: 13,
                              ),
                            ),
                          ),
                          const SizedBox(height: 35),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.black,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              minimumSize: Size(double.infinity,56),
                            ),
                            onPressed: () {
                              if (formKey.currentState?.validate() ?? false) {
                                Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => BottomNavigation(),
                                  ),
                                      (route) => false,
                                );
                              }
                            },
                            child: Text('sign in'.toUpperCase(),
                              style: AppTextStyle.poppinsMedium.copyWith(
                                fontSize: 20,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          SizedBox(height: 220),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text('Don\'t have an account?',
                                  style: AppTextStyle.poppinsMedium.copyWith(
                                    fontSize: 18,
                                    color: Colors.black,
                                  )
                              ),
                              SizedBox(width: 8),
                              GestureDetector(
                                onTap: () {
                                  Navigator.pushNamed(context, AppRoute.signup);
                                },
                                child: Text('Signup',
                                    style: AppTextStyle.poppinsMedium.copyWith(
                                      fontSize: 18,
                                      color: Color(0xff7C53FB),
                                    )
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 15),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}