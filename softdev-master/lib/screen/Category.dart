import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:recipe/consent/appbar.dart';
import 'package:recipe/consent/colors.dart';
import 'package:recipe/screen/recipe.dart';

class Category extends StatelessWidget {
  const Category({Key? key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(top: 10),
          child: GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisExtent: 270,
            ),
            itemCount: 6,
            itemBuilder: (context, index) {
              final categories = [
                'Betawi',
                'Sunda',
                'Padang',
                'Bali',
                'Chinese',
                'Other'
              ];
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => CategoryPage(categoryName: categories[index])),
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.amber,
                      borderRadius: BorderRadius.circular(25),
                      image: DecorationImage(
                        image: AssetImage('images/${index + 1}c.jpg'),
                        fit: BoxFit.cover,
                      ),
                    ),
                    child: Center(
                      child: Text(
                        categories[index],
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24, // Increased font size
                          fontWeight: FontWeight.bold, // Added bold font weight
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

class CategoryPage extends StatelessWidget {
  final String categoryName;

  CategoryPage({required this.categoryName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(categoryName), backgroundColor: Colors.pink),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('recipes').where('category', isEqualTo: categoryName).snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('No recipes found in this category.'));
          }
          var recipes = snapshot.data!.docs;
          return CustomScrollView(
            slivers: [
              SliverPadding(
                padding: EdgeInsets.symmetric(horizontal: 15, vertical: 20),
                sliver: SliverGrid(
                  delegate: SliverChildBuilderDelegate(
                        (context, index) {
                      var recipe = recipes[index];
                      final recipeName = recipe['recipeName'];
                      final isFavorite = recipe['favoriteState'];
                      final thumbnailUrl = recipe['thumbnailUrl'] ?? 'https://via.placeholder.com/150'; // Fallback image
                      final estimatedTime = recipe['estimatedTime'];
                      return GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (BuildContext context) => Recipe(
                                recipeId: recipe.id,
                              ),
                            ),
                          );
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                color: Color.fromARGB(255, 185, 185, 185),
                                offset: Offset(1, 1),
                                blurRadius: 15,
                              ),
                            ],
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Column(
                            children: [
                              SizedBox(height: 10),
                              Padding(
                                padding: const EdgeInsets.only(right: 14),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        // Toggle favorite functionality
                                      },
                                      child: Icon(
                                        isFavorite ? Icons.favorite : Icons.favorite_border,
                                        color: isFavorite ? maincolor : Colors.grey,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                                child: Container(
                                  height: 120,
                                  width: 120,
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                      image: NetworkImage(thumbnailUrl),
                                      fit: BoxFit.cover,
                                    ),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                ),
                              ),
                              SizedBox(height: 20),
                              Text(
                                recipeName,
                                style: TextStyle(
                                  fontSize: 18,
                                  color: font,
                                  fontFamily: 'ro',
                                ),
                              ),
                              SizedBox(height: 10),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: [
                                  Text(
                                    '$estimatedTime min',
                                    style: TextStyle(
                                      fontSize: 15,
                                      color: Colors.grey,
                                      fontFamily: 'ro',
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                      );
                    },
                    childCount: recipes.length,
                  ),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisExtent: 270,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}