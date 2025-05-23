import 'dart:convert';
import 'dart:io';

import 'package:logging/logging.dart';
import 'package:result_dart/result_dart.dart';
import '../../services/api/model/login/login_request.dart';
import '../../services/api/model/login/login_responde.dart';

class AuthApiClient {
  AuthApiClient({HttpClient Function()? clientFactory})
      : _clientFactory = clientFactory ?? HttpClient.new;

  final HttpClient Function() _clientFactory;

  String get _hostBase => 'http://localhost:8000/api/v1/usuarios/login';

  final _log = Logger('AuthApiClient');

  AsyncResult<LoginResponse> login(LoginRequest loginRequest) async {
    final client = _clientFactory();
    try {
      _log.info('POST $_hostBase');
      final request = await client.postUrl(
        Uri.parse(_hostBase),
      );
      request.headers.contentType =
          ContentType('application', 'x-www-form-urlencoded', charset: 'utf-8');
      final body = 'grant_type=password'
          '&username=${Uri.encodeComponent(loginRequest.email)}'
          '&password=${Uri.encodeComponent(loginRequest.password)}';
      request.write(body);
      final response = await request.close();
      if (response.statusCode == 200) {
        final stringData = await response.transform(utf8.decoder).join();
        return Success(LoginResponse.fromJson(jsonDecode(stringData)));
      } else if (response.statusCode == 401) {
        return Failure(
          Exception('Usuario o contraseña incorrectos'),
        );
      } else {
        _log.severe('Login error com status ${response.statusCode}');
        return const Failure(HttpException('Login error'));
      }
    } on Exception catch (error) {
      _log.severe('Login error: $error');
      return Failure(error);
    } finally {
      client.close();
    }
  }
}
