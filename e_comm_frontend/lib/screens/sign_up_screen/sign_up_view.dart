import 'package:e_commerce_app/screens/sign_in_screen/cubit/sign_in_cubit.dart';
import 'package:e_commerce_app/screens/sign_in_screen/sign_in_view.dart';
import 'package:e_commerce_app/screens/sign_up_screen/cubit/sign_up_cubit.dart';
import 'package:e_commerce_app/utils/constants/variables.dart';
import 'package:e_commerce_app/utils/constants/methods.dart';
import 'package:e_commerce_app/utils/popup_message/pop_up.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  TextEditingController nameController = TextEditingController();

  TextEditingController emailController = TextEditingController();

  TextEditingController passwordController = TextEditingController();

  TextEditingController confirmPasswordController = TextEditingController();

  bool isValidate = false;
  bool colorchng = false;

  final GlobalKey<FormState> _nameFormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _emailFormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _passwordFormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _cpasswordFormKey = GlobalKey<FormState>();

  final FocusNode nameNode = FocusNode();
  final FocusNode emailNode = FocusNode();
  final FocusNode passwordNode = FocusNode();
  final FocusNode cpasswordNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return BlocListener<SignUpCubit, SignUpState>(
      listener: (context, state) {
        if(state.success){
          showAlertMessage(context: context, message: state.data['message'],
          voidCallback: ()=>{
            Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => BlocProvider(
                                create: (context) => SignInCubit(),
                                child: const SignInScreen())))
          });
        }
        else{
          showAlertMessage(context: context, message: state.data['message']);
        }
      },
      child: Scaffold(
        appBar: AppBar(
            leading: GestureDetector(
                onTap: () {
                  Navigator.of(context).pop();
                },
                child: const Icon(Icons.arrow_back, size: 25))),
        body: SingleChildScrollView(
          //physics: const NeverScrollableScrollPhysics(),
          child: Column(
            children: [
              const SizedBox(height: 20),
              Center(
                child: Stack(
                  alignment: Alignment.center,
                  children: <Widget>[
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        height: 13,
                        width: 58,
                        color: themeColor,
                      ),
                    ),
                    const Text(
                      'Sign Up with Email',
                      style: TextStyle(
                        fontSize: 26, // Large font size
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              Container(
                  padding: const EdgeInsets.only(left: 40, right: 40),
                  alignment: Alignment.center,
                  child: const Text(
                    "Start your journey by registering yourself!",
                    style: TextStyle(
                        color: Colors.grey,
                        fontSize: 22,
                        fontWeight: FontWeight.w400),
                    textAlign: TextAlign.center,
                  )),
              const SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 15, right: 15),
                child: Container(
                    color: Colors.grey, height: 2, width: double.infinity),
              ),
              const SizedBox(
                height: 20,
              ),
              header("Username"),
              textFeild(_nameFormKey, nameController, nameNode),
              header("Email Id"),
              textFeild(_emailFormKey, emailController, emailNode),
              header("Password"),
              textFeild(_passwordFormKey, passwordController, passwordNode),
              header("Confirm Password"),
              textFeild(
                  _cpasswordFormKey, confirmPasswordController, cpasswordNode),
              const SizedBox(height: 50),
              GestureDetector(
                  onTap: () {
                    nameNode.unfocus();
                    emailNode.unfocus();
                    passwordNode.unfocus();
                    cpasswordNode.unfocus();
                    validators();
                    if (isValidate) {
                      context.read<SignUpCubit>().registerUser(
                          context,
                          nameController.text,
                          emailController.text,
                          passwordController.text);
                    }
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(left: 20, right: 20),
                    child: Container(
                        alignment: Alignment.center,
                        height: 50,
                        width: double.infinity,
                        decoration: BoxDecoration(
                            color: colorchng ? buttonColor : Colors.grey,
                            borderRadius: BorderRadius.circular(15)),
                        child: Text("Create an account",
                            style: TextStyle(
                                color: colorchng ? Colors.white : Colors.black,
                                fontSize: 20,
                                fontWeight: FontWeight.w500))),
                  )),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
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
            altColor();
          },
        ),
      ),
    );
  }

  altColor() {
    setState(() {
      if (nameController.text.isNotEmpty &&
          emailController.text.isNotEmpty &&
          passwordController.text.isNotEmpty &&
          confirmPasswordController.text.isNotEmpty) {
        colorchng = true;
      } else {
        colorchng = false;
      }
    });
  }

  validators() {
    final emailTest =
        RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
    if (nameController.text.isEmpty) {
      showAlertMessage(context: context, message: "Enter the name!");
      nameNode.requestFocus();
    } else if (emailController.text.isEmpty) {
      showAlertMessage(context: context, message: "Enter the email id!");
      emailNode.requestFocus();
    } else if (!emailTest.hasMatch(emailController.text)) {
      showAlertMessage(
          context: context, message: "Please enter a valid email address");
      emailNode.requestFocus();
    } else if (passwordController.text.isEmpty) {
      showAlertMessage(context: context, message: "Enter the password!");
      passwordNode.requestFocus();
    } else if (confirmPasswordController.text.isEmpty) {
      showAlertMessage(
          context: context, message: "Enter the confirm password!");
      cpasswordNode.requestFocus();
    } else if (confirmPasswordController.text != passwordController.text) {
      showAlertMessage(
          context: context,
          message: "Confirm password and password does not match");
      cpasswordNode.requestFocus();
    } else {
      setState(() {
        isValidate = true;
      });
    }
  }

  OutlineInputBorder borderStyle() {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(15),
      borderSide: const BorderSide(width: 2, color: Colors.grey),
    );
  }
}
