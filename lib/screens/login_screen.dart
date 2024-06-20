import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:lux_chain/screens/reset_password_screen.dart';
import 'package:lux_chain/utilities/frame.dart';
import 'package:lux_chain/utilities/size_config.dart';
import 'package:lux_chain/screens/signup_screen.dart';
import 'package:http/http.dart' as http;
import 'package:lux_chain/utilities/utils.dart';
import 'package:url_launcher/url_launcher.dart';

const String authURL = '$baseUrl/auth';

/*
const List<String> scopes = <String>[
  'email',
];

GoogleSignIn _googleSignIn = GoogleSignIn(
  // Optional clientId
  // clientId: 'your-client_id.apps.googleusercontent.com',
  scopes: scopes,
);
*/

class LoginScreen extends StatefulWidget {
  static const String id = 'LoginScreen';
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginState();
}

class _LoginState extends State<LoginScreen> {
  bool _showPassword = false;
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  Widget _buildEmailTF() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const Text(
          'Email',
          style: kLabelStyle,
        ),
        const SizedBox(height: 10.0),
        Container(
          alignment: Alignment.centerLeft,
          decoration: kBoxDecorationStyle,
          height: 60.0,
          child: TextField(
            controller: emailController,
            keyboardType: TextInputType.emailAddress,
            style: const TextStyle(
              color: Colors.white,
            ),
            decoration: const InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.only(top: 14.0),
              prefixIcon: Icon(
                Icons.account_box,
                color: Colors.white,
              ),
              hintText: 'Enter your email',
              hintStyle: kHintTextStyle,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPasswordTF() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const Text(
          'Password',
          style: kLabelStyle,
        ),
        const SizedBox(height: 10.0),
        Container(
          alignment: Alignment.centerLeft,
          decoration: kBoxDecorationStyle,
          height: 60.0,
          child: TextField(
            controller: passwordController,
            obscureText: !_showPassword,
            style: const TextStyle(
              color: Colors.white,
            ),
            decoration: const InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.only(top: 14.0),
              prefixIcon: Icon(
                Icons.lock,
                color: Colors.white,
              ),
              hintText: 'Enter your Password',
              hintStyle: kHintTextStyle,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildForgotPasswordBtn() {
    return Container(
      alignment: Alignment.centerRight,
      child: TextButton(
        onPressed: () async {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('Do you want to reset your password?'),
              actions: <Widget>[
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('No'),
                ),
                TextButton(
                  onPressed: () {
                    if (emailController.text.isNotEmpty) {
                      _forgotPassword(emailController.text, context);
                    } else {
                      snackbar(context, 'email missing');
                    }
                  },
                  child: const Text('Yes'),
                ),
              ],
            ),
          );
        },
        child: const Text(
          'Forgot Password?',
          style: kLabelStyle,
        ),
      ),
    );
  }

  Widget _buildShowPasswordBox() {
    return SizedBox(
      height: 20.0,
      child: Row(
        children: <Widget>[
          Theme(
            data: ThemeData(unselectedWidgetColor: Colors.white),
            child: Checkbox(
              value: _showPassword,
              checkColor: Colors.green,
              activeColor: Colors.white,
              onChanged: (value) {
                setState(() {
                  _showPassword = value!;
                });
              },
            ),
          ),
          const Text(
            'Show Password',
            style: kLabelStyle,
          ),
        ],
      ),
    );
  }

  Widget _buildLoginBtn() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 15.0),
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () async {
          if (emailController.text.isNotEmpty &&
              passwordController.text.isNotEmpty) {
            try {
              Map<String, String> requestBody = {
                'email': emailController.text,
                'password': passwordController.text,
              };

              final response = await http
                  .post(
                    Uri.parse('$authURL/login'),
                    headers: <String, String>{
                      'Content-Type': 'application/json; charset=UTF-8',
                    },
                    body: jsonEncode(requestBody),
                  )
                  .timeout(const Duration(seconds: 10));

              if (response.statusCode == 200) {
                Map<String, dynamic> myMap = jsonDecode(response.body);
                for (var v in myMap['user'].entries) {
                  saveData(v.key, v.value);
                }
                token = myMap['token'];
                saveData('token', token);
                Navigator.pushNamedAndRemoveUntil(
                    context, FrameScreen.id, (_) => false);
              } else if (response.statusCode == 401) {
                snackbar(context, 'Incorrect email or password');
              } else {
                snackbar(context, 'Server error, please try again later');
              }
            } catch (e) {
              snackbar(context, 'Connection error with the server');
              throw Exception('[FLUTTER] Login Error: $e');
            }
          } else {
            snackbar(context, 'Incorrect email or password');
          }
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blue,
        ),
        child: const Text(
          'LOGIN',
          style: TextStyle(
            color: Colors.white,
            letterSpacing: 1.5,
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildSignInWithText() {
    return const Column(
      children: <Widget>[
        Text(
          '- OR -',
          style: TextStyle(
            fontWeight: FontWeight.w400,
          ),
        ),
        SizedBox(height: 20.0),
        Text(
          'Sign in with',
          style: kLabelStyle,
        ),
      ],
    );
  }

  Widget _buildSocialBtn(VoidCallback onTap, AssetImage logo) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 60.0,
        width: 60.0,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white,
          boxShadow: const [
            BoxShadow(
              color: Colors.black26,
              offset: Offset(0, 2),
              blurRadius: 6.0,
            ),
          ],
          image: DecorationImage(
            image: logo,
          ),
        ),
      ),
    );
  }

  Widget _buildSocialBtnRow() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 30.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          _buildSocialBtn(
            () async {
              print('Google Login Pressed');

              // login via browser:
              final Uri url = Uri.parse('$authURL/login/google');
              if (!await launchUrl(url)) {
                throw Exception('Could not launch $url');
              }

              try {
                final Uri callbackUrl =
                    Uri.parse('$baseUrl/'); // modificare con nuova chiamata
                final response = await http
                    .get(callbackUrl)
                    .timeout(const Duration(seconds: 10));
                if (response.statusCode == 200) {
                  Map<String, dynamic> myMap = jsonDecode(response.body);
                  for (var v in myMap['user'].entries) {
                    saveData(v.key, v.value);
                  }
                  token = myMap['token'];
                  saveData('token', token);
                  Navigator.pushReplacementNamed(context, FrameScreen.id);
                } else {
                  snackbar(context, 'Server error, please try again later');
                }
              } catch (e) {
                snackbar(context, 'Connection error with the server');
                throw Exception('[FLUTTER] Login Error: $e');
              }

              /* login via google_sign_in plugin
              try {
                //await _googleSignIn.disconnect();
                
                // getting token try 1
                await _googleSignIn.signIn().then((result) {
                  print(result);
                  result?.authentication.then((googleKey) {
                    print(googleKey.accessToken);
                    print(googleKey.idToken);
                    print(_googleSignIn.currentUser?.displayName);
                  }).catchError((err) {
                    print('inner error');
                  });
                }).catchError((err) {
                  print('error occured');
                });

                /* getting token try 2
                var googleUser = await _googleSignIn.signIn();
                if (googleUser == null) {
                    throw Exception(
                        '[FLUTTER] Google Login: User not retrieved from google api');
                } else {
                  print(googleUser);

                  //api call try 1
                  final response = await http.post(
                    Uri.parse('$apiURL/login/google'),
                    headers: {
                      'Content-Type': 'application/x-www-form-urlencoded'
                    },
                    body: {'idtoken': id_token},
                  );

                  //api call try 2
                  Map<String, String> headers = await googleUser.authHeaders;
                  final response = await http.get(
                      Uri.parse('$apiURL/google/callback'),
                      headers: headers);


                  print(response.statusCode);
                  if (response.statusCode == 200) {
                    // salva user + token e cambia pagina
                    print('user:');
                    print(jsonDecode(response.body)['user']);
                    print('token:');
                    print(jsonDecode(response.body)['token']);
                  } else {
                    throw Exception(
                        '[FLUTTER] Google Login api Error: ${response.statusCode}');
                  }
                } */
              } catch (e) {
                throw Exception('[FLUTTER] Google Login Plugin Error: $e');
              }
              */
            },
            const AssetImage(
              'assets/images/google.jpg',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSignupBtn() {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const SignUpScreen(),
          ),
        );
      },
      child: RichText(
        text: const TextSpan(
          children: [
            TextSpan(
              text: 'Don\'t have an Account? ',
              style: TextStyle(
                color: Colors.black,
                fontSize: 18.0,
                fontWeight: FontWeight.w400,
              ),
            ),
            TextSpan(
              text: 'Sign Up',
              style: TextStyle(
                color: Colors.black,
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _forgotPassword(String email, BuildContext context) async {
    try {
      final response = await http
          .post(
            Uri.parse("$authURL/reset_pwd_code"),
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
            },
            body: jsonEncode({'email': email}),
          )
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        // Successo
        showDialog(
          context: context,
          builder: (BuildContext context) => AlertDialog(
            title: const Text(
                'An email with the password reset code has been sent to you'),
            content: const Text('Insert the code in the next screen'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pushNamed(context, ResetPasswordScreen.id,
                      arguments: email);
                },
                child: const Text('OK'),
              ),
            ],
          ),
        );
      } else if (response.statusCode == 401) {
        // chiudi dialog e manda messaggio di errore
        Navigator.pop(context);
        snackbar(context, 'Incorrect email');
      } else {
        // chiudi dialog e manda messaggio di errore
        Navigator.pop(context);
        snackbar(context, 'Server error, please try again later');
      }
    } catch (e) {
      snackbar(context, 'Connection error with the server');
      throw Exception('[FLUTTER] Login Error: $e');
    }
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
//    double height = SizeConfig.screenH!;
    double width = SizeConfig.screenW!;

    return Scaffold(
      appBar: appBar(width),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Stack(
          children: <Widget>[
            Container(
              height: double.infinity,
              width: double.infinity,
              decoration: const BoxDecoration(
                  color: Color.fromARGB(255, 191, 223, 250)),
            ),
            SizedBox(
              height: double.infinity,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.symmetric(
                  horizontal: 40.0,
                  vertical: 40.0,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    const Text(
                      'Sign In',
                      style: TextStyle(
                        fontSize: 30.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 30.0),
                    _buildEmailTF(),
                    const SizedBox(height: 30.0),
                    _buildPasswordTF(),
                    _buildForgotPasswordBtn(),
                    _buildShowPasswordBox(),
                    const SizedBox(height: 10.0),
                    _buildLoginBtn(),
                    _buildSignInWithText(),
                    _buildSocialBtnRow(),
                    _buildSignupBtn(),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

final kBoxDecorationStyle = BoxDecoration(
  color: const Color(0xFF6CA8F1),
  borderRadius: BorderRadius.circular(10.0),
  boxShadow: const [
    BoxShadow(
      color: Colors.black12,
      blurRadius: 6.0,
      offset: Offset(0, 2),
    ),
  ],
);
