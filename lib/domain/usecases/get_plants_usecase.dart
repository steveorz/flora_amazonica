import '../entities/plant.dart';
import '../repositories_interfaces/plant_repository.dart';

class GetPlantsUseCase {
  final PlantRepository repository;

  GetPlantsUseCase(this.repository);

  Future<List<Plant>> executeFeatured() {
    return repository.getFeaturedPlants();
  }

  Future<List<Plant>> executeByMorphology(String morphology) {
    return repository.getPlantsByMorphology(morphology);
  }

  Future<List<Plant>> executeSearch(String query) {
    return repository.searchPlants(query);
  }

  Future<List<Plant>> executeAll() {
    return repository.getAllPlants();
  }
}
