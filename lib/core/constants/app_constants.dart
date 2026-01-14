/// Application-wide constants
class AppConstants {
  // SharedPreferences keys
  static const String subscriptionStatusKey = 'subscription_status';
  static const String subscriptionTypeKey = 'subscription_type';
  static const String purchaseDateKey = 'purchase_date';

  // Subscription types
  static const String monthlySubscription = 'monthly';
  static const String yearlySubscription = 'yearly';

  // Pricing (in USD)
  static const double monthlyPrice = 9.99;
  static const double yearlyPrice = 99.99; // ~17% discount vs monthly
}
