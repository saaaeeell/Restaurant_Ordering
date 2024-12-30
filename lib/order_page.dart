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
  Map<MenuItem, int> itemCounts = {}; // Menyimpan jumlah setiap item

  @override
  void initState() {
    super.initState();
    cart = List.from(widget.selectedItems);
    for (var item in cart) {
      itemCounts[item] = 1; // Inisialisasi jumlah setiap item
    }
  }

  @override
  Widget build(BuildContext context) {
    double total =
        cart.fold(0, (sum, item) => sum + (item.price * itemCounts[item]!));

    return Scaffold(
      appBar: AppBar(title: Text("Order Summary")),
      body: Column(
        children: [
          Expanded(
            child: cart.isEmpty
                ? Center(
                    child: Text(
                      "Keranjang Anda kosong!",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  )
                : ListView.builder(
                    itemCount: cart.length,
                    itemBuilder: (context, index) {
                      var item = cart[index];
                      return ListTile(
                        leading: Icon(Icons.fastfood),
                        title: Text(item.name),
                        subtitle:
                            Text("Rp ${item.price} x ${itemCounts[item]}"),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: Icon(Icons.remove, color: Colors.red),
                              onPressed: () {
                                setState(() {
                                  if (itemCounts[item]! > 1) {
                                    itemCounts[item] =
                                        itemCounts[item]! - 1; // Kurangi jumlah
                                  } else {
                                    cart.removeAt(
                                        index); // Hapus item jika jumlahnya 0
                                    itemCounts.remove(item);
                                  }
                                });
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      content: Text("${item.name} removed")),
                                );
                              },
                            ),
                            IconButton(
                              icon: Icon(Icons.add, color: Colors.green),
                              onPressed: () {
                                setState(() {
                                  itemCounts[item] =
                                      itemCounts[item]! + 1; // Tambah jumlah
                                });
                              },
                            ),
                          ],
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
                    widget
                        .onOrderConfirmed(); // Kosongkan keranjang di HomePage
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
