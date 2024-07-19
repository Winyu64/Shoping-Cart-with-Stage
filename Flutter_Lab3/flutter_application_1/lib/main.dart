import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

void main() {
  runApp(MainApp());
}

class MainApp extends StatefulWidget {
  MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  final ValueNotifier<int> totalQuantity = ValueNotifier<int>(0); // ใช้ ValueNotifier เพื่อเก็บผลรวมของจำนวนสินค้า
  final ValueNotifier<double> totalPrice = ValueNotifier<double>(0.0); // ใช้ ValueNotifier เพื่อเก็บผลรวมของราคาสินค้า

  void _clearAll() {
    // ฟังก์ชันรีเซ็ตจำนวนสินค้าทั้งหมด
    setState(() {
      totalQuantity.value = 0;
      totalPrice.value = 0.0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text("Shopping Cart"),
          backgroundColor: Colors.deepOrange,
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Expanded(
                child: ListView(
                  children: [
                    ShoppingItem(
                      title: "iPad Pro",
                      price: 39000.00,
                      imageUrl: "assets/images/ipad_pro.jpg",
                      totalQuantity: totalQuantity,
                      totalPrice: totalPrice,
                    ),
                    ShoppingItem(
                      title: "iPad Air",
                      price: 29000.00,
                      imageUrl: "assets/images/ipad_air.jpg",
                      totalQuantity: totalQuantity,
                      totalPrice: totalPrice,
                    ),
                    ShoppingItem(
                      title: "iPad Mini",
                      price: 23000.00,
                      imageUrl: "assets/images/ipad_mini.jpg",
                      totalQuantity: totalQuantity,
                      totalPrice: totalPrice,
                    ),
                    ShoppingItem(
                      title: "iPad",
                      price: 19000.00,
                      imageUrl: "assets/images/ipad.jpg",
                      totalQuantity: totalQuantity,
                      totalPrice: totalPrice,
                    ),
                  ],
                ),
              ),
              const Divider(thickness: 2),
              ValueListenableBuilder<int>(
                valueListenable: totalQuantity,
                builder: (context, value, child) {
                  return Text(
                    "Total Quantity: $value", // แสดงผลรวมของจำนวนสินค้า
                    style: const TextStyle(fontSize: 20),
                  );
                },
              ),
              ValueListenableBuilder<double>(
                valueListenable: totalPrice,
                builder: (context, value, child) {
                  final currencyFormat = NumberFormat("#,##0.00", "th_TH");
                  return Text(
                    "Total Price: ฿${currencyFormat.format(value)}", // แสดงผลรวมของราคาสินค้า
                    style: const TextStyle(fontSize: 28),
                  );
                },
              ),
              ElevatedButton(
                onPressed: _clearAll,
                child: const Text("Clear"),
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.red), // สีพื้นหลัง
                  foregroundColor: MaterialStateProperty.all(Colors.white), // สีข้อความ
                  padding: MaterialStateProperty.all(const EdgeInsets.symmetric(vertical: 15, horizontal: 30)),
                  textStyle: MaterialStateProperty.all(const TextStyle(fontSize: 20)),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class ShoppingItem extends StatefulWidget {
  final String title;
  final double price;
  final String imageUrl;
  final ValueNotifier<int> totalQuantity;
  final ValueNotifier<double> totalPrice;

  ShoppingItem({
    required this.title,
    required this.price,
    required this.imageUrl,
    required this.totalQuantity,
    required this.totalPrice,
  });

  @override
  State<ShoppingItem> createState() => _ShoppingItemState();
}

class _ShoppingItemState extends State<ShoppingItem> {
  int count = 0; // เก็บจำนวนสินค้าของแต่ละรายการ
  bool isSelected = false; // ใช้เก็บสถานะว่าผู้ใช้เลือกสินค้าหรือไม่

  void _updateTotalQuantity(int change) {
    widget.totalQuantity.value += change; // อัพเดตผลรวมของจำนวนสินค้า
  }

  void _updateTotalPrice(double change) {
    widget.totalPrice.value += change; // อัพเดตผลรวมของราคาสินค้า
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Image.asset(
              widget.imageUrl, // แสดงรูปภาพสินค้า
              width: 100,
              height: 100,
              fit: BoxFit.cover,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.title, // แสดงชื่อสินค้า
                    style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "฿${widget.price.toStringAsFixed(2)}", // แสดงราคาสินค้า
                    style: const TextStyle(fontSize: 24),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Switch(
                        value: isSelected,
                        onChanged: (bool value) {
                          setState(() {
                            isSelected = value; // อัพเดตสถานะของสวิตช์
                            if (!isSelected) {
                              _updateTotalQuantity(-count); // หักจำนวนสินค้าออกจากผลรวมถ้าผู้ใช้ปิดสวิตช์
                              _updateTotalPrice(-count * widget.price); // หักราคาสินค้าออกจากผลรวมถ้าผู้ใช้ปิดสวิตช์
                              count = 0; // รีเซ็ตจำนวนสินค้าเป็น 0
                            }
                          });
                        },
                      ),
                      if (isSelected) // ถ้าผู้ใช้เลือกสินค้าจะแสดงปุ่มเพิ่มและลดจำนวนสินค้า
                        Row(
                          children: [
                            IconButton(
                              onPressed: () {
                                setState(() {
                                  if (count > 0) {
                                    count--; // ลดจำนวนสินค้า
                                    _updateTotalQuantity(-1); // หัก 1 ออกจากผลรวมของจำนวนสินค้า
                                    _updateTotalPrice(-widget.price); // หักราคาสินค้าออกจากผลรวมของราคา
                                  }
                                });
                              },
                              icon: const Icon(Icons.remove),
                            ),
                            Text(
                              count.toString(), // แสดงจำนวนสินค้า
                              style: const TextStyle(fontSize: 28),
                            ),
                            IconButton(
                              onPressed: () {
                                setState(() {
                                  count++; // เพิ่มจำนวนสินค้า
                                  _updateTotalQuantity(1); // เพิ่ม 1 เข้าไปในผลรวมของจำนวนสินค้า
                                  _updateTotalPrice(widget.price); // เพิ่มราคาสินค้าเข้าไปในผลรวมของราคา
                                });
                              },
                              icon: const Icon(Icons.add),
                            ),
                          ],
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
