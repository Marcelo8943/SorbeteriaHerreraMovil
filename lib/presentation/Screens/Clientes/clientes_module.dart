import 'package:herrera_system/core/network/api_client.dart';
import 'package:herrera_system/data/repository/cliente_repository.dart';
import 'package:herrera_system/presentation/providers/cliente_provider.dart';
import 'package:herrera_system/services/cliente_service.dart';

/// Composition root privado del módulo de Clientes.
class ClientesModule {
  final ApiClient _apiClient;
  late final ClienteRepository repository;
  late final ClienteService service;
  late final ClienteProvider provider;

  ClientesModule._(this._apiClient) {
    repository = ClienteRepository(_apiClient);
    service = ClienteService(repository);
    provider = ClienteProvider(service);
  }

  factory ClientesModule.create() => ClientesModule._(ApiClient());

  void dispose() {
    provider.dispose();
    _apiClient.dispose();
  }
}
