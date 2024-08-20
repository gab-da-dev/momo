import 'package:flutter/material.dart';
// import 'package:m_delivery/pages/login.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

import '../network_services/auth_service.dart';
import 'home_page.dart';
import 'login.dart';

class Register extends StatefulWidget {
  const Register({Key? key}) : super(key: key);

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  String first_name = '';
  String last_name = '';
  String email = '';
  String phone_number = '';
  String password = '';
  String confirm_password = '';
  final AuthService authService = AuthService();
  bool _asyncCall = false;

  @override
  Widget build(BuildContext context) {
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
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      TextFormField(
                        onChanged: (value) {
                          first_name = value;
                      },
                        decoration: const InputDecoration(
                          border: UnderlineInputBorder(),
                          labelText: 'First name',
                        ),
                      ),
                      TextFormField(
                        onChanged: (value) {
                          last_name = value;
                      },
                        decoration: const InputDecoration(
                          border: UnderlineInputBorder(),
                          labelText: 'Last name',
                        ),
                      ),
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
                        onChanged: (value) {
                          phone_number = value;
                      },
                        decoration: const InputDecoration(
                          border: UnderlineInputBorder(),
                          labelText: 'Phone number',
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
                      TextFormField(
                        obscureText: true,
                        onChanged: (value) {
                        confirm_password = value;
                      },
                        decoration: const InputDecoration(
                          border: UnderlineInputBorder(),
                          labelText: 'Confirm password',
                        ),
                      ),
                      const SizedBox(
                        height: 40,
                      ),
                      GestureDetector(
                        onTap: ()async{
                          if(password.toString() == confirm_password.toString()){
                            try {
                              setState(() {
                                _asyncCall = true;
                              });
                              await authService.registerUser({'first_name': first_name.toString(),
                                'last_name': last_name.toString(),
                                'phone_number': phone_number.toString(),
                                'email': email.toString(),
                                'password': password.toString(),
                                'confirm_password': confirm_password.toString(),});
                              Navigator.push(context, MaterialPageRoute(builder: (context) => HomePage()));
                            } catch (error) {
                              setState(() {
                                _asyncCall = false;
                              });
                              final snackBar = SnackBar(
                                content: const Text('Unable to create account.'),
                                action: SnackBarAction(
                                  label: '',
                                  onPressed: () {
                                    // Some code to undo the change.
                                  },
                                ),
                              );
                              ScaffoldMessenger.of(context).showSnackBar(snackBar);
                            }
                          }else{
                            final snackBar = SnackBar(
                              content: const Text('The provided passwords don\'t match. Try again.'),
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
                              'Register',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                  color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 10,),
                      GestureDetector(
                          onTap: () {
                            Navigator.push(context,
                                MaterialPageRoute(builder: (context) => const Login()));
                          },
                          child: const Text('Already registered? Login here'))
                    ],
                  ),
                ),
              ),
            ),
          ],
        )),
      ),
    );
  }
}
