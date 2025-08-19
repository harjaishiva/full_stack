
import 'package:e_commerce_app/screens/forget_password/cubit/forget_password_cubit.dart';
import 'package:e_commerce_app/screens/sign_in_screen/cubit/sign_in_cubit.dart';
import 'package:e_commerce_app/screens/sign_in_screen/sign_in_view.dart';
import 'package:e_commerce_app/utils/constants/methods.dart';
import 'package:e_commerce_app/utils/constants/variables.dart';
import 'package:e_commerce_app/utils/popup_message/pop_up.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pinput/pinput.dart';

class ForgetPasswordScreen extends StatefulWidget {
  const ForgetPasswordScreen({super.key});

  @override
  State<ForgetPasswordScreen> createState() => _ForgetPasswordScreenState();
}

class _ForgetPasswordScreenState extends State<ForgetPasswordScreen> {
  GlobalKey<FormState> newPasswordFormKey = GlobalKey();
  GlobalKey<FormState> conPasswordFormKey = GlobalKey();
  GlobalKey<FormState> emailFormKey = GlobalKey();
  TextEditingController newPasswordController = TextEditingController();
  TextEditingController conPasswordController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController otpController = TextEditingController();
  FocusNode emailNode = FocusNode();
  FocusNode newPassNode = FocusNode();
  FocusNode conPassNode = FocusNode();

  bool showEmail = true;
  bool showOtp = false;
  bool showPass = false;

  @override
  void initState() {
    super.initState();
    showEmail = true;
    showOtp = false;
    showPass = false;
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ForgetPasswordCubit, ForgetPasswordState>(
      listener: (context, state) {
        if (state.emailSuccess) {
          setState(() {
            showEmail = false;
            showOtp = true;
          });
        }
        if (state.otpSuccess) {
          setState(() {
            showOtp = false;
            showPass = true;
          });
        }
        if (state.passSuccess) {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (_) => BlocProvider(
                      create: (context) => SignInCubit(),
                      child: const SignInScreen())));
        }
      },
      child: Scaffold(
        appBar: AppBar(
          leading: GestureDetector(
              onTap: () {
                Navigator.of(context).pop();
              },
              child: const Icon(Icons.arrow_back, color: Colors.white)),
          centerTitle: true,
          title: const Text("Forget Password",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 26,
                  fontWeight: FontWeight.w600)),
          backgroundColor: themeColor,
        ),
        body: BlocBuilder<ForgetPasswordCubit, ForgetPasswordState>(
          builder: (context, state) {
            return 
            state.loading ? 
            const Center(
              child: SizedBox(
                height:50,
                width:50,
                child: CircularProgressIndicator(
                  color: themeColor
                ),
                ),
            ) : 
            Column(
              children: [
                const SizedBox(height: 20),
                showEmail
                    ? header("Enter your Email Id for verification:")
                    : const SizedBox(),
                showEmail
                    ? textFeild(emailFormKey, emailController, emailNode)
                    : const SizedBox(),
                showOtp ? header("Enter OTP:") : const SizedBox(),
                showOtp ? otpFeild() : const SizedBox(),
                showPass
                    ? header("Enter your New Password:")
                    : const SizedBox(),
                showPass
                    ? textFeild(
                        newPasswordFormKey, newPasswordController, newPassNode)
                    : const SizedBox(),
                showPass
                    ? header("Re-Enter your New Password:")
                    : const SizedBox(),
                showPass
                    ? textFeild(
                        conPasswordFormKey, conPasswordController, conPassNode)
                    : const SizedBox(),
                const Spacer(),
                GestureDetector(
                    onTap: () {
                      if (showEmail) {
                        if (emailController.text.isNotEmpty) {
                          context
                              .read<ForgetPasswordCubit>()
                              .reqOtp(emailController.text);
                        } else {
                          showAlertMessage(
                              context: context,
                              message: "Enter Email id first!");
                        }
                      } else if (showOtp) {
                        if (otpController.text.isNotEmpty) {
                          context.read<ForgetPasswordCubit>().verifyOtp(
                              emailController.text, otpController.text);
                        } else {
                          showAlertMessage(
                              context: context, message: "Enter OTP first!");
                        }
                      } else if (showPass) {
                        if (newPasswordController.text.isEmpty) {
                          showAlertMessage(
                              context: context,
                              message: "Enter password first!");
                        } else if (conPasswordController.text !=
                            newPasswordController.text) {
                          showAlertMessage(
                              context: context,
                              message: "Passwords do not match!");
                        } else {
                          context.read<ForgetPasswordCubit>().updatePass(
                              emailController.text, newPasswordController.text);
                        }
                      }
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(left: 20, right: 20),
                      child: Container(
                          alignment: Alignment.center,
                          height: 50,
                          width: double.infinity,
                          decoration: BoxDecoration(
                              color: buttonColor,
                              borderRadius: BorderRadius.circular(15)),
                          child: Text(buttonText(),
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w500))),
                    )),
                const SizedBox(height: 20),
              ],
            );
          },
        ),
      ),
    );
  }

  buttonText() {
    if (showEmail) {
      return "Send OTP";
    } else if (showOtp) {
      return "Submit OTP";
    } else {
      return "Update Password";
    }
  }

  Widget header(String heading) {
    return Row(
      children: [
        const Bullet(),
        Container(
            padding: const EdgeInsets.only(left: 10),
            alignment: Alignment.centerLeft,
            child: Text(heading,
                style: const TextStyle(color: Colors.black, fontSize: 18))),
      ],
    );
  }

  Widget textFeild(GlobalKey key, TextEditingController cont, FocusNode node) {
    return Container(
      height: 95,
      padding: const EdgeInsets.only(left: 30, right: 30, top: 10, bottom: 10),
      child: Form(
        key: key,
        child: TextFormField(
          controller: cont,
          focusNode: node,
          cursorColor: Colors.black,
          decoration: InputDecoration(
              border: borderStyle(),
              errorBorder: borderStyle(),
              enabledBorder: borderStyle(),
              focusedBorder: borderStyle(),
              disabledBorder: borderStyle(),
              focusedErrorBorder: borderStyle(),
              helperText: " ",
              helperStyle: const TextStyle(height: 0.5),
              errorStyle: const TextStyle(height: 0.5)),
          onChanged: (event) {
            // altColor();
          },
        ),
      ),
    );
  }

  otpFeild() {
    return Pinput(
      controller: otpController,
      length: 4,
      defaultPinTheme: pinTheme(),
      separatorBuilder: (index) => const SizedBox(width: 20),
    );
  }

  pinTheme() {
    return PinTheme(
      width: 50,
      height: 50,
      margin: const EdgeInsets.only(top: 10, bottom: 10),
      textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
      decoration: BoxDecoration(
          color: const Color.fromARGB(255, 140, 241, 220),
          borderRadius: BorderRadius.circular(8)),
    );
  }
}
