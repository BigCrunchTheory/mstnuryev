import 'package:equatable/equatable.dart';
import 'package:mstnuryev/domain/entities/subscription_entity.dart';

/// Base class for subscription states
abstract class SubscriptionState extends Equatable {
  const SubscriptionState();

  @override
  List<Object?> get props => [];
}

/// Initial state
class SubscriptionInitial extends SubscriptionState {
  const SubscriptionInitial();
}

/// Loading state when checking subscription
class SubscriptionLoading extends SubscriptionState {
  const SubscriptionLoading();
}

/// State when subscription check is successful
class SubscriptionLoaded extends SubscriptionState {
  final SubscriptionEntity subscription;

  const SubscriptionLoaded({required this.subscription});

  @override
  List<Object?> get props => [subscription];
}

/// State when purchase is successful
class SubscriptionPurchased extends SubscriptionState {
  final SubscriptionEntity subscription;

  const SubscriptionPurchased({required this.subscription});

  @override
  List<Object?> get props => [subscription];
}

/// State when an error occurs
class SubscriptionError extends SubscriptionState {
  final String message;

  const SubscriptionError({required this.message});

  @override
  List<Object?> get props => [message];
}

/// State when subscription is cleared
class SubscriptionCleared extends SubscriptionState {
  const SubscriptionCleared();
}
