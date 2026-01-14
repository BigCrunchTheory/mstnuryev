// ============================================================================
// FILE IMPORTS & DEPENDENCY GUIDE
// ============================================================================

// This file explains all the imports and dependencies used in the project
// to help you understand the external packages and internal modules.

// ============================================================================
// CORE FLUTTER PACKAGES
// ============================================================================

// - flutter/material.dart
//   Provides Material Design widgets, themes, and design system
//   Used in: Every UI file (screens, pages, widgets)

// - flutter/cupertino.dart (not used here, but available for iOS design)

// ============================================================================
// STATE MANAGEMENT PACKAGES
// ============================================================================

// - flutter_bloc package (flutter_bloc/flutter_bloc.dart)
//   Implements the BLoC (Business Logic Component) pattern
//   Used in: main.dart, app.dart, paywall_page.dart
//   Why: Separates UI from business logic, provides reactive state management
//
// - bloc package (bloc/bloc.dart)
//   Core BLoC library (foundation for flutter_bloc)
//   Included as dependency of flutter_bloc

// ============================================================================
// EQUALITY & VALUE TYPES
// ============================================================================

// - equatable package (equatable/equatable.dart)
//   Provides easy value equality for Dart objects
//   Used in: All events, states, and entities
//   Why: Prevents unnecessary rebuilds when values haven't changed
//
// Example from subscription_state.dart:
//   class SubscriptionLoaded extends SubscriptionState {
//     final SubscriptionEntity subscription;
//     @override
//     List<Object?> get props => [subscription];
//   }
// This makes two states with the same subscription equal, preventing rebuilds

// ============================================================================
// DATA PERSISTENCE
// ============================================================================

// - shared_preferences package (shared_preferences/shared_preferences.dart)
//   Provides key-value local storage
//   Used in: local_datasource.dart
//   Why: Persists subscription state across app restarts
//
// Platform implementations:
//   - Android: SharedPreferences
//   - iOS: UserDefaults  
//   - Web: localStorage
//   - Desktop: Platform-specific (e.g., Windows Registry for Windows)

// ============================================================================
// INTERNAL IMPORTS STRUCTURE
// ============================================================================

// All internal imports use package: scheme instead of relative imports
// This makes refactoring easier and imports more readable

// Example:
//   ❌ import '../../../domain/entities/subscription_entity.dart';
//   ✅ import 'package:mstnuryev/domain/entities/subscription_entity.dart';

// Benefits:
//   - Works correctly if file is moved
//   - Clearer module structure
//   - Easier to find where code comes from

// ============================================================================
// DEPENDENCY FLOW DIAGRAM
// ============================================================================

/*
main.dart (Entry Point)
  ├── SharedPreferences instance
  ├── LocalDataSourceImpl (depends on SharedPreferences)
  ├── SubscriptionRepositoryImpl (depends on LocalDataSourceImpl)
  ├── GetSubscriptionStatus UseCase (depends on SubscriptionRepositoryImpl)
  ├── SaveSubscription UseCase (depends on SubscriptionRepositoryImpl)
  └── SubscriptionBloc (depends on both UseCase instances)
      └── Provided to entire app via MultiBlocProvider

presentation/screens/app.dart (Root Widget)
  ├── Material3 Theme from app_theme.dart
  ├── SubscriptionBloc listener (observes subscription state)
  └── Conditionally renders:
      ├── SplashScreen (while loading)
      ├── OnboardingPage + PaywallPage (if not purchased)
      └── MainScreen (if purchased)
*/

// ============================================================================
// PAYMENT SIMULATION IMPLEMENTATION
// ============================================================================

/*

WHY SIMULATE INSTEAD OF REAL PAYMENTS?

The purchase simulation in SubscriptionBloc._onPurchaseSubscription() does NOT
actually process payments. Instead, it:

1. Simulates network delay (800ms) for realistic UX
2. Saves subscription data to SharedPreferences
3. Emits success/error states to update UI

ADVANTAGES of Simulation:
✅ No need for payment API keys during development
✅ Works without internet connection
✅ Easy to test different scenarios
✅ No real transactions charged
✅ Perfect for UI/UX testing

DISADVANTAGES (why you need real payments in production):
❌ Doesn't actually charge users
❌ Can't verify receipt server-side
❌ No fraud protection
❌ Not compliant with app store requirements

HOW TO INTEGRATE REAL PAYMENTS:

1. Choose payment provider:
   - Stripe (most popular for custom implementations)
   - RevenueCat (subscription management)
   - Paddle (simpler setup for subscriptions)
   - Google Play Billing (Android only)
   - App Store Connect (iOS only)

2. Install package:
   flutter pub add stripe_sdk  // or other payment package

3. Replace purchase simulation:

   // Current simulation (in subscription_bloc.dart):
   Future<void> _onPurchaseSubscription(...) async {
     await Future.delayed(const Duration(milliseconds: 800)); // FAKE DELAY
     await saveSubscription(event.subscriptionType);          // SAVES LOCALLY
   }

   // With real Stripe integration:
   Future<void> _onPurchaseSubscription(...) async {
     try {
       final paymentIntent = await StripeService.instance.createPaymentIntent(
         amount: event.subscriptionType == 'monthly' ? 999 : 9999, // cents
         currency: 'usd',
       );
       
       await StripeService.instance.confirmPayment(paymentIntent);
       
       await saveSubscription(event.subscriptionType);
       emit(SubscriptionPurchased(subscription: updatedSubscription));
     } catch (e) {
       emit(SubscriptionError(message: 'Payment failed: $e'));
     }
   }

INTEGRATION STEPS:

1. Initialize payment service in main.dart:
   WidgetsFlutterBinding.ensureInitialized();
   await StripeService.instance.initialize('pk_test_...');

2. Create StripeService:
   - Handles payment intent creation
   - Processes payment confirmation
   - Verifies receipts server-side
   - Updates subscription status

3. Handle edge cases:
   - Network failures
   - Declined cards
   - 3D Secure authentication
   - Subscription cancellations

4. Add server-side verification:
   - Webhook handlers for payment events
   - Subscription status database
   - Receipt validation
   - Fraud detection

RECOMMENDED APPROACH FOR PRODUCTION:

Use RevenueCat (recommended for subscriptions):
- Handles Apple & Google app stores
- Built-in subscription management
- Server-side receipt validation
- Cross-platform implementation

Installation:
  flutter pub add revenuecat_flutter

Basic usage:
  await Purchases.configure(PurchasesConfiguration("<api_key>"));
  
  final offerings = await Purchases.getOfferings();
  final package = offerings.current?.getPackage("yearly");
  
  try {
    await Purchases.purchasePackage(package!);
    // Update subscription state
  } on PurchasesErrorCode catch (e) {
    // Handle error
  }

*/

// ============================================================================
// SHARED PREFERENCES IMPLEMENTATION DETAILS
// ============================================================================

/*

STORAGE MECHANISM:

Android:
  - Uses SharedPreferences
  - Stored in: /data/data/<package>/shared_prefs/flutter.xml

iOS:
  - Uses UserDefaults
  - Stored in: ~/Library/Preferences/com.example.app.plist

Web:
  - Uses localStorage
  - Stored in: Browser's local storage

Windows/Linux:
  - Uses native file system
  - Stored in: Platform-specific directories

STORED DATA STRUCTURE:

{
  "subscription_status": true,
  "subscription_type": "yearly",
  "purchase_date": "2024-01-14T10:30:00.000Z"
}

CLEARING DATA:

When user taps "Logout" (for testing):
- ClearSubscriptionEvent dispatched
- All three keys removed from SharedPreferences
- App returns to onboarding flow
- User can test different subscription types

PERSISTENCE ACROSS:
✅ App restarts
✅ Device restarts  
✅ App updates (usually)
✅ System resets (if app data not cleared)

CLEARED BY:
❌ App uninstall
❌ "Clear app data" from settings
❌ Factory reset
❌ Logout feature in our app

*/

// ============================================================================
// ANIMATION FRAMEWORK DETAILS
// ============================================================================

/*

ANIMATION TYPES USED:

1. Scale Animations:
   - Used for: Paywall card selection, content hover effects
   - Implementation: ScaleTransition with AnimatedContainer
   - Duration: 200-300ms
   - Curve: Curves.easeOut
   - Benefit: Visual feedback for user interaction

2. Fade Animations:
   - Used for: Page transitions, button state changes
   - Implementation: FadeTransition
   - Duration: 300-500ms
   - Curve: Curves.easeInOut
   - Benefit: Smooth visual transitions

3. Opacity Animations:
   - Used for: Selected state indicators
   - Implementation: AnimatedOpacity
   - Duration: 200-300ms
   - Benefit: Subtle feedback

PERFORMANCE OPTIMIZATION:

✅ Using const widgets to prevent unnecessary rebuilds
✅ Proper disposal of AnimationController
✅ Limiting animation duration to <1 second
✅ Using GPU-accelerated transitions (Transform, Opacity)
✅ Avoiding layout animations (expensive)

ANTI-PATTERNS AVOIDED:

❌ Animating layout properties (width, height, padding)
   → Use Transform instead
❌ Long animations (>2 seconds)
   → Feels sluggish
❌ Multiple simultaneous animations
   → Use composed animations or AnimationGroup
❌ Forgetting to dispose AnimationController
   → Memory leak

*/

// ============================================================================
// MATERIAL 3 THEMING SYSTEM
// ============================================================================

/*

THEME IMPLEMENTATION:

AppTheme class in config/theme/app_theme.dart provides:

1. Color Palette:
   - Primary: #6366F1 (Indigo 500) - Main brand color
   - Secondary: #10B981 (Emerald 600) - Accent color  
   - Background: #F9FAFB (Gray 50) - App background
   - Surface: #FFFFFF - Card/dialog background
   - Error: #EF4444 - Error states

2. Typography:
   - Display: Large, bold headings
   - Title: Medium-sized section headers
   - Body: Regular text content
   - Label: Small text, captions

3. Component Themes:
   - Buttons: Elevated, Outlined, Text
   - AppBar: Material 3 style
   - Cards: Rounded corners, elevation
   - Input fields: Filled style with rounded borders

MATERIAL 3 BENEFITS:

✅ Modern, polished appearance
✅ Consistent across platforms
✅ Accessibility built-in
✅ Dark mode support ready
✅ Smooth animations included

EXTENDING THE THEME:

To add dark mode:
  1. Create darkTheme getter in AppTheme
  2. Set themeMode: ThemeMode.system in MaterialApp
  3. Use Theme.of(context) to access current theme

To customize colors:
  1. Edit AppTheme color constants
  2. Automatic propagation throughout app
  3. No widget updates needed

*/

// ============================================================================
// TESTING PAYMENT FLOWS
// ============================================================================

/*

TEST SCENARIO 1: First Time User
1. Delete app data
2. Launch app
3. See splash screen
4. See onboarding page 1
5. Tap "Continue"
6. See onboarding page 2  
7. Tap "Continue"
8. See paywall with two options
9. Select yearly (default)
10. Tap "Continue to Payment"
11. See loading spinner (800ms)
12. See main screen with welcome banner
13. Check SharedPreferences: subscription_status = true, subscription_type = "yearly"

TEST SCENARIO 2: Returning User
1. Don't delete app data
2. Launch app
3. See splash screen (checking status)
4. Go directly to main screen (no onboarding!)
5. Tap logout button
6. Return to onboarding flow

TEST SCENARIO 3: Monthly Purchase
1. Go through onboarding
2. On paywall, tap "Monthly" card
3. "Monthly" card scales and shows selected indicator
4. Tap "Continue to Payment"  
5. See main screen
6. Logout and purchase again to switch to yearly

TEST SCENARIO 4: Error Handling
1. Interrupt app during purchase
2. See error message
3. Tap retry button
4. Continue purchase flow

*/

// ============================================================================
// SUMMARY OF KEY PATTERNS
// ============================================================================

/*

1. DEPENDENCY INJECTION
   └─ Dependencies provided at app root (main.dart)
   └─ BLoC provided via MultiBlocProvider
   └─ No global singletons

2. LAYERED ARCHITECTURE
   └─ Domain: Pure business logic
   └─ Data: Storage and repository implementations
   └─ Presentation: UI and state management
   └─ Config: App-wide configuration

3. EVENT-DRIVEN STATE MANAGEMENT
   └─ Events trigger BLoC actions
   └─ BLoC emits new states
   └─ UI listens to state changes
   └─ Predictable, testable, debuggable

4. USE CASES
   └─ Single responsibility
   └─ Reusable across widgets
   └─ Easy to test

5. ABSTRACT REPOSITORIES
   └─ Data source abstraction
   └─ Easy to swap implementations
   └─ Testable with mocks

6. PERSISTENCE
   └─ SharedPreferences for local storage
   └─ Automatic app data restoration
   └─ Simple key-value store

This architecture ensures:
✅ Maintainability - Clear, organized code
✅ Testability - Each layer independently testable
✅ Scalability - Easy to add features
✅ Reusability - Components can be used in other apps
✅ Flexibility - Easy to change implementations

*/
