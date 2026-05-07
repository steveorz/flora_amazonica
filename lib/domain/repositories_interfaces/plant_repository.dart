import '../entities/plant.dart';

abstract class PlantRepository {
  Future<List<Plant>> getFeaturedPlants();
  Future<List<Plant>> getPlantsByMorphology(String morphology);
  Future<List<Plant>> searchPlants(String query);
  Future<List<Plant>> getAllPlants();
  Future<Plant?> getPlantById(String id);
}
