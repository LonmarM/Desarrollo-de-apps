// ============================================================================
// PANTALLA 3: RESULTADOS GENERALES, ESTADÍSTICAS Y RESUMEN ARQUITECTÓNICO
// Archivo: lib/screens/general_stats_screen.dart
// ============================================================================

import 'package:flutter/material.dart';
import '../models/student_grade_packet.dart';

class GeneralStatsScreen extends StatelessWidget {
  final List<StudentGradePacket> students;
  final int rejectedCount;

  const GeneralStatsScreen({
    super.key,
    required this.students,
    required this.rejectedCount,
  });

  @override
  Widget build(BuildContext context) {
    final total = students.length;
    final passedCount = students.where((s) => s.passed).length;
    final failedCount = total - passedCount;
    final passRate = total == 0 ? 0.0 : (passedCount / total) * 100.0;

    final courseAverage = total == 0
        ? 0.0
        : students.map((s) => s.weightedAverage).reduce((a, b) => a + b) / total;

    final highest = total == 0
        ? 0.0
        : students.map((s) => s.weightedAverage).reduce((a, b) => a > b ? a : b);

    final lowest = total == 0
        ? 0.0
        : students.map((s) => s.weightedAverage).reduce((a, b) => a < b ? a : b);

    final superiorCount =
        students.where((s) => s.weightedAverage >= 4.50).length;
    final altoCount = students
        .where((s) => s.weightedAverage >= 4.00 && s.weightedAverage < 4.50)
        .length;
    final basicoCount = students
        .where((s) => s.weightedAverage >= 3.00 && s.weightedAverage < 4.00)
        .length;
    final bajoCount = students.where((s) => s.weightedAverage < 3.00).length;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            'Indicadores Generales del Curso (Escala USTA 0.0 - 5.0)',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _MetricCard(
                  title: 'Promedio General',
                  value: courseAverage.toStringAsFixed(2),
                  subtitle: 'Escala 0.00 a 5.00',
                  color: const Color(0xFF1D4ED8),
                  icon: Icons.analytics_outlined,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _MetricCard(
                  title: 'Tasa Aprobación',
                  value: '${passRate.toStringAsFixed(0)}%',
                  subtitle: '$passedCount aprobados / $failedCount reprob.',
                  color: const Color(0xFF15803D),
                  icon: Icons.verified_outlined,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: _MetricCard(
                  title: 'Nota Máxima / Mínima',
                  value: '${highest.toStringAsFixed(2)} / ${lowest.toStringAsFixed(2)}',
                  subtitle: 'Rango del grupo actual',
                  color: const Color(0xFF0F172A),
                  icon: Icons.swap_vert_circle_outlined,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _MetricCard(
                  title: 'Rechazados en Filtro 1',
                  value: '$rejectedCount',
                  subtitle: 'Detenidos por validación',
                  color: const Color(0xFFD97706),
                  icon: Icons.filter_alt_off_outlined,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Card(
            elevation: 1,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Distribución por Nivel de Clasificación (Etapa 3 del Pipeline)',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 14),
                  _DistributionBar(
                    label: 'Superior (4.50 - 5.00)',
                    count: superiorCount,
                    total: total,
                    color: const Color(0xFF1D4ED8),
                  ),
                  const SizedBox(height: 10),
                  _DistributionBar(
                    label: 'Alto (4.00 - 4.49)',
                    count: altoCount,
                    total: total,
                    color: const Color(0xFF0284C7),
                  ),
                  const SizedBox(height: 10),
                  _DistributionBar(
                    label: 'Básico (3.00 - 3.99)',
                    count: basicoCount,
                    total: total,
                    color: const Color(0xFF16A34A),
                  ),
                  const SizedBox(height: 10),
                  _DistributionBar(
                    label: 'Bajo / Reprobado (< 3.00)',
                    count: bajoCount,
                    total: total,
                    color: const Color(0xFFDC2626),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Card(
            elevation: 0,
            color: const Color(0xFFF1F5F9),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: const Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Sustentación Arquitectónica en el Código:',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                  ),
                  SizedBox(height: 6),
                  Text(
                    '• Tubos y Filtros (Pipes & Filters): GradeProcessingPipeline conecta ValidationFilter, AverageCalculationFilter y ClassificationFilter sin que los filtros dependan entre sí.
'
                    '• Orientación a Objetos y Subrutinas: StudentGradePacket encapsula el estado inmutable y cada filtro emplea métodos auxiliares privados (_isGradeInRange, _computeWeightedAverage, _determineCategory).',
                    style: TextStyle(fontSize: 12.5, height: 1.45),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _MetricCard extends StatelessWidget {
  final String title;
  final String value;
  final String subtitle;
  final Color color;
  final IconData icon;

  const _MetricCard({
    required this.title,
    required this.value,
    required this.subtitle,
    required this.color,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: color, size: 20),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF475569),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              value,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              subtitle,
              style: const TextStyle(fontSize: 11.5, color: Color(0xFF64748B)),
            ),
          ],
        ),
      ),
    );
  }
}

class _DistributionBar extends StatelessWidget {
  final String label;
  final int count;
  final int total;
  final Color color;

  const _DistributionBar({
    required this.label,
    required this.count,
    required this.total,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final ratio = total == 0 ? 0.0 : count / total;
    final pct = (ratio * 100).toStringAsFixed(0);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500)),
            Text(
              '$count est. ($pct%)',
              style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        const SizedBox(height: 5),
        ClipRRect(
          borderRadius: BorderRadius.circular(6),
          child: LinearProgressIndicator(
            value: ratio,
            minHeight: 10,
            backgroundColor: const Color(0xFFE2E8F0),
            valueColor: AlwaysStoppedAnimation<Color>(color),
          ),
        ),
      ],
    );
  }
}
