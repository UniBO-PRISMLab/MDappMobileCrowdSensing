class FollowedCampaign {
  final int id;
  final String name;
  final String address;
  final int age;

  const FollowedCampaign({
    required this.id,
    required this.name,
    required this.address,
    required this.age,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'address': address,
      'age': age,
    };
  }

  @override
  String toString() {
    return 'FollowedCampaign{id: $id, name: $name, age: $age}';
  }
}