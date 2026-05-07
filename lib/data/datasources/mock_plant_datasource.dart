import '../../domain/entities/plant.dart';

class MockPlantDataSource {
  final List<Plant> _mockDatabase = [
    Plant(
      id: '1',
      commonName: 'Victoria Regia',
      scientificName: 'Victoria amazonica',
      family: 'Nymphaeaceae',
      morphologyType: 'Hierba',
      description: 'Planta acuática gigante endémica de la cuenca del Amazonas. Sus hojas pueden alcanzar hasta 3 metros de diámetro y soportar más de 40 kg de peso.',
      imageUrl: 'https://images.unsplash.com/photo-1599424424361-9c60e0a6d0c9?auto=format&fit=crop&q=80&w=600',
      matchPercentage: 98.5,
    ),
    Plant(
      id: '2',
      commonName: 'Lupuna',
      scientificName: 'Ceiba pentandra',
      family: 'Malvaceae',
      morphologyType: 'Árbol',
      description: 'Uno de los árboles más altos de la selva amazónica, alcanzando hasta 70 metros de altura. Tiene raíces tabulares espectaculares.',
      imageUrl: 'https://images.unsplash.com/photo-1448375240586-882707db888b?auto=format&fit=crop&q=80&w=600',
      matchPercentage: 95.0,
    ),
    Plant(
      id: '3',
      commonName: 'Uña de Gato',
      scientificName: 'Uncaria tomentosa',
      family: 'Rubiaceae',
      morphologyType: 'Liana',
      description: 'Liana trepadora que recibe su nombre por las espinas en forma de garra. Ampliamente utilizada en la medicina tradicional amazónica.',
      imageUrl: 'https://images.unsplash.com/photo-1463936575829-25148e1db1b8?auto=format&fit=crop&q=80&w=600',
      matchPercentage: 92.3,
    ),
    Plant(
      id: '4',
      commonName: 'Sangre de Grado',
      scientificName: 'Croton lechleri',
      family: 'Euphorbiaceae',
      morphologyType: 'Árbol',
      description: 'Famoso por su látex rojo que fluye cuando se corta la corteza. Se usa tradicionalmente por sus propiedades cicatrizantes.',
      imageUrl: 'https://images.unsplash.com/photo-1502082553048-f009c37129b9?auto=format&fit=crop&q=80&w=600',
      matchPercentage: 88.0,
    ),
    Plant(
      id: '5',
      commonName: 'Ayahuasca',
      scientificName: 'Banisteriopsis caapi',
      family: 'Malpighiaceae',
      morphologyType: 'Liana',
      description: 'Liana considerada planta maestra en la Amazonía, utilizada ritualísticamente por pueblos indígenas.',
      imageUrl: 'https://images.unsplash.com/photo-1518531933037-91b2f5f229cc?auto=format&fit=crop&q=80&w=600',
      matchPercentage: 85.1,
    ),
  ];

  Future<List<Plant>> getFeaturedPlants() async {
    await Future.delayed(const Duration(seconds: 1)); // Simulate network latency
    return _mockDatabase.take(3).toList(); // Return top 3 as featured
  }

  Future<List<Plant>> getPlantsByMorphology(String morphology) async {
    await Future.delayed(const Duration(seconds: 1));
    return _mockDatabase.where((plant) => plant.morphologyType.toLowerCase() == morphology.toLowerCase()).toList();
  }

  Future<Plant?> getPlantById(String id) async {
    await Future.delayed(const Duration(milliseconds: 500));
    try {
      return _mockDatabase.firstWhere((plant) => plant.id == id);
    } catch (_) {
      return null;
    }
  }

  Future<List<Plant>> searchPlants(String query) async {
    await Future.delayed(const Duration(seconds: 1));
    final q = query.toLowerCase();
    return _mockDatabase.where((plant) {
      return plant.commonName.toLowerCase().contains(q) || 
             plant.scientificName.toLowerCase().contains(q) ||
             plant.family.toLowerCase().contains(q);
    }).toList();
  }

  Future<List<Plant>> getAllPlants() async {
    await Future.delayed(const Duration(seconds: 1));
    return _mockDatabase.toList();
  }
}

