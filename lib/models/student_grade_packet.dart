// ============================================================================
// ESTILO ARQUITECTÓNICO: ORIENTACIÓN A OBJETOS (ENCAPSULAMIENTO DE DATOS)
// Archivo: lib/models/student_grade_packet.dart
// Descripción: Define el paquete de datos (Data Packet) que fluye a través de
//              las tuberías (pipes) y guarda la bitácora de trazabilidad.
// ============================================================================

/// Representa un registro individual del recorrido del dato en una etapa (Filtro).
class PipeStageLog {
  final int stageNumber;
  final String filterName;
  final String inputData;
  final String outputData;
  final bool success;

  const PipeStageLog({
    required this.stageNumber,
    required this.filterName,
    required this.inputData,
    required this.outputData,
    required this.success,
  });
}

/// Paquete de datos que viaja por la tubería (Pipe) entre cada Filtro.
class StudentGradePacket {
  // Datos crudos de entrada
  final String studentName;
  final String studentCode;
  final String rawCorte1;
  final String rawCorte2;
  final String rawCorte3;

  // Datos transformados por Etapa 1 (Filtro de Validación)
  final bool isValid;
  final String validationMessage;
  final double corte1;
  final double corte2;
  final double corte3;

  // Datos transformados por Etapa 2 (Filtro de Cálculo de Promedio)
  final double weightedAverage;

  // Datos transformados por Etapa 3 (Filtro de Clasificación)
  final String classification;
  final bool passed;

  // Evidencia del recorrido de los datos (Trazabilidad por etapas)
  final List<PipeStageLog> traceLogs;

  const StudentGradePacket({
    required this.studentName,
    required this.studentCode,
    required this.rawCorte1,
    required this.rawCorte2,
    required this.rawCorte3,
    this.isValid = false,
    this.validationMessage = 'Pendiente de validación',
    this.corte1 = 0.0,
    this.corte2 = 0.0,
    this.corte3 = 0.0,
    this.weightedAverage = 0.0,
    this.classification = 'Sin clasificar',
    this.passed = false,
    this.traceLogs = const [],
  });

  /// Crea una nueva instancia transformada para enviar por la siguiente tubería (Pipe).
  StudentGradePacket copyWith({
    bool? isValid,
    String? validationMessage,
    double? corte1,
    double? corte2,
    double? corte3,
    double? weightedAverage,
    String? classification,
    bool? passed,
    List<PipeStageLog>? traceLogs,
  }) {
    return StudentGradePacket(
      studentName: studentName,
      studentCode: studentCode,
      rawCorte1: rawCorte1,
      rawCorte2: rawCorte2,
      rawCorte3: rawCorte3,
      isValid: isValid ?? this.isValid,
      validationMessage: validationMessage ?? this.validationMessage,
      corte1: corte1 ?? this.corte1,
      corte2: corte2 ?? this.corte2,
      corte3: corte3 ?? this.corte3,
      weightedAverage: weightedAverage ?? this.weightedAverage,
      classification: classification ?? this.classification,
      passed: passed ?? this.passed,
      traceLogs: traceLogs ?? this.traceLogs,
    );
  }
}
