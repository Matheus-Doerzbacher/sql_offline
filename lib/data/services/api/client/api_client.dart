import 'dart:convert';
import 'dart:io';

import 'package:logging/logging.dart';
import 'package:result_dart/result_dart.dart';

typedef AuthHeaderProvider = String? Function();

class ApiClient {
  ApiClient({HttpClient Function()? clientFactory})
      : _clientFactory = clientFactory ?? HttpClient.new;

  final HttpClient Function() _clientFactory;

  AuthHeaderProvider? authHeaderProvider;

  final _log = Logger('ApiClient');

  Future<void> _authHeader(HttpHeaders headers) async {
    final header = authHeaderProvider?.call();
    if (header != null) {
      headers.add(HttpHeaders.authorizationHeader, header);
    }
  }

  String get _hostBase => 'http://localhost:8000/api/v1';

  String _getUri(String path, {int? id}) {
    if (path.startsWith('/')) {
      if (id != null) {
        return '$_hostBase$path/$id';
      }
      return '$_hostBase$path/';
    }
    if (id != null) {
      return '$_hostBase/$path/$id';
    }
    return '$_hostBase/$path/';
  }

  AsyncResult<dynamic> get(String path) async {
    final client = _clientFactory();
    try {
      _log.info('GET $path');
      final request = await client.getUrl(Uri.parse(_getUri(path)));
      await _authHeader(request.headers);
      final response = await request.close();
      if (response.statusCode == 200) {
        final stringData = await response.transform(utf8.decoder).join();
        final json = jsonDecode(stringData);
        return Success(json);
      } else {
        return Failure(
          HttpException(
            'GET $path falhou com status ${response.statusCode}',
          ),
        );
      }
    } on Exception catch (error) {
      _log.severe('GET $path falhou: $error');
      return Failure(error);
    } finally {
      client.close();
    }
  }

  AsyncResult<dynamic> post(String path, dynamic body) async {
    final client = _clientFactory();
    try {
      _log
        ..info('POST $path')
        ..info('data: ${jsonEncode(body)}');
      final request = await client.postUrl(Uri.parse(_getUri(path)));
      await _authHeader(request.headers);
      request.write(jsonEncode(body));
      final response = await request.close();
      if (response.statusCode == 201) {
        final stringData = await response.transform(utf8.decoder).join();
        final json = jsonDecode(stringData);
        return Success(json);
      } else {
        _log.severe('POST $path falhou com status ${response.statusCode}');
        return Failure(
          HttpException(
            'POST $path falhou com status ${response.statusCode}',
          ),
        );
      }
    } on Exception catch (error) {
      _log.severe('POST $path falhou: $error');
      return Failure(error);
    } finally {
      client.close();
    }
  }

  AsyncResult<dynamic> put(String path, dynamic body, int id) async {
    final client = _clientFactory();
    try {
      _log.info('PUT $path/$id');
      final request = await client.putUrl(Uri.parse(_getUri(path, id: id)));
      await _authHeader(request.headers);
      request.write(jsonEncode(body));
      final response = await request.close();
      if (response.statusCode == 200) {
        final stringData = await response.transform(utf8.decoder).join();
        final json = jsonDecode(stringData);
        return Success(json);
      } else {
        _log.severe('PUT $path/$id falhou com status ${response.statusCode}');
        return Failure(
          HttpException(
            'PUT $path/$id falhou com status ${response.statusCode}',
          ),
        );
      }
    } on Exception catch (error) {
      _log.severe('PUT $path falhou: $error');
      return Failure(error);
    } finally {
      client.close();
    }
  }

  AsyncResult<Unit> delete(String path, int id) async {
    final client = _clientFactory();
    try {
      _log.info('DELETE $path/$id');
      final request = await client.deleteUrl(Uri.parse(_getUri(path, id: id)));
      await _authHeader(request.headers);
      final response = await request.close();
      // Response 204 "No Content", delete was successful
      if (response.statusCode == 204) {
        return const Success(unit);
      } else {
        return Failure(
          HttpException(
            'DELETE $path/$id falhou com status ${response.statusCode}',
          ),
        );
      }
    } on Exception catch (error) {
      _log.severe('DELETE $path/$id falhou: $error');
      return Failure(error);
    } finally {
      client.close();
    }
  }
}
