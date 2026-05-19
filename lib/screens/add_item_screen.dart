import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class AddItemScreen extends StatefulWidget {
  @override
  State<AddItemScreen> createState() => _AddItemScreenState();
}

class _AddItemScreenState extends State<AddItemScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _qtyController = TextEditingController();

  Future<void> _saveItem() async {
    String name = _nameController.text.trim();
    String qtyText = _qtyController.text.trim();

    if (name.isEmpty || qtyText.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please fill all fields!')),
      );
      return;
    }

    int qty = int.tryParse(qtyText) ?? 0;
    final box = Hive.box('shoppingBox');

    List<Map<String, dynamic>> items = [];
    final rawItems = box.get('items');

    if (rawItems != null && rawItems is List) {
      for (var item in rawItems) {
        if (item is Map) {
          items.add(Map<String, dynamic>.from(item));
        }
      }
    }

    items.add({
      'name': name,
      'quantity': qty,
      'id': DateTime.now().millisecondsSinceEpoch.toString(),
    });

    await box.put('items', items);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('✅ $name added!')),
    );

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Item'),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
      ),

      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16),
          child: Column(
            children: [
              TextField(
                controller: _nameController,
                decoration: InputDecoration(
                  hintText: 'Item name',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.shopping_bag),
                ),
              ),
              SizedBox(height: 16),

              TextField(
                controller: _qtyController,
                decoration: InputDecoration(
                  hintText: 'Quantity',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.numbers),
                ),
                keyboardType: TextInputType.number,
              ),

              SizedBox(height: 30),

              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _saveItem,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple,
                  ),
                  child: Text(
                    'Save Item',
                    style: TextStyle(fontSize: 18, color: Colors.white),
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
