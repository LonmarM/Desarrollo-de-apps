import '../models/inventory_models.dart';
import '../events/inventory_event_bus.dart';

class InventoryRuleEngine {
  static StockAlertItem? evaluateRules(ProductItem product, String timestamp) {
    if (product.currentStock <= 0) {
      return StockAlertItem(
        productId: product.id,
        productSku: product.sku,
        productName: product.name,
        currentStock: product.currentStock,
        minStock: product.minStock,
        severity: 'Critica (Agotado)',
        ruleTriggered: 'Producto sin existencias disponibles (0 uds.)',
        timestamp: timestamp,
      );
    }

    if (product.currentStock <= product.minStock) {
      return StockAlertItem(
        productId: product.id,
        productSku: product.sku,
        productName: product.name,
        currentStock: product.currentStock,
        minStock: product.minStock,
        severity: 'Preventiva (Stock Minimo)',
        ruleTriggered: 'Existencias (${product.currentStock} uds.) en o por debajo del minimo (${product.minStock} uds.)',
        timestamp: timestamp,
      );
    }

    return null;
  }
}

class SharedInventoryRepository {
  final InventoryEventBus eventBus;
  final List<ProductItem> _products = [];
  final List<StockAlertItem> _activeAlerts = [];

  SharedInventoryRepository({required this.eventBus}) {
    eventBus.subscribe('Alertas', _onInventoryEventReceived);
    eventBus.subscribe('Auditoria', (_) {});
    eventBus.subscribe('Estadisticas', (_) {});
  }

  List<ProductItem> get products => List.unmodifiable(_products);
  List<StockAlertItem> get activeAlerts => List.unmodifiable(_activeAlerts);

  void _onInventoryEventReceived(InventoryDomainEvent event) {
    final p = event.productSnapshot;
    _activeAlerts.removeWhere((a) => a.productId == p.id);

    final alert = InventoryRuleEngine.evaluateRules(p, event.timestamp);
    if (alert != null) {
      _activeAlerts.insert(0, alert);
    }
  }

  void createProduct({
    required String sku,
    required String name,
    required String category,
    required int initialStock,
    required int minStock,
    required double unitPrice,
  }) {
    final newProduct = ProductItem(
      id: 'P${DateTime.now().millisecondsSinceEpoch}_${_products.length}',
      sku: sku.trim().toUpperCase(),
      name: name.trim(),
      category: category.trim(),
      currentStock: initialStock,
      minStock: minStock,
      unitPrice: unitPrice,
    );
    _products.insert(0, newProduct);

    eventBus.publish(
      eventType: newProduct.isBelowOrAtMin ? 'STOCK_BAJO' : 'NUEVO_PRODUCTO',
      publisherModule: 'Inventario',
      payloadSummary:
          'Registro de "${newProduct.name}" (${newProduct.sku}) con ${newProduct.currentStock} uds.',
      productSnapshot: newProduct,
    );
  }

  void updateProductStock(String productId, int delta, {String origin = 'Inventario'}) {
    final idx = _products.indexWhere((p) => p.id == productId);
    if (idx == -1) return;

    final current = _products[idx];
    final updatedStock = (current.currentStock + delta) < 0 ? 0 : (current.currentStock + delta);
    final updatedProduct = current.copyWith(currentStock: updatedStock);
    _products[idx] = updatedProduct;

    final actionLabel = delta < 0 ? 'Salida ($delta uds.)' : 'Entrada (+$delta uds.)';
    final eventType = updatedProduct.isBelowOrAtMin
        ? 'ALERTA_STOCK_MINIMO'
        : (delta > 0 ? 'REABASTECIMIENTO' : 'MOVIMIENTO_STOCK');

    eventBus.publish(
      eventType: eventType,
      publisherModule: origin,
      payloadSummary:
          '$actionLabel en "${updatedProduct.name}": ${current.currentStock} -> ${updatedProduct.currentStock} uds.',
      productSnapshot: updatedProduct,
    );
  }
}
