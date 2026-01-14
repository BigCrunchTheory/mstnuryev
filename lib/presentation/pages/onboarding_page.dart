import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mstnuryev/presentation/bloc/subscription_bloc.dart';
import 'package:mstnuryev/presentation/bloc/subscription_event.dart';
import 'package:mstnuryev/presentation/widgets/onboarding_page_1.dart';
import 'package:mstnuryev/presentation/widgets/onboarding_page_2.dart';

/// Onboarding page
/// This page guides users through a multi-step onboarding process
/// before showing the paywall
class OnboardingPage extends StatefulWidget {
  final VoidCallback onOnboardingComplete;

  const OnboardingPage({
    Key? key,
    required this.onOnboardingComplete,
  }) : super(key: key);

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage>
    with TickerProviderStateMixin {
  int _currentPage = 0;
  late PageController _pageController;
  late AnimationController _fadeController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _fadeController.forward();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  void _nextPage() {
    if (_currentPage < 1) {
      _fadeController.reverse().then((_) {
        _pageController.nextPage(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
        _fadeController.forward();
      });
    } else {
      widget.onOnboardingComplete();
    }
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 600;
    
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Progress indicator
            Padding(
              padding: EdgeInsets.all(isMobile ? 16 : 24),
              child: Row(
                children: [
                  for (int i = 0; i < 2; i++) ...[
                    Expanded(
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        height: 4,
                        decoration: BoxDecoration(
                          color: i <= _currentPage
                              ? Colors.blue.shade700
                              : Colors.grey.shade300,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),
                    if (i < 1) SizedBox(width: isMobile ? 6 : 8),
                  ],
                ],
              ),
            ),
            
            // Page content with fade animation
            Expanded(
              child: FadeTransition(
                opacity: _fadeController,
                child: PageView(
                  controller: _pageController,
                  physics: const NeverScrollableScrollPhysics(),
                  onPageChanged: (index) {
                    setState(() => _currentPage = index);
                  },
                  children: [
                    SingleChildScrollView(
                      padding: EdgeInsets.symmetric(
                        horizontal: isMobile ? 16 : 24,
                        vertical: isMobile ? 12 : 24,
                      ),
                      child: OnboardingPage1(onContinue: _nextPage),
                    ),
                    SingleChildScrollView(
                      padding: EdgeInsets.symmetric(
                        horizontal: isMobile ? 16 : 24,
                        vertical: isMobile ? 12 : 24,
                      ),
                      child: OnboardingPage2(onContinue: _nextPage),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
