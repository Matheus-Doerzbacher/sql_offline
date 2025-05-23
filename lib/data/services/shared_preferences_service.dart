// Copyright 2024 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:logging/logging.dart';
import 'package:result_dart/result_dart.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesService {
  static const _tokenKey = 'TOKEN';
  final _log = Logger('SharedPreferencesService');

  AsyncResult<String> fetchToken() async {
    try {
      final sharedPreferences = await SharedPreferences.getInstance();
      _log.finer('Buscando token no SharedPreferences');
      final token = sharedPreferences.getString(_tokenKey);
      if (token == null) {
        return Failure(Exception('Token não encontrado'));
      }
      return Success(token);
    } on Exception catch (e) {
      _log.warning('Falha ao buscar token: $e');
      return Failure(e);
    }
  }

  AsyncResult<Unit> saveToken(String? token) async {
    try {
      final sharedPreferences = await SharedPreferences.getInstance();
      if (token == null) {
        _log.finer('Removendo token');
        await sharedPreferences.remove(_tokenKey);
      } else {
        _log.finer('Substituindo token');
        await sharedPreferences.setString(_tokenKey, token);
      }
      return const Success(unit);
    } on Exception catch (e, s) {
      _log.warning('Falha ao definir token: $e\n$s');
      return Failure(e);
    }
  }
}
