// lib/config/app_config.dart

/// Configuración global de la aplicación.
///
/// Para cambiar la URL base según el entorno, usa --dart-define al correr o compilar:
///
/// Producción:
///   flutter build apk --dart-define=BASE_URL=https://backend-ferova-production-187b.up.railway.app/api
///
/// Si no se pasa BASE_URL, se usa el valor de [defaultValue] (testing).
class AppConfig {
  static const String baseUrl = String.fromEnvironment(
    'BASE_URL',
    defaultValue: 'http://10.0.2.2:5002/api', // Testing — cambiar a producción para usuarios finales
  );
}