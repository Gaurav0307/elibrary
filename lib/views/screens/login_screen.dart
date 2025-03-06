import 'package:elibrary/common/global/global.dart';
import 'package:elibrary/views/screens/register_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../common/constants/color_constants.dart';
import '../../common/constants/string_constants.dart';
import '../../common/utils/utility_methods.dart';
import '../widgets/border_button.dart';
import '../widgets/gradient_button.dart';
import 'home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  void initState() {
    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.manual,
      overlays: [
        SystemUiOverlay.top,
        SystemUiOverlay.bottom,
      ],
    );

    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
      ),
    );

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false, //It should be false to work
      onPopInvokedWithResult: (didPop, _) async {
        if (didPop) {
          return;
        }
        await _onBackPressed();
      },
      child: Scaffold(
        body: Center(
          child: SingleChildScrollView(
            child: Container(
              margin: const EdgeInsets.all(25.0),
              padding: const EdgeInsets.all(25.0),
              clipBehavior: Clip.hardEdge,
              decoration: BoxDecoration(
                color: ColorConstants.theWhite,
                borderRadius: BorderRadius.circular(20.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.shade400,
                    spreadRadius: 2.0,
                    blurRadius: 8.0,
                  )
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    StringConstants.login,
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.w500,
                      color: ColorConstants.theBlack,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 25.0),
                  const LoginForm(),
                  const SizedBox(height: 55.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        StringConstants.doNotHaveAnAccount,
                        style: TextStyle(
                          color: ColorConstants.theBlack,
                          fontSize: 15.0,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      const SizedBox(width: 10),
                      BorderButton(
                        width: 80,
                        padding: const EdgeInsets.symmetric(
                          vertical: 5.0,
                          horizontal: 0.0,
                        ),
                        onPressed: () async {
                          Get.to(() => const RegisterScreen());
                        },
                        child: Text(
                          StringConstants.register,
                          style: TextStyle(
                            fontSize: 12,
                            color: ColorConstants.theBlack,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _onBackPressed() async {
    await showAdaptiveDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text(
            StringConstants.confirm,
            style: TextStyle(
              color: Colors.red,
            ),
          ),
          content: const Text(StringConstants.doYouWantToExitTheApp),
          actions: <Widget>[
            TextButton(
              child: const Text(
                StringConstants.no,
                style: TextStyle(color: Colors.blue),
              ),
              onPressed: () {
                Navigator.of(context).pop(); //Will not exit the App
              },
            ),
            TextButton(
              child: const Text(
                StringConstants.yes,
                style: TextStyle(color: Colors.red),
              ),
              onPressed: () {
                SystemNavigator.pop();
                Navigator.of(context).pop(); //Will exit the App
              },
            )
          ],
        );
      },
    );
  }
}

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  String email = '';
  String password = '';

  bool _showPassword = false;

  final _formKey = GlobalKey<FormState>();

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty || UtilityMethods.isBlank(value)) {
      return StringConstants.emailIsRequired;
    }
    if (!RegExp(r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$')
        .hasMatch(value)) {
      return StringConstants.enterAValidEmailAddress;
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty || UtilityMethods.isBlank(value)) {
      return StringConstants.passwordIsRequired;
    }
    if (value.length < 6) {
      return StringConstants.passwordMustHaveAtLeast8Characters;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            style: const TextStyle(color: Colors.black87),
            validator: _validateEmail,
            inputFormatters: [
              FilteringTextInputFormatter.allow(
                RegExp(r'[a-zA-Z0-9@._-]'), // Allow valid email characters
              ),
            ],
            decoration: const InputDecoration(
              hintText: StringConstants.email,
              hintStyle: TextStyle(color: Colors.black87),
              prefixIcon: Icon(
                Icons.mail_outlined,
                color: Colors.black87,
              ),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.black87),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.black87),
              ),
              contentPadding: EdgeInsets.all(15.0),
            ),
            keyboardType: TextInputType.emailAddress,
            onChanged: (val) {
              email = val;
            },
          ),
          const SizedBox(height: 16),
          TextFormField(
            style: const TextStyle(color: Colors.black87),
            obscureText: !_showPassword,
            // validator: _validatePassword,
            decoration: InputDecoration(
              hintText: StringConstants.password,
              hintStyle: const TextStyle(color: Colors.black87),
              prefixIcon: const Icon(
                Icons.lock_outline_rounded,
                color: Colors.black87,
              ),
              suffixIcon: IconButton(
                icon: Icon(
                  _showPassword
                      ? Icons.visibility_outlined
                      : Icons.visibility_off_outlined,
                  color: Colors.black87,
                ),
                onPressed: () {
                  setState(() {
                    _showPassword = !_showPassword;
                  });
                },
              ),
              enabledBorder: const UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.black87),
              ),
              focusedBorder: const UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.black87),
              ),
              contentPadding: const EdgeInsets.all(15.0),
            ),
            onChanged: (val) {
              password = val;
            },
          ),
          const SizedBox(height: 20.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              GestureDetector(
                onTap: () {
                  // Get.to(() => const ForgotPasswordScreen());
                },
                child: Text(
                  StringConstants.forgotPassword,
                  style: TextStyle(
                    color: ColorConstants.theBlack,
                    fontSize: 16.0,
                    fontWeight: FontWeight.w400,
                    decoration: TextDecoration.underline,
                    decorationColor: ColorConstants.theBlack,
                  ),
                ),
              ),
              const SizedBox(width: 8.0),
            ],
          ),
          const SizedBox(height: 50.0),
          Obx(
            () => Visibility(
              visible: !authController.isLoading.value,
              replacement: Center(
                child: CircularProgressIndicator(
                  color: ColorConstants.theIndigo,
                  strokeWidth: 3.0,
                ),
              ),
              child: GradientButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    FocusScope.of(context).unfocus();
                    if (await authController.login(email, password)) {
                      Get.to(() => const HomeScreen());
                    }
                  }
                },
                child: Text(
                  StringConstants.login,
                  style: TextStyle(
                    fontSize: 16,
                    color: ColorConstants.theWhite,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
