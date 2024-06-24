import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:recipe/consent/colors.dart';

class RecipeFormScreen extends StatefulWidget {
  @override
  _RecipeFormScreenState createState() => _RecipeFormScreenState();
}

class _RecipeFormScreenState extends State<RecipeFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _recipeNameController = TextEditingController();
  final _ingredientsController = TextEditingController();
  final _instructionsController = TextEditingController();
  final _videoUrlController = TextEditingController();
  final _estimatedTimeController = TextEditingController();
  File? _image;
  String? _selectedCategory;

  final List<String> _categories = [
    'Betawi',
    'Sunda',
    'Padang',
    'Bali',
    'Chinese',
    'Other'
  ];

  Future<void> _pickImage() async {
    final ImagePicker _picker = ImagePicker();
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      if (_selectedCategory == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Please select a food category')),
        );
        return;
      }

      String imageUrl = '';
      if (_image != null) {
        try {
          Reference storageReference = FirebaseStorage.instance
              .ref()
              .child('recipe_images/${DateTime.now().millisecondsSinceEpoch}.jpg');
          UploadTask uploadTask = storageReference.putFile(_image!);
          TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() => null);
          imageUrl = await taskSnapshot.ref.getDownloadURL();
        } catch (e) {
          print('Error uploading image: $e');
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to upload image')),
          );
          return;
        }
      }

      try {
        await FirebaseFirestore.instance.collection('recipes').add({
          'recipeName': _recipeNameController.text,
          'ingredients': _ingredientsController.text,
          'instructions': _instructionsController.text,
          'videoUrl': _videoUrlController.text,
          'thumbnailUrl': imageUrl,
          'favoriteState': false,
          'estimatedTime': int.parse(_estimatedTimeController.text),
          'category': _selectedCategory,
        });
        Navigator.of(context).pop();
      } catch (e) {
        print('Error submitting form: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to submit form')),
        );
      }
    }
  }

  @override
  void dispose() {
    _recipeNameController.dispose();
    _ingredientsController.dispose();
    _instructionsController.dispose();
    _videoUrlController.dispose();
    _estimatedTimeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Recipe'),
        backgroundColor: maincolor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                GestureDetector(
                  onTap: _pickImage,
                  child: Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                    ),
                    child: _image == null
                        ? Icon(Icons.add_a_photo)
                        : Image.file(_image!, fit: BoxFit.cover),
                  ),
                ),
                TextFormField(
                  controller: _recipeNameController,
                  decoration: InputDecoration(labelText: 'Recipe Name'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the recipe name';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _ingredientsController,
                  decoration: InputDecoration(labelText: 'Ingredients'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the ingredients';
                    }
                    return null;
                  },
                  maxLines: null,
                  keyboardType: TextInputType.multiline,
                ),
                TextFormField(
                  controller: _instructionsController,
                  decoration: InputDecoration(labelText: 'Instructions'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the instructions';
                    }
                    return null;
                  },
                  maxLines: null,
                  keyboardType: TextInputType.multiline,
                ),
                TextFormField(
                  controller: _videoUrlController,
                  decoration: InputDecoration(labelText: 'YouTube URL'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the YouTube URL';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _estimatedTimeController,
                  decoration: InputDecoration(labelText: 'Estimated Time (minutes)'),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the estimated time';
                    }
                    if (int.tryParse(value) == null) {
                      return 'Please enter a valid number';
                    }
                    return null;
                  },
                ),
                DropdownButtonFormField<String>(
                  decoration: InputDecoration(labelText: 'Food Category'),
                  value: _selectedCategory,
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedCategory = newValue;
                    });
                  },
                  items: _categories.map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  validator: (value) {
                    if (value == null) {
                      return 'Please select a food category';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _submitForm,
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.pink, // Set the text color to white
                    textStyle: TextStyle(
                      fontWeight: FontWeight.bold, // Make the text bold
                    ),
                  ),
                  child: Text('Submit'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}