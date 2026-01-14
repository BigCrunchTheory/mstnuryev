import 'package:mstnuryev/data/datasources/local_datasource.dart';
import 'package:mstnuryev/domain/entities/subscription_entity.dart';
import 'package:mstnuryev/domain/repositories/subscription_repository.dart';

/// Repository implementation following the Repository pattern
/// This acts as a bridge between domain and data layers.
/// It handles data logic and delegates to data sources.
class SubscriptionRepositoryImpl implements SubscriptionRepository {
  final LocalDataSource localDataSource;

  SubscriptionRepositoryImpl({required this.localDataSource});

  @override
  Future<SubscriptionEntity> getSubscriptionStatus() async {
    return await localDataSource.getSubscriptionStatus();
  }

  @override
  Future<void> saveSubscription(String type) async {
    return await localDataSource.saveSubscription(type);
  }

  @override
  Future<void> clearSubscription() async {
    return await localDataSource.clearSubscription();
  }
}
