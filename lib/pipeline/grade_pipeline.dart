// ============================================================================
// ESTILO ARQUITECTÓNICO: FLUJO DE DATOS — TUBOS Y FILTROS (PIPES & FILTERS)
// COMBINADO CON LLAMADO Y RETORNO (SUBRUTINAS Y ORIENTACIÓN A OBJETOS)
// Archivo: lib/pipeline/grade_pipeline.dart
// Descripción: Implementa tres filtros independientes conectados en serie.
//              Cada filtro recibe un StudentGradePacket por la tubería de
//              entrada, aplica una transformación aislada y emite un nuevo
//              paquete por la tubería de salida.
// ============================================================================

import '../models/student_grade_packet.dart';

/// Contrato base para cualquier Filtro dentro de la arquitectura Tubos y Filtros.
abstract class GradeFilter {
  String get filterName;
  StudentGradePacket execute(StudentGradePacket input);
}

/// ETAPA 1: Filtro de Validación de Datos y Rangos (Escala USTA 0.0 a 5.0)
class ValidationFilter implements GradeFilter {
  @override
  String get filterName => 'Filtro 1: Validación de Entrada y Rango (0.0 - 5.0)';

  /// Subrutina auxiliar de validación de rango numérico
  bool _isGradeInRange(double? value) => value != null && value >= 0.0 && value <= 5.0;

  @override
  StudentGradePacket execute(StudentGradePacket input) {
    final nameClean = input.studentName.trim();
    final codeClean = input.studentCode.trim();
    final n1 = double.tryParse(input.rawCorte1.replaceAll(',', '.'));
    final n2 = double.tryParse(input.rawCorte2.replaceAll(',', '.'));
    final n3 = double.tryParse(input.rawCorte3.replaceAll(',', '.'));

    final inputSummary =
        'Estudiante: "$nameClean" ($codeClean) | Notas crudas: [${input.rawCorte1}, ${input.rawCorte2}, ${input.rawCorte3}]';

    if (nameClean.isEmpty || codeClean.isEmpty) {
      final log = PipeStageLog(
        stageNumber: 1,
        filterName: filterName,
        inputData: inputSummary,
        outputData: 'RECHAZADO: Nombre o código estudiantil vacío.',
        success: false,
      );
      return input.copyWith(
        isValid: false,
        validationMessage: 'Error: El nombre y código del estudiante son obligatorios.',
        traceLogs: [...input.traceLogs, log],
      );
    }

    if (!_isGradeInRange(n1) || !_isGradeInRange(n2) || !_isGradeInRange(n3)) {
      final log = PipeStageLog(
        stageNumber: 1,
        filterName: filterName,
        inputData: inputSummary,
        outputData: 'RECHAZADO: Notas fuera del rango institucional USTA (0.0 a 5.0).',
        success: false,
      );
      return input.copyWith(
        isValid: false,
        validationMessage: 'Error: Todas las notas deben ser números entre 0.0 y 5.0.',
        traceLogs: [...input.traceLogs, log],
      );
    }

    final log = PipeStageLog(
      stageNumber: 1,
      filterName: filterName,
      inputData: inputSummary,
      outputData:
          'VALIDADO OK -> C1: ${n1!.toStringAsFixed(2)}, C2: ${n2!.toStringAsFixed(2)}, C3: ${n3!.toStringAsFixed(2)}',
      success: true,
    );

    return input.copyWith(
      isValid: true,
      validationMessage: 'Datos validados correctamente en escala 0.0 - 5.0',
      corte1: n1,
      corte2: n2,
      corte3: n3,
      traceLogs: [...input.traceLogs, log],
    );
  }
}

/// ETAPA 2: Filtro de Cálculo de Promedio Ponderado (30% + 30% + 40%)
class AverageCalculationFilter implements GradeFilter {
  @override
  String get filterName => 'Filtro 2: Cálculo de Promedio Ponderado (30/30/40)';

  /// Subrutina matemática de ponderación académica (Llamado y Retorno)
  double _computeWeightedAverage(double c1, double c2, double c3) {
    final raw = (c1 * 0.30) + (c2 * 0.30) + (c3 * 0.40);
    return double.parse(raw.toStringAsFixed(2));
  }

  @override
  StudentGradePacket execute(StudentGradePacket input) {
    if (!input.isValid) {
      final log = PipeStageLog(
        stageNumber: 2,
        filterName: filterName,
        inputData: 'Paquete inválido recibido desde Tubería 1',
        outputData: 'OMITIDO: No se calcula promedio por fallo en validación previa.',
        success: false,
      );
      return input.copyWith(traceLogs: [...input.traceLogs, log]);
    }

    final avg = _computeWeightedAverage(input.corte1, input.corte2, input.corte3);
    final log = PipeStageLog(
      stageNumber: 2,
      filterName: filterName,
      inputData:
          'Notas validadas: C1=${input.corte1.toStringAsFixed(2)} (30%), C2=${input.corte2.toStringAsFixed(2)} (30%), C3=${input.corte3.toStringAsFixed(2)} (40%)',
      outputData: 'Promedio ponderado calculado = ${avg.toStringAsFixed(2)} / 5.00',
      success: true,
    );

    return input.copyWith(
      weightedAverage: avg,
      traceLogs: [...input.traceLogs, log],
    );
  }
}

/// ETAPA 3: Filtro de Clasificación Académica y Estado de Aprobación
class ClassificationFilter implements GradeFilter {
  @override
  String get filterName => 'Filtro 3: Clasificación de Desempeño y Estado';

  /// Subrutina de categorización cualitativa según promedio
  String _determineCategory(double avg) {
    if (avg >= 4.50) return 'Superior (Excelencia)';
    if (avg >= 4.00) return 'Alto (Destacado)';
    if (avg >= 3.00) return 'Básico (Aprobado)';
    return 'Bajo (Reprobado)';
  }

  @override
  StudentGradePacket execute(StudentGradePacket input) {
    if (!input.isValid) {
      final log = PipeStageLog(
        stageNumber: 3,
        filterName: filterName,
        inputData: 'Sin promedio calculado',
        outputData: 'OMITIDO: Clasificación cancelada por datos inválidos.',
        success: false,
      );
      return input.copyWith(
        classification: 'Inválido / Rechazado',
        passed: false,
        traceLogs: [...input.traceLogs, log],
      );
    }

    final category = _determineCategory(input.weightedAverage);
    final isPassed = input.weightedAverage >= 3.00;
    final statusText = isPassed ? 'APROBADO (>= 3.0)' : 'REPROBADO (< 3.0)';

    final log = PipeStageLog(
      stageNumber: 3,
      filterName: filterName,
      inputData: 'Promedio recibido por tubería: ${input.weightedAverage.toStringAsFixed(2)}',
      outputData: 'Nivel: $category | Estado final: $statusText',
      success: true,
    );

    return input.copyWith(
      classification: category,
      passed: isPassed,
      traceLogs: [...input.traceLogs, log],
    );
  }
}

/// TUBERÍA PRINCIPAL (PIPELINE): Conecta los filtros de forma secuencial y desacoplada.
class GradeProcessingPipeline {
  final List<GradeFilter> _filters = [
    ValidationFilter(),
    AverageCalculationFilter(),
    ClassificationFilter(),
  ];

  /// Hace fluir el paquete de entrada a través de todos los filtros conectados.
  StudentGradePacket runPipeline(StudentGradePacket initialPacket) {
    StudentGradePacket currentPacket = initialPacket;
    for (final filter in _filters) {
      // El tubo (pipe) transfiere la salida del filtro actual a la entrada del siguiente
      currentPacket = filter.execute(currentPacket);
    }
    return currentPacket;
  }
}
