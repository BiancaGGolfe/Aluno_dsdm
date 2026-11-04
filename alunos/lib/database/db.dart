import 'package:path/path.dart'; //acesso aos diretorios
import 'package:sqflite_common/sqflite.dart'; //acesso ao banco de dados


Future<Database> getDatabase() async {
  final String caminhoBanco = join(await getDatabasesPath(), 'alunos.db' );
  return openDatabase(
    caminhoBanco,
    onCreate: (db, version) {
      db.execute("CREATE TABLE alunos(id INTEGER PRIMARY KEY AUTOINCREMENT, nome TEXT, matricula TEXT, telefone TEXT);");
      },    
      version: 1
    );

}