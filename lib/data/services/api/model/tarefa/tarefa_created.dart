class TarefaCreated {
  final String titulo;
  final String descricao;

  TarefaCreated({
    required this.titulo,
    required this.descricao,
  });

  factory TarefaCreated.fromJson(Map<String, dynamic> json) {
    return TarefaCreated(
      titulo: json['titulo'],
      descricao: json['descricao'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'titulo': titulo,
      'descricao': descricao,
    };
  }
}
