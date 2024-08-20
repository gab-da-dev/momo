import 'package:flutter/material.dart';
// import 'package:m_delivery/pages/home_page.dart';

import '../utils/constants.dart';
import '../widget/bottom_nav.dart';
import 'home_page.dart';
class Success extends StatelessWidget {
  const Success({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Container(
        color: Colors.lightGreen,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          child: BottomNav(),
        ),
      ),
      body: SafeArea(
        child: Column(

          children: [

            Expanded(
              child: Column(
                // crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.check_circle_outline_rounded, size: 200, color: Colors.lightGreen,),
                    const SizedBox(
                      height: 10,
                    ),
                    Text('Order Successful', style: TextStyle(fontSize: 30),),
                    const SizedBox(
                      height: 40,
                    ),
                    Center(
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => HomePage()));
                        },
                        child: Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              color: kMainColor),
                          child: const Padding(
                            padding: EdgeInsets.all(10.0),
                            child: Text(
                              'Back to home',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                  color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                    ),

                  ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
