import 'package:flutter/services.dart' show rootBundle;
import 'package:csv/csv.dart';
import 'package:flutter/foundation.dart'; // Para compute

class Species {
  final String nombreComun;
  final String nombreCientifico;
  final bool peligroso;
  final String razon;
  final String peso;
  final String longitud;
  final String origen;
  final String tipo;
  final String clasificacion;
  final String descripcion;

  Species({
    required this.nombreComun,
    required this.nombreCientifico,
    required this.peligroso,
    required this.razon,
    required this.peso,
    required this.longitud,
    required this.origen,
    required this.tipo,
    required this.clasificacion,
    required this.descripcion,
  });

  factory Species.fromCsv(List<dynamic> row) {
    String clean(String? s) => (s ?? '').trim().toLowerCase();
    return Species(
      nombreComun: row[0]?.toString() ?? '',
      nombreCientifico: row[1]?.toString() ?? '',
      peligroso: clean(row[2]) == 'sí',
      razon: row[3]?.toString() ?? '',
      peso: row[4]?.toString() ?? '',
      longitud: row[5]?.toString() ?? '',
      origen: row[6]?.toString() ?? '',
      tipo: clean(row[7]),
      clasificacion: clean(row[8]),
      descripcion: row[9]?.toString() ?? '',
    );
  }
}

List<String> cleanRow(List row) =>
    row.map((e) => (e?.toString() ?? '').trim()).toList();

// Función para parsear el CSV en un isolate, robusta y segura
List<Species> parseSpeciesCsv(String data) {
  try {
    final csvRows = const CsvToListConverter(
      fieldDelimiter: ',',
      eol: '\n',
      shouldParseNumbers: false,
    ).convert(data, eol: '\n');
    final List<Species> result = [];
    for (var i = 1; i < csvRows.length; i++) {
      final row = cleanRow(csvRows[i]);
      if (row.length >= 10) {
        try {
          result.add(Species.fromCsv(row));
        } catch (e) {}
      }
      if (result.length > 500) break;
    }
    print('Cargadas especies: \\${result.length}');
    return result;
  } catch (e) {
    // Si el parser falla, intenta con CsvToListConverter sin eol explícito
    try {
      final csvRows = const CsvToListConverter(
        fieldDelimiter: ',',
        shouldParseNumbers: false,
      ).convert(data);
      final List<Species> result = [];
      for (var i = 1; i < csvRows.length; i++) {
        final row = cleanRow(csvRows[i]);
        if (row.length >= 10) {
          try {
            result.add(Species.fromCsv(row));
          } catch (e) {}
        }
        if (result.length > 500) break;
      }
      print('Cargadas especies: \\${result.length}');
      return result;
    } catch (e) {
      print('Error parseando CSV: \\${e.toString()}');
      return [];
    }
  }
}

Future<List<Species>> loadSpecies() async {
  final data = await rootBundle.loadString('assets/EcoScanDataset.csv');
  return compute(parseSpeciesCsv, data);
}
