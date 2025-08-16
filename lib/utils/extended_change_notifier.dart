import "package:flutter/material.dart";

class ExtendedChangeNotifier extends ChangeNotifier {
  final List<ChangeNotifier> _attachedNotifiers = <ChangeNotifier>[];

  @override
  void notifyListeners() {
    super.notifyListeners();
  }

  /// Attaches this change notifier to another.
  /// If the attaché notifies its listeners then this change notifiers also notifies its listeners.
  /// This change notifier removes itself from the attaché when being disposed of.
  void attach(final ChangeNotifier changeNotifier) {
    changeNotifier.addListener(notifyListeners);
    _attachedNotifiers.add(changeNotifier);
  }

  @override
  void dispose() {
    for (final ChangeNotifier notifier in _attachedNotifiers) {
      notifier.removeListener(notifyListeners);
    }
    super.dispose();
  }
}
