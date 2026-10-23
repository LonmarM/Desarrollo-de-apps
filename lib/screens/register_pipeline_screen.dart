// ============================================================================
// PANTALLA 1: REGISTRO DE ESTUDIANTES Y VISUALIZACIÓN DE TUBOS Y FILTROS
// Archivo: lib/screens/register_pipeline_screen.dart
// ============================================================================

import 'package:flutter/material.dart';
import '../models/student_grade_packet.dart';

class RegisterPipelineScreen extends StatefulWidget {
  final StudentGradePacket? lastProcessedPacket;
  final void Function(String name, String code, String c1, String c2, String c3) onProcessStudent;

  const RegisterPipelineScreen({
    super.key,
    required this.lastProcessedPacket,
    required this.onProcessStudent,
  });

  @override
  State<RegisterPipelineScreen> createState() => _RegisterPipelineScreenState();
}

class _RegisterPipelineScreenState extends State<RegisterPipelineScreen> {
  final _nameCtrl = TextEditingController();
  final _codeCtrl = TextEditingController();
  final _c1Ctrl = TextEditingController();
  final _c2Ctrl = TextEditingController();
  final _c3Ctrl = TextEditingController();

  @override
  void dispose() {
    _nameCtrl.dispose();
    _codeCtrl.dispose();
    _c1Ctrl.dispose();
    _c2Ctrl.dispose();
    _c3Ctrl.dispose();
    super.dispose();
  }

  void _submit() {
    widget.onProcessStudent(
      _nameCtrl.text,
      _codeCtrl.text,
      _c1Ctrl.text,
      _c2Ctrl.text,
      _c3Ctrl.text,
    );
  }

  void _fillDemoValid() {
    setState(() {
      _nameCtrl.text = 'Valentina Gómez Rueda';
      _codeCtrl.text = '2241890';
      _c1Ctrl.text = '4.4';
      _c2Ctrl.text = '4.6';
      _c3Ctrl.text = '4.8';
    });
  }

  void _fillDemoInvalid() {
    setState(() {
      _nameCtrl.text = 'Estudiante Prueba Error';
      _codeCtrl.text = '2249999';
      _c1Ctrl.text = '4.2';
      _c2Ctrl.text = '5.8'; // Nota inválida (> 5.0) para demostrar el Filtro 1
      _c3Ctrl.text = '3.9';
    });
  }

  void _clearFields() {
    setState(() {
      _nameCtrl.clear();
      _codeCtrl.clear();
      _c1Ctrl.clear();
      _c2Ctrl.clear();
      _c3Ctrl.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    final packet = widget.lastProcessedPacket;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Card(
            elevation: 0,
            color: const Color(0xFF0F172A),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: const Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'ARQUITECTURA: TUBOS Y FILTROS + LLAMADO Y RETORNO',
                    style: TextStyle(
                      color: Color(0xFFF59E0B),
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                      letterSpacing: 0.8,
                    ),
                  ),
                  SizedBox(height: 6),
                  Text(
                    'Ingresa un estudiante y ejecuta el pipeline para observar cómo el paquete de datos se transforma en cada etapa (Validación -> Promedio -> Clasificación).',
                    style: TextStyle(color: Colors.white, fontSize: 13.5),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Card(
            elevation: 1,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        '1. Entrada de Datos (Raw Input)',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      Wrap(
                        spacing: 8,
                        children: [
                          TextButton.icon(
                            onPressed: _fillDemoValid,
                            icon: const Icon(Icons.auto_fix_high, size: 16),
                            label: const Text('Ejemplo Válido'),
                          ),
                          TextButton.icon(
                            onPressed: _fillDemoInvalid,
                            icon: const Icon(Icons.warning_amber_rounded, size: 16, color: Colors.orange),
                            label: const Text('Probar Nota > 5.0'),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        flex: 3,
                        child: TextField(
                          controller: _nameCtrl,
                          decoration: const InputDecoration(
                            labelText: 'Nombre del Estudiante',
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(Icons.person_outline),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        flex: 2,
                        child: TextField(
                          controller: _codeCtrl,
                          decoration: const InputDecoration(
                            labelText: 'Código USTA',
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(Icons.badge_outlined),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _c1Ctrl,
                          keyboardType: const TextInputType.numberWithOptions(decimal: true),
                          decoration: const InputDecoration(
                            labelText: 'Corte 1 (30%)',
                            helperText: 'Rango: 0.0 - 5.0',
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: TextField(
                          controller: _c2Ctrl,
                          keyboardType: const TextInputType.numberWithOptions(decimal: true),
                          decoration: const InputDecoration(
                            labelText: 'Corte 2 (30%)',
                            helperText: 'Rango: 0.0 - 5.0',
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: TextField(
                          controller: _c3Ctrl,
                          keyboardType: const TextInputType.numberWithOptions(decimal: true),
                          decoration: const InputDecoration(
                            labelText: 'Corte 3 (40%)',
                            helperText: 'Rango: 0.0 - 5.0',
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: FilledButton.icon(
                          onPressed: _submit,
                          icon: const Icon(Icons.play_arrow_rounded),
                          label: const Text('Ejecutar Tubería (Pipes & Filters)'),
                          style: FilledButton.styleFrom(
                            backgroundColor: const Color(0xFF1D4ED8),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      OutlinedButton(
                        onPressed: _clearFields,
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
                        ),
                        child: const Text('Limpiar'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            '2. Evidencia en Vivo del Recorrido de los Datos (Pipeline Trace)',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          if (packet == null)
            const Card(
              child: Padding(
                padding: EdgeInsets.all(20),
                child: Text('Aún no se ha ejecutado el pipeline en esta sesión.'),
              ),
            )
          else ...[
            for (int i = 0; i < packet.traceLogs.length; i++) ...[
              _PipeStageCard(log: packet.traceLogs[i]),
              if (i < packet.traceLogs.length - 1)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 4),
                  child: Center(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.south, color: Color(0xFF1D4ED8), size: 20),
                        SizedBox(width: 6),
                        Text(
                          'Tubería (Pipe): Transfiere StudentGradePacket',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF1D4ED8),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ],
        ],
      ),
    );
  }
}

class _PipeStageCard extends StatelessWidget {
  final PipeStageLog log;

  const _PipeStageCard({required this.log});

  @override
  Widget build(BuildContext context) {
    final bgColor = log.success ? const Color(0xFFEFF6FF) : const Color(0xFFFEF2F2);
    final borderColor = log.success ? const Color(0xFF93C5FD) : const Color(0xFFFCA5A5);
    final iconColor = log.success ? const Color(0xFF1D4ED8) : const Color(0xFFDC2626);

    return Container(
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: borderColor, width: 1.4),
      ),
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                log.success ? Icons.check_circle_rounded : Icons.cancel_rounded,
                color: iconColor,
                size: 20,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  log.filterName,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: iconColor,
                    fontSize: 14,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: iconColor.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  'Etapa ${log.stageNumber}',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: iconColor,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'Entrada al filtro: ${log.inputData}',
            style: const TextStyle(fontSize: 12.5, color: Color(0xFF334155)),
          ),
          const SizedBox(height: 4),
          Text(
            'Salida a la tubería: ${log.outputData}',
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: Color(0xFF0F172A),
            ),
          ),
        ],
      ),
    );
  }
}
