import '../datasource/hive_datasource.dart';
import '../models/ovelha.dart';

class OvelhaRepository {
  final HiveDataSource _ds;
  OvelhaRepository(this._ds);

  Future<void> save(Ovelha o) => _ds.upsertOvelha(o);
  Ovelha? get(String rfid) => _ds.getByRfid(rfid);
  ValueListenable listenable() => _ds.listenable();
  List<Ovelha> all() => _ds.all();
}
