import 'package:flexeat/bloc/product_cubit.dart';
import 'package:flexeat/ui/product_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'data/in_memory_product_repository.dart';

void main() {
  runApp(const MyApp());
}

const colorScheme = ColorScheme.light(
    background: Color(0xff1E88E5),
    primary: Color(0xff006DB3),
    onBackground: Colors.white);

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
            primarySwatch: Colors.blue,
            scaffoldBackgroundColor: colorScheme.background,
            iconTheme: IconThemeData(color: colorScheme.onBackground),
            buttonTheme: const ButtonThemeData(colorScheme: colorScheme),
            colorScheme: colorScheme),
        home: Scaffold(
            body: BlocProvider(
          create: (_) => ProductCubit(InMemoryProductRepository()),
          child: const ProductPage(),
        )));
  }
}
