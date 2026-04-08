import 'package:flutter/material.dart';
import 'package:genzee_wears/constants/app_routes.dart';
import 'package:genzee_wears/constants/app_text_styles.dart';
import 'package:genzee_wears/login_page.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  bool isObscure = true;
  final formKey = GlobalKey<FormState>();
  // bool isPasswordObscure = true;
  // bool isConfirmPasswordObscure = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
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
              const Padding(
                padding: EdgeInsets.only(left: 35, top: 40, bottom: 30),
                child: Text(
                  "Create\nAccount!",
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
                  padding: const EdgeInsets.symmetric(
                      horizontal: 30, vertical: 35),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(40),
                      topRight: Radius.circular(40),
                    ),
                  ),
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Form(
                      key: formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Full Name",
                            style: TextStyle(
                              color: Color(0xff9b4dff),
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          TextFormField(
                            controller: nameController,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Please enter your email";
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                              hintText: "John Doe",
                              enabledBorder: const UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.black26),
                              ),
                              focusedBorder: const UnderlineInputBorder(
                                borderSide: BorderSide(
                                    color: Color(0xff9b4dff)),
                              ),
                            ),
                          ),
                          SizedBox(height: 25),
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
                                borderSide: BorderSide(
                                    color: Color(0xff9b4dff)),
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
                                  icon: Icon(
                                      isObscure ? Icons.visibility_off : Icons
                                          .visibility),
                                  color: Colors.grey[700]
                              ),
                              enabledBorder: const UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.black26),
                              ),
                              focusedBorder: const UnderlineInputBorder(
                                borderSide: BorderSide(
                                    color: Color(0xff9b4dff)),
                              ),
                            ),
                          ),
                          const SizedBox(height: 25),
                          const Text(
                            "Confirm Password",
                            style: TextStyle(
                              color: Color(0xff9b4dff),
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          TextFormField(
                            controller: confirmPasswordController,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your password';
                              } else if (value != passwordController.text) {
                                return 'Password and confirm password are not same';
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
                                  icon: Icon(
                                      isObscure ? Icons.visibility_off : Icons
                                          .visibility),
                                  color: Colors.grey[700]
                              ),
                              enabledBorder: const UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.black26),
                              ),
                              focusedBorder: const UnderlineInputBorder(
                                borderSide: BorderSide(
                                    color: Color(0xff9b4dff)),
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
                                    builder: (context) => LoginPage(),
                                  ),
                                      (route) => false,
                                );
                              }
                            },
                            child: Text('sign up'.toUpperCase(),
                              style: AppTextStyle.poppinsMedium.copyWith(
                                fontSize: 20,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          const SizedBox(height: 80),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text('Already have an account?',
                                  style: AppTextStyle.poppinsMedium.copyWith(
                                    fontSize: 18,
                                    color: Colors.black,
                                  )
                              ),
                              SizedBox(width: 8),
                              GestureDetector(
                                onTap: () {
                                  Navigator.pushNamed(context, AppRoute.login);
                                },
                                child: Text('Sign in',
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