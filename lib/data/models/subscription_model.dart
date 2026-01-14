import 'package:mstnuryev/domain/entities/subscription_entity.dart';

class SubscriptionModel extends SubscriptionEntity {
  const SubscriptionModel({
    required bool isPurchased,
    String? subscriptionType,
    DateTime? purchaseDate,
  }) : super(
    isPurchased: isPurchased,
    subscriptionType: subscriptionType,
    purchaseDate: purchaseDate,
  );

  /// Factory constructor for creating a model from JSON
  factory SubscriptionModel.fromJson(Map<String, dynamic> json) {
    return SubscriptionModel(
      isPurchased: json['isPurchased'] ?? false,
      subscriptionType: json['subscriptionType'] as String?,
      purchaseDate: json['purchaseDate'] != null
          ? DateTime.parse(json['purchaseDate'] as String)
          : null,
    );
  }

  /// Convert model to JSON
  Map<String, dynamic> toJson() {
    return {
      'isPurchased': isPurchased,
      'subscriptionType': subscriptionType,
      'purchaseDate': purchaseDate?.toIso8601String(),
    };
  }

  /// Factory for creating an unpurchased subscription
  factory SubscriptionModel.unpurchased() {
    return const SubscriptionModel(isPurchased: false);
  }
}
