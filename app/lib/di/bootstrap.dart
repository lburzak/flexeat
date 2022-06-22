import 'package:flexeat/data/database.dart' as database;
import 'package:flexeat/di/app_container.dart';
import 'package:flexeat/ui/app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

class BootstrapApp extends StatefulWidget {
  const BootstrapApp({Key? key}) : super(key: key);

  @override
  State<BootstrapApp> createState() => _BootstrapAppState();
}

class _BootstrapAppState extends State<BootstrapApp> {
  late AppContainer container;
  bool loaded = false;

  @override
  Widget build(BuildContext context) {
    return loaded
        ? MultiProvider(
            providers: container.buildServiceProviders(),
            child: MultiBlocProvider(
              providers: container.buildBlocProviders(),
              child: const App(),
            ),
          )
        : const CircularProgressIndicator();
  }

  @override
  void initState() {
    super.initState();
    database.openDatabase().then((db) {
      setState(() {
        container = AppContainer(db);
        loaded = true;
      });
    });
  }
}
