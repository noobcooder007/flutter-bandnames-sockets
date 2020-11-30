import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:band_names/services/socket_service.dart';
import 'package:band_names/pages/HomePage.dart';
import 'package:band_names/pages/StatusPage.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => SocketService())
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        initialRoute: HomePage.IDPAGE,
        routes: {
          HomePage.IDPAGE: (_) => HomePage(),
          StatusPage.IDPAGE: (_) => StatusPage()
        },
      ),
    );
  }
}
