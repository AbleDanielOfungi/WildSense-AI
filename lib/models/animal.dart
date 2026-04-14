class Animal {
  final String id;
  final String species;
  final String sex;
  final int age;
  final String registeredAt;

  Animal({
    required this.id,
    required this.species,
    required this.sex,
    required this.age,
    required this.registeredAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'species': species,
      'sex': sex,
      'age': age,
      'registered_at': registeredAt,
    };
  }
}
