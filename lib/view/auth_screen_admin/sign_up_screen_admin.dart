import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hotel_kitchen_management_app/constants/color_constants.dart';
import 'package:hotel_kitchen_management_app/controller/auth_controller/password_contoller.dart';
import 'package:hotel_kitchen_management_app/controller/loading_controller.dart';
import 'package:hotel_kitchen_management_app/utils/custom_sizedbox.dart';
import 'package:hotel_kitchen_management_app/widgets/auth_widgets/custom_button.dart';
import 'package:hotel_kitchen_management_app/widgets/auth_widgets/custom_text_field.dart';
import 'package:provider/provider.dart';

import '../../utils/mediaquery.dart';
import '../../utils/page_navigation_animation_widget.dart';
import 'sign_in_screen_admin.dart';

class SignUpPageAdmin extends StatefulWidget {
  const SignUpPageAdmin({super.key});

  @override
  State<SignUpPageAdmin> createState() => _SignUpPageAdminState();
}

class _SignUpPageAdminState extends State<SignUpPageAdmin> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final FirebaseAuth authInstance = FirebaseAuth.instance;
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController usernameContoller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    bool isValidUsername(String username) {
      // Use a regular expression to check if the username contains only alphanumeric characters
      return RegExp(r'^[a-zA-Z0-9]+$').hasMatch(username);
    }

    double height = CustomeSize.customHeight(context);
    double width = CustomeSize.customWidth(context);
    var isloadingprovider = Provider.of<LoadingProvider>(context);

    var textScale = CustomeSize.textScaleFactor(context);
    return Scaffold(
      body: Padding(
          padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
          child: SingleChildScrollView(
            child: Form(
              key: formKey,
              autovalidateMode: AutovalidateMode.always,
              child: Column(
                children: [
                  SafeArea(
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      decoration: const BoxDecoration(
                          color: ColorConst.customWhite,
                          borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(15),
                              bottomRight: Radius.circular(15))),
                      child: Column(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Hotel Kitchen Management App",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: textScale * 23),
                              ),
                              Text(
                                "Hi Admin,",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: textScale * 23),
                              ),
                            ],
                          ),
                          SizedBox(
                              height: height * 0.2,
                              child: Image.asset(
                                  fit: BoxFit.contain, "assets/png/chef.png")),
                        ],
                      ),
                    ),
                  ),
                  kHeight(height * 0.01),
                  Container(
                    height: height * 0.7,
                    padding: const EdgeInsets.all(30),
                    decoration: const BoxDecoration(
                        color: ColorConst.customWhite,
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(15),
                            topRight: Radius.circular(15))),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Row(
                          children: [
                            Text(
                              "Sign Up",
                              style: TextStyle(
                                  fontWeight: FontWeight.w900,
                                  fontSize: textScale * 23),
                            ),
                          ],
                        ),
                        kHeight(20),
                        CustomTextField(
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Username is required';
                              } else if (!isValidUsername(value)) {
                                return 'Invalid username. Alphanumeric characters only.';
                              }
                              return null;
                            },
                            hintText: "Username",
                            labelText: "Username",
                            controller: usernameContoller),
                        kHeight(20),
                        CustomTextField(
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your email';
                              } else if (!RegExp(
                                      r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$')
                                  .hasMatch(value)) {
                                return 'Please enter a valid email address';
                              }
                              return null;
                            },
                            hintText: "Email",
                            labelText: "Email",
                            controller: emailController),
                        kHeight(20),
                        Consumer<PasswordProvider>(
                            builder: (context, passwordProvider, child) {
                          return CustomTextField(
                              obscureText: passwordProvider.isvisible,
                              suffixIcon: IconButton(
                                icon: Icon(
                                  passwordProvider.isvisible
                                      ? Icons.visibility_off
                                      : Icons.visibility,
                                ),
                                onPressed: () {
                                  passwordProvider
                                      .isVisible(passwordProvider.isvisible);
                                },
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your password';
                                } else if (value.length < 6) {
                                  return 'Password must be at least 6 characters';
                                }
                                return null;
                              },
                              hintText: "Password",
                              labelText: "Password",
                              controller: passwordController);
                        }),
                        kHeight(10),
                        isloadingprovider.isLoading
                            ? CircularProgressIndicator()
                            : Center(
                                child: CustomButton(
                                  onPressed: () =>
                                      submitForm(isloadingprovider),
                                  width: width * 0.3,
                                  buttonName: "Sign Up",
                                ),
                              ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text("Already Have An Account Sign in ? "),
                            TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: const Text(
                                  "Sign In",
                                  style: TextStyle(
                                      color: Color.fromARGB(255, 255, 132, 0),
                                      fontWeight: FontWeight.w900),
                                ))
                          ],
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          )),
    );
  }

  void submitForm(LoadingProvider isloadingprovider) async {
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();
      isloadingprovider.setLoading(true);
      try {
        await authInstance.createUserWithEmailAndPassword(
            email: emailController.text, password: passwordController.text);
        final uid = authInstance.currentUser!.uid;
        await FirebaseFirestore.instance.collection("admins").doc(uid).set({
          "id": uid,
          "name": usernameContoller.text,
          "email": emailController.text,
          "createdAt": Timestamp.now(),
          "role": "admin",
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Registration Complete!'),
          ),
        );
        isloadingprovider.setLoading(false);
        Navigator.of(context)
            .pushReplacement(SlidePageRoute(page: SigninPageAdmin()));
      } on FirebaseAuthException catch (error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('ERROR OCCURED $error '),
          ),
        );
        isloadingprovider.setLoading(false);
      } catch (error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('ERROR OCCURED $error '),
          ),
        );
        isloadingprovider.setLoading(false);
      } finally {
        isloadingprovider.setLoading(false);
      }

      usernameContoller.clear();
      emailController.clear();
      passwordController.clear();
    }
  }
}
