abstract class Entity {
  final String uid;
  Entity({required this.uid});

  Map<String, dynamic> toMap();
}
