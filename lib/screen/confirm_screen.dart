import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:payment_app/screen/success_screen.dart';

class ConfirmScreen extends StatefulWidget {
  final String productName;
  final int totalPrice;
  final int quantity;
  final VoidCallback onConfirm;

  ConfirmScreen({
    required this.productName,
    required this.totalPrice,
    required this.quantity,
    required this.onConfirm,
  });

  @override
  State<ConfirmScreen> createState() => _ConfirmScreenState();
}

class _ConfirmScreenState extends State<ConfirmScreen> {
  String orderId = '';
  String selectedPayment = '';

  TextEditingController addressController = TextEditingController();
  TextEditingController cardNumberController = TextEditingController();
  TextEditingController cardHolderController = TextEditingController();
  TextEditingController expiryDateController = TextEditingController();
  TextEditingController cvcController = TextEditingController();

  TextEditingController paypalEmailController = TextEditingController();

  @override
  void initState() {
    super.initState();
    orderId = generateOrderId();
  }

  void _saveOrderAsJson() {
    Map<String, dynamic> orderData = {
      'orderId': orderId,
      'productName': widget.productName,
      'totalPrice': widget.totalPrice,
      'quantity': widget.quantity,
      'address': addressController.text.trim(),
      'paymentMethod': selectedPayment,
      if (selectedPayment == 'credit_card')
        'creditCardDetails': {
          'cardNumber': cardNumberController.text.trim(),
          'cardHolder': cardHolderController.text.trim(),
          'expiryDate': expiryDateController.text.trim(),
          'cvc': cvcController.text.trim(),
        },
      if (selectedPayment == 'paypal')
        'paypalEmail': paypalEmailController.text.trim(),
    };

    String orderJson = jsonEncode(orderData);
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => SuccessScreen(orderJson: orderJson),
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ConfirmPayment'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Text(
                  'Order ID: $orderId',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Row(
                  children: [
                    Text(
                      '${widget.productName} ${widget.quantity} ชิ้น',
                      style: TextStyle(fontSize: 18),
                    ),
                    Spacer(),
                    Text(
                      'ราคา: ${widget.totalPrice} บาท',
                      style: TextStyle(fontSize: 18),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'ที่อยู่จัดส่ง',
                  style: TextStyle(fontSize: 18),
                ),
              ),
              TextFormField(
                controller: addressController,
                maxLines: 3,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'ที่อยู่',
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Text(
                  'เลือกช่องทางชำระเงิน',
                  style: TextStyle(fontSize: 18),
                ),
              ),
              Column(
                children: [
                  RadioListTile<String>(
                    title: Text('ชำระเงินผ่านบัตรเครดิต'),
                    value: 'credit_card',
                    groupValue: selectedPayment,
                    onChanged: (value) {
                      setState(() {
                        selectedPayment = value!;
                      });
                    },
                  ),
                  Visibility(
                    visible: selectedPayment == 'credit_card',
                    child: Column(
                      children: [
                        TextFormField(
                          controller: cardNumberController,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'หมายเลขบัตร',
                          ),
                          keyboardType: TextInputType.number,
                        ),
                        SizedBox(height: 10),
                        TextFormField(
                          controller: cardHolderController,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'ชื่อผู้ถือบัตร',
                          ),
                        ),
                        SizedBox(height: 10),
                        Row(
                          children: [
                            Expanded(
                              child: TextFormField(
                                controller: expiryDateController,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  labelText: 'วันหมดอายุ (MM/YY)',
                                ),
                                keyboardType: TextInputType.datetime,
                              ),
                            ),
                            SizedBox(width: 10),
                            Expanded(
                              child: TextFormField(
                                controller: cvcController,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  labelText: 'CVC',
                                ),
                                keyboardType: TextInputType.number,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  RadioListTile<String>(
                    title: Text('ชำระเงินผ่าน PayPal'),
                    value: 'paypal',
                    groupValue: selectedPayment,
                    onChanged: (value) {
                      setState(() {
                        selectedPayment = value!;
                      });
                    },
                  ),
                  Visibility(
                    visible: selectedPayment == 'paypal',
                    child: TextFormField(
                      controller: paypalEmailController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'อีเมล PayPal',
                      ),
                      keyboardType: TextInputType.emailAddress,
                    ),
                  )
                ],
              ),
              SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    String address = addressController.text.trim();
                    if (address.isNotEmpty && selectedPayment.isNotEmpty) {
                      _saveOrderAsJson();
                    }
                  },
                  child: Text(
                    'OK',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

String generateOrderId() {
  // Generate a random number between 10000 and 99999
  var random = Random();
  var orderId = random.nextInt(90000) + 10000;
  return 'ORD$orderId'; // Format as ORD followed by the random number
}
