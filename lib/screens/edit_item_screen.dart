// lib/screens/edit_item_screen.dart
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/item_model.dart';

class EditItemScreen extends StatefulWidget {
  final int index;
  final ItemModel item;

  EditItemScreen({required this.index, required this.item});

  @override
  State<EditItemScreen> createState() => _EditItemScreenState();
}

class _EditItemScreenState extends State<EditItemScreen> {
  late TextEditingController _nameController;
  late TextEditingController _qtyController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.item.name);
    _qtyController = TextEditingController(text: widget.item.quantity.toString());
  }

  Future<void> _updateItem() async {
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

    // Get existing items
    List<Map<String, dynamic>> items = [];
    final rawItems = box.get('items');
    if (rawItems != null && rawItems is List) {
      for (var item in rawItems) {
        if (item is Map) {
          Map<String, dynamic> converted = {};
          item.forEach((key, value) {
            converted[key.toString()] = value;
          });
          items.add(converted);
        }
      }
    }

    // Update item at index
    items[widget.index] = {
      'name': name,
      'quantity': qty,
      'id': widget.item.id,
    };

    await box.put('items', items);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('✏️ $name updated!')),
    );

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Item'),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
      ),
      body: Padding(
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
            SizedBox(height: 24),
            ElevatedButton(
              onPressed: _updateItem,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.indigoAccent,
                minimumSize: Size(double.infinity, 50),
              ),
              child: Text('Update Item', style: TextStyle(fontSize: 18),),
            ),
          ],
        ),
      ),
    );
  }
}