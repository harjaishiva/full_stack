import 'package:e_commerce_app/screens/forget_password/cubit/forget_password_cubit.dart';
import 'package:e_commerce_app/screens/forget_password/forget_password_view.dart';
import 'package:e_commerce_app/screens/home_screen/cubit/home_screen_cubit.dart';
import 'package:e_commerce_app/screens/home_screen/home_view.dart';
import 'package:e_commerce_app/screens/sign_in_screen/cubit/sign_in_cubit.dart';
import 'package:e_commerce_app/utils/constants/methods.dart';
import 'package:e_commerce_app/utils/constants/variables.dart';
import 'package:e_commerce_app/utils/popup_message/pop_up.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  TextEditingController emailController = TextEditingController();

  TextEditingController passwordController = TextEditingController();

  bool isValidate = false;
  bool colorchng = false;

  final GlobalKey<FormState> _emailFormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _passwordFormKey = GlobalKey<FormState>();

  final FocusNode emailNode = FocusNode();
  final FocusNode passwordNode = FocusNode();

  @override
  void initState() {
    super.initState();
    SharedPreferencesClass.initialisePrefs();
        
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<SignInCubit, SignInState>(
      listener: (context, state) {
        if(state.success){
          SharedPreferencesClass.pref.setString(token,state.data['token']);
          SharedPreferencesClass.pref.setString(userId,state.data['userId'].toString());
          SharedPreferencesClass.pref.setString(name,state.data['name']);
          SharedPreferencesClass.pref.setString(email,state.data['email']);
          Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_)=>BlocProvider(create: (context)=>HomeScreenCubit(),child:const HomeScreen())), (route) => false);
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
                      'Sign In with Email',
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
                    "Welcome back! Sign in using your email to continue us",
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
              header("Email Id"),
              textFeild(_emailFormKey, emailController, emailNode),
              header("Password"),
              textFeild(_passwordFormKey, passwordController, passwordNode),
              const SizedBox(height: 50),
              GestureDetector(
                  onTap: () {
                    emailNode.unfocus();
                    passwordNode.unfocus();
                    validators();
                    if (isValidate) {
                      context.read<SignInCubit>().loginUser(
                          emailController.text, passwordController.text);
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
                        child: Text("Login",
                            style: TextStyle(
                                color: colorchng ? Colors.white : Colors.black,
                                fontSize: 20,
                                fontWeight: FontWeight.w500))),
                  )),
              const SizedBox(height: 20),
              Padding(
    padding: const EdgeInsets.only(left: 10, right: 10),
    child: Container(color: Colors.grey, height: 2, width: double.infinity),
  ),
              GestureDetector(
                onTap: (){
                  showAlertMessage(context: context, message: "Forgot your password? No worries! You’ll be asked to enter your registered email to reset it securely",voidCallback:(){
                                Navigator.push(context, MaterialPageRoute(builder:(context)=>BlocProvider(create: (context)=>ForgetPasswordCubit(),child:const ForgetPasswordScreen())));
                              });
                },
                child: Container(
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.only(top:5,right:10),
                  child: const Text("Forget Password?",style:TextStyle(color:Colors.blue,fontSize:16,fontWeight:FontWeight.w500)),
                ),
              ),
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
      if (emailController.text.isNotEmpty &&
          passwordController.text.isNotEmpty) {
        colorchng = true;
      } else {
        colorchng = false;
      }
    });
  }

  validators() {
    final emailTest =
        RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
    if (emailController.text.isEmpty) {
      showAlertMessage(context: context, message: "Enter the email id!");
      emailNode.requestFocus();
    } else if (!emailTest.hasMatch(emailController.text)) {
      showAlertMessage(
          context: context, message: "Please enter a valid email address");
      emailNode.requestFocus();
    } else if (passwordController.text.isEmpty) {
      showAlertMessage(context: context, message: "Enter the password!");
      passwordNode.requestFocus();
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
