import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mstnuryev/data/datasources/local_datasource.dart';
import 'package:mstnuryev/data/repositories/subscription_repository_impl.dart';
import 'package:mstnuryev/domain/usecases/get_subscription_status.dart';
import 'package:mstnuryev/domain/usecases/save_subscription.dart';
import 'package:mstnuryev/presentation/bloc/subscription_bloc.dart';
import 'package:mstnuryev/presentation/bloc/subscription_event.dart';
import 'package:mstnuryev/presentation/screens/app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final sharedPreferences = await SharedPreferences.getInstance();
  final localDataSource = LocalDataSourceImpl(
    sharedPreferences: sharedPreferences,
  );
  final repository = SubscriptionRepositoryImpl(
    localDataSource: localDataSource,
  );

  // Create use cases with injected dependencies
  final getSubscriptionStatusUseCase = GetSubscriptionStatus(repository);
  final saveSubscriptionUseCase = SaveSubscription(repository);

  runApp(
    MyApp(
      getSubscriptionStatus: getSubscriptionStatusUseCase,
      saveSubscription: saveSubscriptionUseCase,
      repository: repository,
    ),
  );
}

class MyApp extends StatelessWidget {
  final GetSubscriptionStatus getSubscriptionStatus;
  final SaveSubscription saveSubscription;
  final SubscriptionRepositoryImpl repository;

  const MyApp({
    Key? key,
    required this.getSubscriptionStatus,
    required this.saveSubscription,
    required this.repository,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        /// Provide SubscriptionBloc at the app root
        /// This makes the BLoC available throughout the entire app
        BlocProvider<SubscriptionBloc>(
          create: (context) => SubscriptionBloc(
            getSubscriptionStatus: getSubscriptionStatus,
            saveSubscription: saveSubscription,
            repository: repository,
          )
            // Check subscription status on app initialization
            ..add(const CheckSubscriptionEvent()),
        ),
      ],
      child: const App(),
    );
  }
}
