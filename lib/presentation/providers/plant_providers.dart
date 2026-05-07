import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/plant.dart';
import '../../domain/usecases/get_plants_usecase.dart';
import '../../data/datasources/mock_plant_datasource.dart';
import '../../data/repositories/plant_repository_impl.dart';

// DI Providers
final mockDataSourceProvider = Provider((ref) => MockPlantDataSource());
final plantRepositoryProvider = Provider<PlantRepositoryImpl>((ref) {
  return PlantRepositoryImpl(ref.watch(mockDataSourceProvider));
});
final getPlantsUseCaseProvider = Provider<GetPlantsUseCase>((ref) {
  return GetPlantsUseCase(ref.watch(plantRepositoryProvider));
});

// State Providers for the UI
final featuredPlantsProvider = FutureProvider<List<Plant>>((ref) async {
  final usecase = ref.watch(getPlantsUseCaseProvider);
  return usecase.executeFeatured();
});

final plantsByMorphologyProvider = FutureProvider.family<List<Plant>, String>((ref, morphology) async {
  final usecase = ref.watch(getPlantsUseCaseProvider);
  return usecase.executeByMorphology(morphology);
});

final searchPlantsProvider = FutureProvider.family<List<Plant>, String>((ref, query) async {
  final usecase = ref.watch(getPlantsUseCaseProvider);
  if (query.isEmpty) {
    return usecase.executeAll();
  }
  return usecase.executeSearch(query);
});

class IndexNotifier extends Notifier<int> {
  @override
  int build() => 0;
  void setIndex(int index) => state = index;
}
final bottomNavIndexProvider = NotifierProvider<IndexNotifier, int>(IndexNotifier.new);

class SearchQueryNotifier extends Notifier<String> {
  @override
  String build() => '';
  void setQuery(String query) => state = query;
}
final searchQueryProvider = NotifierProvider<SearchQueryNotifier, String>(SearchQueryNotifier.new);

class WizardStateNotifier extends Notifier<Map<int, String>> {
  @override
  Map<int, String> build() => {};

  void answerStep(int step, String answer) {
    state = {...state, step: answer};
  }

  void clear() => state = {};
}
final wizardProvider = NotifierProvider<WizardStateNotifier, Map<int, String>>(WizardStateNotifier.new);
