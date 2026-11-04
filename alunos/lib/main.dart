import 'dart:io';
import 'package:alunos/dao/aluno.dart';
import 'package:alunos/model/aluno.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:sqflite_common_ffi_web/sqflite_ffi_web.dart';

void main() async{
  await WidgetsFlutterBinding.ensureInitialized();
  if (kIsWeb) {
    databaseFactory = databaseFactoryFfiWeb; 
    } else if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  }

  
  runApp(MaterialApp(home: PaginaInicial(), debugShowCheckedModeBanner: false));
}

class PaginaInicial extends StatefulWidget {
  @override
  State<PaginaInicial> createState() => _PaginaInicialState();
}

class _PaginaInicialState extends State<PaginaInicial> {
  //Estou dizendo que minha classe é uma tela através do StatelessWidget
  List<Aluno> alunos = []; //Mostrar essa lista no ListView!
  final TextEditingController _searchController = TextEditingController();
  String _searchText = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<List<Map<String, dynamic>>> _carregarAlunos() {
    if (_searchText.trim().isEmpty) {
      return findAll();
    }
    return findByName(_searchText.trim());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("OLÁ 3F!"),
        leading: Icon(Icons.menu),
        centerTitle: true,
        backgroundColor: Colors.blue,
      ),

      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: TextField(
              controller: _searchController,
              onChanged: (value) {
                setState(() {
                  _searchText = value;
                });
              },
              decoration: InputDecoration(
                hintText: 'Pesquisar aluno',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
                fillColor: Colors.white,
              ),
            ),
          ),
          Expanded(
            child: FutureBuilder(
              initialData: const [],
              future: _carregarAlunos(),
              builder: (context, snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.none:
                    return Center(child: Text("Erro de conexão com o banco"));
                  case ConnectionState.active:
                  case ConnectionState.waiting:
                    return Center(child: CircularProgressIndicator());
                  case ConnectionState.done: //conexão finalizou e esta ok
                    List<Map<String, dynamic>> alunos =
                        snapshot.data as List<Map<String, dynamic>>;
                    //listView Builder
                    return ListView.builder(
                      itemCount: alunos.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          leading: Icon(Icons.person),
                          title:
                              Text("Aluno:" + alunos[index]['nome'].toString()),
                          subtitle: Text(
                            "Matricula: " +
                                alunos[index]['matricula'].toString(),
                          ),
                          trailing: IconButton(
                            onPressed: () {
                              setState(() {
                                deleteById(alunos[index]['id']);
                              });
                            },
                            icon: Icon(Icons.delete),
                          ),
                        );
                      },
                    );
                }
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => FormularioCadastro()),
          ).then((aluno) {
            setState(() {} );
            });
          },
        child: Icon(Icons.add),
      ),
    );
  }
  }


class FormularioCadastro extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    TextEditingController nome = TextEditingController();
    TextEditingController telefone = TextEditingController();
    TextEditingController matricula = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: Text("Formulário de Cadastro"),
        backgroundColor: Colors.blue,
      ),
      body: ListView(
        padding: EdgeInsets.all(64.0),
        children: [
          Text("Nome:"),
          TextField(controller: nome),
          Text("Telefone:"),
          TextField(controller: telefone),
          Text("Matrícula"),
          TextField(controller: matricula),
          Container(
            padding: EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: () async {
                if (nome.text != '' &&
                    telefone.text != '' &&
                    matricula.text != '') {    
                  Aluno aluno = Aluno(
                    nome: nome.text,
                    telefone: telefone.text,
                    matricula: matricula.text,
                  );
                  await insert(aluno); //Insere aluno no banco
                  final resultado = await findByName(aluno.nome);
                  debugPrint("Resultado da busca por LIKE (${aluno.nome}): $resultado");
                  Navigator.pop(context);
                } else {
                  debugPrint("Preencha todos os campos");
                }
              },
              child: Text("Salvar"),
            ),
          ),
        ],
      ),
    );
  }
}

class TelaVisualizacao extends StatelessWidget {
  Aluno info;
  TelaVisualizacao(this.info);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Visualização do Aluno: ${info.nome}")),
      body: ListView(
        padding: EdgeInsets.all(30.0),
        children: [
          Text("Nome: " + info.nome),
          Text("Telefone: " + info.telefone),
          Text("Matrícula: " + info.matricula),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Voltar"),
          ),
        ],
      ),
    );
  }
}
