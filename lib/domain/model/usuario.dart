import 'base_model.dart';

class Usuario extends BaseModel {
  final int idUsuario;
  final String nome;
  final String email;
  final String? senha;

  Usuario({
    required this.idUsuario,
    required this.nome,
    required this.email,
    this.senha,
    required super.apiStatus,
    required super.dataCriacao,
    required super.dataAlteracao,
  });

  Map<String, dynamic> toMap() {
    return {
      'id_usuario': idUsuario,
      'nome': nome,
      'email': email,
      'senha': senha,
      ...baseMap,
    };
  }

  factory Usuario.fromMap(Map<String, dynamic> json) {
    final base = BaseModel.fromMap(json);

    return Usuario(
      idUsuario: json['id_usuario'],
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
      idUsuario: idUsuario,
      nome: nome ?? this.nome,
      email: email,
      senha: senha ?? this.senha,
      apiStatus: apiStatus,
      dataCriacao: dataCriacao,
      dataAlteracao: dataAlteracao,
    );
  }
}
