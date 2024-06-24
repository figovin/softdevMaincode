import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:recipe/consent/appbar.dart';
import 'package:recipe/screen/recipe.dart'; // Ensure this path is correct

class Search extends StatefulWidget {
  const Search({super.key});

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  final TextEditingController _searchController = TextEditingController();
  List<DocumentSnapshot> _searchResults = [];

  void _searchRecipes(String query) async {
    if (query.isNotEmpty) {
      var results = await FirebaseFirestore.instance
          .collection('recipes')
          .where('recipeName', isGreaterThanOrEqualTo: query)
          .where('recipeName', isLessThan: query.substring(0, 1) + 'z')
          .get();
      setState(() {
        _searchResults = results.docs;
      });
    } else {
      setState(() {
        _searchResults = [];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
              child: Container(
                width: double.infinity,
                height: 55,
                padding: EdgeInsets.only(left: 10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Color.fromARGB(255, 185, 185, 185),
                      offset: Offset(1, 1),
                      blurRadius: 15,
                    ),
                  ],
                ),
                child: TextField(
                  controller: _searchController,
                  onChanged: _searchRecipes,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Search your recipe',
                    icon: Icon(Icons.search),
                  ),
                ),
              ),
            ),
            Expanded(
              child: Container(
                color: Colors.grey[200], // Background color for the dropdown list
                child: _searchResults.isEmpty
                    ? Center(child: Text('No results found'))
                    : ListView.builder(
                  itemCount: _searchResults.length,
                  itemBuilder: (context, index) {
                    var recipe = _searchResults[index];
                    String thumbnailUrl = recipe['thumbnailUrl'] ?? 'placeholder_image_url';
                    return ListTile(
                      leading: Image.network(
                        thumbnailUrl,
                        width: 50,
                        height: 50,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Image.asset(
                            'images/nofood.png', // Path to your placeholder image
                            width: 50,
                            height: 50,
                            fit: BoxFit.cover,
                          );
                        },
                      ),
                      title: Text(recipe['recipeName']),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Recipe(recipeId: recipe.id),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}