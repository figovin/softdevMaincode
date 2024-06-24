import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:recipe/consent/colors.dart';
import 'package:recipe/userAuth/recipeFormScreen.dart';
import 'package:recipe/screen/profile.dart'; // Assuming your profile page is in the screen directory

class CustomAppBar extends StatefulWidget implements PreferredSizeWidget {
  @override
  _CustomAppBarState createState() => _CustomAppBarState();

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}

class _CustomAppBarState extends State<CustomAppBar> {
  String? profilePictureUrl;

  @override
  void initState() {
    super.initState();
    fetchProfilePicture();
  }

  Future<void> fetchProfilePicture() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      DocumentSnapshot userData = await FirebaseFirestore.instance
          .collection('userdata')
          .doc(user.uid)
          .get();
      if (userData.exists) {
        setState(() {
          profilePictureUrl = userData['profilePictureUrl'] ?? 'images/profileFoto.jpg';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      elevation: 0,
      title: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => RecipeFormScreen()),
          );
        },
        child: Icon(
          Icons.add_outlined,
          size: 27,
        ),
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 15),
          child: GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Profil()),
              );
            },
            child: CircleAvatar(
              radius: 18,
              backgroundImage: profilePictureUrl != null
                  ? NetworkImage(profilePictureUrl!)
                  : AssetImage('images/profileFoto.jpg') as ImageProvider,
            ),
          ),
        ),
      ],
      backgroundColor: maincolor,
    );
  }
}