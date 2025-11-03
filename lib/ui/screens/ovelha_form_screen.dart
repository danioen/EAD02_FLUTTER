import 'package:flutter/material.dart';
import '../../models/ovelha.dart';
import '../../datasource/hive_datasource.dart';
import '../../repository/ovelha_repository.dart';
import '../widgets/rfid_input_formatter.dart';

class OvelhaFormScreen extends StatefulWidget {
  final Ovelha? existing;
  const OvelhaFormScreen({super.key, this.existing});

  @override
  State<OvelhaFormScreen> createState() => _OvelhaFormScreenState();
}

class _OvelhaFormScreenState extends State<OvelhaFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _rfidCtrl = TextEditingController();
  final _idadeCtrl = TextEditingController();

  String? _raca; // "Santa Inês", "Dorper", "Texel"
  bool _vacinada = false;
  late final OvelhaRepository _repo;

  @override
  void initState() {
    super.initState();
    _repo = OvelhaRepository(HiveDataSource());
    if (widget.existing != null) {
      final e = widget.existing!;
      _rfidCtrl.text = e.rfidOvelha;
      _raca = e.racaOvelha;
      _idadeCtrl.text = e.idadeOvelha.toString();
      _vacinada = e.indVacinada;
    }
  }

  @override
  void dispose() {
    _rfidCtrl.dispose();
    _idadeCtrl.dispose();
    super.dispose();
  }

  void _onRacaChanged(String r) {
    setState(() {
      _raca = r;
    });
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    final rfid = _rfidCtrl.text;
    final idade = int.tryParse(_idadeCtrl.text) ?? 0;
    final raca = _raca ?? 'Santa Inês';
    final o = Ovelha(
      rfidOvelha: rfid,
      racaOvelha: raca,
      idadeOvelha: idade,
      indVacinada: _vacinada,
    );
    await _repo.save(o); // upsert via HiveDataSource
    // volta para a lista e indica que salvou
    if (mounted) Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.existing != null;
    return Scaffold(
      appBar: AppBar(title: Text(isEdit ? 'Editar ovelha' : 'Adicionar ovelha')),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _rfidCtrl,
                inputFormatters: [RfidInputFormatter()],
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'RFID (999-XXXXXXXXXXXXXXX)'),
                validator: (v) {
                  if (v == null || v.isEmpty) return 'RFID obrigatório';
                  // validar estrutura 3 dígitos + '-' + 15 dígitos = 19 chars
                  if (!RegExp(r'^\d{3}-\d{15}$').hasMatch(v)) {
                    return 'Formato inválido. Ex: 123-000000000000000';
                  }
                  return null;
                },
                enabled: !isEdit, // opcional: impedir alteração da chave (rfid) em edição
              ),
              const SizedBox(height: 12),
              const Text('Raça'),
              CheckboxListTile(
                title: const Text('Santa Inês'),
                value: _raca == 'Santa Inês',
                onChanged: (v) => _onRacaChanged('Santa Inês'),
              ),
              CheckboxListTile(
                title: const Text('Dorper'),
                value: _raca == 'Dorper',
                onChanged: (v) => _onRacaChanged('Dorper'),
              ),
              CheckboxListTile(
                title: const Text('Texel'),
                value: _raca == 'Texel',
                onChanged: (v) => _onRacaChanged('Texel'),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _idadeCtrl,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Idade (anos)'),
                validator: (v) {
                  if (v == null || v.isEmpty) return 'Idade obrigatória';
                  final n = int.tryParse(v);
                  if (n == null || n < 0) return 'Idade inválida (>= 0)';
                  return null;
                },
              ),
              const SizedBox(height: 12),
              SwitchListTile(
                title: const Text('Vacinada'),
                value: _vacinada,
                onChanged: (v) => setState(() => _vacinada = v),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _save,
                child: const Text('Salvar'),
              )
            ],
          ),
        ),
      ),
    );
  }
}
