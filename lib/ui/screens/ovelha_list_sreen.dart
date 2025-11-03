import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../../models/ovelha.dart';
import '../../datasource/hive_datasource.dart';
import '../../repository/ovelha_repository.dart';
import 'ovelha_form_screen.dart';
import 'package:flutter/services.dart';

class OvelhaListScreen extends StatefulWidget {
  const OvelhaListScreen({super.key});
  @override
  State<OvelhaListScreen> createState() => _OvelhaListScreenState();
}

class _OvelhaListScreenState extends State<OvelhaListScreen> {
  late final HiveDataSource _ds;
  late final OvelhaRepository _repo;

  @override
  void initState() {
    super.initState();
    _ds = HiveDataSource();
    _repo = OvelhaRepository(_ds);
  }

  List<Ovelha> _sorted(Box<Ovelha> box) {
    final list = box.values.toList();
    list.sort((a, b) => a.rfidOvelha.compareTo(b.rfidOvelha));
    return list;
  }

  @override
  Widget build(BuildContext context) {
    final box = Hive.box<Ovelha>('ovelhas');
    return Scaffold(
      appBar: AppBar(title: const Text('Rebanho • Hive')),
      body: ValueListenableBuilder(
        valueListenable: box.listenable(),
        builder: (context, Box<Ovelha> b, _) {
          final items = _sorted(b);
          if (items.isEmpty) {
            return const Center(child: Text('Nenhuma ovelha. Adicione usando o botão abaixo.'));
          }
          return ListView.builder(
            itemCount: items.length,
            itemBuilder: (context, index) {
              final o = items[index];
              return ListTile(
                title: Text(o.rfidOvelha),
                subtitle: Text('${o.racaOvelha} • ${o.idadeOvelha} anos • ${o.indVacinada ? "Vacinada" : "Não vacinada"}'),
                trailing: IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () async {
                    await Navigator.push(context, MaterialPageRoute(
                      builder: (_) => OvelhaFormScreen(existing: o),
                    ));
                    // lista atualiza automaticamente via ValueListenableBuilder
                  },
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        label: const Text('Adicionar'),
        icon: const Icon(Icons.add),
        onPressed: () async {
          await Navigator.push(context, MaterialPageRoute(
            builder: (_) => const OvelhaFormScreen(),
          ));
        },
      ),
      bottomNavigationBar: SafeArea(
        child: Container(
          padding: const EdgeInsets.all(8),
          child: ElevatedButton(
            onPressed: () {
              SystemNavigator.pop();
            },
            child: const Text('Fechar aplicativo'),
          ),
        ),
      ),
    );
  }
}
