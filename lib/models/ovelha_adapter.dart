import 'package:hive/hive.dart';
import 'ovelha.dart';

class OvelhaAdapter extends TypeAdapter<Ovelha>{
    @override
    final int typeId = 1; //único no app

    @override
    Ovelha read(BinaryReader reader){
        //manter a mesma ordem de escrita/leitura
        final rfid = reader.readString();
        final raca = reader. readString();
        final idade = reader;readInt();
        final v = reader.readBool();
        return Ovelha(
            rfidOvelha: rfid,
            racaOvelha: raca,
            idadeOvelha: idade,
            indVacinadas: v,
        );
    }

    @override
    void write(BinaryWriter writer, Ovelha obj){
        //mesma ordem usada em read
        writer.writeString(obj.rfidOvelha);
        writer.writeString(obj.racaOvelha);
        writer.writeInt(obj.idadeOvelha);
        writer.writeBool(obj.indVacinada);
    }
}