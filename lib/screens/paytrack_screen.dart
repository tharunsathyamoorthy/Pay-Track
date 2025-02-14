import 'package:flutter/material.dart';

class PayTrackScreen extends StatefulWidget {
  const PayTrackScreen({super.key});

  @override
  _PayTrackScreenState createState() => _PayTrackScreenState();
}

class _PayTrackScreenState extends State<PayTrackScreen> {
  List<Map<String, dynamic>> payments = []; // Empty list initially
  final TextEditingController customerController = TextEditingController();
  final TextEditingController amountController = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  String status = "Pending";

  void handleAddPayment() {
    if (customerController.text.isEmpty ||
        amountController.text.isEmpty ||
        dateController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill all fields.")),
      );
      return;
    }

    setState(() {
      payments.add({
        "id": DateTime.now().toString(),
        "customer": customerController.text,
        "amount": double.parse(amountController.text),
        "date": dateController.text,
        "status": status,
      });
    });

    // Clear input fields after adding
    customerController.clear();
    amountController.clear();
    dateController.clear();
    status = "Pending";
  }

  void handleUpdateStatus(String id, String newStatus) {
    setState(() {
      for (var payment in payments) {
        if (payment["id"] == id) {
          payment["status"] = newStatus;
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Pay Track')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Pay Track - Sri Nandhini Marketings',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            TextField(
                controller: customerController,
                decoration: const InputDecoration(
                    labelText: 'Customer Name', border: OutlineInputBorder())),
            const SizedBox(height: 10),
            TextField(
                controller: amountController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                    labelText: 'Amount', border: OutlineInputBorder())),
            const SizedBox(height: 10),
            TextField(
                controller: dateController,
                keyboardType: TextInputType.datetime,
                decoration: const InputDecoration(
                    labelText: 'Date', border: OutlineInputBorder())),
            const SizedBox(height: 10),
            ElevatedButton(
                onPressed: handleAddPayment, child: const Text('Add Payment')),
            const SizedBox(height: 20),
            const Text('Payments List',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            Expanded(
              child: payments.isEmpty
                  ? const Center(child: Text("No payments added yet."))
                  : ListView.builder(
                      itemCount: payments.length,
                      itemBuilder: (context, index) {
                        final payment = payments[index];
                        return Card(
                          margin: const EdgeInsets.symmetric(vertical: 5),
                          child: ListTile(
                            title: Text(payment["customer"]),
                            subtitle: Text(
                                "Amount: \$${payment["amount"]} | Date: ${payment["date"]}"),
                            trailing: DropdownButton<String>(
                              value: payment["status"],
                              onChanged: (newStatus) {
                                if (newStatus != null) {
                                  handleUpdateStatus(payment["id"], newStatus);
                                }
                              },
                              items: ["Pending", "Paid"].map((status) {
                                return DropdownMenuItem(
                                    value: status, child: Text(status));
                              }).toList(),
                            ),
                          ),
                        );
                      },
                    ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Back to Home'),
            ),
          ],
        ),
      ),
    );
  }
}
