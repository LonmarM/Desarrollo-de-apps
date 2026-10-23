// ============================================================================
// PANTALLA 2: CONSULTA DE RESULTADOS INDIVIDUALES Y TRAZABILIDAD POR ALUMNO
// Archivo: lib/screens/individual_results_screen.dart
// ============================================================================

import 'package:flutter/material.dart';
import '../models/student_grade_packet.dart';

class IndividualResultsScreen extends StatefulWidget {
  final List<StudentGradePacket> students;

  const IndividualResultsScreen({super.key, required this.students});

  @override
  State<IndividualResultsScreen> createState() => _IndividualResultsScreenState();
}

class _IndividualResultsScreenState extends State<IndividualResultsScreen> {
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    final filtered = widget.students.where((s) {
      final q = _searchQuery.toLowerCase();
      return s.studentName.toLowerCase().contains(q) ||
          s.studentCode.toLowerCase().contains(q) ||
          s.classification.toLowerCase().contains(q);
    }).toList();

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextField(
            onChanged: (value) => setState(() => _searchQuery = value),
            decoration: const InputDecoration(
              labelText: 'Buscar por estudiante, código USTA o clasificación',
              prefixIcon: Icon(Icons.search),
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Mostrando ${filtered.length} de ${widget.students.length} registros procesados (toca un estudiante para ver su recorrido de datos):',
            style: const TextStyle(fontSize: 13, color: Color(0xFF475569)),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: ListView.separated(
              itemCount: filtered.length,
              separatorBuilder: (_, __) => const SizedBox(height: 10),
              itemBuilder: (context, index) {
                final student = filtered[index];
                final badgeColor = student.passed
                    ? const Color(0xFF15803D)
                    : const Color(0xFFB91C1C);

                return Card(
                  elevation: 1,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: ExpansionTile(
                    leading: CircleAvatar(
                      backgroundColor: badgeColor.withOpacity(0.15),
                      child: Text(
                        student.weightedAverage.toStringAsFixed(1),
                        style: TextStyle(
                          color: badgeColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ),
                      ),
                    ),
                    title: Text(
                      student.studentName,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      'Código: ${student.studentCode}  •  ${student.classification}',
                      style: const TextStyle(fontSize: 12.5),
                    ),
                    trailing: Chip(
                      label: Text(
                        student.passed ? 'APROBADO' : 'REPROBADO',
                        style: TextStyle(
                          color: badgeColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 11,
                        ),
                      ),
                      backgroundColor: badgeColor.withOpacity(0.12),
                      side: BorderSide.none,
                    ),
                    childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                    children: [
                      const Divider(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _GradePill(label: 'Corte 1 (30%)', value: student.corte1),
                          _GradePill(label: 'Corte 2 (30%)', value: student.corte2),
                          _GradePill(label: 'Corte 3 (40%)', value: student.corte3),
                          _GradePill(
                            label: 'Definitiva',
                            value: student.weightedAverage,
                            highlight: true,
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      const Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Trazabilidad del Paquete en la Tubería (Pipes & Filters):',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12.5),
                        ),
                      ),
                      const SizedBox(height: 6),
                      for (final log in student.traceLogs)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 6),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Icon(Icons.Subdirectory_arrow_right,
                                  size: 16, color: Color(0xFF1D4ED8)),
                              const SizedBox(width: 6),
                              Expanded(
                                child: Text(
                                  '[Etapa ${log.stageNumber}] ${log.filterName}: ${log.outputData}',
                                  style: const TextStyle(fontSize: 12),
                                ),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _GradePill extends StatelessWidget {
  final String label;
  final double value;
  final bool highlight;

  const _GradePill({
    required this.label,
    required this.value,
    this.highlight = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: highlight ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              color: highlight ? Colors.white70 : const Color(0xFF64748B),
            ),
          ),
          const SizedBox(height: 2),
          Text(
            value.toStringAsFixed(2),
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: highlight ? Colors.white : const Color(0xFF0F172A),
            ),
          ),
        ],
      ),
    );
  }
}
