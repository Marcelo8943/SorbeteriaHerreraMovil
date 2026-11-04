import 'package:herrera_system/data/models/precio_general_model.dart';
import 'package:herrera_system/data/repository/precio_repository.dart';

class PrecioService {
  final PrecioRepository _repository;

  PrecioService(this._repository);

  Future<List<PrecioGeneralModel>> obtenerPreciosGenerales({int? lineId}) =>
      _repository.obtenerPreciosGenerales(lineId: lineId);

  Future<void> actualizarPreciosGenerales({
    required int linePresentationId,
    required double retailPrice,
    required double wholesalePrice,
  }) => _repository.actualizarPreciosGenerales(
    linePresentationId: linePresentationId,
    retailPrice: retailPrice,
    wholesalePrice: wholesalePrice,
  );
}
