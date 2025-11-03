import 'package:hive/hive.dart';

part 'ovelha.g.dart';

@HiveType(typeId: 1)
class Ovelha {
    @HiveField(0)
    final String rfidOvelha; //chave da box

    @HiveField(1)
    final String racaOvelha; 

    @HiveField(2)
    final String idadeOvelha; //anos

    @HiveField(3)
    final String indVacinadas; 

    Ovelha({
        required this.rfidOvelha,
        required this.racaOvelha,
        required this.idadeOvelha,
        required this.indVacinadas,
    });

    Ovelha copyWith({
        String? rfidOvelha,
        String? racaOvelha,
        int? idadeOvelha,
        bool? indVacinadas,
    }) {
        return Ovelha(
            rfidOvelha: rfidOvelha ?? this. rfidOvelha,
            racaOvelha: racaOvelha ?? this.racaOvelha,
            idadeOvelha: idadeOvelha ?? this.idadeOvelha,
            indVacinadas: indVacinadas ?? this.indVacinadas,
        );
    }

}