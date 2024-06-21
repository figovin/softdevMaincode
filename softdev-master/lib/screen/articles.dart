import 'package:flutter/material.dart';
import 'package:recipe/consent/appbar.dart';

class Category extends StatelessWidget {
  const Category({Key? key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appbar(),
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
              return GestureDetector(
                onTap: () {
                  // Navigasi ke halaman baru ketika gambar diklik
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => DetailPage(index)),
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

class DetailPage extends StatelessWidget {
  final int index;

  DetailPage(this.index);

  @override
  Widget build(BuildContext context) {
    final pages = [
      ThaiFoodPage(),
      FastFoodPage(),
      ItalianFoodPage(),
      MexicanFoodPage(),
      JapaneseFoodPage(),
      IndomiePage(),
    ];

    if (index >= 0 && index < pages.length) {
      return pages[index];
    } else {
      return Scaffold(
        appBar: AppBar(title: Text('Detail Page'), backgroundColor: Colors.red),
        body: Center(child: Text('Invalid index')),
      );
    }
  }
}

class ThaiFoodPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Thai Food'), backgroundColor: Color(0xfff96163)),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'Memperkenalkan Kelezatan Masakan Thailand\n\n'
                  'Masakan Thailand telah mendunia berkat keunikan rasa yang dimilikinya, '
                  'ditandai dengan penggunaan rempah-rempah khas dan perpaduan rasa yang '
                  'seimbang antara manis, pedas, asam, asin, dan pahit. Kelezatan dan aroma '
                  'yang kaya membuat masakan Thailand tidak hanya memanjakan lidah, tetapi '
                  'juga menggambarkan kekayaan budaya dan sejarahnya.\n\n',

              style: TextStyle(fontSize: 16.0),
            ),
            Text(
              'Warisan Budaya dalam Masakan**\n\n'
                  'Masakan Thailand mencerminkan kekayaan warisan budaya, dipengaruhi oleh '
                  'sejarah panjang negaranya sebagai pusat perdagangan di Asia Tenggara. '
                  'Pengaruh dari Tiongkok, India, dan bahkan Eropa turut mempengaruhi evolusi '
                  'masakan Thailand yang beragam. Bumbu-bumbu seperti serai, daun jeruk purut, '
                  'jahe, dan pasta cabai merah (nam phrik) menjadi pilar utama dalam penggunaan '
                  'bahan-bahan ini dalam hidangan sehari-hari.\n\n',

              style: TextStyle(fontSize: 16.0),
            ),
            Text(
              'Komponen Utama Masakan Thailand\n\n'
                  '- Nasi: Sebagai makanan pokok, nasi putih dimakan bersama hampir setiap '
                  'hidangan Thailand. Biasanya disajikan dengan berbagai hidangan seperti sup, '
                  'kari, atau hidangan berkuah lainnya.\n\n'
                  '- Kari Thai (Kaeng): Kari Thailand memiliki berbagai variasi, mulai dari '
                  'yang berbahan dasar kelapa dengan warna kuning hingga yang pedas dengan '
                  'bahan dasar air. Daging, unggas, ikan, atau sayuran bisa diolah menjadi '
                  'hidangan kari yang khas dengan berbagai cita rasa.\n\n',

              style: TextStyle(fontSize: 16.0),
            ),
            Text(
              'Masakan Thailand tidak hanya menciptakan sensasi rasa yang memukau, tetapi '
                  'juga mengajak untuk memahami dan menghargai budaya yang kaya dan kompleks '
                  'di balik setiap hidangan. Keunikan masakan ini menjadikannya salah satu '
                  'dari yang terbaik di dunia kuliner global.',
              textAlign: TextAlign.justify,
              style: TextStyle(fontSize: 16.0),
            ),
          ],
        ),
      ),
    );
  }
}

class FastFoodPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Fast Food'), backgroundColor: Color(0xfff96163)),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'Artikel tentang Fast Food\n\n'
                  'Ini adalah artikel tentang makanan cepat saji. Ceritakan tentang sejarah, '
                  'popularitas, dan variasi fast food di berbagai belahan dunia. Jelaskan bagaimana '
                  'fast food telah menjadi bagian penting dari gaya hidup modern, tetapi juga '
                  'menyuarakan perdebatan tentang dampaknya terhadap kesehatan.',
              style: TextStyle(fontSize: 16.0),
            ),
          ],
        ),
      ),
    );
  }
}

class ItalianFoodPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Italian Food'), backgroundColor: Color(0xfff96163)),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'Artikel tentang Masakan Italia\n\n'
                  'Ini adalah artikel yang membahas tentang masakan Italia. Ceritakan tentang '
                  'kelezatan pasta, pizza, dan hidangan khas Italia lainnya. Jelaskan pentingnya '
                  'bahan-bahan segar dan metode memasak tradisional yang membuat masakan Italia '
                  'begitu dicintai di seluruh dunia.',
              style: TextStyle(fontSize: 16.0),
            ),
          ],
        ),
      ),
    );
  }
}

class MexicanFoodPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Mexican Food'), backgroundColor: Color(0xfff96163)),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'Artikel tentang Masakan Meksiko\n\n'
                  'Ini adalah artikel yang membahas tentang masakan Meksiko. Ceritakan tentang '
                  'keanekaragaman rasa dari hidangan seperti tacos, burritos, dan guacamole. '
                  'Jelaskan penggunaan bahan-bahan seperti kacang hitam, jagung, dan cabai '
                  'yang membuat masakan Meksiko begitu unik dan lezat.',
              style: TextStyle(fontSize: 16.0),
            ),
          ],
        ),
      ),
    );
  }
}

class JapaneseFoodPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Japanese Food'), backgroundColor: Color(0xfff96163)),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'Artikel tentang Masakan Jepang\n\n'
                  'Ini adalah artikel yang membahas tentang masakan Jepang. Ceritakan tentang '
                  'kesederhanaan dan kehalusan rasa dari hidangan seperti sushi, sashimi, dan '
                  'ramen. Jelaskan tentang nilai estetika dan kualitas bahan baku yang tinggi '
                  'yang menjadi ciri khas masakan Jepang.',
              style: TextStyle(fontSize: 16.0),
            ),
          ],
        ),
      ),
    );
  }
}

class IndomiePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Indomie'), backgroundColor: Color(0xfff96163)),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'Artikel tentang Indomie\n\n'
                  'Ini adalah artikel yang membahas tentang Indomie, mie instan yang populer di '
                  'Indonesia dan dunia. Ceritakan tentang sejarah pembuatan, variasi rasa, dan '
                  'populernya di kalangan masyarakat. Jelaskan cara memasak Indomie dan berbagai '
                  'resep kreatif yang dapat dibuat dengan Indomie sebagai bahan utamanya.',
              style: TextStyle(fontSize: 16.0),
            ),
          ],
        ),
      ),
    );
  }
}