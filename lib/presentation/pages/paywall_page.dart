import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mstnuryev/core/constants/app_constants.dart';
import 'package:mstnuryev/presentation/bloc/subscription_bloc.dart';
import 'package:mstnuryev/presentation/bloc/subscription_event.dart';
import 'package:mstnuryev/presentation/bloc/subscription_state.dart';
import 'package:mstnuryev/presentation/widgets/subscription_option_card.dart';

/// Paywall page with subscription options
class PaywallPage extends StatefulWidget {
  final VoidCallback onPurchaseComplete;

  const PaywallPage({
    Key? key,
    required this.onPurchaseComplete,
  }) : super(key: key);

  @override
  State<PaywallPage> createState() => _PaywallPageState();
}

class _PaywallPageState extends State<PaywallPage>
    with TickerProviderStateMixin {
  String _selectedSubscription = 'yearly'; // Default to yearly
  late AnimationController _scaleController;
  bool _isPurchasing = false;

  @override
  void initState() {
    super.initState();
    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _scaleController.forward();
  }

  @override
  void dispose() {
    _scaleController.dispose();
    super.dispose();
  }

  void _handlePurchase() {
    if (_isPurchasing) return;

    setState(() => _isPurchasing = true);

    // Dispatch purchase event to BLoC
    context.read<SubscriptionBloc>().add(
      PurchaseSubscriptionEvent(
        subscriptionType: _selectedSubscription,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 600;
    
    return BlocListener<SubscriptionBloc, SubscriptionState>(
      listener: (context, state) {
        if (state is SubscriptionPurchased) {
          widget.onPurchaseComplete();
        } else if (state is SubscriptionError) {
          setState(() => _isPurchasing = false);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        }
      },
      child: Scaffold(
        body: SafeArea(
          child: ScaleTransition(
            scale: Tween<double>(begin: 0.95, end: 1.0).animate(
              CurvedAnimation(parent: _scaleController, curve: Curves.easeOut),
            ),
            child: SingleChildScrollView(
              padding: EdgeInsets.all(isMobile ? 16 : 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  Text(
                    'Unlock Premium',
                    style: Theme.of(context).textTheme.displayMedium?.copyWith(
                      fontSize: isMobile ? 28 : null,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Choose your perfect plan',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: Colors.grey.shade600,
                    ),
                  ),
                  const SizedBox(height: 24),
                  
                  // Monthly subscription card
                  SubscriptionOptionCard(
                    title: 'Monthly',
                    price: '\$${AppConstants.monthlyPrice.toStringAsFixed(2)}',
                    period: 'month',
                    features: [
                      'Unlimited access',
                      'Ad-free experience',
                      'Cancel anytime',
                    ],
                    isYearly: false,
                    isSelected: _selectedSubscription == 'monthly',
                    onTap: () {
                      setState(() => _selectedSubscription = 'monthly');
                    },
                  ),
                  const SizedBox(height: 12),
                  
                  SubscriptionOptionCard(
                    title: 'Yearly',
                    price: '\$${AppConstants.yearlyPrice.toStringAsFixed(2)}',
                    period: 'year',
                    features: [
                      'Everything in Monthly',
                      'Save \$20 vs monthly',
                      'Best value',
                    ],
                    isYearly: true,
                    isSelected: _selectedSubscription == 'yearly',
                    showRecommended: true,
                    onTap: () {
                      setState(() => _selectedSubscription = 'yearly');
                    },
                  ),
                  const SizedBox(height: 32),
                  
                  // Purchase button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _isPurchasing ? null : _handlePurchase,
                      child: _isPurchasing
                          ? SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  Colors.blue.shade700,
                                ),
                                strokeWidth: 2,
                              ),
                            )
                          : const Text('Continue to Payment'),
                    ),
                  ),
                  const SizedBox(height: 12),
                  
                  // Terms and conditions
                  Center(
                    child: Text(
                      'By continuing, you agree to our Terms',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.grey.shade600,
                        fontSize: isMobile ? 12 : null,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
