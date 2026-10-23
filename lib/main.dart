// ============================================================================
// UNIVERSIDAD SANTO TOMÁS - SECCIONAL BUCARAMANGA
// FACULTAD DE INGENIERÍA MECATRÓNICA - DESARROLLO DE APLICACIONES
// Docente: Ing. M.Sc. Carlos Daniel Pimentel Díaz
// Expositor: Lonmar Eduardo Martínez Palacio
// Tema 1: Llamado y retorno y flujo de datos (23 de octubre de 2026)
// Mini-proyecto: Procesador de Calificaciones (Tubos y Filtros + OO)
// ============================================================================

import 'package:flutter/material.dart';
import 'models/student_grade_packet.dart';
import 'pipeline/grade_pipeline.dart';
import 'screens/register_pipeline_screen.dart';
import 'screens/individual_results_screen.dart';
import 'screens/general_stats_screen.dart';

void main() {
  runApp(const GradeProcessorApp());
}

class GradeProcessorApp extends StatelessWidget {
  const GradeProcessorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Procesador de Calificaciones USTA',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF1D4ED8),
          brightness: Brightness.light,
        ),
        useMaterial3: true,
      ),
      home: const MainNavigationShell(),
    );
  }
}

class MainNavigationShell extends StatefulWidget {
  const MainNavigationShell({super.key});

  @override
  State<MainNavigationShell> createState() => _MainNavigationShellState();
}

class _MainNavigationShellState extends State<MainNavigationShell> {
  final GradeProcessingPipeline _pipeline = GradeProcessingPipeline();
  final List<StudentGradePacket> _processedStudents = [];
  StudentGradePacket? _lastProcessedPacket;
  int _rejectedCount = 0;
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _loadInitialSampleStudents();
  }

  /// Subrutina de carga inicial que pasa 5 registros por la tubería (Pipes & Filters)
  void _loadInitialSampleStudents() {
    final samples = [
      const StudentGradePacket(
        studentName: 'Lonmar Eduardo Martínez Palacio',
        studentCode: '2230415',
        rawCorte1: '4.7',
        rawCorte2: '4.6',
        rawCorte3: '4.9',
      ),
      const StudentGradePacket(
        studentName: 'Camila Andrea Serrano Rojas',
        studentCode: '2230812',
        rawCorte1: '4.1',
        rawCorte2: '4.3',
        rawCorte3: '4.2',
      ),
      const StudentGradePacket(
        studentName: 'Juan Sebastián Mantilla',
        studentCode: '2231104',
        rawCorte1: '3.2',
        rawCorte2: '3.5',
        rawCorte3: '3.4',
      ),
      const StudentGradePacket(
        studentName: 'Andrés Felipe Castellanos',
        studentCode: '2231509',
        rawCorte1: '2.5',
        rawCorte2: '2.8',
        rawCorte3: '2.4',
      ),
      const StudentGradePacket(
        studentName: 'Laura Sofía Pinzón Duarte',
        studentCode: '2231920',
        rawCorte1: '4.5',
        rawCorte2: '4.4',
        rawCorte3: '4.7',
      ),
    ];

    for (final rawPacket in samples) {
      final result = _pipeline.runPipeline(rawPacket);
      if (result.isValid) {
        _processedStudents.add(result);
      }
      _lastProcessedPacket = result;
    }
  }

  /// Ejecuta el pipeline cuando el usuario registra un estudiante en la Pantalla 1
  void _handleProcessStudent(
    String name,
    String code,
    String c1,
    String c2,
    String c3,
  ) {
    final initialPacket = StudentGradePacket(
      studentName: name,
      studentCode: code,
      rawCorte1: c1,
      rawCorte2: c2,
      rawCorte3: c3,
    );

    final processedPacket = _pipeline.runPipeline(initialPacket);

    setState(() {
      _lastProcessedPacket = processedPacket;
      if (processedPacket.isValid) {
        _processedStudents.insert(0, processedPacket);
      } else {
        _rejectedCount++;
      }
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: processedPacket.isValid
            ? const Color(0xFF15803D)
            : const Color(0xFFDC2626),
        content: Text(
          processedPacket.isValid
              ? 'Pipeline completado: Promedio ${processedPacket.weightedAverage.toStringAsFixed(2)} (${processedPacket.classification})'
              : processedPacket.validationMessage,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screens = [
      RegisterPipelineScreen(
        lastProcessedPacket: _lastProcessedPacket,
        onProcessStudent: _handleProcessStudent,
      ),
      IndividualResultsScreen(students: _processedStudents),
      GeneralStatsScreen(
        students: _processedStudents,
        rejectedCount: _rejectedCount,
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF0F172A),
        foregroundColor: Colors.white,
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Procesador de Calificaciones — USTA',
              style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
            ),
            Text(
              'Tema 1: Tubos y Filtros (Pipes & Filters) + Llamado y Retorno',
              style: TextStyle(fontSize: 11.5, color: Color(0xFF93C5FD)),
            ),
          ],
        ),
      ),
      body: screens[_selectedIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (idx) => setState(() => _selectedIndex = idx),
        destinations: [
          const NavigationDestination(
            icon: Icon(Icons.account_tree_outlined),
            selectedIcon: Icon(Icons.account_tree),
            label: '1. Registro y Tubería',
          ),
          NavigationDestination(
            icon: Badge(
              label: Text('${_processedStudents.length}'),
              child: const Icon(Icons.person_search_outlined),
            ),
            selectedIcon: Badge(
              label: Text('${_processedStudents.length}'),
              child: const Icon(Icons.person_search),
            ),
            label: '2. Resultados Indiv.',
          ),
          const NavigationDestination(
            icon: Icon(Icons.bar_chart_outlined),
            selectedIcon: Icon(Icons.bar_chart),
            label: '3. Estadísticas Curso',
          ),
        ],
      ),
    );
  }
}
