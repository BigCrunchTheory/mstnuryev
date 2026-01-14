import 'package:mstnuryev/core/constants/app_constants.dart';
import 'package:mstnuryev/core/errors/exceptions.dart';
import 'package:mstnuryev/data/models/subscription_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Abstract definition of local data source
/// Following Dependency Inversion Principle: depend on abstractions, not concrete implementations
abstract class LocalDataSource {
  Future<SubscriptionModel> getSubscriptionStatus();
  Future<void> saveSubscription(String type);
  Future<void> clearSubscription();
}

/// Implementation of local data source using SharedPreferences
/// This handles all local storage operations
class LocalDataSourceImpl implements LocalDataSource {
  final SharedPreferences sharedPreferences;

  LocalDataSourceImpl({required this.sharedPreferences});

  @override
  Future<SubscriptionModel> getSubscriptionStatus() async {
    try {
      // Check if subscription exists in shared preferences
      final isPurchased = sharedPreferences.getBool(
        AppConstants.subscriptionStatusKey,
      ) ?? false;

      if (!isPurchased) {
        return SubscriptionModel.unpurchased();
      }

      // Retrieve subscription type and purchase date
      final subscriptionType = sharedPreferences.getString(
        AppConstants.subscriptionTypeKey,
      );
      final purchaseDateString = sharedPreferences.getString(
        AppConstants.purchaseDateKey,
      );

      return SubscriptionModel(
        isPurchased: isPurchased,
        subscriptionType: subscriptionType,
        purchaseDate: purchaseDateString != null
            ? DateTime.parse(purchaseDateString)
            : null,
      );
    } catch (e) {
      throw StorageException('Failed to get subscription status: $e');
    }
  }

  @override
  Future<void> saveSubscription(String type) async {
    try {
      // Save subscription status and type
      await sharedPreferences.setBool(AppConstants.subscriptionStatusKey, true);
      await sharedPreferences.setString(AppConstants.subscriptionTypeKey, type);
      await sharedPreferences.setString(
        AppConstants.purchaseDateKey,
        DateTime.now().toIso8601String(),
      );
    } catch (e) {
      throw StorageException('Failed to save subscription: $e');
    }
  }

  @override
  Future<void> clearSubscription() async {
    try {
      await sharedPreferences.remove(AppConstants.subscriptionStatusKey);
      await sharedPreferences.remove(AppConstants.subscriptionTypeKey);
      await sharedPreferences.remove(AppConstants.purchaseDateKey);
    } catch (e) {
      throw StorageException('Failed to clear subscription: $e');
    }
  }
}
