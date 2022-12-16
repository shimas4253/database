import 'package:flutter/material.dart';

import 'homepage.dart';

void main(){
  runApp(Myapp());
}
class Myapp extends StatelessWidget {
  const Myapp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute:'/' ,
      routes: {
        '/':(context)=>home()
      },
    );
  }
}
