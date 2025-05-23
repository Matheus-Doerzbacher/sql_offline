import '../../../../../domain/model/base_model.dart';

class UsuarioUpdate {
  String? name;
  String? email;
  String? senha;
  DateTime? dataAlteracao;
  ApiStatus? apiStatus;

  UsuarioUpdate({
    this.name,
    this.email,
    this.senha,
    this.dataAlteracao,
    this.apiStatus,
  });

  factory UsuarioUpdate.fromJson(Map<String, dynamic> json) {
    return UsuarioUpdate(
      name: json['name'],
      email: json['email'],
      senha: json['senha'],
      dataAlteracao: json['data_alteracao'],
      apiStatus: ApiStatus.values.byName(json['status']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'senha': senha,
      'data_alteracao': dataAlteracao,
      'status': apiStatus,
    };
  }
}
