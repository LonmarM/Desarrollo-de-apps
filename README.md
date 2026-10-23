# Procesador de Calificaciones USTA — Arquitectura Tubos y Filtros + Llamado y Retorno

**Universidad Santo Tomás — Seccional Bucaramanga**  
**Facultad de Ingeniería Mecatrónica**  
**Cátedra Opcional Complementaria: Desarrollo de Aplicaciones**  
- **Docente:** Ing. M.Sc. Carlos Daniel Pimentel Díaz  
- **Expositor:** Lonmar Eduardo Martínez Palacio  
- **Tema de Exposición 1:** Llamado y retorno y flujo de datos  
- **Fecha:** 23 de octubre de 2026  

## 1. Descripción General y Propósito Arquitectónico

Esta aplicación en **Flutter** implementa un **Procesador de Calificaciones** diseñado para demostrar de forma práctica e interactiva los conceptos del **Tema 1: Llamado y retorno y flujo de datos**:

1. **Estilo de Flujo de Datos — Tubos y Filtros (*Pipes and Filters*)**:  
   Cada registro estudiantil ingresa como un paquete inmutable (`StudentGradePacket`) a una tubería principal (`GradeProcessingPipeline`) compuesta por **tres etapas independientes (filtros)**:
   - **Etapa 1 (`ValidationFilter`)**: Verifica que el nombre y código estudiantil no estén vacíos y que las notas de los tres cortes sean valores numéricos dentro de la escala institucional de la USTA (**0.0 a 5.0**). Si detecta un error, rechaza el paquete y registra el motivo en la bitácora del tubo.
   - **Etapa 2 (`AverageCalculationFilter`)**: Toma las notas validadas desde la tubería y calcula el promedio ponderado (**Corte 1: 30%**, **Corte 2: 30%**, **Corte 3: 40%**).
   - **Etapa 3 (`ClassificationFilter`)**: Recibe el promedio calculado y clasifica el rendimiento en cuatro categorías (**Superior: 4.50–5.00**, **Alto: 4.00–4.49**, **Básico: 3.00–3.99**, **Bajo/Reprobado: < 3.00**), determinando el estado final de aprobación (`>= 3.0`).
2. **Estilo de Llamado y Retorno — Orientación a Objetos y Subrutinas**:  
   - **Orientación a Objetos**: Uso del contrato polimórfico `GradeFilter`, encapsulamiento del estado en `StudentGradePacket` y separación de responsabilidades entre modelos, pipeline y vistas.
   - **Subrutinas**: Métodos auxiliares especializados dentro de cada filtro (`_isGradeInRange`, `_computeWeightedAverage`, `_determineCategory`) invocados de manera jerárquica con control de retorno inmediato.

## 2. Funcionalidades Principales (Tres Pantallas con Navegación)

La aplicación cuenta con una barra de navegación inferior (`NavigationBar`) que conecta tres pantallas:

| Pantalla | Archivo | Funcionalidad Principal |
| :--- | :--- | :--- |
| **1. Registro y Tubería** | `lib/screens/register_pipeline_screen.dart` | Formulario de registro de estudiantes y notas (con botones rápidos de *Ejemplo Válido* y *Probar Nota > 5.0* para demostración en vivo) y visualización gráfica paso a paso de la entrada y salida de cada Filtro. |
| **2. Resultados Individuales** | `lib/screens/individual_results_screen.dart` | Consulta y búsqueda de estudiantes por nombre, código USTA o nivel de desempeño. Al expandir un estudiante se muestra el detalle de sus 3 cortes y la **bitácora completa del recorrido de los datos** a través de las tres etapas. |
| **3. Estadísticas del Curso** | `lib/screens/general_stats_screen.dart` | Cálculo de indicadores globales del grupo (promedio general, tasa de aprobación, nota máxima/mínima, paquetes rechazados en el Filtro 1) y barras de distribución por nivel de clasificación. |

## 3. Estructura del Proyecto

```text
procesador_calificaciones_ustabuca/
├── pubspec.yaml
├── README.md
└── lib/
    ├── main.dart                                # Punto de entrada y navegación entre las 3 pantallas
    ├── models/
    │   └── student_grade_packet.dart            # Paquete de datos (Data Packet) y registro PipeStageLog
    ├── pipeline/
    │   └── grade_pipeline.dart                  # Implementación de Tubos y Filtros (3 filtros + Pipeline)
    └── screens/
        ├── register_pipeline_screen.dart        # Pantalla 1: Registro y ejecución visual del Pipeline
        ├── individual_results_screen.dart       # Pantalla 2: Consulta individual y trazabilidad del dato
        └── general_stats_screen.dart            # Pantalla 3: Resultados generales y estadísticas del curso
```

## 4. Instrucciones para Ejecutar en FlutLab.io y Localmente

### Ejecución en FlutLab.io (Recomendado para la exposición)
1. Ingresa a [https://flutlab.io](https://flutlab.io) e inicia sesión en tu cuenta.
2. Haz clic en **Upload Project (ZIP)** y selecciona el archivo `procesador_calificaciones_flutlab.zip` (o crea un proyecto en blanco y sube las carpetas `models/`, `pipeline/`, `screens/` y `main.dart` dentro de `lib/`).
3. Presiona el botón verde **Build / Run (Web Emulator)** en la esquina superior izquierda.
4. Una vez compilado el emulador web, utiliza los botones **"Ejemplo Válido"** y **"Probar Nota > 5.0"** en la Pantalla 1 para evidenciar en vivo el recorrido de los datos por las tres etapas y navega por las Pantallas 2 y 3.

### Ejecución Local con Flutter CLI
1. Clona este repositorio:
   ```bash
   git clone https://github.com/lonmar4212/procesador-calificaciones-usta.git
   cd procesador-calificaciones-usta
   ```
2. Descarga las dependencias e inicia la aplicación en Chrome o dispositivo:
   ```bash
   flutter pub get
   flutter run -d chrome
   ```
