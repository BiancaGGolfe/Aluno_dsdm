import 'package:alunos/dao/aluno.dart';

void main() {
  final sample = [
    {'id': 1, 'nome': 'João Silva', 'matricula': '123', 'telefone': '9999'},
    {'id': 2, 'nome': 'Maria', 'matricula': '456', 'telefone': '8888'},
  ];

  print('Mostrando apenas id e nome:');
  printResultados(sample, camposASeremMostrados: ['id', 'nome']);

  print('\nMostrando registros completos:');
  printResultados(sample);
}
