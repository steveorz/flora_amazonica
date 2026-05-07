import '../../domain/entities/plant.dart';

class PlantModel extends Plant {
  PlantModel({
    required super.id,
    required super.commonName,
    required super.scientificName,
    required super.family,
    required super.morphologyType,
    required super.description,
    required super.imageUrl,
    super.matchPercentage,
  });

  factory PlantModel.fromJson(Map<String, dynamic> json) {
    return PlantModel(
      id: json['id'],
      commonName: json['commonName'],
      scientificName: json['scientificName'],
      family: json['family'],
      morphologyType: json['morphologyType'],
      description: json['description'],
      imageUrl: json['imageUrl'],
      matchPercentage: json['matchPercentage']?.toDouble() ?? 0.0,
    );
  }
}
