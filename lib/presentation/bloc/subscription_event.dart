import 'package:equatable/equatable.dart';

abstract class SubscriptionEvent extends Equatable {
  const SubscriptionEvent();

  @override
  List<Object?> get props => [];
}

/// Event to check current subscription status
class CheckSubscriptionEvent extends SubscriptionEvent {
  const CheckSubscriptionEvent();

  @override
  List<Object?> get props => [];
}

/// Event to simulate a successful purchase
class PurchaseSubscriptionEvent extends SubscriptionEvent {
  final String subscriptionType; // 'monthly' or 'yearly'

  const PurchaseSubscriptionEvent({required this.subscriptionType});

  @override
  List<Object?> get props => [subscriptionType];
}

/// Event to clear subscription (for testing)
class ClearSubscriptionEvent extends SubscriptionEvent {
  const ClearSubscriptionEvent();

  @override
  List<Object?> get props => [];
}
