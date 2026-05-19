import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
      ),

      body: ListView(
        padding: EdgeInsets.all(16),
        children: [

          // 👤 Profile Header Card
          Container(
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.deepPurple,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                CircleAvatar(
                  radius: 45,
                  backgroundColor: Colors.white,
                  child: Icon(Icons.person, size: 50, color: Colors.deepPurple),
                ),
                SizedBox(height: 12),
                Text(
                  'Shopping App User',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'Active Member',
                  style: TextStyle(color: Colors.white70),
                ),
              ],
            ),
          ),

          SizedBox(height: 20),

          // 📊 App Info Section
          Card(
            child: Column(
              children: [
                ListTile(
                  leading: Icon(Icons.apps, color: Colors.deepPurple),
                  title: Text('App Name'),
                  subtitle: Text('Shopping List App'),
                ),
                Divider(),
                ListTile(
                  leading: Icon(Icons.verified, color: Colors.deepPurple),
                  title: Text('Version'),
                  subtitle: Text('1.0.0'),
                ),
                Divider(),
                ListTile(
                  leading: Icon(Icons.storage, color: Colors.deepPurple),
                  title: Text('Database'),
                  subtitle: Text('Hive Local Storage'),
                ),
              ],
            ),
          ),

          SizedBox(height: 20),

          // ⚙️ Settings Options (future ready)
          Card(
            child: Column(
              children: [
                ListTile(
                  leading: Icon(Icons.dark_mode, color: Colors.deepPurple),
                  title: Text('Theme'),
                  subtitle: Text('Light / Dark Mode Support'),
                ),
                Divider(),
                ListTile(
                  leading: Icon(Icons.notifications, color: Colors.deepPurple),
                  title: Text('Notifications'),
                  subtitle: Text('Enabled'),
                ),
              ],
            ),
          ),

          SizedBox(height: 20),

          // 🚪 Logout Button
          ElevatedButton.icon(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Logout feature coming soon!')),
              );
            },
            icon: Icon(Icons.logout),
            label: Text('Logout'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.redAccent,
              minimumSize: Size(double.infinity, 50),
            ),
          ),
        ],
      ),
    );
  }
}