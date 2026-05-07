class Plant {
  final String id;
  final String commonName;
  final String scientificName;
  final String family;
  final String morphologyType; // 'Árbol', 'Arbusto', 'Hierba', 'Liana'
  final String description;
  final String imageUrl;
  final double matchPercentage; // for filtering results, mock value

  Plant({
    required this.id,
    required this.commonName,
    required this.scientificName,
    required this.family,
    required this.morphologyType,
    required this.description,
    required this.imageUrl,
    this.matchPercentage = 0.0,
  });
}
