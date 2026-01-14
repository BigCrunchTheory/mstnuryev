import 'package:mstnuryev/domain/entities/subscription_entity.dart';
import 'package:mstnuryev/domain/repositories/subscription_repository.dart';

/// Use case for fetching subscription status
/// This encapsulates the business logic for getting subscription information.
/// Following the Single Responsibility Principle from SOLID.
class GetSubscriptionStatus {
  final SubscriptionRepository repository;

  GetSubscriptionStatus(this.repository);

  Future<SubscriptionEntity> call() async {
    return await repository.getSubscriptionStatus();
  }
}
