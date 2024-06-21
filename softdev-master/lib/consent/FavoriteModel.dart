import 'package:flutter/foundation.dart';

class FavoriteModel extends ChangeNotifier {
  List<bool> _isFavoriteList = List.generate(4, (index) => false);

  List<bool> get isFavoriteList => _isFavoriteList;

  void toggleFavorite(int index) {
    _isFavoriteList[index] = !_isFavoriteList[index];
    notifyListeners();
  }
}