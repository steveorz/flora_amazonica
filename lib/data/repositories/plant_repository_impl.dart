import '../../domain/entities/plant.dart';
import '../../domain/repositories_interfaces/plant_repository.dart';
import '../datasources/mock_plant_datasource.dart';

class PlantRepositoryImpl implements PlantRepository {
  final MockPlantDataSource dataSource;

  PlantRepositoryImpl(this.dataSource);

  @override
  Future<List<Plant>> getFeaturedPlants() {
    return dataSource.getFeaturedPlants();
  }

  @override
  Future<List<Plant>> getPlantsByMorphology(String morphology) {
    return dataSource.getPlantsByMorphology(morphology);
  }
  
  @override
  Future<Plant?> getPlantById(String id) {
    return dataSource.getPlantById(id);
  }

  @override
  Future<List<Plant>> searchPlants(String query) {
    return dataSource.searchPlants(query);
  }

  @override
  Future<List<Plant>> getAllPlants() {
    return dataSource.getAllPlants();
  }
}
