import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class SettingsScreen extends StatefulWidget {
  final Function(bool) onThemeChanged;
  final bool isDarkMode;

  SettingsScreen({
    required this.onThemeChanged,
    required this.isDarkMode,
  });

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {

  bool _darkMode = false;
  bool _notifications = true;
  String _selectedCurrency = 'PKR';

  @override
  void initState() {
    super.initState();

    final box = Hive.box('settingsBox');

    _darkMode = widget.isDarkMode;
    _notifications = box.get('notifications', defaultValue: true);
    _selectedCurrency = box.get('currency', defaultValue: 'PKR');
  }

  // 🌙 Theme update
  void _updateDarkMode(bool value) {
    final box = Hive.box('settingsBox');
    box.put('darkMode', value);

    setState(() {
      _darkMode = value;
    });

    widget.onThemeChanged(value);
  }

  // 🔔 Notifications update
  void _updateNotifications(bool value) {
    final box = Hive.box('settingsBox');
    box.put('notifications', value);

    setState(() {
      _notifications = value;
    });
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        title: Text('Settings'),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
      ),

      body: ListView(

        children: [

          // 🌙 THEME SECTION
          Padding(
            padding: EdgeInsets.all(16),
            child: Text(
              'Appearance',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          SwitchListTile(
            title: Text('Dark Mode'),
            subtitle: Text('Enable dark theme'),
            value: _darkMode,
            onChanged: _updateDarkMode,
            activeColor: Colors.deepPurple,
          ),

          Divider(),

          // ⚙️ PREFERENCES
          Padding(
            padding: EdgeInsets.all(16),
            child: Text(
              'Preferences',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          SwitchListTile(
            title: Text('Notifications'),
            subtitle: Text('Receive updates'),
            value: _notifications,
            onChanged: _updateNotifications,
            activeColor: Colors.deepPurple,
          ),



          // ℹ️ ABOUT
          Padding(
            padding: EdgeInsets.all(16),
            child: Text(
              'About',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          ListTile(
            leading: Icon(Icons.info, color: Colors.deepPurple),
            title: Text('Version'),
            subtitle: Text('1.0.0'),
          ),

          ListTile(
            leading: Icon(Icons.star, color: Colors.deepPurple),
            title: Text('Rate App'),
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Coming Soon!')),
              );
            },
          ),

          ListTile(
            leading: Icon(Icons.share, color: Colors.deepPurple),
            title: Text('Share App'),
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Coming Soon!')),
              );
            },
          ),

          ListTile(
            leading: Icon(Icons.privacy_tip, color: Colors.deepPurple),
            title: Text('Privacy Policy'),
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Coming Soon!')),
              );
            },
          ),
        ],
      ),
    );
  }
}