import '../app_models.dart';

const String mockPreciosUltimaActualizacion = '23/06/26, 04:56 p. m.';

/// Precios sugeridos y de distribución por línea y presentación.
/// Los valores coinciden con los precios definidos en mock_productos.dart.
final List<PrecioGeneral> mockPreciosGenerales = [
  // Sorbete tradicional
  const PrecioGeneral(
    id: 1,
    presentacion: '4 Onzas',
    linea: 'Tradicional',
    precioDetalle: 45.0,
    precioMayoreo: 40.0,
    cantidadProductos: 2,
  ),
  const PrecioGeneral(
    id: 2,
    presentacion: '8 Onzas',
    linea: 'Tradicional',
    precioDetalle: 70.0,
    precioMayoreo: 65.0,
    cantidadProductos: 7,
  ),
  const PrecioGeneral(
    id: 3,
    presentacion: '1/4 Galón',
    linea: 'Tradicional',
    precioDetalle: 145.0,
    precioMayoreo: 135.0,
    cantidadProductos: 3,
  ),
  const PrecioGeneral(
    id: 4,
    presentacion: '1/2 Galón',
    linea: 'Tradicional',
    precioDetalle: 250.0,
    precioMayoreo: 225.0,
    cantidadProductos: 3,
  ),

  // Sorbete Light
  const PrecioGeneral(
    id: 5,
    presentacion: '8 Onzas',
    linea: 'Lights',
    precioDetalle: 75.0,
    precioMayoreo: 68.0,
    cantidadProductos: 7,
  ),
  const PrecioGeneral(
    id: 6,
    presentacion: '1/4 Galón',
    linea: 'Lights',
    precioDetalle: 155.0,
    precioMayoreo: 140.0,
    cantidadProductos: 4,
  ),
  const PrecioGeneral(
    id: 7,
    presentacion: '1/2 Galón',
    linea: 'Lights',
    precioDetalle: 265.0,
    precioMayoreo: 240.0,
    cantidadProductos: 4,
  ),

  // Sorbetes Fantacia (línea Fantacia)
  const PrecioGeneral(
    id: 8,
    presentacion: '1 libra',
    linea: 'Fantacia',
    precioDetalle: 240.0,
    precioMayoreo: 200.0,
    cantidadProductos: 4,
  ),
  const PrecioGeneral(
    id: 9,
    presentacion: '1/4 Galón',
    linea: 'Fantacia',
    precioDetalle: 320.0,
    precioMayoreo: 280.0,
    cantidadProductos: 5,
  ),
  const PrecioGeneral(
    id: 10,
    presentacion: '1/2 Galón',
    linea: 'Fantacia',
    precioDetalle: 420.0,
    precioMayoreo: 380.0,
    cantidadProductos: 6,
  ),

  // Nieves
  const PrecioGeneral(
    id: 11,
    presentacion: '4 Onzas',
    linea: 'Nieves',
    precioDetalle: 45.0,
    precioMayoreo: 40.0,
    cantidadProductos: 2,
  ),
  const PrecioGeneral(
    id: 12,
    presentacion: '8 Onzas',
    linea: 'Nieves',
    precioDetalle: 70.0,
    precioMayoreo: 65.0,
    cantidadProductos: 5,
  ),
  const PrecioGeneral(
    id: 13,
    presentacion: '1/4 Galón',
    linea: 'Nieves',
    precioDetalle: 145.0,
    precioMayoreo: 135.0,
    cantidadProductos: 4,
  ),
  const PrecioGeneral(
    id: 14,
    presentacion: '1/2 Galón',
    linea: 'Nieves',
    precioDetalle: 250.0,
    precioMayoreo: 225.0,
    cantidadProductos: 4,
  ),

  // Paletas
  const PrecioGeneral(
    id: 15,
    presentacion: '4 Onzas',
    linea: 'Paleta',
    precioDetalle: 45.0,
    precioMayoreo: 40.0,
    cantidadProductos: 15,
  ),
];

/// Precios especiales y ofertas aplicadas a productos específicos.
final List<PrecioEspecial> mockPreciosEspeciales = [
  const PrecioEspecial(
    id: 1,
    productoId: 101,
    productoNombre: 'Sorbete tradicional Ron con pasas 4 Oz',
    precioEspecial: 20.0,
    motivo: '40% Descuento',
    fechaInicio: '03/03/25',
    colorTag: 'purple',
  ),
  const PrecioEspecial(
    id: 2,
    productoId: 102,
    productoNombre: 'Sorbete tradicional Vainilla 8 Oz',
    precioEspecial: 50.0,
    motivo: 'Especial Día de Madres',
    fechaInicio: '02/03/25',
    colorTag: 'yellow',
  ),
];
