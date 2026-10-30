class ProductItem {
  final String id;
  final String sku;
  final String name;
  final String category;
  final int currentStock;
  final int minStock;
  final double unitPrice;

  const ProductItem({
    required this.id,
    required this.sku,
    required this.name,
    required this.category,
    required this.currentStock,
    required this.minStock,
    required this.unitPrice,
  });

  bool get isBelowOrAtMin => currentStock <= minStock;
  bool get isOutOfStock => currentStock <= 0;

  ProductItem copyWith({
    String? name,
    String? category,
    int? currentStock,
    int? minStock,
    double? unitPrice,
  }) {
    return ProductItem(
      id: id,
      sku: sku,
      name: name ?? this.name,
      category: category ?? this.category,
      currentStock: currentStock ?? this.currentStock,
      minStock: minStock ?? this.minStock,
      unitPrice: unitPrice ?? this.unitPrice,
    );
  }
}

class StockAlertItem {
  final String productId;
  final String productSku;
  final String productName;
  final int currentStock;
  final int minStock;
  final String severity;
  final String ruleTriggered;
  final String timestamp;

  const StockAlertItem({
    required this.productId,
    required this.productSku,
    required this.productName,
    required this.currentStock,
    required this.minStock,
    required this.severity,
    required this.ruleTriggered,
    required this.timestamp,
  });
}

class InventoryDomainEvent {
  final String eventType;
  final String publisherModule;
  final String payloadSummary;
  final List<String> implicitSubscribersNotified;
  final ProductItem productSnapshot;
  final String timestamp;

  const InventoryDomainEvent({
    required this.eventType,
    required this.publisherModule,
    required this.payloadSummary,
    required this.implicitSubscribersNotified,
    required this.productSnapshot,
    required this.timestamp,
  });
}
