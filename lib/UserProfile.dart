import 'package:circular_profile_avatar/circular_profile_avatar.dart';
import 'package:flutter/material.dart';
import 'package:it_delivery/provider/auth_provider.dart';
import 'package:provider/provider.dart';

class UserProfile extends StatefulWidget {
  const UserProfile({Key key}) : super(key: key);

  @override
  _UserProfileState createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  var userProfile;
  List locations;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    userProfile = Provider.of<AuthProvider>(context, listen: false);
    locations = userProfile.loggedUser.locations;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            child: Container(
              child: Align(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: CircularProfileAvatar(
                        '',
                        child: Icon(
                          Icons.person,
                          color: Colors.teal,
                          size: 40,
                        ),
                        borderColor: Colors.teal.shade700,
                        borderWidth: 1.0,
                        elevation: 2,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        userProfile.loggedUser.name,
                        style: TextStyle(
                            fontSize: 21, fontWeight: FontWeight.bold),
                      ),
                    ),
                    // Padding(
                    //   padding: const EdgeInsets.symmetric(
                    //       horizontal: 8.0, vertical: 3.0),
                    //   child: Container(
                    //     height: MediaQuery.of(context).size.height / 8,
                    //     child: Card(
                    //       shape: RoundedRectangleBorder(
                    //         borderRadius: BorderRadius.circular(15),
                    //       ),
                    //       child: Padding(
                    //         padding: const EdgeInsets.symmetric(
                    //             horizontal: 16, vertical: 14),
                    //         child: Row(
                    //           children: [
                    //             IconButton(
                    //                 icon: Icon(
                    //                   Icons.mail_outline,
                    //                   color: Colors.teal,
                    //                 ),
                    //                 onPressed: null),
                    //             Text(userProfile.loggedUser.email != null
                    //                 ? userProfile.loggedUser.email
                    //                 : ''),
                    //           ],
                    //         ),
                    //       ),
                    //     ),
                    //   ),
                    // ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        height: MediaQuery.of(context).size.height / 8,
                        child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 14),
                            child: Row(
                              children: [
                                IconButton(
                                    icon: Icon(
                                      Icons.phone_iphone,
                                      color: Colors.teal,
                                    ),
                                    onPressed: null),
                                Text(userProfile.loggedUser.mobile != null
                                    ? userProfile.loggedUser.mobile
                                    : ''),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        height: MediaQuery.of(context).size.height / 2,
                        child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 14),
                            child: Container(
                              width: double.infinity,
                              child: Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      'Locations',
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  Expanded(
                                    child: locations.length != 0
                                        ? ListView.builder(
                                            itemCount: locations.length,
                                            itemBuilder: (ctx, index) {
                                              return Row(
                                                children: [
                                                  IconButton(
                                                      icon: Icon(
                                                        Icons.location_on,
                                                        color: Colors.teal,
                                                      ),
                                                      onPressed: null),
                                                  Text(locations[index]
                                                          ['title'] ??
                                                      '')
                                                ],
                                              );
                                            },
                                          )
                                        : Text('No locations saved'),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width * 0.9,
                          child: TextButton(
                            onPressed: () async {
                              userProfile.logout();
                            },
                            child: Text(
                              'Logout',
                              style: TextStyle(color: Colors.red, fontSize: 16),
                            ),
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class UserProfileClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(size.width, 0);
    path.lineTo(size.width, size.height - 100);
    path.lineTo(0, size.height);

    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {}
}
