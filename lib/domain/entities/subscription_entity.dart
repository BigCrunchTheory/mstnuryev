import 'package:equatable/equatable.dart';

class SubscriptionEntity extends Equatable {
  final bool isPurchased;
  final String? subscriptionType;
  final DateTime? purchaseDate;

  const SubscriptionEntity({
    required this.isPurchased,
    this.subscriptionType,
    this.purchaseDate,
  });

  @override
  List<Object?> get props => [isPurchased, subscriptionType, purchaseDate];
}
