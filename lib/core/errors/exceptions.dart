/// Custom exception for subscription-related errors
class SubscriptionException implements Exception {
  final String message;

  SubscriptionException(this.message);

  @override
  String toString() => message;
}

/// Exception thrown when local storage operations fail
class StorageException implements Exception {
  final String message;

  StorageException(this.message);

  @override
  String toString() => message;
}
