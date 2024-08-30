import 'package:budget_tracker_app/Screens/HomePage.dart';
import 'package:budget_tracker_app/Screens/detailPage.dart';
import 'package:budget_tracker_app/Screens/editPage.dart';
import 'package:budget_tracker_app/Screens/favPage.dart';
import 'package:budget_tracker_app/provider/themeProvider.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => ThemeProvider(),
        ),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      themeMode: (Provider.of<ThemeProvider>(context).istap)
          ? ThemeMode.dark
          : ThemeMode.light,
      debugShowCheckedModeBanner: false,
      routes: {
        '/': (context) => HomePage(),
        'DetailPage': (context) => DetailPage(),
        'FavouritePage': (context) => FavouritePage(),
        'EditPage': (context) => EditPage(),
      },
    );
  }
}
