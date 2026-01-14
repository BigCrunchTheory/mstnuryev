import 'package:mstnuryev/domain/entities/subscription_entity.dart';

/// Abstract repository following the Repository pattern
/// This defines the contract for subscription-related operations.
/// Implementation is provided by the data layer.
abstract class SubscriptionRepository {
  /// Fetches the current subscription status
  Future<SubscriptionEntity> getSubscriptionStatus();

  /// Saves a subscription after purchase
  /// [type] should be 'monthly' or 'yearly'
  Future<void> saveSubscription(String type);

  /// Clears subscription data (for testing or logout)
  Future<void> clearSubscription();
}
