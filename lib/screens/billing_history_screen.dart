import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BillingHistoryScreen extends StatefulWidget {
  const BillingHistoryScreen({super.key});

  @override
  _BillingHistoryScreenState createState() => _BillingHistoryScreenState();
}

class _BillingHistoryScreenState extends State<BillingHistoryScreen> {
  List<Map<String, dynamic>> billingHistory = [];

  @override
  void initState() {
    super.initState();
    loadBillingHistory();
  }

  Future<void> loadBillingHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String>? history = prefs.getStringList('billingHistory');

    if (history != null) {
      billingHistory = history
          .map((bill) => jsonDecode(bill))
          .toList()
          .cast<Map<String, dynamic>>();
    } else {
      billingHistory = [];
    }

    setState(() {});
  }

  Future<void> deleteBill(int index) async {
    final prefs = await SharedPreferences.getInstance();
    billingHistory.removeAt(index);

    List<String> updatedHistory =
        billingHistory.map((bill) => jsonEncode(bill)).toList();
    await prefs.setStringList('billingHistory', updatedHistory);

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Billing History')),
      body: billingHistory.isEmpty
          ? const Center(child: Text('No billing history available.'))
          : ListView.builder(
              itemCount: billingHistory.length,
              itemBuilder: (context, index) {
                final bill = billingHistory[index];
                return Card(
                  margin: const EdgeInsets.all(10),
                  child: ListTile(
                    title: Text(
                        "Bill #${bill['billNumber']} - \$${bill['totalAmount']}"),
                    subtitle: Text("Date: ${bill['date']}"),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () => deleteBill(index),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
