import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mstnuryev/core/errors/exceptions.dart';
import 'package:mstnuryev/domain/usecases/get_subscription_status.dart';
import 'package:mstnuryev/domain/usecases/save_subscription.dart';
import 'package:mstnuryev/presentation/bloc/subscription_event.dart';
import 'package:mstnuryev/presentation/bloc/subscription_state.dart';
import 'package:mstnuryev/data/repositories/subscription_repository_impl.dart';

/// BLoC for managing subscription state
/// This BLoC encapsulates all subscription-related business logic.
/// It follows the BLoC pattern to keep UI separate from business logic (SOLID principle).
class SubscriptionBloc extends Bloc<SubscriptionEvent, SubscriptionState> {
  final GetSubscriptionStatus getSubscriptionStatus;
  final SaveSubscription saveSubscription;
  final SubscriptionRepositoryImpl repository;

  SubscriptionBloc({
    required this.getSubscriptionStatus,
    required this.saveSubscription,
    required this.repository,
  }) : super(const SubscriptionInitial()) {
    on<CheckSubscriptionEvent>(_onCheckSubscription);
    on<PurchaseSubscriptionEvent>(_onPurchaseSubscription);
    on<ClearSubscriptionEvent>(_onClearSubscription);
  }

  /// Handle subscription status check
  /// This method retrieves the current subscription status from storage
  Future<void> _onCheckSubscription(
    CheckSubscriptionEvent event,
    Emitter<SubscriptionState> emit,
  ) async {
    emit(const SubscriptionLoading());
    try {
      final subscription = await getSubscriptionStatus();
      emit(SubscriptionLoaded(subscription: subscription));
    } on StorageException catch (e) {
      emit(SubscriptionError(message: e.message));
    } catch (e) {
      emit(SubscriptionError(message: 'Failed to check subscription: $e'));
    }
  }

  /// Handle subscription purchase
  /// This simulates a purchase by saving the subscription to storage
  /// In a real app, this would integrate with a payment provider (e.g., Stripe, RevenueCat)
  Future<void> _onPurchaseSubscription(
    PurchaseSubscriptionEvent event,
    Emitter<SubscriptionState> emit,
  ) async {
    emit(const SubscriptionLoading());
    try {
      // Simulate network delay for purchase processing
      await Future.delayed(const Duration(milliseconds: 800));

      // Save the subscription
      await saveSubscription(event.subscriptionType);

      // Fetch and emit the updated subscription state
      final updatedSubscription = await getSubscriptionStatus();
      emit(SubscriptionPurchased(subscription: updatedSubscription));
    } on StorageException catch (e) {
      emit(SubscriptionError(message: e.message));
    } catch (e) {
      emit(SubscriptionError(message: 'Failed to complete purchase: $e'));
    }
  }

  /// Handle clearing subscription (useful for testing)
  Future<void> _onClearSubscription(
    ClearSubscriptionEvent event,
    Emitter<SubscriptionState> emit,
  ) async {
    try {
      await repository.clearSubscription();
      emit(const SubscriptionCleared());
      // Reset to initial state after clearing
      add(const CheckSubscriptionEvent());
    } on StorageException catch (e) {
      emit(SubscriptionError(message: e.message));
    } catch (e) {
      emit(SubscriptionError(message: 'Failed to clear subscription: $e'));
    }
  }
}
