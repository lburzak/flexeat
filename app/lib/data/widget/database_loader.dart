import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:sqflite/sqflite.dart' as sqflite;

import '../sqlite/database.dart';

class DatabaseLoader extends StatefulWidget {
  final Widget Function(BuildContext context, bool loaded) builder;

  const DatabaseLoader({Key? key, required this.builder}) : super(key: key);

  @override
  State<DatabaseLoader> createState() => _DatabaseLoaderState();
}

class _DatabaseLoaderState extends State<DatabaseLoader> {
  sqflite.Database? _database;

  @override
  void initState() {
    super.initState();

    openDatabase().then(_onLoaded);
  }

  @override
  Widget build(BuildContext context) {
    return _database != null
        ? Provider(
            create: (context) => _database,
            child: widget.builder(context, true),
          )
        : widget.builder(context, false);
  }

  void _onLoaded(sqflite.Database database) {
    setState(() {
      _database = database;
    });
  }
}
