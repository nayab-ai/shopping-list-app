import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hive/hive.dart'; // ✅ FIX ADDED

// Screens
import 'screens/splash_screen.dart';
import 'screens/home_screen.dart';
import 'screens/add_item_screen.dart';
import 'screens/edit_item_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/settings_screen.dart';
import 'screens/login_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();
  await Hive.openBox('userBox');
  await Hive.openBox('shoppingBox');
  await Hive.openBox('settingsBox');

  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  ThemeMode _themeMode = ThemeMode.light;

  @override
  void initState() {
    super.initState();
    _loadTheme();
  }

  void _loadTheme() {
    final box = Hive.box('settingsBox');
    bool isDark = box.get('darkMode', defaultValue: false);

    _themeMode = isDark ? ThemeMode.dark : ThemeMode.light;
    setState(() {});
  }

  void _toggleTheme(bool isDark) {
    final box = Hive.box('settingsBox');
    box.put('darkMode', isDark);

    setState(() {
      _themeMode = isDark ? ThemeMode.dark : ThemeMode.light;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Shopping List App',
      debugShowCheckedModeBanner: false,

      theme: ThemeData(
        brightness: Brightness.light,
        primarySwatch: Colors.deepPurple,
        useMaterial3: true,
      ),

      darkTheme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.deepPurple,
        useMaterial3: true,
      ),

      themeMode: _themeMode,

      initialRoute: '/',

      routes: {
        '/': (context) => SplashScreen(),

        // ✅ FIXED HOME SCREEN CALL
        '/home': (context) => HomeScreen(
          onThemeChanged: _toggleTheme,
        ),

        '/add': (context) => AddItemScreen(),
        '/profile': (context) => ProfileScreen(),

        '/settings': (context) => SettingsScreen(
          onThemeChanged: _toggleTheme,
          isDarkMode: _themeMode == ThemeMode.dark,
        ),


        '/login': (context) => LoginScreen(),
      },

      onGenerateRoute: (settings) {
        if (settings.name == '/edit') {
          final args = settings.arguments as Map;

          return MaterialPageRoute(
            builder: (context) => EditItemScreen(
              index: args['index'],
              item: args['item'],
            ),
          );
        }
        return null;
      },
    );
  }
}