import '../../../../../domain/model/base_model.dart';

class UsuarioCreated extends BaseModel {
  final String nome;
  final String email;
  final String senha;

  UsuarioCreated({
    required this.nome,
    required this.email,
    required this.senha,
    ApiStatus? apiStatus,
    DateTime? dataCriacao,
    DateTime? dataAlteracao,
  }) : super(
          apiStatus: apiStatus ?? ApiStatus.pendente,
          dataCriacao: dataCriacao ?? DateTime.now(),
          dataAlteracao: dataAlteracao ?? DateTime.now(),
        );

  factory UsuarioCreated.fromJson(Map<String, dynamic> json) {
    final base = BaseModel.fromMap(json);

    return UsuarioCreated(
      nome: json['nome'],
      email: json['email'],
      senha: json['senha'],
      apiStatus: base.apiStatus,
      dataCriacao: base.dataCriacao,
      dataAlteracao: base.dataAlteracao,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'nome': nome,
      'email': email,
      'senha': senha,
      ...baseMap,
    };
  }
}
