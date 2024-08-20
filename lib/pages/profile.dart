import 'package:flutter/material.dart';
// import 'package:m_delivery/network_services/profile_service.dart';
// import 'package:m_delivery/network_services/auth_service.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import '../network_services/auth_service.dart';
import '../network_services/profile_service.dart';
import '../widget/bottom_nav.dart';
import 'login.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  String first_name = '';
  String last_name = '';
  String email = '';
  String phone_number = '';
  String password = '';
  String confirm_password = '';
  bool _asyncCall = true;
  final AuthService authService = AuthService();
  final ProfileService profileService = ProfileService();

  late var FirstNameController = TextEditingController();
  late var LastNameController = TextEditingController(text: last_name);
  late var EmailController = TextEditingController(text: email);
  late var PhoneNumberController = TextEditingController(text: phone_number);
  late var PasswordController = TextEditingController(text: password);
  late var ConfirmPasswordController = TextEditingController(text: confirm_password);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    profileService.getUserData().then((value) => {

    setState(() {
      print(value);
      // print(value['first_name']);
      first_name = value['first_name'];
      last_name = value['last_name'];
      email = value['email'];
      phone_number = value['phone_number'];

      FirstNameController.text = first_name;
      LastNameController.text = last_name;
      EmailController.text = email;
      PhoneNumberController.text = phone_number;
      _asyncCall = false;
      // print(email);
      // currentOrder = value;
    })
    });
  }

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: _asyncCall,
      child: Scaffold(
        bottomNavigationBar: BottomNav(),
        body: SafeArea(
            child: Column(
              children: [
                Expanded(
                  flex: 1,
                  child: Image.asset(
                      fit: BoxFit.fill, "assets/images/momo_logos_black.png"),
                ),
                Expanded(
                  flex: 3,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 20, right: 20),
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          TextFormField(
                            controller: FirstNameController,
                            onChanged: (value) {
                              first_name = value;
                            },
                            decoration: const InputDecoration(
                              border: UnderlineInputBorder(),
                              labelText: 'First name',
                            ),
                          ),
                          TextFormField(
                            controller: LastNameController,
                            onChanged: (value) {
                              last_name = value;
                            },
                            decoration: const InputDecoration(
                              border: UnderlineInputBorder(),
                              labelText: 'Last name',
                            ),
                          ),
                          TextFormField(
                            controller: EmailController,
                            readOnly: true,
                            onChanged: (value) {
                              email = value;
                            },
                            decoration: const InputDecoration(
                              border: UnderlineInputBorder(),
                              labelText: 'Email address',
                            ),
                          ),
                          TextFormField(
                            controller: PhoneNumberController,
                            onChanged: (value) {
                              phone_number = value;
                            },
                            decoration: const InputDecoration(
                              border: UnderlineInputBorder(),
                              labelText: 'Phone number',
                            ),
                          ),
                          TextFormField(
                            controller: PasswordController,
                            obscureText: true,
                            onChanged: (value) {
                              password = value;
                            },
                            decoration: const InputDecoration(
                              border: UnderlineInputBorder(),
                              labelText: 'New password',
                            ),
                          ),
                          TextFormField(
                            controller: ConfirmPasswordController,
                            obscureText: true,
                            onChanged: (value) {
                              confirm_password = value;
                            },
                            decoration: const InputDecoration(
                              border: UnderlineInputBorder(),
                              labelText: 'Confirm new password',
                            ),
                          ),
                          const SizedBox(
                            height: 40,
                          ),
                          GestureDetector(
                            onTap: (){
                              profileService.updateProfile({
                                'first_name': first_name.toString(),
                                'last_name': last_name.toString(),
                                'phone_number': phone_number.toString(),
                                'password': password.toString(),
                                'confirm_password': confirm_password.toString(),
                              }).then((value) => {
                                  print(value)
                              });
                              final snackBar = SnackBar(
                                content: const Text('Profile has been updated.'),
                                action: SnackBarAction(
                                  label: '',
                                  onPressed: () {
                                    // Some code to undo the change.
                                  },
                                ),
                              );
                              ScaffoldMessenger.of(context).showSnackBar(snackBar);
                            },
                            child: Container(
                              width: double.infinity,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  color: Colors.lightGreen),
                              child: const Padding(
                                padding: EdgeInsets.only(
                                    left: 100, right: 100, top: 10, bottom: 10),
                                child: Center(
                                  child: Text(
                                    'Update Profile',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20,
                                        color: Colors.white),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 40,
                          ),
                          GestureDetector(
                            onTap: (){
                              // print('$email, $password');
                              authService.logout();
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => const Login()));
                              final snackBar = SnackBar(
                                content: const Text('Successfully logged out.'),
                                action: SnackBarAction(
                                  label: '',
                                  onPressed: () {
                                    // Some code to undo the change.
                                  },
                                ),
                              );
                              ScaffoldMessenger.of(context).showSnackBar(snackBar);

                            },
                            child: Container(
                              width: double.infinity,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  color: Colors.lightGreen),
                              child: const Padding(
                                padding: EdgeInsets.only(
                                    left: 100, right: 100, top: 10, bottom: 10),
                                child: Center(
                                  child: Text(
                                    'Logout',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20,
                                        color: Colors.white),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 40,
                          ),
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
