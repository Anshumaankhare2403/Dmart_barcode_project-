import 'package:flutter/material.dart';
import '../components/top_bar.dart';
import '../components/scanner.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final List<Map<String, dynamic>> DB = [
    {"ID": "1111", "Product": "BC", "Price": 230},
    {"ID": "1112", "Product": "BC1", "Price": 210},
  ];

  final List<Map<String, dynamic>> qrResults = []; // Store product and quantity

  void _addResult(String result) {
    setState(() {
      final existingProductIndex =
          qrResults.indexWhere((product) => product["ID"] == result);

      if (existingProductIndex != -1) {
        // If the product already exists, increase the quantity
        qrResults[existingProductIndex]["Quantity"]++;
      } else {
        // If the product doesn't exist, add it with a quantity of 1
        qrResults.add({
          "ID": result,
          "Quantity": 1,
        });
      }
    });
  }

  Map<String, dynamic>? _findProduct(String qrCode) {
    // Search for product in the DB by ID, return null if not found
    try {
      return DB.firstWhere((product) => product["ID"] == qrCode);
    } catch (e) {
      return null; // If no product is found, return null
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(
            screenHeight * 0.15), // Adjust height relative to screen height
        child: const TopBar(),
      ),
      body: Column(
        children: [
          // Scanner widget with onDetect callback
          Flexible(
            flex: 5,
            child: Scanner(
              onDetect: (String result) {
                _addResult(result); // Handle detected QR code
              },
            ),
          ),

          // Display scanned QR results with product details
          Flexible(
            flex: 3,
            child: Padding(
              padding: EdgeInsets.all(
                  screenWidth * 0.05), // Add padding for cleaner UI
              child: ListView.builder(
                itemCount: qrResults.length,
                itemBuilder: (context, index) {
                  final qrCode = qrResults[index]["ID"];
                  final product = _findProduct(qrCode);
                  final quantity = qrResults[index]["Quantity"];

                  return Card(
                    margin: EdgeInsets.only(
                        bottom: screenHeight * 0.02), // Add space between items
                    child: ListTile(
                      leading: const Icon(Icons.qr_code),
                      title: Text(
                        product != null
                            ? product["Product"]
                            : "Product not found for QR: $qrCode",
                      ),
                      subtitle: product != null
                          ? Text(
                              "Price: \Rs. ${product["Price"] * quantity}, Quantity: $quantity")
                          : null,
                      trailing: Icon(
                        product != null ? Icons.check_circle : Icons.error,
                        color: product != null ? Colors.green : Colors.red,
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
