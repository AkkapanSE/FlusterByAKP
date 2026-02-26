import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/product_provider.dart';
import '../providers/cart_provider.dart'; // เพิ่มการนำเข้า CartProvider
import 'product_detail_screen.dart';

class ProductListScreen extends StatefulWidget {
  const ProductListScreen({super.key});

  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  @override
  void initState() {
    super.initState();
    // ดึงข้อมูลสินค้าจาก API เมื่อเปิดหน้าจอครั้งแรก
    Future.microtask(() =>
        context.read<ProductProvider>().loadProducts());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("FakeStore Products"),
        centerTitle: true,
        elevation: 2,
        actions: [
          // ส่วนแสดงปุ่มตะกร้าสินค้าพร้อมตัวเลขแจ้งเตือน (Badge)
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Stack(
              alignment: Alignment.center,
              children: [
                IconButton(
                  icon: const Icon(Icons.shopping_cart, size: 28),
                  onPressed: () {
                    // นำทางไปหน้าตะกร้าสินค้า
                    Navigator.pushNamed(context, '/cart');
                  },
                ),
                // ตัวเลขแสดงจำนวนสินค้าในตะกร้า
                Positioned(
                  right: 4,
                  top: 4,
                  child: Consumer<CartProvider>(
                    builder: (context, cart, child) {
                      return cart.itemCount > 0
                          ? Container(
                              padding: const EdgeInsets.all(2),
                              decoration: BoxDecoration(
                                color: Colors.red,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              constraints: const BoxConstraints(
                                minWidth: 18,
                                minHeight: 18,
                              ),
                              child: Text(
                                '${cart.itemCount}',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            )
                          : const SizedBox.shrink(); // ไม่แสดงถ้าตะกร้าว่าง
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      body: Consumer<ProductProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (provider.error != null) {
            return Center(child: Text("Error: ${provider.error}"));
          }

          if (provider.products.isEmpty) {
            return const Center(child: Text("ไม่พบสินค้าในระบบ"));
          }

          return GridView.builder(
            padding: const EdgeInsets.all(12),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, 
              childAspectRatio: 0.72, 
              mainAxisSpacing: 12, 
              crossAxisSpacing: 12,
            ),
            itemCount: provider.products.length,
            itemBuilder: (context, i) {
              final p = provider.products[i];
              
              return InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ProductDetailScreen(product: p),
                    ),
                  );
                },
                child: Card(
                  elevation: 2,
                  clipBehavior: Clip.antiAlias,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // ส่วนแสดงรูปภาพสินค้า
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          width: double.infinity,
                          color: Colors.white,
                          child: Hero(
                            tag: 'product-${p.id}',
                            child: Image.network(
                              p.image, 
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                      ),
                      // ส่วนข้อมูลสินค้า
                      Padding(
                        padding: const EdgeInsets.all(10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              p.title, 
                              maxLines: 2, 
                              overflow: TextOverflow.ellipsis, 
                              style: const TextStyle(
                                fontWeight: FontWeight.bold, 
                                fontSize: 13,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              "\$${p.price.toStringAsFixed(2)}", 
                              style: const TextStyle(
                                color: Colors.green, 
                                fontSize: 16, 
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}