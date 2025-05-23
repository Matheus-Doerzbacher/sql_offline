import 'package:sql_offline/domain/model/base_model.dart';

class Tarefa extends BaseModel {
  final int idTarefa;
  final int idUsuario;
  final String titulo;
  final String descricao;
  final bool isConcluida;

  Tarefa({
    required this.idTarefa,
    required this.idUsuario,
    required this.titulo,
    required this.descricao,
    required this.isConcluida,
    required super.apiStatus,
    required super.dataCriacao,
    required super.dataAlteracao,
  });

  factory Tarefa.fromMap(Map<String, dynamic> json) {
    final base = BaseModel.fromMap(json);

    return Tarefa(
      idTarefa: json['id_tarefa'],
      idUsuario: json['id_usuario'],
      titulo: json['titulo'],
      descricao: json['descricao'],
      isConcluida: json['is_concluida'],
      apiStatus: base.apiStatus,
      dataCriacao: base.dataCriacao,
      dataAlteracao: base.dataAlteracao,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id_tarefa': idTarefa,
      'id_usuario': idUsuario,
      'titulo': titulo,
      'descricao': descricao,
      'is_concluida': isConcluida,
      ...baseMap,
    };
  }

  Tarefa copyWith({
    String? titulo,
    String? descricao,
    bool? isConcluida,
    ApiStatus? apiStatus,
  }) {
    return Tarefa(
      idTarefa: idTarefa,
      idUsuario: idUsuario,
      titulo: titulo ?? this.titulo,
      descricao: descricao ?? this.descricao,
      isConcluida: isConcluida ?? this.isConcluida,
      apiStatus: apiStatus ?? this.apiStatus,
      dataCriacao: dataCriacao,
      dataAlteracao: dataAlteracao,
    );
  }
}
