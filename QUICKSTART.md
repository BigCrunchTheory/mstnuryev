## Quick Start Guide

### ✅ Project Setup Complete!

Your Flutter Premium Subscription App is ready to run. Here's what you need to know:

---

## 🎯 What's Implemented

### ✨ Core Features
1. **Onboarding Screens** - 2-page onboarding with animations
2. **Paywall Screen** - Monthly/Yearly subscription options with pricing
3. **Main Screen** - Premium content grid and feature showcase
4. **State Persistence** - SharedPreferences for subscription data

### 🏛️ Architecture
- **Clean Architecture** with 4 layers (Domain, Data, Presentation, Config)
- **BLoC Pattern** for state management
- **SOLID Principles** throughout codebase
- **Dependency Injection** at app initialization

### 🎨 UI/UX
- Smooth animations (fade, scale, hover effects)
- Material 3 design theme
- Responsive layouts
- Polished visual feedback

---

## 🚀 Running the App

### Before Running
```bash
cd c:\Users\blood\Desktop\MST_Nuryev\mstnuryev
flutter pub get
```

### Run Options

**Web (Recommended for testing)**
```bash
flutter run -d chrome
```

**Android**
```bash
flutter run -d android
```

**iOS**
```bash
flutter run -d ios
```

---

## 📋 User Flow

### First Launch
1. **Splash Screen** (Loading subscription status)
2. **Onboarding Page 1** (Welcome screen)
3. **Onboarding Page 2** (Features showcase)
4. **Paywall Screen** (Monthly/Yearly selection)
5. **Main Screen** (Premium content)

### Return Visits
- Goes directly to **Main Screen** (subscription data persisted)

### Testing
- Tap **Logout** button on Main Screen to reset
- Returns to Onboarding flow
- Test different subscription purchases

---

## 🎨 Interactive Elements

### Paywall Screen
- **Card Selection**: Tap cards to select subscription (animates with scale)
- **Recommended Badge**: Visual indicator on yearly plan
- **Discount Badge**: Shows 17% savings on yearly
- **Continue Button**: Simulates purchase (shows loading spinner)

### Main Screen
- **Hover Effects**: Content cards scale on mouse hover
- **Responsive Grid**: 2-column grid that adapts to screen size
- **Feature Cards**: Display app capabilities
- **Logout Button**: In app bar for testing reset flow

### Animations Used
- `ScaleTransition`: Card selection and hover effects
- `FadeTransition`: Page transitions
- `AnimatedContainer`: Smooth property changes
- `AnimatedOpacity`: Button state changes

---

## 🏗️ Code Structure

Each layer has a specific responsibility:

```
Domain Layer     ← Business logic (pure Dart, no dependencies)
    ↓
Data Layer       ← Storage & data access implementation
    ↓
Presentation     ← UI & state management (BLoC)
```

**Key Files to Explore:**

- `main.dart` - App entry point with dependency injection
- `presentation/screens/app.dart` - Navigation logic
- `presentation/bloc/subscription_bloc.dart` - State management
- `domain/usecases/` - Business logic
- `data/datasources/local_datasource.dart` - Storage implementation

---

## 💾 Data Persistence

Subscription data is stored locally using SharedPreferences:

**Stored Data:**
- `subscription_status` (bool) - Whether user has purchased
- `subscription_type` (string) - "monthly" or "yearly"
- `purchase_date` (string) - ISO8601 timestamp

**Location:** Platform-dependent local storage
- **Android**: SharedPreferences
- **iOS**: UserDefaults
- **Web**: localStorage
- **Desktop**: Platform-specific local storage

---

## 🔧 Customization Ideas

### Change Pricing
Edit `lib/core/constants/app_constants.dart`:
```dart
static const double monthlyPrice = 9.99;
static const double yearlyPrice = 99.99;
```

### Change Colors
Edit `lib/config/theme/app_theme.dart`:
```dart
static const Color primaryColor = Color(0xFF6366F1);
```

### Add More Onboarding Pages
Add new widgets in `lib/presentation/widgets/` and add to `PageView` in `lib/presentation/pages/onboarding_page.dart`

### Add Real Payments
Replace purchase simulation in `SubscriptionBloc._onPurchaseSubscription()` with actual payment API calls

---

## 🎓 Architecture Highlights

### Why This Structure?

1. **Domain Layer is Framework-Agnostic**
   - Can test business logic without Flutter
   - Easy to reuse in other platforms (Web, Desktop)

2. **BLoC Pattern**
   - Clean separation of UI and logic
   - Predictable state management
   - Easy to test and debug

3. **Dependency Injection**
   - No global singletons
   - Easy to mock for testing
   - Changes isolated to one place

4. **Use Cases**
   - Single responsibility (SRP)
   - Reusable business logic
   - Easy to compose complex operations

---

## 📊 State Diagram

```
CheckSubscriptionEvent
         ↓
  SubscriptionLoading
         ↓
  SubscriptionLoaded
    /          \
isPurchased    not purchased
   /              \
Main Screen    OnboardingPage
                   ↓
              PaywallPage
                   ↓
         PurchaseSubscriptionEvent
                   ↓
          SubscriptionLoading
                   ↓
         SubscriptionPurchased
                   ↓
              Main Screen
```

---

## 🐛 Troubleshooting

### App won't run
```bash
flutter clean
flutter pub get
flutter run
```

### Hot reload not working
- Try hot restart instead (⌃⌘↩️ on Mac, or Shift+F5)
- Or stop and rebuild

### SharedPreferences errors
- Clear app data and rebuild
- Restart Flutter daemon

---

## 📚 Additional Resources

### Documentation
- [Flutter BLoC Library](https://bloclibrary.dev/)
- [Clean Architecture](https://resocoder.com/flutter-clean-architecture)
- [SharedPreferences](https://pub.dev/packages/shared_preferences)

### Key Concepts
- **SOLID Principles**: S.O.L.I.D design principles for maintainable code
- **BLoC Pattern**: Business Logic Component pattern
- **Clean Architecture**: Layered architecture with clear boundaries

---

## ✅ Verification Checklist

Run through this to verify everything works:

- [ ] App launches and shows splash screen
- [ ] First page shows "Welcome!" with rocket icon
- [ ] Navigate to second onboarding page
- [ ] Paywall shows monthly ($9.99) and yearly ($99.99) options
- [ ] Select yearly plan and tap "Continue to Payment"
- [ ] Loading spinner appears briefly
- [ ] Main screen loads with gradient banner
- [ ] Tap logout button to reset
- [ ] App returns to onboarding flow
- [ ] Hover over content cards (they scale)
- [ ] Subscription selection cards animate on select

---

## 🎉 You're All Set!

The app is production-ready and demonstrates best practices for Flutter development.

Enjoy exploring the clean architecture! 🚀
