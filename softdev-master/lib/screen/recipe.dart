import 'package:flutter/material.dart';
import 'package:recipe/consent/colors.dart';
import 'package:recipe/userAuth/home.dart';

class Recipe extends StatefulWidget {
  final String recipeName;
  final String imagePath;
  // Add other recipe details here

  Recipe({required this.recipeName, required this.imagePath});

  @override
  _RecipeState createState() => _RecipeState();
}

class _RecipeState extends State<Recipe> {
  TextEditingController _ingredientsController = TextEditingController();
  TextEditingController _recipeDetailsController = TextEditingController();
  bool _isEditingIngredients = false;
  bool _isEditingRecipe = false;

  @override
  void initState() {
    super.initState();
    _ingredientsController.text = "1 ekor ayam kampung\n1 ruas jahe, geprek\nBumbu ungkep :\n4 siung bawang merah\n2 siung bawang putih\n2 buah kemiri\n1 sdt ketumbar \n1/2 sdt merica \n1 ruas jahe \n1 ruas kunyit \n3 sdm gula merah sisir \n7 sdm kecap manis \n2 daun salam \nsecukupnya Garam & kaldu bubuk";
    _recipeDetailsController.text = "1. Cuci bersih ayam. Kemudian rebus sebentar pake jahe geprek\n2. Haluskan semua bumbu ungkep kecuali gula, garam, kecap, dan daun salam. Kemudian tumis dengan sedikit minyak sampai harum. Masukkan gula garam & daun salam nya. Beri air sedikit agar gula cepet larut.\n3. Masukkan ayam nya. Aduk rata & masak sebentar sampai bumbu agak meresap. Kemudian beri air kira2 2 gelas. Beri kecap dan aduk rata. Oya saya rekomendasikan pake kecap cap bango ya biar warna nya lebih cantik :)\n4. Biarkan sampai air menyusut sambil sesekali diaduk2. Angkat.\n5. Panaskan teflon. Bakar ayam pake api kecil saja. Bakar sampai permukaan ayam terlihat mengkaramel & kecoklatan. Angkat.\n6. Ayam bakar siap disajikan. Makan bersama sambel goreng dan lalapan.";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              automaticallyImplyLeading: false,
              backgroundColor: Colors.white,
              expandedHeight: 400,
              flexibleSpace: FlexibleSpaceBar(
                background: Image.asset(
                  widget.imagePath,
                  fit: BoxFit.cover,
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
                    color: Colors.white,
                  ),
                  child: Column(
                    children: [
                      SizedBox(height: 15),
                      Container(
                        width: 80,
                        height: 4,
                        color: font,
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
                    child: Icon(
                      Icons.favorite_border,
                      size: 25,
                      color: font,
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
              child: _getbody(),
            )
          ],
        ),
      ),
    );
  }

  Widget _getbody() {
    return Wrap(
        children: [
        Container(
        width: double.infinity,
        color: Colors.white,
        child: Column(
          children: [
          Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Container(
              width: 33,
              height: 33,
              child: Image.asset('images/flash.png'),
            ),
            Container(
              width: 33,
              height: 33,
              child: Image.asset('images/meat.png'),
            ),
            Container(
              width: 33,
              height: 33,
              child: Image.asset('images/calories.png'),
            ),
            Container(
              width: 33,
              height: 33,
              child: Image.asset('images/star.png'),
            ),
          ],
        ),
        SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text(
              '120',
              style: TextStyle(
                fontSize: 15,
                color: Colors.grey,
                fontFamily: 'ro',
              ),
            ),
            Text(
              '150',
              style: TextStyle(
                fontSize: 15,
                color: Colors.grey,
                fontFamily: 'ro',
              ),
            ),
            Text(
              '10',
              style: TextStyle(
                fontSize: 15,
                color: Colors.grey,
                fontFamily: 'ro',
              ),
            ),
            Text(
              '4.4',
              style: TextStyle(
                fontSize: 15,
                color: Colors.grey,
                fontFamily: 'ro',
              ),
            ),
          ],
        ),
        SizedBox(height: 20),
        Padding(
          padding: const EdgeInsets.only(left: 15),
          child: Row(
            children: [
              Text(
                'Ingredients',
                style: TextStyle(
                  fontSize: 20,
                  color: font,
                  fontFamily: 'ro',
                ),
              ),
              Spacer(),
              IconButton(
                icon: Icon(
                  _isEditingIngredients ? Icons.save : Icons.edit,
                  color: font,
                ),
                onPressed: () {
                  setState(() {
                    _isEditingIngredients = !_isEditingIngredients;
                  });
                },
              ),
            ],
          ),
        ),
        Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
    child: _isEditingIngredients
    ? TextField(
    controller: _ingredientsController,
    maxLines: null,
    decoration: InputDecoration(
      border: InputBorder.none,
      hintText: '1 ekor ayam kampung/n1 ruas jahe, geprek/nBumbu ungkep :/n4 siung bawang merah/n2 siung bawang putih/n2 buah kemiri/n1 sdt ketumbar /n1/2 sdt merica /n1 ruas jahe /n1 ruas kunyit /n3 sdm gula merah sisir /n7 sdm kecap manis /n2 daun salam /nsecukupnya Garam & kaldu bubuk',
    ),
    )
        : Text(
      _ingredientsController.text,
      style: TextStyle(
        fontSize: 18,
        color: font,
        fontFamily: 'ro',
        fontWeight: FontWeight.w500,
      ),
    ),
        ),
            SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.only(left: 15),
              child: Row(
                children: [
                  Text(
                    'Recipe',
                    style: TextStyle(
                      fontSize: 20,
                      color: font,
                      fontFamily: 'ro',
                    ),
                  ),
                  Spacer(),
                  IconButton(
                    icon: Icon(
                      _isEditingRecipe ? Icons.save : Icons.edit,
                      color: font,
                    ),
                    onPressed: () {
                      setState(() {
                        _isEditingRecipe = !_isEditingRecipe;
                      });
                    },
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
              child: _isEditingRecipe
                  ? TextField(
                controller: _recipeDetailsController,
                maxLines: null,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Enter recipe details',
                ),
              )
                  : Text(
                _recipeDetailsController.text,
                style: TextStyle(
                  fontSize: 18,
                  color: font,
                  fontFamily: 'ro',
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
        ),
        ],
    );
  }
}