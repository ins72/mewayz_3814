import 'package:flutter/foundation.dart';
import 'dart:async';
import 'dart:collection';

/// State change record
class StateChange<T> {
  final T previousState;
  final T newState;
  final DateTime timestamp;
  final String? source;
  final Map<String, dynamic>? metadata;

  StateChange({
    required this.previousState,
    required this.newState,
    required this.timestamp,
    this.source,
    this.metadata,
  });
}

/// State listener function type
typedef StateListener<T> = void Function(T newState, T previousState);

/// Optimized state manager for improved performance and stability
class OptimizedStateManager<T> extends ChangeNotifier {
  T _state;
  final Map<String, StreamSubscription> _subscriptions = {};
  final Map<String, Timer> _debounceTimers = {};
  final Queue<StateChange<T>> _stateHistory = Queue<StateChange<T>>();
  final Map<String, List<StateListener<T>>> _listeners = {};
  
  static const int _maxHistorySize = 50;
  static const Duration _defaultDebounceDelay = Duration(milliseconds: 300);

  /// Constructor
  OptimizedStateManager(this._state) {
    _recordStateChange(_state, _state, 'initial');
  }

  /// Get current state
  T get state => _state;

  /// Get state history
  List<StateChange<T>> get history => _stateHistory.toList();

  /// Update state with optimization
  void setState(T newState, {
    String? source,
    Map<String, dynamic>? metadata,
    bool debounce = false,
    Duration debounceDelay = _defaultDebounceDelay,
  }) {
    if (_state == newState) return; // Avoid unnecessary updates

    if (debounce) {
      _debounceStateUpdate(newState, source, metadata, debounceDelay);
    } else {
      _updateState(newState, source, metadata);
    }
  }

  /// Update state conditionally
  void setStateIf(
    bool Function(T currentState) condition,
    T newState, {
    String? source,
    Map<String, dynamic>? metadata,
  }) {
    if (condition(_state)) {
      setState(newState, source: source, metadata: metadata);
    }
  }

  /// Transform state
  void transformState(
    T Function(T currentState) transformer, {
    String? source,
    Map<String, dynamic>? metadata,
  }) {
    final newState = transformer(_state);
    setState(newState, source: source, metadata: metadata);
  }

  /// Update state with debouncing
  void _debounceStateUpdate(
    T newState,
    String? source,
    Map<String, dynamic>? metadata,
    Duration delay) {
    final debounceKey = source ?? 'default';
    
    _debounceTimers[debounceKey]?.cancel();
    _debounceTimers[debounceKey] = Timer(delay, () {
      _updateState(newState, source, metadata);
      _debounceTimers.remove(debounceKey);
    });
  }

  /// Internal state update
  void _updateState(T newState, String? source, Map<String, dynamic>? metadata) {
    final previousState = _state;
    _state = newState;
    
    _recordStateChange(previousState, newState, source, metadata);
    _notifySpecificListeners(newState, previousState);
    
    // Notify all listeners
    notifyListeners();
  }

  /// Record state change in history
  void _recordStateChange(
    T previousState,
    T newState,
    String? source, [
    Map<String, dynamic>? metadata,
  ]) {
    _stateHistory.add(StateChange<T>(
      previousState: previousState,
      newState: newState,
      timestamp: DateTime.now(),
      source: source,
      metadata: metadata));

    // Maintain history size
    if (_stateHistory.length > _maxHistorySize) {
      _stateHistory.removeFirst();
    }
  }

  /// Add specific listener for state changes
  void addStateListener(String key, StateListener<T> listener) {
    if (!_listeners.containsKey(key)) {
      _listeners[key] = [];
    }
    _listeners[key]!.add(listener);
  }

  /// Remove specific listener
  void removeStateListener(String key, StateListener<T> listener) {
    _listeners[key]?.remove(listener);
    if (_listeners[key]?.isEmpty == true) {
      _listeners.remove(key);
    }
  }

  /// Remove all listeners for a key
  void removeAllStateListeners(String key) {
    _listeners.remove(key);
  }

  /// Notify specific listeners
  void _notifySpecificListeners(T newState, T previousState) {
    for (final listeners in _listeners.values) {
      for (final listener in listeners) {
        try {
          listener(newState, previousState);
        } catch (e) {
          debugPrint('Error in state listener: $e');
        }
      }
    }
  }

  /// Subscribe to stream with automatic cleanup
  void subscribeToStream<S>(
    String key,
    Stream<S> stream,
    void Function(S data) onData, {
    void Function(Object error)? onError,
    void Function()? onDone,
  }) {
    _subscriptions[key]?.cancel();
    
    _subscriptions[key] = stream.listen(
      onData,
      onError: onError ?? (error) {
        debugPrint('Stream error in $key: $error');
      },
      onDone: onDone);
  }

  /// Unsubscribe from stream
  void unsubscribeFromStream(String key) {
    _subscriptions[key]?.cancel();
    _subscriptions.remove(key);
  }

  /// Get last state change
  StateChange<T>? getLastStateChange() {
    return _stateHistory.isEmpty ? null : _stateHistory.last;
  }

  /// Get state changes since timestamp
  List<StateChange<T>> getStateChangesSince(DateTime timestamp) {
    return _stateHistory
        .where((change) => change.timestamp.isAfter(timestamp))
        .toList();
  }

  /// Check if state has changed recently
  bool hasChangedRecently(Duration duration) {
    final cutoff = DateTime.now().subtract(duration);
    return _stateHistory.any((change) => change.timestamp.isAfter(cutoff));
  }

  /// Reset state to initial value
  void reset(T initialState, {String? source}) {
    setState(initialState, source: source ?? 'reset');
  }

  /// Undo last state change
  void undo() {
    if (_stateHistory.length > 1) {
      final previousChange = _stateHistory.elementAt(_stateHistory.length - 2);
      setState(previousChange.newState, source: 'undo');
    }
  }

  /// Clear state history
  void clearHistory() {
    _stateHistory.clear();
    _recordStateChange(_state, _state, 'history_cleared');
  }

  /// Get state statistics
  Map<String, dynamic> getStatistics() {
    final now = DateTime.now();
    final last24Hours = now.subtract(const Duration(hours: 24));
    
    final recentChanges = _stateHistory
        .where((change) => change.timestamp.isAfter(last24Hours))
        .toList();

    final changesBySource = <String, int>{};
    for (final change in recentChanges) {
      final source = change.source ?? 'unknown';
      changesBySource[source] = (changesBySource[source] ?? 0) + 1;
    }

    return {
      'total_changes': _stateHistory.length,
      'changes_last_24h': recentChanges.length,
      'changes_by_source': changesBySource,
      'active_subscriptions': _subscriptions.length,
      'active_listeners': _listeners.length,
      'active_debounce_timers': _debounceTimers.length,
      'last_change_time': _stateHistory.isNotEmpty 
          ? _stateHistory.last.timestamp.toIso8601String()
          : null,
    };
  }

  @override
  void dispose() {
    // Cancel all subscriptions
    for (final subscription in _subscriptions.values) {
      subscription.cancel();
    }
    _subscriptions.clear();

    // Cancel all debounce timers
    for (final timer in _debounceTimers.values) {
      timer.cancel();
    }
    _debounceTimers.clear();

    // Clear listeners
    _listeners.clear();

    // Clear history
    _stateHistory.clear();

    super.dispose();
  }
}

/// Multi-state manager for managing multiple related states
class MultiStateManager extends ChangeNotifier {
  final Map<String, OptimizedStateManager> _managers = {};
  final Map<String, StreamSubscription> _managerSubscriptions = {};

  /// Add state manager
  void addStateManager<T>(String key, OptimizedStateManager<T> manager) {
    _managers[key] = manager;
    
    // Subscribe to manager changes
    _managerSubscriptions[key] = manager.addListener(() {
      notifyListeners();
    }) as StreamSubscription;
  }

  /// Get state manager
  OptimizedStateManager<T>? getStateManager<T>(String key) {
    return _managers[key] as OptimizedStateManager<T>?;
  }

  /// Get state
  T? getState<T>(String key) {
    return getStateManager<T>(key)?.state;
  }

  /// Set state
  void setState<T>(String key, T newState, {String? source}) {
    getStateManager<T>(key)?.setState(newState, source: source);
  }

  /// Remove state manager
  void removeStateManager(String key) {
    _managerSubscriptions[key]?.cancel();
    _managerSubscriptions.remove(key);
    _managers[key]?.dispose();
    _managers.remove(key);
  }

  /// Get all state statistics
  Map<String, dynamic> getAllStatistics() {
    final stats = <String, dynamic>{};
    
    for (final entry in _managers.entries) {
      stats[entry.key] = entry.value.getStatistics();
    }

    return {
      'total_managers': _managers.length,
      'manager_stats': stats,
    };
  }

  @override
  void dispose() {
    // Cancel all subscriptions
    for (final subscription in _managerSubscriptions.values) {
      subscription.cancel();
    }
    _managerSubscriptions.clear();

    // Dispose all managers
    for (final manager in _managers.values) {
      manager.dispose();
    }
    _managers.clear();

    super.dispose();
  }
}

/// Global state manager instance
class GlobalStateManager {
  static final GlobalStateManager _instance = GlobalStateManager._internal();
  factory GlobalStateManager() => _instance;
  GlobalStateManager._internal();

  final MultiStateManager _multiStateManager = MultiStateManager();

  /// Get multi-state manager
  MultiStateManager get multiStateManager => _multiStateManager;

  /// Create optimized state manager
  OptimizedStateManager<T> createStateManager<T>(String key, T initialState) {
    final manager = OptimizedStateManager<T>(initialState);
    _multiStateManager.addStateManager(key, manager);
    return manager;
  }

  /// Get state manager
  OptimizedStateManager<T>? getStateManager<T>(String key) {
    return _multiStateManager.getStateManager<T>(key);
  }

  /// Dispose all state managers
  void disposeAll() {
    _multiStateManager.dispose();
  }
}