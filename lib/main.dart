import 'package:easy_pos/helpers/sql_helper.dart';
import 'package:easy_pos/pages/home.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  var sqlHelper = SqlHelper();
     //type it just once
  await sqlHelper.init();
  if (sqlHelper.db != null) {
    GetIt.I.registerSingleton<SqlHelper>(sqlHelper);
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Easy Pos',
      theme: ThemeData(
        appBarTheme: AppBarTheme(
            backgroundColor: Color(0xff0157db), 
            //color of anything on the appBar=> 
            foregroundColor: Colors.white),
        colorScheme: ColorScheme.fromSwatch(
            errorColor: Colors.red,
            cardColor: Colors.blue.shade100,
            backgroundColor: Colors.white,
            primarySwatch: getMaterialColor(Color(0xff0157db))),
        useMaterial3: true,
      ),
      home: HomePage(),
    );
  }

  MaterialColor getMaterialColor(Color color) {
    final int red = color.red;
    final int green = color.green;
    final int blue = color.blue;

    final Map<int, Color> shades = {
      50: Color.fromRGBO(red, green, blue, .1),
      100: Color.fromRGBO(red, green, blue, .2),
      200: Color.fromRGBO(red, green, blue, .3),
      300: Color.fromRGBO(red, green, blue, .4),
      400: Color.fromRGBO(red, green, blue, .5),
      500: Color.fromRGBO(red, green, blue, .6),
      600: Color.fromRGBO(red, green, blue, .7),
      700: Color.fromRGBO(red, green, blue, .8),
      800: Color.fromRGBO(red, green, blue, .9),
      900: Color.fromRGBO(red, green, blue, 1),
    };

    return MaterialColor(color.value, shades);
  }
}
