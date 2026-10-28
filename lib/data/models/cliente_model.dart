class ClienteModel {
  final int id;
  final int municipalityId;
  final String municipalityName;
  final int departmentId;
  final String departmentName;
  final String firstName;
  final String lastName;
  final String phone;
  final String pointOfSale;
  final String posAddress;
  final bool isActive;

  const ClienteModel({
    required this.id,
    required this.municipalityId,
    required this.municipalityName,
    required this.departmentId,
    required this.departmentName,
    required this.firstName,
    required this.lastName,
    required this.phone,
    required this.pointOfSale,
    required this.posAddress,
    required this.isActive,
  });

  factory ClienteModel.fromJson(Map<String, dynamic> json) {
    return ClienteModel(
      id: _intValue(json['id']),
      municipalityId: _intValue(json['municipalityId']),
      municipalityName: json['municipalityName']?.toString() ?? '',
      departmentId: _intValue(json['departmentId']),
      departmentName: json['departmentName']?.toString() ?? '',
      firstName: json['firstName']?.toString() ?? '',
      lastName: json['lastName']?.toString() ?? '',
      phone: json['phone']?.toString() ?? '',
      pointOfSale: json['pointOfSale']?.toString() ?? '',
      posAddress: json['posaddress']?.toString() ??
          json['posAddress']?.toString() ??
          '',
      isActive: json['isActive'] == true,
    );
  }

  String get nombreCompleto => '$firstName $lastName'.trim();
  String get estado => isActive ? 'Activo' : 'Inactivo';
  String get iniciales {
    final first = firstName.trim();
    final last = lastName.trim();
    if (first.isEmpty) return 'CL';
    return last.isEmpty
        ? first[0].toUpperCase()
        : '${first[0]}${last[0]}'.toUpperCase();
  }

  static int _intValue(dynamic value) =>
      value is int ? value : int.tryParse(value?.toString() ?? '') ?? 0;
}

class DepartamentoCliente {
  final int id;
  final String nombre;

  const DepartamentoCliente({required this.id, required this.nombre});

  factory DepartamentoCliente.fromJson(Map<String, dynamic> json) =>
      DepartamentoCliente(
        id: ClienteModel._intValue(json['id']),
        nombre: json['departmentName']?.toString() ?? '',
      );
}

class MunicipioCliente {
  final int id;
  final int departmentId;
  final String nombre;

  const MunicipioCliente({
    required this.id,
    required this.departmentId,
    required this.nombre,
  });

  factory MunicipioCliente.fromJson(Map<String, dynamic> json) =>
      MunicipioCliente(
        id: ClienteModel._intValue(json['id']),
        departmentId: ClienteModel._intValue(json['departmentId']),
        nombre: json['municipalityName']?.toString() ?? '',
      );
}

class ClienteEstadisticas {
  final int activos;
  final int inactivos;
  final int municipios;
  final int puntosVentaActivos;

  const ClienteEstadisticas({
    required this.activos,
    required this.inactivos,
    required this.municipios,
    required this.puntosVentaActivos,
  });

  factory ClienteEstadisticas.fromJson(Map<String, dynamic> json) =>
      ClienteEstadisticas(
        activos: ClienteModel._intValue(json['activeCustomers']),
        inactivos: ClienteModel._intValue(json['inactiveCustomers']),
        municipios: ClienteModel._intValue(
          json['distinctMunicipalitiesWithCustomers'],
        ),
        puntosVentaActivos: ClienteModel._intValue(json['activePointsOfSale']),
      );
}

class PaginaClientes {
  final List<ClienteModel> clientes;
  final int currentPage;
  final int pageSize;
  final int totalRecords;
  final int totalPages;

  const PaginaClientes({
    required this.clientes,
    required this.currentPage,
    required this.pageSize,
    required this.totalRecords,
    required this.totalPages,
  });

  factory PaginaClientes.fromJson(Map<String, dynamic> json) => PaginaClientes(
    clientes: (json['data'] as List<dynamic>? ?? const [])
        .whereType<Map<String, dynamic>>()
        .map(ClienteModel.fromJson)
        .toList(),
    currentPage: ClienteModel._intValue(json['currentPage']),
    pageSize: ClienteModel._intValue(json['pageSize']),
    totalRecords: ClienteModel._intValue(json['totalRecords']),
    totalPages: ClienteModel._intValue(json['totalPages']),
  );
}
