class Candidate {
  final int id;
  final String name;
  final String description;
  final String? imageUrl;

  Candidate({
    required this.id,
    required this.name,
    required this.description,
    this.imageUrl,
  });

  factory Candidate.fromJson(Map<String, dynamic> json) {
    return Candidate(
      id: json['id'],
      name: json['nombre'],
      description: json['description'] ?? '',
      imageUrl: json['image_url'], // Si hubiera imagenes
    );
  }
}
