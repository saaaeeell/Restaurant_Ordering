import 'package:flutter/material.dart';
import 'menu_data.dart';

class OrderPage extends StatefulWidget {
  final List<MenuItem> selectedItems;
  final VoidCallback onOrderConfirmed;

  OrderPage({required this.selectedItems, required this.onOrderConfirmed});

  @override
  _OrderPageState createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {
  late List<MenuItem> cart;

  @override
  void initState() {
    super.initState();
    cart = List.from(widget.selectedItems); // Salin isi keranjang
  }

  @override
  Widget build(BuildContext context) {
    double total = cart.fold(0, (sum, item) => sum + item.price);

    return Scaffold(
      appBar: AppBar(title: Text("Order Summary")),
      body: Column(
        children: [
          Expanded(
            child: cart.isEmpty
                ? Center(
                    child: Text(
                      "Keranjang Anda kosong!",
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  )
                : ListView.builder(
                    itemCount: cart.length,
                    itemBuilder: (context, index) {
                      var item = cart[index];
                      return ListTile(
                        leading: Icon(Icons.fastfood),
                        title: Text(item.name),
                        subtitle: Text("Rp ${item.price}"),
                        trailing: IconButton(
                          icon: Icon(Icons.delete, color: Colors.red),
                          onPressed: () {
                            setState(() {
                              cart.removeAt(index); // Hapus item dari keranjang
                            });
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text("${item.name} removed")),
                            );
                          },
                        ),
                      );
                    },
                  ),
          ),
          Divider(),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Total: Rp $total",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () {
                    widget.onOrderConfirmed(); // Kosongkan keranjang di HomePage
                    Navigator.pop(context); // Kembali ke HomePage
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Pesanan berhasil!")),
                    );
                  },
                  child: Text("Confirm Order"),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
