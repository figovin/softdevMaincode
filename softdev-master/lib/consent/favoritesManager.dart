class FavoritesManager {
  static final FavoritesManager _instance = FavoritesManager._internal();
  factory FavoritesManager() => _instance;
  FavoritesManager._internal();

  final List<String> favoriteRecipes = [];

  void toggleFavorite(String recipeName) {
    if (favoriteRecipes.contains(recipeName)) {
      favoriteRecipes.remove(recipeName);
    } else {
      favoriteRecipes.add(recipeName);
    }
  }
  Map<String, dynamic> getRecipeDetails(String recipeName) {
    final categories = [
      ['Soto Tangkar', 'Hot Pot', 'Dumplings', 'Dendeng'],
      ['Rendang', 'Sate Padang', 'Ayam Pop', 'Gulai Ayam'],
      ['Dim Sum', 'Mapo Tofu', 'Char Siu', 'Kung Pao Chicken'],
      ['Soto Betawi', 'Nasi Uduk', 'Ketoprak', 'Gado-Gado'],
    ];
    final categoryNames = ['All', 'Padang', 'Chinese', 'Betawi'];

    for (var i = 0; i < categories.length; i++) {
      for (var j = 0; j < categories[i].length; j++) {
        if (categories[i][j] == recipeName) {
          return {
            'categoryName': categoryNames[i],
            'index': j,
          };
        }
      }
    }
    return {};
  }
}