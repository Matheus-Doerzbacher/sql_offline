import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import '../data/repository/auth_repository.dart';
import '../data/repository/usuario_repository.dart';
import '../data/services/api/api_client.dart';
import '../data/services/api/auth_api_client.dart';
import '../data/services/api/usuario/usuario_service.dart';
import '../data/services/shared_preferences_service.dart';
import '../ui/auth/login/login_viewmodel.dart';
import '../ui/auth/logout/logout_viewmodel.dart';
import '../ui/home/home_viewmodel.dart';

List<SingleChildWidget> providers = [
  // Services
  Provider(create: (context) => ApiClient()),
  Provider(create: (context) => AuthApiClient()),
  Provider(create: (context) => SharedPreferencesService()),

  // Services
  Provider(
    create: (context) => UsuarioService(
      apiClient: context.read(),
    ),
  ),

  // Repositories
  ChangeNotifierProvider(
    create: (context) => AuthRepository(
      apiClient: context.read(),
      authApiClient: context.read(),
      sharedPreferencesService: context.read(),
    ),
  ),
  Provider(
    create: (context) => UsuarioRepository(
      usuarioService: context.read(),
    ),
  ),

  // ViewModels
  ChangeNotifierProvider(
    create: (context) => LoginViewModel(
      authRepository: context.read(),
      usuarioRepository: context.read(),
    ),
  ),
  ChangeNotifierProvider(
    create: (context) => LogoutViewModel(
      authRepository: context.read(),
    ),
  ),
  ChangeNotifierProvider(create: (context) => HomeViewModel()),
];
