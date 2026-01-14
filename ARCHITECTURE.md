# Premium Subscription App - Architecture & Implementation Guide

A production-ready Flutter application demonstrating clean architecture, BLoC state management, and subscription-based onboarding flow.

## 📱 Features

### 1. **Onboarding Screen**
- Two-step onboarding experience with smooth animations
- Progress indicator showing user progression
- Page-based navigation with fade transitions
- Informative content about app features

### 2. **Paywall Screen**
- Two subscription options: Monthly ($9.99) and Yearly ($99.99)
- Visual indicators for the recommended yearly plan
- Discount badge showing 17% savings with yearly subscription
- Smooth card selection animations with hover effects
- Loading state during purchase processing
- Simulated purchase flow (800ms network delay)

### 3. **Main Content Screen**
- Welcome banner with gradient background
- Feature showcase with icons and descriptions
- Premium content grid with hover animations
- Logout button to reset subscription state for testing
- Responsive design using CustomScrollView and SliverGrid

### 4. **Subscription State Persistence**
- Uses `SharedPreferences` for local data persistence
- Automatically skips onboarding/paywall for returning users
- Persists subscription type (monthly/yearly) and purchase date
- Smooth restoration of app state on launch

## 🏗️ Architecture

This app follows **Clean Architecture** principles with clear separation of concerns:

```
lib/
├── config/              # App configuration (theme, constants)
├── core/               # Core utilities, constants, errors
├── data/               # Data layer (repositories, data sources, models)
├── domain/             # Domain layer (entities, repositories, use cases)
└── presentation/       # Presentation layer (BLoC, pages, widgets)
```

### Architecture Layers Explained

#### **Domain Layer** (`domain/`)
- **Entities**: Pure business objects independent of any framework
- **Repositories**: Abstract contracts defining data operations
- **Use Cases**: Encapsulate business logic following SOLID principles

*Why*: Domain layer is framework-agnostic and testable, representing the core business rules.

#### **Data Layer** (`data/`)
- **Models**: Data objects with serialization/deserialization
- **Data Sources**: Local storage implementation (SharedPreferences)
- **Repositories**: Concrete implementations bridging domain and data

*Why*: Separates data access from business logic, making it easy to swap implementations.

#### **Presentation Layer** (`presentation/`)
- **BLoC**: State management using Flutter BLoC pattern
- **Pages/Screens**: High-level UI containers managing navigation
- **Widgets**: Reusable UI components

*Why*: Keeps UI concerns separate from business logic, improving testability and reusability.

## 🎯 SOLID Principles Applied

### Single Responsibility Principle (SRP)
- Each use case handles one specific operation (e.g., `GetSubscriptionStatus`, `SaveSubscription`)
- Data sources are isolated for their specific storage medium
- BLoC events have single, well-defined purposes

### Open/Closed Principle (OCP)
- Abstract repository interface allows adding new implementations without modifying existing code
- New features can be added to the BLoC by adding new events/states

### Liskov Substitution Principle (LSP)
- Data source implementations can be swapped without breaking the contract
- Different repository implementations are interchangeable

### Interface Segregation Principle (ISP)
- `LocalDataSource` interface exposes only necessary methods
- BLoC only depends on use case interfaces, not concrete implementations

### Dependency Inversion Principle (DIP)
- High-level modules (BLoC) depend on abstractions (use cases, repositories)
- Low-level modules (data sources) are injected as dependencies
- Dependency injection setup in `main.dart`

## 🔄 State Management (BLoC Pattern)

The app uses **Flutter BLoC** for state management:

```
Events → BLoC → States → UI
```

### Subscription BLoC
- **Events**: `CheckSubscriptionEvent`, `PurchaseSubscriptionEvent`, `ClearSubscriptionEvent`
- **States**: `SubscriptionInitial`, `SubscriptionLoading`, `SubscriptionLoaded`, `SubscriptionPurchased`, `SubscriptionError`
- **Benefits**: 
  - Separates UI from business logic
  - Predictable state transitions
  - Easy to test
  - Automatic rebuilds through `BlocBuilder`

## 🎨 UI/UX Features

### Animations
- **Scale Transitions**: Selection cards scale smoothly when selected
- **Fade Transitions**: Page transitions use fade effects for elegance
- **Opacity Animations**: Buttons show selection state through opacity changes
- **Hover Effects**: Content cards respond to mouse hover with scale transitions

*Implementation note*: We use `AnimatedContainer`, `FadeTransition`, `ScaleTransition`, and `AnimationController` for smooth, performant animations. Each animation is properly disposed to prevent memory leaks.

### Performance Optimizations
- Use of `const` widgets throughout for compile-time constants
- `IgnorePointer` to prevent interaction during transitions
- Lazy loading of widgets with `VisibleArea`
- Efficient grid rendering with `SliverGrid`

## 📦 Dependencies

- **flutter_bloc**: State management
- **equatable**: Value equality for events and states
- **shared_preferences**: Local persistent storage

## 🚀 Getting Started

### Prerequisites
- Flutter 3.9.0 or higher
- Dart 3.9.0 or higher

### Installation

1. Install dependencies:
```bash
flutter pub get
```

2. Run the app:
```bash
flutter run
```

### First Time Users
- App shows Onboarding → Paywall flow
- User selects subscription and "purchases"
- After purchase, goes to Main Screen
- Subscription persists in `SharedPreferences`

### Returning Users
- App automatically loads last subscription state
- Skips Onboarding and Paywall
- Goes directly to Main Screen

### Testing the Flow
- Tap logout button on Main Screen to clear subscription
- App returns to Onboarding flow
- Can test multiple purchase scenarios

## 💡 Design Decisions

### Why BLoC?
BLoC provides a clean separation between business logic and UI, making the codebase more testable and maintainable. It follows reactive programming patterns that are easy to reason about.

### Why Use Cases?
Encapsulating business logic in use cases provides a single point for business rule enforcement and makes the code more reusable across different widgets.

### Why Data Models?
Models handle serialization/deserialization, separating data access concerns from domain logic. This makes it easy to add caching or transformations in the future.

### Why Animations?
Subtle animations enhance user experience by providing visual feedback. We kept animations lightweight (300-800ms) to avoid feeling sluggish while improving perceived quality.

### Purchase Simulation
Instead of integrating real payment providers (which would require API keys and testing accounts), we simulate a successful purchase with:
- 800ms network delay to feel realistic
- Proper error handling structure
- Ready for integration with actual payment providers (Stripe, RevenueCat, etc.)

## 🔐 Future Enhancements

1. **Payment Integration**
   - Replace purchase simulation with real payment provider (Stripe, RevenueCat)
   - Add subscription management and cancellation
   - Handle payment errors gracefully

2. **Analytics**
   - Track user onboarding flow completion
   - Monitor purchase events
   - Analyze user retention

3. **Testing**
   - Add unit tests for BLoC and use cases
   - Add widget tests for UI components
   - Add integration tests for complete flows

4. **Features**
   - Multi-language support
   - Dark mode theme
   - User authentication
   - Subscription renewal reminders

## 📄 File Structure

```
lib/
├── config/theme/
│   └── app_theme.dart           # Material 3 themed configuration
├── core/
│   ├── constants/
│   │   └── app_constants.dart   # App-wide constants
│   ├── errors/
│   │   └── exceptions.dart      # Custom exceptions
│   └── utils/
│       └── enums.dart           # App enums
├── data/
│   ├── datasources/
│   │   └── local_datasource.dart # SharedPreferences implementation
│   ├── models/
│   │   └── subscription_model.dart
│   └── repositories/
│       └── subscription_repository_impl.dart
├── domain/
│   ├── entities/
│   │   └── subscription_entity.dart
│   ├── repositories/
│   │   └── subscription_repository.dart
│   └── usecases/
│       ├── get_subscription_status.dart
│       └── save_subscription.dart
├── presentation/
│   ├── bloc/
│   │   ├── subscription_bloc.dart
│   │   ├── subscription_event.dart
│   │   └── subscription_state.dart
│   ├── pages/
│   │   ├── onboarding_page.dart
│   │   └── paywall_page.dart
│   ├── widgets/
│   │   ├── onboarding_page_1.dart
│   │   ├── onboarding_page_2.dart
│   │   └── subscription_option_card.dart
│   └── screens/
│       ├── app.dart             # Root app with navigation logic
│       ├── splash_screen.dart   # Loading screen
│       └── main_screen.dart     # Premium content
└── main.dart                    # App entry point
```

## 🎓 Learning Resources

This project demonstrates:
- Clean Architecture in Flutter
- SOLID Principles application
- BLoC pattern for state management
- Dependency Injection
- Proper separation of concerns
- Animation and UX patterns
- Error handling strategies
- SharedPreferences for persistence

Perfect as a reference or template for production Flutter apps!
