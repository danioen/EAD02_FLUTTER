import 'package:hive/hive.dart';
import '../models/ovelha.dart';

class HiveDataSource {
  final Box<Ovelha> box = Hive.box<Ovelha>('ovelhas');

  // Upsert: put with key = RFID
  Future<void> upsertOvelha(Ovelha ovelha) async {
    await box.put(ovelha.rfidOvelha, ovelha);
  }

  // Get single
  Ovelha? getByRfid(String rfid) {
    return box.get(rfid);
  }

  // Listenable box
  ValueListenable<Box<Ovelha>> listenable() => box.listenable();

  // All values
  List<Ovelha> all() => box.values.toList();
}
