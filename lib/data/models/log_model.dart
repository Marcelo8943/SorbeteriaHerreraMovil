class LogModel {
  final String id;
  final DateTime timestamp;
  final String level;
  final String userId;
  final String userName;
  final String rol;
  final String method;
  final String path;
  final String modulo;
  final String tipo;
  final int statusCode;
  final bool success;
  final int elapsedMilliseconds;

  const LogModel({
    required this.id,
    required this.timestamp,
    required this.level,
    required this.userId,
    required this.userName,
    required this.rol,
    required this.method,
    required this.path,
    required this.modulo,
    required this.tipo,
    required this.statusCode,
    required this.success,
    required this.elapsedMilliseconds,
  });

  factory LogModel.fromJson(Map<String, dynamic> json) {
    final statusCode = json['statusCode'] as int? ?? 0;
    return LogModel(
      id: json['id']?.toString() ?? '',
      timestamp: DateTime.parse(json['timestamp'] as String),
      level: json['level']?.toString() ?? '',
      userId: json['userId']?.toString() ?? '',
      userName: json['userName']?.toString() ?? '',
      rol: json['rol']?.toString() ?? '',
      method: json['method']?.toString() ?? '',
      path: json['path']?.toString() ?? '',
      modulo: json['modulo']?.toString() ?? '',
      tipo: json['tipo']?.toString() ?? '',
      statusCode: statusCode,
      success: json['success'] as bool? ?? statusCode < 400,
      elapsedMilliseconds: json['elapsedMilliseconds'] as int? ?? 0,
    );
  }
}

class LogPageModel {
  final List<LogModel> logs;
  final int currentPage;
  final int pageSize;
  final int totalRecords;
  final int totalPages;

  const LogPageModel({
    required this.logs,
    required this.currentPage,
    required this.pageSize,
    required this.totalRecords,
    required this.totalPages,
  });

  factory LogPageModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'];
    if (data is! List) {
      throw const FormatException('Formato de página de logs inválido.');
    }

    return LogPageModel(
      logs: data.map((item) {
        if (item is! Map<String, dynamic>) {
          throw const FormatException('Formato de registro de log inválido.');
        }
        return LogModel.fromJson(item);
      }).toList(),
      currentPage: json['currentPage'] as int? ?? 1,
      pageSize: json['pageSize'] as int? ?? 10,
      totalRecords: json['totalRecords'] as int? ?? 0,
      totalPages: json['totalPages'] as int? ?? 0,
    );
  }
}

class LogDetailModel {
  final LogModel log;
  final String traceId;
  final String environment;
  final String clientIp;
  final String device;
  final String queryString;
  final String payload;
  final String status;
  final String exception;

  const LogDetailModel({
    required this.log,
    required this.traceId,
    required this.environment,
    required this.clientIp,
    required this.device,
    required this.queryString,
    required this.payload,
    required this.status,
    required this.exception,
  });

  factory LogDetailModel.fromJson(Map<String, dynamic> json) {
    return LogDetailModel(
      log: LogModel.fromJson(json),
      traceId: json['traceId']?.toString() ?? '',
      environment: json['environment']?.toString() ?? '',
      clientIp: json['clientIp']?.toString() ?? '',
      device: json['device']?.toString() ?? '',
      queryString: json['queryString']?.toString() ?? '',
      payload: json['payload']?.toString() ?? '',
      status: json['status']?.toString() ?? '',
      exception: json['exception']?.toString() ?? '',
    );
  }
}
