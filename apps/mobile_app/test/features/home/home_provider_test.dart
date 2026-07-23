import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:mobile_app/features/home/data/home_repository.dart';
import 'package:mobile_app/features/home/models/dashboard_data.dart';
import 'package:mobile_app/features/home/providers/home_provider.dart';

import 'home_provider_test.mocks.dart';

@GenerateMocks([HomeRepository])
void main() {
  late MockHomeRepository mockRepo;
  late ProviderContainer container;

  setUp(() {
    mockRepo = MockHomeRepository();
    container = ProviderContainer(
      overrides: [homeRepositoryProvider.overrideWithValue(mockRepo)],
    );
  });

  tearDown(() => container.dispose());

  test('loads dashboard successfully', () async {
    const dashboard = DashboardData(
      points: 300,
      recentListings: [ListingSummary(id: '1', title: 'Chair', price: 500, category: 'Furniture', condition: 'good')],
    );
    when(mockRepo.getDashboard()).thenAnswer((_) async => dashboard);

    final result = await container.read(dashboardProvider.future);

    expect(result.points, 300);
    expect(result.recentListings.length, 1);
    expect(result.recentListings[0].title, 'Chair');
  });

  test('handles empty dashboard', () async {
    const dashboard = DashboardData(points: 0, recentListings: []);
    when(mockRepo.getDashboard()).thenAnswer((_) async => dashboard);

    final result = await container.read(dashboardProvider.future);

    expect(result.points, 0);
    expect(result.recentListings, isEmpty);
  });

  test('propagates error from repository', () async {
    when(mockRepo.getDashboard()).thenThrow(Exception('server down'));

    final future = container.read(dashboardProvider.future);
    expect(future, throwsException);
  });
}
