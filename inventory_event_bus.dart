import '../models/inventory_models.dart';

typedef EventSubscriberCallback = void Function(InventoryDomainEvent event);

class SubscriberRegistration {
  final String subscriberName;
  final EventSubscriberCallback callback;

  const SubscriberRegistration({
    required this.subscriberName,
    required this.callback,
  });
}

class InventoryEventBus {
  final List<SubscriberRegistration> _subscribers = [];
  final List<InventoryDomainEvent> _eventHistory = [];

  List<InventoryDomainEvent> get eventHistory => List.unmodifiable(_eventHistory);

  void subscribe(String subscriberName, EventSubscriberCallback callback) {
    _subscribers.add(
      SubscriberRegistration(
        subscriberName: subscriberName,
        callback: callback,
      ),
    );
  }

  InventoryDomainEvent publish({
    required String eventType,
    required String publisherModule,
    required String payloadSummary,
    required ProductItem productSnapshot,
  }) {
    final now = DateTime.now();
    final timeStr =
        '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}:${now.second.toString().padLeft(2, '0')}';

    final notifiedNames = _subscribers.map((s) => s.subscriberName).toList();

    final event = InventoryDomainEvent(
      eventType: eventType,
      publisherModule: publisherModule,
      payloadSummary: payloadSummary,
      implicitSubscribersNotified: notifiedNames,
      productSnapshot: productSnapshot,
      timestamp: timeStr,
    );

    _eventHistory.insert(0, event);

    for (final sub in _subscribers) {
      sub.callback(event);
    }

    return event;
  }
}
