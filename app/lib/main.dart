import 'package:flexeat/bloc/product_cubit.dart';
import 'package:flexeat/ui/product_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import 'data/in_memory_product_repository.dart';

void main() {
  runApp(const MyApp());
}

const colorScheme = ColorScheme.light(
    background: Color(0xff1E88E5),
    primary: Color(0xff006DB3),
    onBackground: Colors.white);

final textTheme = GoogleFonts.tajawalTextTheme(ThemeData.light().textTheme);

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
            textTheme: textTheme.copyWith(
                headline1: textTheme.headline1?.copyWith(
                  fontSize: 32,
                  color: colorScheme.onBackground,
                ),
                headline5: textTheme.headline5?.copyWith(
                  color: colorScheme.onBackground,
                ),
                bodyText2: textTheme.bodyText2
                    ?.copyWith(color: colorScheme.onPrimary, fontSize: 16)),
            colorScheme: colorScheme),
        home: Scaffold(
            body: BlocProvider(
          create: (_) => ProductCubit(InMemoryProductRepository()),
          child: const ProductPage(),
        )));
  }
}
