import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cehpoint_marketplace/authentication/Views/loginView/login_controller.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:cehpoint_marketplace/common/colors.dart';
import 'package:cehpoint_marketplace/common/utils.dart';
import 'package:cehpoint_marketplace/routes/app_routes.dart';

class LoginView extends StatelessWidget {
  const LoginView({super.key});
  @override
  Widget build(BuildContext context) {
    final controller = Get.put(LoginController());
    final formKey = GlobalKey<FormState>();

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      body: GetBuilder<LoginController>(
        builder: (_) => Stack(
          children: [
            Container(
              height: 300,
              color: ColorConstants.blue700,
              child: Stack(
                children: [
                  Container(
                    margin: const EdgeInsets.fromLTRB(30, 50, 30, 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 30),
                        const Text(
                          'Welcome to\nCehpoint Marketplace!',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 40,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Container(
                          width: 35,
                          height: 8,
                          decoration: BoxDecoration(
                            color: ColorConstants.orange500,
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // main part
            Container(
              margin: const EdgeInsets.fromLTRB(30, 320, 30, 0),
              child: Form(
                key: formKey, // Add Form key
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Email',
                      textAlign: TextAlign.right,
                    ),
                    TextFormField(
                      controller: controller.email,
                      decoration: const InputDecoration(
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: ColorConstants.blue700),
                          borderRadius: BorderRadius.all(Radius.circular(5.0)),
                        ),
                        border: OutlineInputBorder(),
                        contentPadding: EdgeInsets.symmetric(
                          vertical: 10.0,
                          horizontal: 16.0,
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Enter Email';
                        }
                        return null;
                      },
                    ),

                    // password
                    SizedBox(height: Get.height * 0.01),
                    const Text('Password'),
                    GetBuilder<LoginController>(
                      builder: (_) => TextFormField(
                        controller: controller.password,
                        obscureText: !controller.isPasswordVisible,
                        decoration: InputDecoration(
                          enabledBorder: const OutlineInputBorder(
                            borderSide:
                                BorderSide(color: ColorConstants.blue700),
                            borderRadius:
                                BorderRadius.all(Radius.circular(5.0)),
                          ),
                          border: const OutlineInputBorder(),
                          contentPadding: const EdgeInsets.symmetric(
                              vertical: 10.0, horizontal: 16.0),
                          suffixIcon: IconButton(
                            icon: Icon(
                              controller.isPasswordVisible
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                            ),
                            onPressed: () =>
                                controller.togglePasswordVisibleFunc(),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Enter Your Password';
                          }
                          return null;
                        },
                      ),
                    ),

                    // forgot pass
                    SizedBox(height: Get.height * 0.02),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: 'Forgot Password?',
                                style: const TextStyle(
                                  color: Colors.blue,
                                  fontSize: 12,
                                ),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    Fluttertoast.showToast(
                                        msg: 'Forgot password');
                                  },
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    // seperator
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Container(
                            height: 1,
                            color: Colors.grey,
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 8),
                          child: Text('or'),
                        ),
                        Expanded(
                          child: Container(
                            height: 1,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),

                    // social login
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // GestureDetector(
                        //   onTap: () {
                        //     Fluttertoast.showToast(msg: 'Facebook login');
                        //   },
                        //   child: Container(
                        //     // padding: EdgeInsets.all(8.0),
                        //     decoration: BoxDecoration(
                        //       borderRadius: BorderRadius.circular(8.0),
                        //     ),
                        //     child: Image.asset(
                        //       'assets/fb_sign.png',
                        //     ),
                        //   ),
                        // ),
                        GestureDetector(
                          onTap: () {
                            Get.find<LoginController>().googleSignIn();
                          },
                          child: Container(
                            // padding: EdgeInsets.all(8.0),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            child: Image.asset(
                              'assets/google_sign.png',
                            ),
                          ),
                        ),
                      ],
                    ),
                    // Log In button
                    SizedBox(height: Get.height * 0.02),

                    if (controller.isLoading)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Text('Loading'),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Utils.customLoadingSpinner(),
                          ),
                        ],
                      )
                    else
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: TextButton(
                                  style: ButtonStyle(
                                    backgroundColor: WidgetStateProperty.all(
                                        ColorConstants.blue700),
                                    shape: WidgetStateProperty.all<
                                        RoundedRectangleBorder>(
                                      RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                  ),
                                  onPressed: () async {
                                    if (formKey.currentState!.validate()) {
                                      controller.logIn();
                                    }
                                  },
                                  child: const SizedBox(
                                    height: 35,
                                    child: Center(
                                      child: Text(
                                        'Login',
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 25),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),

                          // Switch to Register section
                          const SizedBox(height: 12),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text('New Here?'),
                              const SizedBox(
                                width: 10,
                              ),
                              TextButton(
                                onPressed: () {
                                  Get.toNamed(AppRoutes.registerScreen);
                                },
                                style: ButtonStyle(
                                  side: WidgetStateProperty.all(
                                    const BorderSide(
                                      color: Colors.blue,
                                      width: 2.0,
                                    ),
                                  ),
                                  shape: WidgetStateProperty.all(
                                    RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(0),
                                    ),
                                  ),
                                ),
                                child: const Text('Register'),
                              ),
                            ],
                          ),
                        ],
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
