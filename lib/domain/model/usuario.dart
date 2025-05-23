import 'base_model.dart';

class Usuario extends BaseModel {
  final int id;
  final String nome;
  final String email;
  final String? senha;

  Usuario({
    required this.id,
    required this.nome,
    required this.email,
    this.senha,
    required super.apiStatus,
    required super.dataCriacao,
    required super.dataAlteracao,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nome': nome,
      'email': email,
      'senha': senha,
      ...baseMap,
    };
  }

  factory Usuario.fromMap(Map<String, dynamic> json) {
    final base = BaseModel.fromMap(json);

    return Usuario(
      id: json['id_usuario'],
      nome: json['nome'],
      email: json['email'],
      apiStatus: base.apiStatus,
      dataCriacao: base.dataCriacao,
      dataAlteracao: base.dataAlteracao,
    );
  }

  Usuario copyWith({
    String? nome,
    String? senha,
  }) {
    return Usuario(
      id: id,
      nome: nome ?? this.nome,
      email: email,
      senha: senha ?? this.senha,
      apiStatus: apiStatus,
      dataCriacao: dataCriacao,
      dataAlteracao: dataAlteracao,
    );
  }
}
