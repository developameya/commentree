import 'package:envied/envied.dart';

part 'secret_service.g.dart';

@Envied()
abstract class SecretService {
  @EnviedField(varName: 'PATH', obfuscate: true)
  static final String path = _SecretService.path;
}
