import '../database/db.dart';
import '../model/aluno.dart';
import 'package:sqflite_common/sqflite.dart';


Future<int> insert(Aluno aluno) async {
  final Database db = await getDatabase();
  return db.insert(
  'alunos',
   aluno.toMap(), 
   conflictAlgorithm: ConflictAlgorithm.replace,
  );
}  

Future<List<Map<String, dynamic>>> findAll() async {
  final Database db = await getDatabase();
  List<Map<String, dynamic>> result = await db.query("alunos");
  return result;
}

Future<int> deleteById(int id) async {
  final Database db = await getDatabase();
  return db.delete("alunos", where: "id = ?", whereArgs: [id]);
} 

Future<List<Map<String, dynamic>>> findByName(String nome, {List<String>? camposASeremMostrados}) {
  return getDatabase().then((db) {
    return db.query(
      "alunos",
      where: "nome LIKE ?",
      whereArgs: ['%$nome%'],
    ).then((resultados) {
        printResultados(resultados, camposASeremMostrados: camposASeremMostrados);
        return resultados;
    });
  });
}

  // Helper para imprimir resultados no terminal; pode ser usado em testes locais.
  void printResultados(List<Map<String, dynamic>> resultados, {List<String>? camposASeremMostrados}) {
    for (final row in resultados) {
      if (camposASeremMostrados != null && camposASeremMostrados.isNotEmpty) {
        final Map<String, dynamic> filtered = {};
        for (final campo in camposASeremMostrados) {
          filtered[campo] = row.containsKey(campo) ? row[campo] : null;
        }
        print(filtered);
      } else {
        print(row);
      }
    }
  }
