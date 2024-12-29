import 'package:flutter/material.dart';
import 'menu_data.dart';
import 'order_page.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<MenuItem> cart = [];

  // Menambah item ke keranjang
  void addToCart(MenuItem item) {
    setState(() {
      cart.add(item);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("${item.name} added to cart")),
    );
  }

  // Mengosongkan keranjang setelah konfirmasi
  void clearCart() {
    setState(() {
      cart.clear(); // Kosongkan keranjang
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Menu Restaurant")),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              children: [
                CategorySection(
                  title: "Food Menu",
                  menuList: foodMenu,
                  onAddToCart: addToCart,
                ),
                CategorySection(
                  title: "Drink Menu",
                  menuList: drinkMenu,
                  onAddToCart: addToCart,
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.shopping_cart),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => OrderPage(
                selectedItems: cart,
                onOrderConfirmed: clearCart, // Callback untuk mengosongkan keranjang
              ),
            ),
          );
        },
      ),
    );
  }
}

class CategorySection extends StatelessWidget {
  final String title;
  final List<MenuItem> menuList;
  final Function(MenuItem) onAddToCart;

  CategorySection({
    required this.title,
    required this.menuList,
    required this.onAddToCart,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            title,
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
        ),
        Container(
          height: 250,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: menuList.length,
            itemBuilder: (context, index) {
              var menu = menuList[index];
              return Card(
                margin: EdgeInsets.symmetric(horizontal: 10),
                child: Column(
                  children: [
                    Image.asset(menu.image, width: 150, height: 150),
                    Text(menu.name),
                    Text("Rp ${menu.price}"),
                    ElevatedButton(
                      onPressed: () => onAddToCart(menu),
                      child: Text("Add to Cart"),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
