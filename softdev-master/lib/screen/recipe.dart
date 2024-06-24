import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:recipe/consent/colors.dart';

class Recipe extends StatefulWidget {
  final String recipeId;

  Recipe({required this.recipeId});

  @override
  _RecipeState createState() => _RecipeState();
}

class _RecipeState extends State<Recipe> {
  late YoutubePlayerController _controller;
  late DocumentSnapshot _recipe;
  bool _isFavorite = false;
  bool _isEditing = false;
  late TextEditingController _ingredientsController;
  late TextEditingController _instructionsController;

  @override
  void initState() {
    super.initState();
    fetchRecipe();
  }

  Future<void> fetchRecipe() async {
    var recipeDoc = await FirebaseFirestore.instance
        .collection('recipes')
        .doc(widget.recipeId)
        .get();
    setState(() {
      _recipe = recipeDoc;
      _isFavorite = _recipe['favoriteState'];
      _ingredientsController = TextEditingController(text: _recipe['ingredients']);
      _instructionsController = TextEditingController(text: _recipe['instructions']);

      try {
        _controller = YoutubePlayerController(
          initialVideoId: YoutubePlayer.convertUrlToId(_recipe['videoUrl'])!,
          flags: YoutubePlayerFlags(
            autoPlay: true,
            mute: false,
          ),
        );
      } catch (e) {
        // Handle the error by setting a placeholder image or thumbnail
        _controller = YoutubePlayerController(
          initialVideoId: 'error', // This will not play any video
          flags: YoutubePlayerFlags(
            autoPlay: false,
            mute: false,
          ),
        );
      }
    });
  }

  void toggleFavorite() async {
    setState(() {
      _isFavorite = !_isFavorite;
    });
    await FirebaseFirestore.instance
        .collection('recipes')
        .doc(widget.recipeId)
        .update({'favoriteState': _isFavorite});
  }

  void toggleEdit() {
    setState(() {
      _isEditing = !_isEditing;
    });
  }

  Future<void> saveChanges() async {
    await FirebaseFirestore.instance
        .collection('recipes')
        .doc(widget.recipeId)
        .update({
      'ingredients': _ingredientsController.text,
      'instructions': _instructionsController.text,
    });
    toggleEdit();
  }

  Future<void> deleteRecipe() async {
    bool confirmDelete = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Delete Recipe'),
        content: Text('Are you sure you want to delete this recipe?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmDelete) {
      await FirebaseFirestore.instance
          .collection('recipes')
          .doc(widget.recipeId)
          .delete();
      Navigator.of(context).pop(); // Close the recipe page after deletion
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_recipe == null) return CircularProgressIndicator();
    return Scaffold(
      backgroundColor: background,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              automaticallyImplyLeading: false,
              backgroundColor: background,
              expandedHeight: 400,
              flexibleSpace: FlexibleSpaceBar(
                background: _controller.initialVideoId == 'error'
                    ? Image.asset(
                  'images/nofood.png',
                  fit: BoxFit.cover,
                )
                    : YoutubePlayer(
                  controller: _controller,
                  showVideoProgressIndicator: true,
                  progressIndicatorColor: maincolor,
                ),
              ),
              bottom: PreferredSize(
                preferredSize: Size.fromHeight(10),
                child: Container(
                  width: double.infinity,
                  height: 50,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(70),
                      topRight: Radius.circular(70),
                    ),
                    color: background,
                  ),
                  child: Column(
                    children: [
                      SizedBox(height: 15),
                      Container(
                        width: 80,
                        height: 4,
                        color: Colors.grey,
                      )
                    ],
                  ),
                ),
              ),
              actions: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: CircleAvatar(
                    backgroundColor: Color.fromRGBO(250, 250, 250, 0.6),
                    radius: 18,
                    child: IconButton(
                      padding: EdgeInsets.only(right: 0), // Adjusted padding
                      icon: Icon(
                        _isFavorite ? Icons.favorite : Icons.favorite_border,
                        size: 25,
                        color: Colors.red,
                      ),
                      onPressed: toggleFavorite,
                    ),
                  ),
                ),
              ],
              title: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: CircleAvatar(
                  backgroundColor: Color.fromRGBO(250, 250, 250, 0.6),
                  radius: 18,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: Icon(
                      Icons.arrow_back,
                      size: 25,
                      color: font,
                    ),
                  ),
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      _recipe['recipeName'],
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: font,
                      ),
                    ),
                  ),
                  _buildEditableSection(
                    title: 'Ingredients',
                    controller: _ingredientsController,
                  ),
                  _buildEditableSection(
                    title: 'Instructions',
                    controller: _instructionsController,
                  ),
                  if (_isEditing)
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: ElevatedButton(
                        onPressed: saveChanges,
                        child: Text('Save Changes'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: maincolor,
                        ),
                      ),
                    ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: ElevatedButton(
                      onPressed: deleteRecipe,
                      child: Text(
                        'Delete Recipe',
                        style: TextStyle(
                          color: Colors.white, // Make the text white
                          fontWeight: FontWeight.bold, // Make the text bold
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.redAccent,
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

  Widget _buildEditableSection({
    required String title,
    required TextEditingController controller,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: font,
                ),
              ),
              IconButton(
                icon: Icon(_isEditing ? Icons.save : Icons.edit),
                onPressed: _isEditing ? saveChanges : toggleEdit,
                color: font,
              ),
            ],
          ),
        ),
        if (_isEditing)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: TextField(
              controller: controller,
              maxLines: null,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
              ),
            ),
          )
        else
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              controller.text,
              style: TextStyle(color: font),
            ),
          ),
      ],
    );
  }
}