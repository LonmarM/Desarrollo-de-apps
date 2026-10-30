import 'package:flutter/material.dart';
import '../models/inventory_models.dart';

class InventoryCatalogScreen extends StatefulWidget {
  final List<ProductItem> products;
  final void Function(String sku, String name, String category, int stock, int minStock, double price) onCreateProduct;
  final void Function(String productId, int delta, String origin) onUpdateStock;

  const InventoryCatalogScreen({
    Key? key,
    required this.products,
    required this.onCreateProduct,
    required this.onUpdateStock,
  }) : super(key: key);

  @override
  State<InventoryCatalogScreen> createState() => _InventoryCatalogScreenState();
}

class _InventoryCatalogScreenState extends State<InventoryCatalogScreen> {
  String _searchQuery = '';
  bool _showCreateForm = false;

  final _skuCtrl = TextEditingController();
  final _nameCtrl = TextEditingController();
  final _catCtrl = TextEditingController();
  final _stockCtrl = TextEditingController(text: '5');
  final _minCtrl = TextEditingController(text: '5');
  final _priceCtrl = TextEditingController(text: '25000');

  @override
  void dispose() {
    _skuCtrl.dispose();
    _nameCtrl.dispose();
    _catCtrl.dispose();
    _stockCtrl.dispose();
    _minCtrl.dispose();
    _priceCtrl.dispose();
    super.dispose();
  }

  void _submitNewProduct() {
    final name = _nameCtrl.text.trim();
    final sku = _skuCtrl.text.trim();
    final cat = _catCtrl.text.trim().isEmpty ? 'General' : _catCtrl.text.trim();
    final stock = int.tryParse(_stockCtrl.text.trim()) ?? 0;
    final minS = int.tryParse(_minCtrl.text.trim()) ?? 5;
    final price = double.tryParse(_priceCtrl.text.trim()) ?? 0;
    if (name.isEmpty || sku.isEmpty) return;

    widget.onCreateProduct(sku, name, cat, stock, minS, price);
    setState(() {
      _nameCtrl.clear();
      _skuCtrl.clear();
      _catCtrl.clear();
      _showCreateForm = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final filtered = widget.products.where((p) {
      final q = _searchQuery.toLowerCase();
      return p.name.toLowerCase().contains(q) ||
          p.sku.toLowerCase().contains(q) ||
          p.category.toLowerCase().contains(q);
    }).toList();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: TextField(
                  onChanged: (v) => setState(() => _searchQuery = v),
                  decoration: const InputDecoration(
                    hintText: 'Buscar por nombre, SKU o categoria...',
                    prefixIcon: Icon(Icons.search),
                    border: OutlineInputBorder(),
                    isDense: true,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              ElevatedButton.icon(
                onPressed: () => setState(() => _showCreateForm = !_showCreateForm),
                icon: Icon(_showCreateForm ? Icons.close : Icons.add, size: 18),
                label: Text(_showCreateForm ? 'Cancelar' : 'Nuevo'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0F172A),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                ),
              ),
            ],
          ),
          if (_showCreateForm) ...[
            const SizedBox(height: 12),
            Card(
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Agregar Producto',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: TextField(
                            controller: _skuCtrl,
                            decoration: const InputDecoration(
                              labelText: 'SKU',
                              border: OutlineInputBorder(),
                              isDense: true,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          flex: 4,
                          child: TextField(
                            controller: _nameCtrl,
                            decoration: const InputDecoration(
                              labelText: 'Nombre',
                              border: OutlineInputBorder(),
                              isDense: true,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: TextField(
                            controller: _catCtrl,
                            decoration: const InputDecoration(
                              labelText: 'Categoria',
                              border: OutlineInputBorder(),
                              isDense: true,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: TextField(
                            controller: _stockCtrl,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                              labelText: 'Stock',
                              border: OutlineInputBorder(),
                              isDense: true,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: TextField(
                            controller: _minCtrl,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                              labelText: 'Minimo',
                              border: OutlineInputBorder(),
                              isDense: true,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _submitNewProduct,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF065F46),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                        child: const Text('Guardar Producto'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
          const SizedBox(height: 14),
          for (final p in filtered)
            Card(
              margin: const EdgeInsets.only(bottom: 10),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
                side: BorderSide(
                  color: p.isBelowOrAtMin ? const Color(0xFFDC2626) : const Color(0xFFE2E8F0),
                  width: p.isBelowOrAtMin ? 1.5 : 1.0,
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                p.name,
                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                'SKU: ${p.sku}  •  ${p.category}  •  Min: ${p.minStock} uds.',
                                style: const TextStyle(fontSize: 12.5, color: Color(0xFF64748B)),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                          decoration: BoxDecoration(
                            color: p.isOutOfStock
                                ? const Color(0xFFFEE2E2)
                                : (p.isBelowOrAtMin
                                    ? const Color(0xFFFEF3C7)
                                    : const Color(0xFFECFDF5)),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            '${p.currentStock} uds.',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                              color: p.isOutOfStock
                                  ? const Color(0xFFB91C1C)
                                  : (p.isBelowOrAtMin
                                      ? const Color(0xFFB45309)
                                      : const Color(0xFF065F46)),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          p.isOutOfStock
                              ? 'Agotado'
                              : (p.isBelowOrAtMin ? 'Stock en nivel minimo' : 'Disponible'),
                          style: TextStyle(
                            fontSize: 12.5,
                            fontWeight: FontWeight.w600,
                            color: p.isOutOfStock
                                ? const Color(0xFFB91C1C)
                                : (p.isBelowOrAtMin
                                    ? const Color(0xFFB45309)
                                    : const Color(0xFF065F46)),
                          ),
                        ),
                        Wrap(
                          spacing: 6,
                          children: [
                            OutlinedButton(
                              onPressed: () => widget.onUpdateStock(p.id, -1, 'Inventario'),
                              child: const Text('-1'),
                            ),
                            OutlinedButton(
                              onPressed: () => widget.onUpdateStock(p.id, -3, 'Inventario'),
                              child: const Text('-3'),
                            ),
                            ElevatedButton(
                              onPressed: () => widget.onUpdateStock(p.id, 5, 'Inventario'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF0F172A),
                                foregroundColor: Colors.white,
                              ),
                              child: const Text('+5'),
                            ),
                          ],
                        ),
                      ],
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

class AlertsRuleCenterScreen extends StatelessWidget {
  final List<StockAlertItem> alerts;
  final void Function(String productId, int delta, String origin) onRestockProduct;

  const AlertsRuleCenterScreen({
    Key? key,
    required this.alerts,
    required this.onRestockProduct,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final criticalCount = alerts.where((a) => a.currentStock <= 0).length;
    final warningCount = alerts.length - criticalCount;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: Card(
                  color: const Color(0xFFFEF2F2),
                  child: Padding(
                    padding: const EdgeInsets.all(14),
                    child: Column(
                      children: [
                        const Text('Agotados', style: TextStyle(fontSize: 12.5, color: Color(0xFF991B1B))),
                        const SizedBox(height: 4),
                        Text(
                          '$criticalCount',
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFFB91C1C),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Card(
                  color: const Color(0xFFFFFBEB),
                  child: Padding(
                    padding: const EdgeInsets.all(14),
                    child: Column(
                      children: [
                        const Text('En Nivel Minimo', style: TextStyle(fontSize: 12.5, color: Color(0xFF92400E))),
                        const SizedBox(height: 4),
                        Text(
                          '$warningCount',
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFFB45309),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          if (alerts.isEmpty)
            const Card(
              child: Padding(
                padding: EdgeInsets.all(24),
                child: Center(
                  child: Text('No hay alertas de stock activas.'),
                ),
              ),
            )
          else
            for (final a in alerts)
              Card(
                margin: const EdgeInsets.only(bottom: 10),
                child: Padding(
                  padding: const EdgeInsets.all(14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            a.currentStock <= 0 ? Icons.error : Icons.warning_amber_rounded,
                            color: a.currentStock <= 0
                                ? const Color(0xFFDC2626)
                                : const Color(0xFFD97706),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              '${a.productName} (${a.productSku})',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                              ),
                            ),
                          ),
                          Text(
                            a.timestamp,
                            style: const TextStyle(fontSize: 12, color: Color(0xFF64748B)),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(
                        '${a.severity}  •  Actual: ${a.currentStock} uds. (Minimo: ${a.minStock} uds.)',
                        style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        a.ruleTriggered,
                        style: const TextStyle(fontSize: 12.5, color: Color(0xFF475569)),
                      ),
                      const SizedBox(height: 10),
                      Align(
                        alignment: Alignment.centerRight,
                        child: ElevatedButton.icon(
                          onPressed: () => onRestockProduct(
                            a.productId,
                            10,
                            'Alertas',
                          ),
                          icon: const Icon(Icons.add_shopping_cart, size: 16),
                          label: const Text('Reabastecer (+10 uds.)'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF065F46),
                            foregroundColor: Colors.white,
                          ),
                        ),
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

class EventBusMonitorScreen extends StatelessWidget {
  final List<InventoryDomainEvent> events;
  final List<ProductItem> products;
  final List<StockAlertItem> alerts;

  const EventBusMonitorScreen({
    Key? key,
    required this.events,
    required this.products,
    required this.alerts,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final totalUnits = products.isEmpty
        ? 0
        : products.map((p) => p.currentStock).reduce((a, b) => a + b);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      children: [
                        const Text('Productos', style: TextStyle(fontSize: 12, color: Color(0xFF64748B))),
                        const SizedBox(height: 4),
                        Text(
                          '${products.length}',
                          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      children: [
                        const Text('Existencias', style: TextStyle(fontSize: 12, color: Color(0xFF64748B))),
                        const SizedBox(height: 4),
                        Text(
                          '$totalUnits',
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF065F46),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      children: [
                        const Text('Eventos', style: TextStyle(fontSize: 12, color: Color(0xFF64748B))),
                        const SizedBox(height: 4),
                        Text(
                          '${events.length}',
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFFB45309),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          const Text(
            'Registro de Eventos',
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          for (final ev in events)
            Card(
              margin: const EdgeInsets.only(bottom: 8),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: ev.eventType.contains('ALERTA') || ev.eventType.contains('BAJO')
                                ? const Color(0xFFFEF2F2)
                                : const Color(0xFFF1F5F9),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            ev.eventType,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 11,
                              color: ev.eventType.contains('ALERTA') || ev.eventType.contains('BAJO')
                                  ? const Color(0xFFDC2626)
                                  : const Color(0xFF0F172A),
                            ),
                          ),
                        ),
                        Text(
                          ev.timestamp,
                          style: const TextStyle(fontSize: 12, color: Color(0xFF64748B)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(ev.payloadSummary, style: const TextStyle(fontSize: 13)),
                    const SizedBox(height: 4),
                    Text(
                      'Origen: ${ev.publisherModule}  •  Notificados: ${ev.implicitSubscribersNotified.join(", ")}',
                      style: const TextStyle(
                        fontSize: 11.5,
                        color: Color(0xFF64748B),
                      ),
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
