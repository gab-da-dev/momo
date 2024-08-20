import 'package:flutter/material.dart';
// import 'package:m_delivery/pages/home_page.dart';
// import 'package:m_delivery/pages/register.dart';
// import 'package:m_delivery/network_services/auth_service.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:momo/pages/register.dart';
import 'package:provider/provider.dart';

import '../models/user_provider.dart';
import '../network_services/auth_service.dart';
import 'home_page.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  String email = '';
  String password = '';
  bool isAuth = false;
  final AuthService authService = AuthService();
  bool _asyncCall = false;

  @override
  Widget build(BuildContext context) {
    final providerUser = Provider.of<UserProvider>(context);
    return ModalProgressHUD(
      inAsyncCall: _asyncCall,
      child: Scaffold(
        body: SafeArea(
            child: Column(
          children: [
            Expanded(
              flex: 1,
              child: Image.asset(
                  fit: BoxFit.fill, "assets/images/momo_logos_black.png"),
            ),
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.only(left: 20, right: 20),
                child: Column(
                  children: [
                    TextFormField(
                      onChanged: (value) {
                        email = value;
                      },
                      decoration: const InputDecoration(
                        border: UnderlineInputBorder(),
                        labelText: 'Email address',
                      ),
                    ),
                    TextFormField(
                      obscureText: true,
                      onChanged: (value) {
                        password = value;
                      },

                      decoration: const InputDecoration(
                        border: UnderlineInputBorder(),
                        labelText: 'Password',
                      ),
                    ),
                    const SizedBox(
                      height: 40,
                    ),
                    GestureDetector(
                      onTap: ()async{
                        try {
                          setState(() {
                            _asyncCall = true;
                          });
                          await authService.loginUser(email: email, password: password);
                          Navigator.push(context, MaterialPageRoute(builder: (context) => HomePage()));
                        } catch (error) {
                          setState(() {
                            _asyncCall = false;
                          });
                          final snackBar = SnackBar(
                            content: const Text('The provided credentials are incorrect.'),
                            action: SnackBarAction(
                              label: '',
                              onPressed: () {
                                // Some code to undo the change.
                              },
                            ),
                          );
                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
                        }

                        },
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            color: Colors.lightGreen),
                        child: const Padding(
                          padding: EdgeInsets.only(
                              left: 100, right: 100, top: 10, bottom: 10),
                          child: Text(
                            'Login',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                                color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const Register()));
                        },
                        child:
                            const Text('Don\'t have an account? Register here'))
                  ],
                ),
              ),
            ),
          ],
        )),
      ),
    );
  }
}
