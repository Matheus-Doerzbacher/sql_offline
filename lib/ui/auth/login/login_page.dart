import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:result_command/result_command.dart';
import '../../../data/services/api/model/login/login_request.dart';
import '../../../data/services/api/model/usuario/usuario_created.dart';
import '../../../routing/routes.dart';
import 'login_viewmodel.dart';

class LoginPage extends StatefulWidget {
  final LoginViewModel viewModel;
  const LoginPage({super.key, required this.viewModel});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _obscureTextPassword = true;
  bool _obscureTextConfirmPassword = true;

  bool _isCreated = false;

  @override
  void initState() {
    widget.viewModel.login.addListener(_listener);
    widget.viewModel.createUser.addListener(_listener);
    super.initState();
  }

  @override
  void dispose() {
    widget.viewModel.login.removeListener(_listener);
    widget.viewModel.createUser.removeListener(_listener);
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _login() {
    if (_formKey.currentState!.validate()) {
      if (_isCreated) {
        widget.viewModel.createUser.execute(
          UsuarioCreated(
            nome: _nameController.text,
            email: _emailController.text.toLowerCase(),
            senha: _passwordController.text,
          ),
        );
      } else {
        widget.viewModel.login.execute(
          LoginRequest(
            email: _emailController.text.toLowerCase(),
            password: _passwordController.text,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListenableBuilder(
        listenable: Listenable.merge([
          widget.viewModel.login,
          widget.viewModel.createUser,
        ]),
        builder: (context, _) {
          final isRunning = widget.viewModel.login.isRunning ||
              widget.viewModel.createUser.isRunning;

          return Form(
            key: _formKey,
            child: Center(
              child: Card(
                margin: const EdgeInsets.symmetric(horizontal: 24),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        _isCreated ? 'Criar usuário' : 'Login',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 16),
                      if (_isCreated) _buildFormNome(),
                      _buildFormEmail(),
                      _buildFormPassword(),
                      if (_isCreated) _buildFormConfirmPassword(),
                      const SizedBox(height: 16),
                      _buildButton(isRunning),
                      _buildTextButton(isRunning),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildFormNome() {
    return TextFormField(
      controller: _nameController,
      decoration: const InputDecoration(
        labelText: 'Nome',
      ),
      validator: (value) {
        if (!_isCreated) return null;

        if (value == null || value.isEmpty) {
          return 'Nome é obrigatório';
        }

        if (value.length < 3) {
          return 'Nome deve ter pelo menos 3 caracteres';
        }

        return null;
      },
    );
  }

  Widget _buildFormEmail() {
    return TextFormField(
      controller: _emailController,
      decoration: const InputDecoration(
        labelText: 'Email',
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Email é obrigatório';
        }

        if (!value.contains('@') || !value.contains('.')) {
          return 'Email inválido';
        }

        return null;
      },
    );
  }

  Widget _buildFormPassword() {
    return TextFormField(
      obscureText: _obscureTextPassword,
      controller: _passwordController,
      decoration: InputDecoration(
        labelText: 'Senha',
        suffix: IconButton(
          icon: Icon(
            _obscureTextPassword
                ? Icons.visibility_off_outlined
                : Icons.visibility_outlined,
          ),
          onPressed: () {
            setState(() {
              _obscureTextPassword = !_obscureTextPassword;
            });
          },
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Senha é obrigatória';
        }
        return null;
      },
    );
  }

  Widget _buildFormConfirmPassword() {
    return TextFormField(
      controller: _confirmPasswordController,
      obscureText: _obscureTextConfirmPassword,
      decoration: InputDecoration(
        labelText: 'Confirmar senha',
        suffix: IconButton(
          icon: Icon(
            _obscureTextConfirmPassword
                ? Icons.visibility_off_outlined
                : Icons.visibility_outlined,
          ),
          onPressed: () {
            setState(() {
              _obscureTextConfirmPassword = !_obscureTextConfirmPassword;
            });
          },
        ),
      ),
      validator: (value) {
        if (!_isCreated) return null;

        if (value == null || value.isEmpty) {
          return 'Senha é obrigatória';
        }

        if (value != _passwordController.text) {
          return 'As senhas não coincidem';
        }

        return null;
      },
    );
  }

  Widget _buildButton(bool isRunning) {
    return FilledButton(
      onPressed: isRunning ? null : _login,
      child: isRunning
          ? const SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(),
            )
          : Text(_isCreated ? 'Criar usuário' : 'Login'),
    );
  }

  Widget _buildTextButton(bool isRunning) {
    return TextButton(
      onPressed: isRunning
          ? null
          : () {
              setState(() {
                _isCreated = !_isCreated;
                _formKey.currentState!.reset();
              });
            },
      child: Text(
        _isCreated ? 'Já tenho uma conta' : 'Criar conta',
      ),
    );
  }

  void _listener() {
    if (widget.viewModel.login.isSuccess) {
      widget.viewModel.login.reset();
      context.go(Routes.home);
    }

    if (widget.viewModel.createUser.isSuccess) {
      widget.viewModel.createUser.reset();
      widget.viewModel.login.execute(
        LoginRequest(
          email: _emailController.text,
          password: _passwordController.text,
        ),
      );
    }

    FailureCommand? failure;
    if (widget.viewModel.login.isFailure) {
      failure = widget.viewModel.login.value as FailureCommand;
      widget.viewModel.login.reset();
    } else if (widget.viewModel.createUser.isFailure) {
      failure = widget.viewModel.createUser.value as FailureCommand;
      widget.viewModel.createUser.reset();
    }

    if (failure != null) {
      final msg = failure.error.toString().replaceAll('Exception: ', '');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.red,
            content: Text(msg),
          ),
        );
      }
    }
  }
}
