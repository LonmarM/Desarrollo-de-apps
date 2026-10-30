# Inventario con Alertas USTA — Arquitectura Centrada en Datos y Componentes Independientes

**Universidad Santo Tomás — Seccional Bucaramanga**  
**Facultad de Ingeniería Mecatrónica**  
**Cátedra Opcional Complementaria: Desarrollo de Aplicaciones**  
- **Docente:** Ing. M.Sc. Carlos Daniel Pimentel Díaz  
- **Expositor:** Lonmar Eduardo Martínez Palacio  
- **Tema de Exposición 2:** Centrado en datos y componentes independientes  
- **Fecha:** 30 de octubre de 2026  

## 1. Descripción General y Propósito Arquitectónico

Esta aplicación en **Flutter** implementa un sistema de **Inventario con Alertas** diseñado para demostrar de forma práctica e interactiva los estilos arquitectónicos del **Tema 2: Centrado en datos y componentes independientes**:

1. **Estilos Centrados en Datos (`lib/data/shared_inventory_store.dart`)**:
   - **Base de Datos Local Compartida (`SharedInventoryRepository`)**: Actúa como la fuente única de verdad (*Single Source of Truth*) donde se almacenan, crean, actualizan y consultan los productos localmente.
   - **Pizarrón (*Blackboard*) y Sistema Experto Basado en Reglas (`InventoryRuleEngine`)**: Evalúa automáticamente la base de conocimiento sobre el estado compartido del inventario mediante dos reglas de producción:
     - **Regla R1 (Crítica):** `SI stockActual == 0 ENTONCES Activar Alerta Crítica de Desabastecimiento`.
     - **Regla R2 (Preventiva):** `SI 0 < stockActual <= stockMinimo ENTONCES Activar Alerta de Reposición por Mínimo Alcanzado`.
2. **Estilos de Componentes Independientes (`lib/events/inventory_event_bus.dart`)**:
   - **Publicar-Suscribir (*Publish-Subscribe*) y Bus de Eventos (`InventoryEventBus`)**: El módulo de inventario publica eventos (`STOCK_UPDATED_EVENT`, `STOCK_MIN_ALERT_EVENT`, `PRODUCT_CREATED`) en el bus sin conocer ni acoplarse a los módulos receptores.
   - **Invocación Implícita vs. Explícita**: Mientras las operaciones CRUD del usuario sobre el repositorio usan *invocación explícita*, la activación de alertas en el `ModuloAlertas` y el registro en `ModuloAuditoria` ocurren por **invocación implícita** cuando el Bus de Eventos notifica a sus suscriptores.

## 2. Funcionalidades Principales (Tres Pantallas con Navegación)

| Pantalla | Archivo | Funcionalidad Principal |
| :--- | :--- | :--- |
| **1. Inventario Local (CRUD)** | `lib/ui/inventory_screens.dart` (`InventoryCatalogScreen`) | Crear nuevos productos, consultar/filtrar por nombre, SKU o categoría, actualizar existencias (`-1`, `-3`, `+5`) y botón rápido de demostración para reducir el stock al mínimo y disparar la alerta. |
| **2. Centro de Alertas y Reglas** | `lib/ui/inventory_screens.dart` (`AlertsRuleCenterScreen`) | Visualización de alertas activadas implícitamente cuando `stockActual <= stockMinimo`, detalle de la regla disparada (`R1` o `R2`) y botón de reposición rápida (`+10 uds.`) por evento. |
| **3. Monitor del Bus de Eventos** | `lib/ui/inventory_screens.dart` (`EventBusMonitorScreen`) | Evidencia en tiempo real de la comunicación por eventos entre módulos: muestra el publicador, el tipo de evento, el payload y la lista de suscriptores notificados implícitamente. |

## 3. Estructura del Proyecto

```text
inventario_alertas_ustabuca/
├── android/                                     # Configuración completa Android (Gradle + Manifest)
├── ios/                                         # Configuración completa iOS (Runner + Xcodeproj)
├── web/                                         # Soporte para Emulador Web en FlutLab.io
├── pubspec.yaml
├── README.md
└── lib/
    ├── main.dart                                # Punto de entrada (MyApp) y barra de navegación
    ├── models/
    │   └── inventory_models.dart                # ProductItem, StockAlertItem e InventoryDomainEvent
    ├── data/
    │   └── shared_inventory_store.dart          # Repositorio Local Compartido + Motor de Reglas (R1/R2)
    ├── events/
    │   └── inventory_event_bus.dart             # Bus de Eventos Publicar-Suscribir (Invocación Implícita)
    └── ui/
        └── inventory_screens.dart               # Las 3 pantallas (Inventario, Alertas y Bus de Eventos)
```

## 4. Instrucciones para Ejecutar en FlutLab.io y Localmente

1. **En FlutLab.io:** Sube el archivo `inventario_alertas_flutlab_tema2.zip` mediante el botón **Upload Project (ZIP)** (ya incluye `android/`, `ios/`, `web/`, `test/` y `lib/`) o clona directamente desde GitHub con **Clone from VCS**.
2. **Localmente con Flutter CLI:**
   ```bash
   git clone https://github.com/lonmar4212/inventario-alertas-usta.git
   cd inventario-alertas-usta
   flutter pub get
   flutter run -d chrome
   ```
