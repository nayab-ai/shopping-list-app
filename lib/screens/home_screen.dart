import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/item_model.dart';

class HomeScreen extends StatefulWidget {
  final Function(bool) onThemeChanged;

  HomeScreen({required this.onThemeChanged});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  // ================= DELETE DIALOG =================
  Future<bool> _showDeleteDialog(BuildContext context) async {
    return await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          title: Text('Delete Item'),
          content: Text('Are you sure you want to delete this item?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: Text(
                'Delete',
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        );
      },
    ) ??
        false;
  }

  // ================= GET ITEMS =================
  List<ItemModel> _getItemsFromBox(Box box) {
    final rawItems = box.get('items');

    if (rawItems == null || rawItems is! List) {
      return [];
    }

    return rawItems.map<ItemModel>((item) {
      return ItemModel.fromMap(Map<String, dynamic>.from(item));
    }).toList();
  }

  // ================= DELETE ITEM =================
  Future<void> _deleteItem(Box box, int index, ItemModel item) async {
    List<ItemModel> items = _getItemsFromBox(box);
    items.removeAt(index);

    await box.put('items', items.map((e) => e.toMap()).toList());

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Deleted ${item.name}')),
    );
  }

  // ================= LOGOUT =================
  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (context) =>
          AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            title: Text('Logout'),
            content: Text('Are you sure you want to logout?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('Cancel'),
              ),
              TextButton(
                onPressed: () async {
                  final box = Hive.box('shoppingBox');
                  await box.put('isLoggedIn', false);

                  Navigator.pop(context);
                  Navigator.pushReplacementNamed(context, '/login');
                },
                child: Text(
                  'Logout',
                  style: TextStyle(color: Colors.red),
                ),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final box = Hive.box('shoppingBox');

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,

      // ================= APP BAR =================
      appBar: AppBar(
        title: Text('Shopping List'),
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
        elevation: 0,
      ),

      // ================= DRAWER =================
      drawer: Drawer(
        child: Container(
          color: Colors.deepPurple,
          child: Column(
            children: [

              DrawerHeader(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      radius: 40,
                      backgroundColor: Colors.white,
                      child: Icon(Icons.shopping_cart,
                          size: 40, color: Colors.deepPurple),
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Shopping App',
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                  ],
                ),
              ),

              ListTile(
                leading: Icon(Icons.home, color: Colors.white),
                title: Text('Home',
                    style: TextStyle(color: Colors.white)),
                onTap: () => Navigator.pop(context),
              ),

              ListTile(
                leading: Icon(Icons.person, color: Colors.white),
                title: Text('Profile',
                    style: TextStyle(color: Colors.white)),
                onTap: () => Navigator.pushNamed(context, '/profile'),
              ),

              ListTile(
                leading: Icon(Icons.settings, color: Colors.white),
                title: Text('Settings',
                    style: TextStyle(color: Colors.white)),
                onTap: () => Navigator.pushNamed(context, '/settings'),
              ),

              ListTile(
                leading: Icon(Icons.logout, color: Colors.red),
                title: Text('Logout',
                    style: TextStyle(color: Colors.red)),
                onTap: _showLogoutDialog,
              ),
            ],
          ),
        ),
      ),

      // ================= BODY =================
      body: ValueListenableBuilder(
        valueListenable: box.listenable(),
        builder: (context, Box box, _) {
          List<ItemModel> items = _getItemsFromBox(box);

          if (items.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.shopping_cart_outlined,
                      size: 80, color: Colors.grey),
                  SizedBox(height: 10),
                  Text(
                    'No items yet',
                    style: TextStyle(
                        fontSize: 18, color: Colors.grey),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: EdgeInsets.all(10),
            itemCount: items.length,
            itemBuilder: (context, index) {
              final item = items[index];

              // ================= PROFESSIONAL CARD =================
              return Card(
                elevation: 4,
                margin: EdgeInsets.symmetric(vertical: 6),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: ListTile(
                  contentPadding: EdgeInsets.symmetric(
                      horizontal: 16, vertical: 10),

                  // ITEM NAME
                  title: Row(
                    children: [
                      Icon(Icons.shopping_bag,
                          color: Colors.deepPurple, size: 20),
                      SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          item.name,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ],
                  ),

                  // QUANTITY
                  subtitle: Padding(
                    padding: const EdgeInsets.only(top: 6),
                    child: Row(
                      children: [
                        Icon(Icons.format_list_numbered,
                            size: 18, color: Colors.grey[700]),
                        SizedBox(width: 6),
                        Text(
                          'Qty: ${item.quantity}',
                          style: TextStyle(
                              fontSize: 14,
                              color: Colors.deepPurpleAccent),
                        ),
                      ],
                    ),
                  ),

                  // ACTION BUTTONS
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [

                      // EDIT
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.orange.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: IconButton(
                          icon: Icon(Icons.edit,
                              color: Colors.orange),
                          onPressed: () {
                            Navigator.pushNamed(
                              context,
                              '/edit',
                              arguments: {
                                'index': index,
                                'item': item,
                              },
                            );
                          },
                        ),
                      ),

                      SizedBox(width: 6),

                      // DELETE
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.red.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: IconButton(
                          icon: Icon(Icons.delete,
                              color: Colors.red),
                          onPressed: () async {
                            bool confirm =
                            await _showDeleteDialog(context);

                            if (confirm) {
                              _deleteItem(box, index, item);
                            }
                          },
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

      // ================= FAB =================
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.lightBlueAccent,
        child: Icon(Icons.add),
        onPressed: () => Navigator.pushNamed(context, '/add'),
      ),

      floatingActionButtonLocation:
      FloatingActionButtonLocation.centerFloat,
    );
  }
}