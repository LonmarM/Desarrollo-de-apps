import 'package:flutter/material.dart';
import 'models/inventory_models.dart';
import 'events/inventory_event_bus.dart';
import 'data/shared_inventory_store.dart';
import 'ui/inventory_screens.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Inventario USTA',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.teal,
        scaffoldBackgroundColor: const Color(0xFFF8FAFC),
      ),
      home: const MainInventoryNavigationShell(),
    );
  }
}

class MainInventoryNavigationShell extends StatefulWidget {
  const MainInventoryNavigationShell({Key? key}) : super(key: key);

  @override
  State<MainInventoryNavigationShell> createState() =>
      _MainInventoryNavigationShellState();
}

class _MainInventoryNavigationShellState
    extends State<MainInventoryNavigationShell> {
  late final InventoryEventBus _eventBus;
  late final SharedInventoryRepository _repository;
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _eventBus = InventoryEventBus();
    _repository = SharedInventoryRepository(eventBus: _eventBus);
    _seedInitialInventory();
  }

  void _seedInitialInventory() {
    _repository.createProduct(
      sku: 'ARD-R4',
      name: 'Placa Arduino UNO R4 WiFi',
      category: 'Microcontroladores',
      initialStock: 8,
      minStock: 5,
      unitPrice: 95000,
    );
    _repository.createProduct(
      sku: 'ESP-32',
      name: 'Modulo ESP32-WROOM Dual Core',
      category: 'IoT',
      initialStock: 6,
      minStock: 5,
      unitPrice: 28000,
    );
    _repository.createProduct(
      sku: 'SRV-MG996',
      name: 'Servomotor Metalico MG996R',
      category: 'Actuadores',
      initialStock: 4,
      minStock: 5,
      unitPrice: 32000,
    );
    _repository.createProduct(
      sku: 'FUE-24V',
      name: 'Fuente Industrial 24V 5A',
      category: 'Potencia',
      initialStock: 10,
      minStock: 4,
      unitPrice: 64000,
    );
  }

  void _handleCreateProduct(
    String sku,
    String name,
    String category,
    int stock,
    int minStock,
    double price,
  ) {
    setState(() {
      _repository.createProduct(
        sku: sku,
        name: name,
        category: category,
        initialStock: stock,
        minStock: minStock,
        unitPrice: price,
      );
    });
  }

  void _handleUpdateStock(String productId, int delta, String origin) {
    setState(() {
      _repository.updateProductStock(productId, delta, origin: origin);
    });
    final updated = _repository.products.firstWhere((p) => p.id == productId);
    if (updated.isBelowOrAtMin && delta < 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: const Color(0xFFDC2626),
          content: Text(
            'Alerta de stock minimo: ${updated.name} (${updated.currentStock} uds.)',
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final alertsCount = _repository.activeAlerts.length;
    final eventsCount = _eventBus.eventHistory.length;

    final screens = [
      InventoryCatalogScreen(
        products: _repository.products,
        onCreateProduct: _handleCreateProduct,
        onUpdateStock: _handleUpdateStock,
      ),
      AlertsRuleCenterScreen(
        alerts: _repository.activeAlerts,
        onRestockProduct: _handleUpdateStock,
      ),
      EventBusMonitorScreen(
        events: _eventBus.eventHistory,
        products: _repository.products,
        alerts: _repository.activeAlerts,
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF0F172A),
        foregroundColor: Colors.white,
        title: const Text(
          'Control de Inventario',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
      body: screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        selectedItemColor: const Color(0xFF0F172A),
        onTap: (idx) => setState(() => _selectedIndex = idx),
        items: [
          const BottomNavigationBarItem(
            icon: Icon(Icons.inventory_2_outlined),
            label: 'Inventario',
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.notifications_none),
            label: 'Alertas ($alertsCount)',
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.history),
            label: 'Eventos ($eventsCount)',
          ),
        ],
      ),
    );
  }
}
