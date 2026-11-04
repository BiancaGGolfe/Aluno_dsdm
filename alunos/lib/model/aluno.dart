class Aluno {
  int? id;
  String nome;
  String telefone;
  String matricula;

  Aluno({
    this.id,
    required this.nome,
    required this.telefone,
    required this.matricula,
    });


  Map<String, dynamic> toMap() {
    return {
      'id': this.id, 
      'nome': this.nome, 
      'telefone': this.telefone, 
      'matricula': this.matricula};
  }




  @override
  String toString() {
    return "Aluno('ID: '$id, 'NOME: '$nome, 'TELEFONE: '$telefone, 'MATRICULA: '$matricula)";
  }
}