import 'package:mstnuryev/domain/repositories/subscription_repository.dart';

/// Use case for saving a subscription after purchase
/// This encapsulates the business logic for saving subscription information.
/// Following the Single Responsibility Principle from SOLID.
class SaveSubscription {
  final SubscriptionRepository repository;

  SaveSubscription(this.repository);

  Future<void> call(String subscriptionType) async {
    return await repository.saveSubscription(subscriptionType);
  }
}
