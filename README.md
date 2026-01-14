# mstnuryev

## Промпт в ChatGPT Глубокое Исследование

Сделай промпт для Claude Haiku 4.5 для создания следующего проекта по тестовому заданию (Чтобы проект наиболее соответствовал вроде SOLID и других, которые подходят по контексту. Необходимо, чтобы проект был оптимизирован и выглядел красиво - анимации, хуверы, которые не нагружают приложение)

*Текст тестового задания*

## Основной промпт

You are asked to create a **Flutter** project from scratch. The app must have the following features:

1. **Onboarding Screen(s)**: Build 1–2 simple onboarding pages (they can contain placeholder text or images). Each page should have a “Continue” button.

2. **Paywall Screen**: Design a simple paywall with two subscription options: **Monthly** and **Yearly** (the yearly option should reflect a discounted price). Include a “Continue” or “Buy” button. When the user taps this button, simulate a successful purchase (no real billing integration is needed).

3. **Main Screen**: After onboarding/purchase, show the main content (it can be a placeholder list, text, or image).

4. **Subscription State Persistence**: Use a method like SharedPreferences (or an equivalent) to save the subscription state. If the user has “purchased” a subscription, the next time the app launches it should skip the onboarding and paywall, and go directly to the main screen.

Additional requirements and best practices:

- Use a **clean architecture** approach with proper separation of concerns:contentReference[oaicite:8]{index=8}:contentReference[oaicite:9]{index=9}. For example, separate the UI (Views), business logic (ViewModels or BLoCs), and data layers. Follow **SOLID principles**:contentReference[oaicite:10]{index=10}:contentReference[oaicite:11]{index=11} and use dependency injection where appropriate.

- Implement state management using **BLoC or MVVM** so that the UI is kept separate from logic. Ensure high-level components do not depend on low-level details (e.g. using abstract services/interfaces):contentReference[oaicite:12]{index=12}.

- Make the UI look polished with subtle animations and hover effects where appropriate (e.g. animated transitions between screens, or button press animations). Use Flutter’s animation widgets (such as `AnimatedContainer`, `AnimatedOpacity`, etc.) for smooth effects:contentReference[oaicite:13]{index=13}. Keep animations lightweight: use `const` widgets when possible and avoid expensive rebuilds:contentReference[oaicite:14]{index=14}. The goal is to enhance UX without degrading performance.

- Structure the code **neatly and clearly**: add comments to explain your choices, use meaningful naming, and organize files logically (for instance, separate folders for screens, widgets, blocs, models, services, etc.). This demonstrates code cleanliness and thought process.

- **Explain your solutions**: Wherever it makes sense, include comments in the code describing why you implemented features in a particular way (e.g. why you chose a certain state-management pattern or how the purchase simulation works).

Your output should be the full Flutter project code (in Dart files) that satisfies the above requirements. Follow best practices for Flutter development and write maintainable, well-documented code.


## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
