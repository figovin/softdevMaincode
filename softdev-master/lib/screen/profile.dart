import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:recipe/consent/colors.dart';
import 'package:recipe/userAuth/login_page.dart';
import 'package:recipe/userAuth/toast.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

class Profil extends StatefulWidget {
  Profil({super.key});

  @override
  _ProfilState createState() => _ProfilState();
}

class _ProfilState extends State<Profil> {
  List<Icon> icons = [
    Icon(Icons.person, color: maincolor),
    Icon(Icons.favorite, color: maincolor),
    Icon(Icons.chat, color: maincolor),
    Icon(Icons.login, color: maincolor),
  ];
  List titles = [
    'Personal Data',
    'FAQs',
    'Logout'
  ];

  String? username;
  String? profilePictureUrl;

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      DocumentSnapshot userData = await FirebaseFirestore.instance
          .collection('userdata')
          .doc(user.uid)
          .get();
      if (userData.exists) {
        Map<String, dynamic> data = userData.data() as Map<String, dynamic>;
        print("Fetched user data: $data");
        setState(() {
          username = data['username'];
          profilePictureUrl = data['profilePictureUrl'] ?? null; // Provide a default value if the field is missing
        });
      } else {
        print("User data does not exist");
      }
    } else {
      print("User is not logged in");
    }
  }

  Future<void> uploadProfilePicture(File imageFile) async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      Reference storageReference = FirebaseStorage.instance
          .ref()
          .child('userdata/${user.uid}/profilePicture.jpg');
      UploadTask uploadTask = storageReference.putFile(imageFile);
      TaskSnapshot taskSnapshot = await uploadTask;
      String downloadUrl = await taskSnapshot.ref.getDownloadURL();

      await FirebaseFirestore.instance
          .collection('userdata')
          .doc(user.uid)
          .update({'profilePictureUrl': downloadUrl});
    }
  }

  Future<File?> pickImage() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      return File(image.path);
    }
    return null;
  }

  void _showPersonalData() async {
    final _formKey = GlobalKey<FormState>();
    String _name = '';
    String _address = '';
    String _phoneNumber = '';
    String _email = '';

    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      DocumentSnapshot userData = await FirebaseFirestore.instance
          .collection('userdata')
          .doc(user.uid)
          .get();
      if (userData.exists) {
        Map<String, dynamic> data = userData.data() as Map<String, dynamic>;
        _name = data['name'] ?? '';
        _address = data['address'] ?? '';
        _phoneNumber = data['phoneNumber'] ?? '';
        _email = data['email'] ?? '';
      }
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Personal Data'),
          content: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    initialValue: username,
                    decoration: InputDecoration(labelText: 'Username'),
                    enabled: false,
                  ),
                  TextFormField(
                    initialValue: _name,
                    decoration: InputDecoration(labelText: 'Name'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your name';
                      }
                      return null;
                    },
                    onSaved: (value) => _name = value!,
                  ),
                  TextFormField(
                    initialValue: _address,
                    decoration: InputDecoration(labelText: 'Address'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your address';
                      }
                      return null;
                    },
                    onSaved: (value) => _address = value!,
                  ),
                  TextFormField(
                    initialValue: _phoneNumber,
                    decoration: InputDecoration(labelText: 'Phone Number'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your phone number';
                      }
                      return null;
                    },
                    onSaved: (value) => _phoneNumber = value!,
                  ),
                  TextFormField(
                    initialValue: _email,
                    decoration: InputDecoration(labelText: 'Email'),
                    enabled: false,
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              child: Text('Save'),
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  _formKey.currentState!.save();
                  User? user = FirebaseAuth.instance.currentUser;
                  if (user != null) {
                    await FirebaseFirestore.instance
                        .collection('userdata')
                        .doc(user.uid)
                        .update({
                      'name': _name,
                      'address': _address,
                      'phoneNumber': _phoneNumber,
                    });
                    showToast(message: 'Data updated successfully');
                    Navigator.of(context).pop();
                  }
                }
              },
            ),
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _showFAQs() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Frequently Asked Questions'),
          content: SingleChildScrollView(
            child: ListBody(
              children: [
                _buildFAQItem(
                    'How do I edit a recipe or its ingredients?',
                    'To edit a recipe, go to the recipe page and look for a pencil icon or similar option. Here, you can adjust ingredients, cooking instructions, and other details to suit your preferences.'),
                _buildFAQItem(
                    'What happens when I "heart" a recipe?',
                    'When you heart (favorite) a recipe by tapping the heart icon, it\'s added to your Favorites page or section for quick access later. You can find your favorite recipes easily whenever you need them.'),
                _buildFAQItem(
                    'How can I search for a specific recipe?',
                    'Use the search bar at the top of the search page to search by recipe name, ingredients, cuisine type, or dietary preferences. Simply type in keywords and relevant recipes will be displayed.'),
                _buildFAQItem(
                    'When will new recipes be added to the app?',
                    'New recipes are regularly added to the app to expand our collection. Stay tuned for updates and check back frequently to discover fresh culinary ideas!'),
                _buildFAQItem(
                    'Can I adjust ingredient quantities or substitute ingredients in recipes?',
                    'Yes, you can customize recipes to suit your needs. Use the edit feature to adjust ingredient quantities or swap ingredients according to your preferences or dietary requirements.'),
                _buildFAQItem(
                    'How do I remove a recipe from my Favorites page?',
                    'If you no longer want a recipe on your Favorites page, simply tap the heart icon again to unfavorite it. This removes the recipe from your Favorites list.'),
                _buildFAQItem(
                    'Is there a way to see trending or popular recipes?',
                    'Yes, you can often find trending or popular recipes highlighted on the app\'s main page or through a specific section dedicated to trending dishes. Explore what others are loving!'),
                _buildFAQItem(
                    'How do I provide feedback about a recipe?',
                    'You can leave comments or ratings on the recipe page to share your feedback with others. Your insights help improve the recipe experience for everyone.'),
                _buildFAQItem(
                    'Are there cooking tips or video tutorials available for recipes?',
                    'Some recipes may include additional tips or video tutorials to guide you through the cooking process. Look for these enhancements on the recipe page for extra support.'),
              ],
            ),
          ),
          actions: [
            TextButton(
              child: Text('Close'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Widget _buildFAQItem(String question, String answer) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          question,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 4),
        Text(answer),
        SizedBox(height: 16),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () async {
                    File? imageFile = await pickImage();
                    if (imageFile != null) {
                      await uploadProfilePicture(imageFile);
                      _fetchUserData();
                    }
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: maincolor, width: 2),
                      shape: BoxShape.circle,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: CircleAvatar(
                        radius: 50,
                        backgroundImage: profilePictureUrl != null ? NetworkImage(profilePictureUrl!) : AssetImage('images/profileFoto.jpg') as ImageProvider,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),
            Text(
              username ?? 'User',
              style: TextStyle(fontSize: 18, color: font, fontFamily: 'ro'),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Divider(
                height: 40,
                thickness: 2,
              ),
            ),
            Expanded(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: titles.length,
                itemBuilder: (BuildContext context, int index) {
                  return ListTile(
                    leading: Container(
                      width: 37,
                      height: 37,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: icons[index],
                    ),
                    title: Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Text(
                        titles[index],
                        style: TextStyle(fontSize: 17, color: font),
                      ),
                    ),
                    trailing: Icon(
                      Icons.arrow_forward_ios_sharp,
                      size: 15,
                    ),
                    onTap: () {
                      // Placeholder functions for each button
                      switch (titles[index]) {
                        case 'Personal Data':
                          _showPersonalData();
                          break;
                        case 'FAQs':
                          _showFAQs();
                          break;
                        case 'Logout':
                          FirebaseAuth.instance.signOut();
                          Navigator.of(context).push(
                              MaterialPageRoute(
                                  builder: ((context) =>
                                      LoginPage())));
                          showToast(message: "Successfully signed out");
                          break;
                      }
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}