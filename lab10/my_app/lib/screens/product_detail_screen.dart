import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cart_provider.dart';
import '../models/product_model.dart'; // import model มาด้วย

class ProductDetailScreen extends StatelessWidget {
  final ProductModel product; // ระบุ Type ให้ชัดเจน

  const ProductDetailScreen({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Product Details")),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: 350,
              width: double.infinity,
              color: Colors.white,
              padding: const EdgeInsets.all(20),
              child: Hero(
                tag: 'product-${product.id}',
                child: Image.network(product.image, fit: BoxFit.contain),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Chip(label: Text(product.category.toUpperCase())),
                      Row(
                        children: [
                          const Icon(Icons.star, color: Colors.orange, size: 20),
                          // แก้จุดนี้: ใช้ product.rating.rate
                          Text(" ${product.rating.rate} (${product.rating.count})"),
                        ],
                      )
                    ],
                  ),
                  const SizedBox(height: 15),
                  Text(product.title, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),
                  Text("\$${product.price.toStringAsFixed(2)}", style: const TextStyle(fontSize: 24, color: Colors.green, fontWeight: FontWeight.bold)),
                  const Divider(height: 30),
                  const Text("Description", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),
                  // จุดนี้จะไม่ Error แล้วเพราะเราเพิ่ม description ใน Model แล้ว
                  Text(product.description, style: const TextStyle(fontSize: 16, height: 1.5)),
                  const SizedBox(height: 100),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomSheet: Container(
        padding: const EdgeInsets.all(20),
        child: ElevatedButton(
          onPressed: () {
            // เรียกใช้ CartProvider เพื่อเพิ่มสินค้า
            context.read<CartProvider>().addToCart(product);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("เพิ่ม ${product.title} ลงตะกร้าแล้ว!"), backgroundColor: Colors.green),
            );
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue,
            foregroundColor: Colors.white,
            minimumSize: const Size(double.infinity, 50),
          ),
          child: const Text("ADD TO CART"),
        ),
      ),
    );
  }
}