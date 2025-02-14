import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BillingScreen extends StatefulWidget {
  const BillingScreen({super.key});

  @override
  _BillingScreenState createState() => _BillingScreenState();
}

class _BillingScreenState extends State<BillingScreen> {
  late int billNumber;
  List<Map<String, dynamic>> cart = [];

  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController addressController = TextEditingController();

  final TextEditingController productController = TextEditingController();
  final TextEditingController categoryController = TextEditingController();
  final TextEditingController countController = TextEditingController();
  final TextEditingController costController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchLastBillNumber();
  }

  void fetchLastBillNumber() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      billNumber = prefs.getInt('lastBillNumber') ?? 1;
    });
  }

  double getTotalAmount() {
    return cart.fold(0.0, (total, item) => total + (item["cost"] as num));
  }

  void handleAddProduct() {
    if (productController.text.isEmpty ||
        categoryController.text.isEmpty ||
        countController.text.isEmpty ||
        costController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill in all product details.")),
      );
      return;
    }

    setState(() {
      cart.add({
        "product": productController.text,
        "category": categoryController.text,
        "count": int.parse(countController.text),
        "cost": double.parse(costController.text),
      });
    });

    productController.clear();
    categoryController.clear();
    countController.clear();
    costController.clear();
  }

  void handleBilling() async {
    if (nameController.text.isEmpty ||
        emailController.text.isEmpty ||
        addressController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill in all customer details.")),
      );
      return;
    }

    if (cart.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("No items in the cart.")),
      );
      return;
    }

    final newBill = {
      "billNumber": billNumber,
      "customer": {
        "name": nameController.text,
        "email": emailController.text,
        "address": addressController.text,
      },
      "cart": cart,
      "totalAmount": getTotalAmount(),
      "date": DateTime.now().toIso8601String().split("T")[0],
    };

    // Save the bill in SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    List<String> billingHistory = prefs.getStringList('billingHistory') ?? [];
    billingHistory.add(jsonEncode(newBill));
    await prefs.setStringList('billingHistory', billingHistory);
    await prefs.setInt('lastBillNumber', billNumber + 1);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Bill #$billNumber generated successfully!")),
    );

    setState(() {
      cart.clear();
      billNumber++;
    });

    Navigator.pushNamed(context, '/billing-history');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Billing')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Bill Number: $billNumber',
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              const Text('Customer Details',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              TextField(
                  controller: nameController,
                  decoration: const InputDecoration(
                      labelText: 'Customer Name',
                      border: OutlineInputBorder())),
              const SizedBox(height: 10),
              TextField(
                  controller: emailController,
                  decoration: const InputDecoration(
                      labelText: 'Customer Email',
                      border: OutlineInputBorder())),
              const SizedBox(height: 10),
              TextField(
                  controller: addressController,
                  decoration: const InputDecoration(
                      labelText: 'Customer Address',
                      border: OutlineInputBorder())),
              const SizedBox(height: 20),
              const Text('Add Product to Cart',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              TextField(
                  controller: productController,
                  decoration: const InputDecoration(
                      labelText: 'Product Name', border: OutlineInputBorder())),
              const SizedBox(height: 10),
              TextField(
                  controller: categoryController,
                  decoration: const InputDecoration(
                      labelText: 'Category', border: OutlineInputBorder())),
              const SizedBox(height: 10),
              TextField(
                  controller: countController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                      labelText: 'Count', border: OutlineInputBorder())),
              const SizedBox(height: 10),
              TextField(
                  controller: costController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                      labelText: 'Cost', border: OutlineInputBorder())),
              const SizedBox(height: 10),
              ElevatedButton(
                  onPressed: handleAddProduct,
                  child: const Text('Add Product')),
              const SizedBox(height: 20),
              ElevatedButton(
                  onPressed: handleBilling, child: const Text('Generate Bill')),
              const SizedBox(height: 10),
              ElevatedButton(
                  onPressed: () =>
                      Navigator.pushNamed(context, '/billing-history'),
                  child: const Text('View Billing History')),
            ],
          ),
        ),
      ),
    );
  }
}
