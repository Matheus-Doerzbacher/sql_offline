class UsuarioCreated {
  final String nome;
  final String email;
  final String senha;

  UsuarioCreated({
    required this.nome,
    required this.email,
    required this.senha,
  });

  factory UsuarioCreated.fromJson(Map<String, dynamic> json) {
    return UsuarioCreated(
      nome: json['nome'],
      email: json['email'],
      senha: json['senha'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'nome': nome,
      'email': email,
      'senha': senha,
    };
  }

  UsuarioCreated copyWith({
    String? nome,
    String? senha,
  }) {
    return UsuarioCreated(
      nome: nome ?? this.nome,
      email: email,
      senha: senha ?? this.senha,
    );
  }
}
