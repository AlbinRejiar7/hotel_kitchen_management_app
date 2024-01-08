// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hotel_kitchen_management_app/constants/color_constants.dart';
import 'package:hotel_kitchen_management_app/controller/auth_controller/password_contolller.dart';
import 'package:hotel_kitchen_management_app/controller/loading_controller.dart';
import 'package:hotel_kitchen_management_app/utils/custom_sizedbox.dart';
import 'package:hotel_kitchen_management_app/view/auth_screen_chef/sign_up_screen.dart';
import 'package:hotel_kitchen_management_app/view/chefs_pages/chef_home_page.dart';
import 'package:hotel_kitchen_management_app/widgets/auth_widgets/custom_button.dart';
import 'package:hotel_kitchen_management_app/widgets/auth_widgets/custom_text_field.dart';
import 'package:provider/provider.dart';

import '../../utils/mediaquery.dart';
import '../../utils/page_navigation_animation_widget.dart';

class SingInPageChef extends StatefulWidget {
  const SingInPageChef({super.key});

  @override
  State<SingInPageChef> createState() => _SingInPageChefState();
}

class _SingInPageChefState extends State<SingInPageChef> {
  final FirebaseAuth authInstance = FirebaseAuth.instance;
  void submitForm(LoadingProvider isloadingprovider) async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      isloadingprovider.setLoading(true);
      try {
        await authInstance.signInWithEmailAndPassword(
            email: emailController.text, password: passwordController.text);
        final user = authInstance.currentUser;
        final userId = user!.uid;
        await FirebaseFirestore.instance
            .collection("chefs")
            .doc(userId)
            .get()
            .then((snapshot) {
          if (snapshot["role"].toString() == "chef") {
            Navigator.of(context).popUntil((route) => route.isFirst);
            Navigator.of(context).pushReplacement(MaterialPageRoute(
              builder: (context) {
                return ChefHomePage();
              },
            ));
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('You are not Chef!'),
              ),
            );
          }
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Logged In!'),
          ),
        );
        isloadingprovider.setLoading(false);
      } on FirebaseAuthException catch (e) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(e.message!)));
      } catch (e) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(e as String)));
      } finally {
        isloadingprovider.setLoading(false);
      }

      emailController.clear();
      passwordController.clear();
    } else {
      // Form is invalid
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Enter all fields")));
    }
  }

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    var isloadingprovider = Provider.of<LoadingProvider>(context);
    var height = CustomeSize.customHeight(context);
    var width = CustomeSize.customWidth(context);

    var textScale = CustomeSize.textScaleFactor(context);
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Padding(
        padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: Column(
              children: [
                SafeArea(
                  child: Container(
                    width: double.infinity,
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
                              "Hi Chef,",
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
                            "Sign In",
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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(
                              onPressed: () {},
                              child: const Text("Forgort Password...?")),
                        ],
                      ),
                      kHeight(10),
                      Center(
                        child: isloadingprovider.isLoading
                            ? CircularProgressIndicator()
                            : CustomButton(
                                onPressed: () => submitForm(isloadingprovider),
                                width: width * 0.3,
                                buttonName: "Sign In",
                              ),
                      ),
                      const Text("Or"),
                      const Text("Connect Using"),
                      Card(
                        elevation: 2,
                        shape: const CircleBorder(),
                        child: GestureDetector(
                          onTap: () {
                            print("object");
                          },
                          child: const CircleAvatar(
                            backgroundImage: NetworkImage(
                                "https://cdn.dribbble.com/users/904380/screenshots/2233565/attachments/415915/revised-google-logo.png"),
                            radius: 25,
                            backgroundColor: ColorConst.customWhite,
                          ),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text("Didn't have an account ? "),
                          TextButton(
                              onPressed: () {
                                Navigator.of(context).push(SlidePageRoute(
                                    page: const SignUpPageChef()));
                              },
                              child: const Text(
                                "Sign Up",
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
        ),
      ),
    );
  }
}
