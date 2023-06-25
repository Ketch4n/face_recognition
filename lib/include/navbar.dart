import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../model/setstate.dart';
import '../model/user.dart';
import '../pages/home.dart';
import '../pages/profile.dart';

class Navbar extends StatefulWidget {
  const Navbar({super.key});

  @override
  State<Navbar> createState() => _NavbarState();
}

class _NavbarState extends State<Navbar> {
  final user = FirebaseAuth.instance.currentUser!;
  Future logout() async {
    final value = await showDialog<bool>(
        context: context,
        builder: (context) {
          return CupertinoAlertDialog(
            title: const Text(
              "Confirm Log out ?",
              style: TextStyle(color: Colors.red, fontFamily: "NexaBold"),
            ),
            content: const Text(
              'You will be required to login again next time',
              style: TextStyle(color: Colors.black, fontFamily: "NexaRegular"),
            ),
            actions: <Widget>[
              TextButton(
                child: const Text('No'),
                onPressed: () {
                  Navigator.of(context).pop(false);
                },
              ),
              TextButton(
                child: const Text('Yes'),
                onPressed: () {
                  Navigator.of(context).pop(false);
                  FirebaseAuth.instance.signOut();
                },
              ),
            ],
          );
        });

    return value == true;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            // UserAccountsDrawerHeader(
            //   accountName: Text("Users.names"),
            //   accountEmail: Text(user.email!),
            //   currentAccountPicture: CircleAvatar(
            //     child: ClipOval(
            //       child: Image.asset(
            //         'assets/images/admin.png',
            //         fit: BoxFit.cover,
            //         width: 90,
            //         height: 90,
            //       ),
            //     ),
            //   ),
            //   decoration: BoxDecoration(
            //       // color: Colors.blue,

            //       ),
            // ),
            Container(
              height: 130,
              decoration: const BoxDecoration(),
              child: Column(
                children: [
                  Stack(children: <Widget>[
                    SizedBox(
                      height: 130,
                      width: double.maxFinite,
                      child: Image.asset(
                        'assets/images/neon.jpg',
                        fit: BoxFit.cover,
                      ),
                    ),
                    Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 10.0, horizontal: 15.0),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(300.0),
                              child: Image.asset(
                                'assets/images/admin.png',
                                height: 70,
                                width: 70,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 15.0),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      UserDetails.name,
                                      style: const TextStyle(
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Text(
                                      UserDetails.email,
                                      style: const TextStyle(
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ]),
                ],
              ),
            ),
            // ListTile(
            //   leading: Icon(Icons.home),
            //   title: Text('Homepage'),
            //   onTap: () {
            //   Navigator.of(context).pop(false);
            //     Navigator.of(context).push(
            //       MaterialPageRoute(
            //         builder: (context) => const ScanScreen(),
            //       ),
            //     );
            //   },
            // ),
            ListTile(
              title: Text(UserDetails.role),
            ),
            ListTile(
              leading: const Icon(Icons.home_sharp),
              title: const Text('Dashboard'),
              onTap: () {
                Navigator.of(context).pop(false);

                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (context) => const Home(),
                  ),
                );
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.calendar_today),
              title: const Text('Attendance'),
              onTap: () {
                // Navigator.of(context).pop(false);

                // Navigator.of(context).push(
                //   MaterialPageRoute(
                //     builder: (context) => const DTRScreen(),
                //   ),
                // );
              },
            ),
            ListTile(
              leading: const Icon(Icons.qr_code),
              title: const Text('Scan'),
              onTap: () {
                // Navigator.of(context).pop(false);
                // Navigator.of(context).push(
                //   MaterialPageRoute(
                //     builder: (context) => const ScanScreen(),
                //   ),
                // );
              },
            ),
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text('Profile'),
              onTap: () {
                Navigator.of(context).pop(false);
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const Profile(),
                  ),
                );
              },
            ),
            // ListTile(
            //   leading: Icon(Icons.notifications),
            //   title: Text('Request'),
            // ),
            // Divider(),
            // ListTile(
            //   title: Text('Admin'),
            // ),
            // ListTile(
            //   leading: Icon(Icons.home),
            //   title: Text('Establishment'),
            //   onTap: () {
            //     // Navigator.of(context).pop(false);
            //     Navigator.of(context).push(
            //       MaterialPageRoute(
            //         builder: (context) => const EstablishmentScreen(),
            //       ),
            //     );
            //   },
            // ),
            // ListTile(
            //   leading: Icon(Icons.description),
            //   title: Text('About'),
            //   onTap: () {
            //     // Navigator.of(context).pop(false);
            //     Navigator.of(context).push(
            //       MaterialPageRoute(
            //         builder: (context) => const AboutScreen(),
            //       ),
            //     );
            //   },
            // ),
            const Divider(),
            ListTile(
              title: const Text('Log-out'),
              leading: const Icon(Icons.exit_to_app),
              onTap: () {
                Navigator.of(context).pop(false);
                logout();
              },
            ),
          ],
        ),
      ),
    );
  }
}
