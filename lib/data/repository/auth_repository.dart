import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'package:result_dart/result_dart.dart';
import '../services/api/api_client.dart';
import '../services/api/auth_api_client.dart';
import '../services/api/model/login/login_request.dart';
import '../services/shared_preferences_service.dart';

class AuthRepository extends ChangeNotifier {
  AuthRepository({
    required ApiClient apiClient,
    required AuthApiClient authApiClient,
    required SharedPreferencesService sharedPreferencesService,
  })  : _apiClient = apiClient,
        _authApiClient = authApiClient,
        _sharedPreferencesService = sharedPreferencesService {
    _apiClient.authHeaderProvider = _authHeaderProvider;
  }

  final ApiClient _apiClient;
  final AuthApiClient _authApiClient;
  final SharedPreferencesService _sharedPreferencesService;

  bool? _isAuthenticated;
  String? _authToken;

  final _log = Logger('AuthRepository');

  Future<void> _buscar() async {
    final result = await _sharedPreferencesService.fetchToken();
    result.fold((token) {
      _authToken = token;
      _isAuthenticated = true;
    }, (failure) {
      _log.severe(
        'Falha ao buscar token do SharedPreferences: $failure',
      );
    });
  }

  Future<bool> get isAuthenticated async {
    if (_isAuthenticated != null) {
      return _isAuthenticated!;
    }
    await _buscar();
    return _isAuthenticated ?? false;
  }

  AsyncResult<Unit> login({required LoginRequest loginRequest}) async {
    try {
      final result = await _authApiClient.login(loginRequest);
      return result.fold(
        (loginResponse) {
          _log.info('Usuário logado com sucesso');
          // Set auth status
          _isAuthenticated = true;
          _authToken = loginResponse.token;
          // Store in Shared preferences
          return _sharedPreferencesService.saveToken(loginResponse.token);
        },
        (failure) {
          _log.warning('Erro ao logar: $failure');
          return Failure(failure);
        },
      );
    } finally {
      notifyListeners();
    }
  }

  AsyncResult<Unit> logout() async {
    _log.info('Usuário deslogado com sucesso');
    try {
      final result = await _sharedPreferencesService.saveToken(null);

      if (result is Failure) {
        _log.severe('Falha ao limpar token de autenticação');
      }

      // Clear token in ApiClient
      _authToken = null;

      // Clear authenticated status
      _isAuthenticated = false;
      return result;
    } finally {
      notifyListeners();
    }
  }

  String? _authHeaderProvider() =>
      _authToken != null ? 'Bearer $_authToken' : null;
}
