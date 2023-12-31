import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_tut/log/test_logger.dart';
import 'package:flutter_tut/main.dart';
import 'package:flutter_tut/resources/auth_methods.dart';
import 'package:flutter_tut/screen/signup_screen.dart';
import 'package:flutter_tut/utils/colors.dart';
import 'package:flutter_tut/utils/global_variables.dart';
import 'package:flutter_tut/utils/utils.dart';
import 'package:flutter_tut/widgets/text_field_input.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    //messageListener(context);
    _emailController.text = 'wow160@wowpress.co.kr';
    _passwordController.text = '123456';
  }

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
  }

  void navigatorToSignup(){
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => const SignupScreen()));
  }

  void loginUser() async{
    setState(() {
      _isLoading = true;
    });
    String res = await AuthMethods().loginUser(
        email: _emailController.text,
        password: _passwordController.text,
    );

    loggerNoStack.i('res result : $res');

    if(res == "success"){
        showSnackBar(res, context);
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => MyApp(),
          ),
        );
        /*
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => const ResponsiveLayout(
              mobileScreenLayout: MobileScreenLayout(),
              webScreenLayout: WebScreenLayout(),
            ),
          ),
        );
        */
    }else{
      showSnackBar(res, context);
    }
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Container(
        padding: MediaQuery.of(context).size.width>webScreenSize?
        EdgeInsets.symmetric(
          horizontal: MediaQuery.of(context).size.width/4
        ):
        EdgeInsets.symmetric(horizontal: 32)
        ,
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Flexible(
              child: Container(),
              flex: 2,
            ),
            //svg image
            SvgPicture.asset(
              'assets/ic_wow_logo.svg',
              color: primaryColor,
              height: 64,
              fit: BoxFit.cover,
            ),
            SvgPicture.asset(
              'assets/android-color-svgrepo-com.svg',
              color: primaryColor,
              height: 64,
              fit: BoxFit.cover,
            ),
            const SizedBox(
              height: 24,
            ),
            TextFieldInput(
              hintText: '아이디@wowpress.co.kr',
              textInputType: TextInputType.emailAddress,
              textEditingController: _emailController,
            ),
            const SizedBox(
              height: 24,
            ),
            TextFieldInput(
              hintText: '비밀번호',
              textInputType: TextInputType.text,
              textEditingController: _passwordController,
              isPass: true,
            ),
            const SizedBox(
              height: 24,
            ),
            InkWell(
              onTap: loginUser,
              child: Container(
                child: _isLoading
                    ? const Center(
                        child: CircularProgressIndicator(color: primaryColor),
                      )
                    : const Text('Login'),
                width: double.infinity,
                alignment: Alignment.center,
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: const ShapeDecoration(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(4)),
                    ),
                  color: blueColor,
                ),
              ),
            ),
            SizedBox(
              height: 12,
            ),
            Flexible(
              child: Container(),
              flex: 2,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  child: Text("Dont have an account?"),
                  padding: const EdgeInsets.symmetric(vertical: 8),
                ),
                GestureDetector(
                  onTap: navigatorToSignup,
                  child: Container(
                    child: Text(
                      "Sign up",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 8),
                  ),
                ),
              ],
            )
          ],
        ),
      )),
    );
  }
}