import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'models/ovelha.dart';
import 'models/ovelha_adapter.dart';
import 'ui/screens/ovelha_list_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  // registrar adapter
  Hive.registerAdapter<Ovelha>(OvelhaAdapter());
  // abrir box com chave = rfidOvelha (String)
  await Hive.openBox<Ovelha>('ovelhas');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Rebanho • Hive',
      theme: ThemeData(useMaterial3: true),
      home: const OvelhaListScreen(),
    );
  }
}
