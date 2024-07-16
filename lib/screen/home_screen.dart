import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';
import 'package:payment_app/product.dart';
import 'package:payment_app/screen/confirm_screen.dart';



class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  int _count = 1;

  List<Product> products  = [
    Product(
      name: 'กางเกงยีนส์ Jean pants',
      detail: 'รายละเอียดสินค้า \nแข็งแรง ทนทาน ใส่ได้นาน สีไม่ซีด',
      price: 239,
      stock: 350,
      imagePath: [
        'images/1.jpg',
        'images/2.jpg',
        'images/3.jpg',
      ]
    ),
  ];
  

  void _increment() {
    setState(() {
        _count++;
    });
  }

  void _decrement() {
    setState(() {
      if (_count > 0) {
        _count--;
      }
    });
  }
  void _pay() {
    setState(() {
      if (_count > 0) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ConfirmScreen(
              productName: products[0].name,
              totalPrice: products[0].price * _count,
              quantity: _count,
              onConfirm: () {
                setState(() {
                  products[0].stock -= _count;
                  _count = 0;
                });
              },
            ),
          ),
        );
      }
    });
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Monoproduct'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            height: 250,
            padding: EdgeInsets.all(10),
            child: SwiperItems(products[0]),
          ),
          Padding(
            padding: const EdgeInsets.all(5.0),
            child: Text(
              '${products[0].name}',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text('${products[0].detail}',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Text('ราคา: ${products[0].price} บาท'),
                Spacer(),
                Text('จำนวนคงเหลือ: ${products[0].stock} ชิ้น'),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                IconButton(
                  icon: Icon(Icons.remove),
                  onPressed: () {
                    // ลดจำนวนสินค้า
                    _decrement();
                  },
                ),
                Text(
                  '$_count', // จำนวนสินค้าปัจจุบัน
                  style: TextStyle(fontSize: 18),
                ),
                IconButton(
                  icon: Icon(Icons.add),
                  onPressed: () {
                    _increment();
                  },
                ),
                Text('ชิ้น'),
              ],),
          ),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  _pay();
                },
                child: Text('ชำระเงินเลย'),
              ),
            )
        ],
        ),
    );
  }
}

class SwiperItems extends StatelessWidget {
  final Product product;

  SwiperItems(this.product);

  @override
  Widget build(BuildContext context) {
    return Swiper(
      itemCount: product.imagePath.length, // จำนวนของรูปภาพในแต่ละรายการสินค้า
      itemBuilder: (context, index) {
        return ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Image.asset(
            product.imagePath[index], // แสดงรูปภาพตามลำดับในรายการรูปภาพ
            fit: BoxFit.cover,
          ),
        );
      },
      pagination: SwiperPagination(), // เพิ่มแสดงหมายเลขหน้าของ Swiper
      control: SwiperControl(), // เพิ่มปุ่มควบคุมของ Swiper
    );
  }
  }