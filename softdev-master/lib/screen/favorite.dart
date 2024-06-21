import 'package:flutter/material.dart';
import 'package:recipe/consent/appbar.dart';
import 'package:recipe/consent/favoritesManager.dart';

class Favorite extends StatefulWidget {
  const Favorite({Key? key}) : super(key: key);

  @override
  _FavoriteState createState() => _FavoriteState();
}

class _FavoriteState extends State<Favorite> {
  @override
  Widget build(BuildContext context) {
    final favoritesManager = FavoritesManager();
    return Scaffold(
      appBar: appbar(),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'Favorite Recipes',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          SliverGrid(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 8.0,
              crossAxisSpacing: 8.0,
              childAspectRatio: 1.0,
            ),
            delegate: SliverChildBuilderDelegate(
                  (BuildContext context, int index) {
                final recipeName = favoritesManager.favoriteRecipes[index];
                final recipeDetails = favoritesManager.getRecipeDetails(recipeName);
                final categoryName = recipeDetails['categoryName'];
                final recipeIndex = recipeDetails['index'];

                return GestureDetector(
                  onTap: () {
                    // Navigate to recipe details if needed
                  },
                  child: Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12.0),
                        child: Image.asset(
                          'images/${categoryName}${recipeIndex}.jpg',
                          fit: BoxFit.cover,
                          width: double.infinity,
                          height: double.infinity,
                        ),
                      ),
                      Positioned(
                        top: 8,
                        right: 8,
                        child: Icon(
                          Icons.favorite,
                          color: Colors.red,
                        ),
                      ),
                    ],
                  ),
                );
              },
              childCount: favoritesManager.favoriteRecipes.length,
            ),
          ),
        ],
      ),
    );
  }
}