import 'base_model.dart';

class Usuario extends BaseModel {
  final int? id;
  final String nome;
  final String email;
  final String? senha;

  Usuario({
    this.id,
    required this.nome,
    required this.email,
    this.senha,
    ApiStatus? apiStatus,
    DateTime? dataCriacao,
    DateTime? dataAlteracao,
  }) : super(
          apiStatus: apiStatus ?? ApiStatus.pendente,
          dataCriacao: dataCriacao ?? DateTime.now(),
          dataAlteracao: dataAlteracao ?? DateTime.now(),
        );

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
    String? email,
    ApiStatus? apiStatus,
    DateTime? dataAlteracao,
  }) {
    return Usuario(
      nome: nome ?? this.nome,
      email: email ?? this.email,
      apiStatus: apiStatus ?? this.apiStatus,
      dataAlteracao: dataAlteracao ?? this.dataAlteracao,
    );
  }
}
