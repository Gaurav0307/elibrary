import 'package:elibrary/common/global/global.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';

import '../../common/constants/color_constants.dart';
import '../../common/constants/string_constants.dart';
import '../../common/utils/utility_methods.dart';
import '../widgets/border_button.dart';
import '../widgets/gradient_button.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: ColorConstants.theBlack,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 50.0,
            vertical: 50.0,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                StringConstants.register,
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.w500,
                  color: ColorConstants.theBlack,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 25.0),
              const RegisterForm(),
              const SizedBox(height: 60.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    StringConstants.alreadyHaveAnAccount,
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
                    onPressed: () {
                      Get.back();
                    },
                    child: Text(
                      StringConstants.login,
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
    );
  }
}

class RegisterForm extends StatefulWidget {
  const RegisterForm({super.key});

  @override
  State<RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  String fullName = '';
  String mobile = '';
  String collegeName = '';
  String email = '';
  String password = '';
  String confirmPassword = '';

  bool _showPassword = false;
  bool _showConfirmPassword = false;

  final _formKey = GlobalKey<FormState>();

  String? _validateFullName(String? value) {
    if (value == null || value.isEmpty || UtilityMethods.isBlank(value)) {
      return StringConstants.fullNameIsRequired;
    }
    return null;
  }

  String toTitleCase(String text) {
    if (text.isEmpty) return '';

    final words = text.split(' ');
    final titleCaseWords = words.map((word) {
      if (word.isNotEmpty) {
        return word[0].toUpperCase() + word.substring(1).toLowerCase();
      }
      return '';
    });

    return titleCaseWords.join(' ');
  }

  String? _validateMobileNumber(String? value) {
    if (value == null || value.isEmpty || UtilityMethods.isBlank(value)) {
      return StringConstants.mobileNumberIsRequired;
    }

    if (!RegExp(r'^\d{10}$').hasMatch(value)) {
      return StringConstants.enterAValid10DigitMobileNumber;
    }

    return null;
  }

  String? _validateCollegeName(String? value) {
    if (value == null || value.isEmpty || UtilityMethods.isBlank(value)) {
      return StringConstants.collegeNameIsRequired;
    }
    return null;
  }

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
    if (value.length < 8) {
      return StringConstants.passwordMustHaveAtLeast8Characters;
    }
    // Password must contain at least 8 characters, one uppercase letter, one lowercase letter, and one number
    final RegExp passwordRegExp = RegExp(
      r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d).{8,}$',
    );
    if (!passwordRegExp.hasMatch(value)) {
      return StringConstants.thePasswordMustContainAtLeast;
    }
    return null;
  }

  bool isPasswordValid(String password) {
    // Password must contain at least 8 characters, one uppercase letter, one lowercase letter, and one number
    final RegExp passwordRegExp = RegExp(
      r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d).{8,}$',
    );

    return passwordRegExp.hasMatch(password);
  }

  PhoneNumber number = PhoneNumber(isoCode: 'IN');

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            style: TextStyle(color: ColorConstants.theBlack),
            validator: _validateFullName,
            inputFormatters: [
              FilteringTextInputFormatter.allow(
                  RegExp(r'[a-zA-Z ]') // Allow alphabets and space
                  ),
              TextInputFormatter.withFunction(
                (oldValue, newValue) {
                  // Convert the new input to title case
                  if (newValue.text.isNotEmpty) {
                    final convertedValue = toTitleCase(newValue.text);
                    return TextEditingValue(
                      text: convertedValue,
                      selection: TextSelection.fromPosition(
                        TextPosition(offset: convertedValue.length),
                      ),
                    );
                  }
                  return newValue;
                },
              ),
            ],
            maxLength: 30,
            maxLengthEnforcement: fullName.isNotEmpty
                ? MaxLengthEnforcement.enforced
                : MaxLengthEnforcement.none,
            decoration: InputDecoration(
              counterText: fullName.isNotEmpty ? null : "",
              hintText: StringConstants.fullName,
              hintStyle: TextStyle(color: ColorConstants.theBlack),
              prefixIcon: Icon(
                Icons.person_outline,
                color: ColorConstants.theBlack,
              ),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: ColorConstants.theBlack),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: ColorConstants.theBlack),
              ),
              contentPadding: const EdgeInsets.all(15.0),
            ),
            keyboardType: TextInputType.name,
            onChanged: (val) {
              setState(() {
                fullName = val;
              });
            },
          ),
          const SizedBox(height: 16),
          InternationalPhoneNumberInput(
            onInputChanged: (PhoneNumber number) {
              mobile = number.phoneNumber!;
            },
            validator: _validateMobileNumber,
            selectorConfig: const SelectorConfig(
              selectorType: PhoneInputSelectorType.BOTTOM_SHEET,
            ),
            ignoreBlank: false,
            autoValidateMode: AutovalidateMode.disabled,
            selectorTextStyle: const TextStyle(color: Colors.black),
            initialValue: number,
            // textFieldController: mobileTEC,
            formatInput: false,
            keyboardType: const TextInputType.numberWithOptions(
              signed: true,
              decimal: true,
            ),
            inputDecoration: InputDecoration(
              hintText: StringConstants.mobileNumber,
              contentPadding: const EdgeInsets.all(15.0),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: ColorConstants.theBlack),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: ColorConstants.theBlack),
              ),
            ),
          ),
          const SizedBox(height: 16),
          TextFormField(
            style: TextStyle(color: ColorConstants.theBlack),
            validator: _validateCollegeName,
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(
                      r'[a-zA-Z .,]') // Allow alphabets, space, dot and comma
                  ),
              // TextInputFormatter.withFunction(
              //   (oldValue, newValue) {
              //     // Convert the new input to title case
              //     if (newValue.text.isNotEmpty) {
              //       final convertedValue = toTitleCase(newValue.text);
              //       return TextEditingValue(
              //         text: convertedValue,
              //         selection: TextSelection.fromPosition(
              //           TextPosition(offset: convertedValue.length),
              //         ),
              //       );
              //     }
              //     return newValue;
              //   },
              // ),
            ],
            maxLines: 2,
            minLines: 1,
            maxLength: 100,
            maxLengthEnforcement: collegeName.isNotEmpty
                ? MaxLengthEnforcement.enforced
                : MaxLengthEnforcement.none,
            decoration: InputDecoration(
              counterText: collegeName.isNotEmpty ? null : "",
              hintText: StringConstants.collegeName,
              hintStyle: TextStyle(color: ColorConstants.theBlack),
              prefixIcon: Icon(
                Icons.menu_book_sharp,
                color: ColorConstants.theBlack,
              ),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: ColorConstants.theBlack),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: ColorConstants.theBlack),
              ),
              contentPadding: const EdgeInsets.all(15.0),
            ),
            keyboardType: TextInputType.name,
            onChanged: (val) {
              setState(() {
                collegeName = val;
              });
            },
          ),
          const SizedBox(height: 16),
          TextFormField(
            style: TextStyle(color: ColorConstants.theBlack),
            validator: _validateEmail,
            inputFormatters: [
              FilteringTextInputFormatter.allow(
                RegExp(r'[a-zA-Z0-9@._-]'), // Allow valid email characters
              ),
            ],
            decoration: InputDecoration(
              hintText: StringConstants.email,
              hintStyle: TextStyle(color: ColorConstants.theBlack),
              prefixIcon: Icon(
                Icons.mail_outlined,
                color: ColorConstants.theBlack,
              ),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: ColorConstants.theBlack),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: ColorConstants.theBlack),
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
            style: TextStyle(color: ColorConstants.theBlack),
            obscureText: !_showPassword,
            validator: _validatePassword,
            decoration: InputDecoration(
              hintText: StringConstants.password,
              hintStyle: TextStyle(color: ColorConstants.theBlack),
              prefixIcon: Icon(
                Icons.lock_outline_rounded,
                color: ColorConstants.theBlack,
              ),
              suffixIcon: IconButton(
                icon: Icon(
                  _showPassword
                      ? Icons.visibility_outlined
                      : Icons.visibility_off_outlined,
                  color: ColorConstants.theBlack,
                ),
                onPressed: () {
                  setState(() {
                    _showPassword = !_showPassword;
                  });
                },
              ),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: ColorConstants.theBlack),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: ColorConstants.theBlack),
              ),
              contentPadding: const EdgeInsets.all(15.0),
            ),
            onChanged: (val) {
              password = val;
            },
          ),
          const SizedBox(height: 16),
          TextFormField(
            style: TextStyle(color: ColorConstants.theBlack),
            obscureText: !_showConfirmPassword,
            validator: (value) {
              if (value != password) {
                return StringConstants.passwordsDoNotMatch;
              }
              return null;
            },
            decoration: InputDecoration(
              hintText: StringConstants.confirmPassword,
              hintStyle: TextStyle(color: ColorConstants.theBlack),
              prefixIcon: Icon(
                Icons.lock_outline_rounded,
                color: ColorConstants.theBlack,
              ),
              suffixIcon: IconButton(
                icon: Icon(
                  _showConfirmPassword
                      ? Icons.visibility_outlined
                      : Icons.visibility_off_outlined,
                  color: ColorConstants.theBlack,
                ),
                onPressed: () {
                  setState(() {
                    _showConfirmPassword = !_showConfirmPassword;
                  });
                },
              ),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: ColorConstants.theBlack),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: ColorConstants.theBlack),
              ),
              contentPadding: const EdgeInsets.all(15.0),
            ),
            onChanged: (val) {
              confirmPassword = val;
            },
          ),
          const SizedBox(height: 40.0),
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

                    ///Split firstName and lastName from fullName
                    String firstName = '';
                    String lastName = '';
                    List<String> nameParts = fullName
                        .trim()
                        .split(RegExp(r'\s+')); // Split by spaces

                    if (nameParts.length == 1) {
                      // If there's only one word, set it as firstName
                      firstName = nameParts[0];
                      lastName = '.';
                    } else {
                      lastName = nameParts
                          .removeLast(); // Extract the last word as lastName
                      firstName = nameParts
                          .join(" "); // Join the remaining words as firstName
                    }

                    if (await authController.register(firstName, lastName,
                        email, password, mobile, collegeName)) {
                      Navigator.pop(context);
                    }
                  }
                },
                child: Text(
                  StringConstants.register,
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
