import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mstnuryev/config/theme/app_theme.dart';
import 'package:mstnuryev/presentation/bloc/subscription_bloc.dart';
import 'package:mstnuryev/presentation/bloc/subscription_event.dart';
import 'package:mstnuryev/presentation/bloc/subscription_state.dart';
import 'package:mstnuryev/presentation/pages/onboarding_page.dart';
import 'package:mstnuryev/presentation/pages/paywall_page.dart';
import 'package:mstnuryev/presentation/screens/main_screen.dart';
import 'package:mstnuryev/presentation/screens/splash_screen.dart';

/// Root app widget
/// This widget manages navigation between different app states:
/// - Splash: Initial loading state
/// - Onboarding: First-time user flow
/// - Paywall: Purchase screen
/// - Main: Post-purchase app content
class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Premium App',
      theme: AppTheme.lightTheme,
      home: BlocBuilder<SubscriptionBloc, SubscriptionState>(
        builder: (context, state) {
          // Show splash while checking subscription
          if (state is SubscriptionInitial || state is SubscriptionLoading) {
            return const SplashScreen();
          }
          
          // Show main app if user has purchased
          if (state is SubscriptionLoaded && state.subscription.isPurchased) {
            return _MainAppFlow(
              key: ValueKey(state.subscription),
            );
          }
          
          if (state is SubscriptionPurchased) {
            return _MainAppFlow(
              key: ValueKey(state.subscription),
            );
          }
          
          // Show onboarding/paywall flow if not purchased
          if (state is SubscriptionLoaded && !state.subscription.isPurchased) {
            return _OnboardingPaywallFlow(
              key: ValueKey(state),
            );
          }
          
          // Error state - show main app with error
          if (state is SubscriptionError) {
            return Scaffold(
              body: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.error_outline,
                      size: 64,
                      color: Colors.red,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Error: ${state.message}',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: () {
                        context.read<SubscriptionBloc>().add(
                          const CheckSubscriptionEvent(),
                        );
                      },
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              ),
            );
          }
          
          return const SplashScreen();
        },
      ),
    );
  }
}

/// Widget managing the onboarding and paywall flow
/// This is shown to first-time users who haven't purchased yet
class _OnboardingPaywallFlow extends StatefulWidget {
  const _OnboardingPaywallFlow({Key? key}) : super(key: key);

  @override
  State<_OnboardingPaywallFlow> createState() => _OnboardingPaywallFlowState();
}

class _OnboardingPaywallFlowState extends State<_OnboardingPaywallFlow>
    with TickerProviderStateMixin {
  bool _onboardingComplete = false;
  late AnimationController _transitionController;

  @override
  void initState() {
    super.initState();
    _transitionController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _transitionController.dispose();
    super.dispose();
  }

  void _handleOnboardingComplete() {
    _transitionController.forward().then((_) {
      setState(() => _onboardingComplete = true);
      _transitionController.reset();
      _transitionController.forward();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Onboarding screen
        FadeTransition(
          opacity: Tween<double>(begin: 1.0, end: 0.0).animate(
            _transitionController,
          ),
          child: IgnorePointer(
            ignoring: _onboardingComplete,
            child: OnboardingPage(
              onOnboardingComplete: _handleOnboardingComplete,
            ),
          ),
        ),
        
        // Paywall screen
        if (_onboardingComplete)
          FadeTransition(
            opacity: _transitionController,
            child: PaywallPage(
              onPurchaseComplete: () {
                // Purchase is handled by BLoC, which will rebuild the widget tree
              },
            ),
          ),
      ],
    );
  }
}

/// Widget managing the main app flow after purchase
/// This displays the main content screen
class _MainAppFlow extends StatelessWidget {
  const _MainAppFlow({Key? key}) : super(key: key);

  void _handleLogout(BuildContext context) {
    // Clear subscription and show onboarding again
    context.read<SubscriptionBloc>().add(
      const ClearSubscriptionEvent(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MainScreen(
      onLogout: () => _handleLogout(context),
    );
  }
}
