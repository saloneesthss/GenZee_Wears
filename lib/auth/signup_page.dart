import 'package:flutter/material.dart';
import 'package:genzee_wears/constants/app_routes.dart';
import 'package:genzee_wears/constants/app_text_styles.dart';
import 'package:genzee_wears/auth/login_page.dart';
import 'package:genzee_wears/services/auth_service.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xff603eca),
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
                              color: Color(0xff3c1d99),
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
                              hintText: "Salonee Shrestha",
                              enabledBorder: const UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.black26),
                              ),
                              focusedBorder: const UnderlineInputBorder(
                                borderSide: BorderSide(
                                    color: Color(0xff3c1d99)),
                              ),
                            ),
                          ),
                          SizedBox(height: 25),
                          const Text(
                            "Email",
                            style: TextStyle(
                              color: Color(0xff3c1d99),
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
                                    color: Color(0xff3c1d99)),
                              ),
                            ),
                          ),
                          const SizedBox(height: 25),
                          const Text(
                            "Password",
                            style: TextStyle(
                              color: Color(0xff3c1d99),
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
                                    color: Color(0xff3c1d99)),
                              ),
                            ),
                          ),
                          const SizedBox(height: 25),
                          const Text(
                            "Confirm Password",
                            style: TextStyle(
                              color: Color(0xff3c1d99),
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
                                    color: Color(0xff3c1d99)),
                              ),
                            ),
                          ),
                          const SizedBox(height: 35),

                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color(0xff191c19),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              minimumSize: Size(double.infinity,56),
                            ),
                            onPressed: () async {
                              if (formKey.currentState?.validate() ?? false) {
                                final message = await AuthService.instance.signup(
                                  nameController.text.trim(),
                                  emailController.text.trim(),
                                  passwordController.text,
                                );
                                if (message == null) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('Account created successfully!'),
                                      backgroundColor: Colors.green,
                                    ),
                                  );
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(builder: (context) => LoginPage()),
                                  );
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(message),
                                      backgroundColor: Colors.redAccent,
                                    ),
                                  );
                                }
                              }
                            },
                            child: Text('sign up'.toUpperCase(),
                              style: AppTextStyle.poppinsMedium.copyWith(
                                fontSize: 18,
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
                                    fontSize: 16,
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
                                      fontSize: 16,
                                      color: Color(0xff3c1d99),
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