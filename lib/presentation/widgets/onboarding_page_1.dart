import 'package:flutter/material.dart';

/// First onboarding page
/// This demonstrates a simple onboarding screen with placeholder content
class OnboardingPage1 extends StatelessWidget {
  final VoidCallback onContinue;

  const OnboardingPage1({super.key, required this.onContinue});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Animated welcome icon
        AnimatedOpacity(
          duration: const Duration(milliseconds: 800),
          opacity: 1,
          child: Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              color: Colors.blue.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.rocket_launch,
              size: 50,
              color: Colors.blue.shade700,
            ),
          ),
        ),
        const SizedBox(height: 40),
        
        // Title
        Text(
          'Welcome!',
          style: Theme.of(context).textTheme.displayMedium,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 16),
        
        // Description
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Text(
            'Discover amazing content and unlock premium features to enhance your experience.',
            style: Theme.of(context).textTheme.bodyLarge,
            textAlign: TextAlign.center,
          ),
        ),
        const SizedBox(height: 60),
        
        // Continue button with subtle animation
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
