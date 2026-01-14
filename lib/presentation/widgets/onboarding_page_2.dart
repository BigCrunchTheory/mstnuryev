import 'package:flutter/material.dart';

/// Second onboarding page
/// This demonstrates another simple onboarding screen
class OnboardingPage2 extends StatelessWidget {
  final VoidCallback onContinue;

  const OnboardingPage2({
    Key? key,
    required this.onContinue,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Animated feature icon
        AnimatedOpacity(
          duration: const Duration(milliseconds: 800),
          opacity: 1,
          child: Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              color: Colors.green.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.star,
              size: 50,
              color: Colors.green.shade700,
            ),
          ),
        ),
        const SizedBox(height: 40),
        
        // Title
        Text(
          'Premium Features',
          style: Theme.of(context).textTheme.displayMedium,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 16),
        
        // Description
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              _FeatureRow(
                icon: Icons.check_circle,
                text: 'Ad-free experience',
              ),
              const SizedBox(height: 16),
              _FeatureRow(
                icon: Icons.check_circle,
                text: 'Exclusive content',
              ),
              const SizedBox(height: 16),
              _FeatureRow(
                icon: Icons.check_circle,
                text: 'Priority support',
              ),
            ],
          ),
        ),
        const SizedBox(height: 60),
        
        // Continue button
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: ElevatedButton(
            onPressed: onContinue,
            child: const Text('Continue'),
          ),
        ),
      ],
    );
  }
}

/// Widget to display feature rows with icons
class _FeatureRow extends StatelessWidget {
  final IconData icon;
  final String text;

  const _FeatureRow({
    required this.icon,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: Colors.green.shade700, size: 24),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            text,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        ),
      ],
    );
  }
}
