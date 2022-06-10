class Role {
  final String id;
  final String name;

  Role(this.id, this.name);

  static fromJson(Map<String, dynamic> json) {
    return Role(json['id'], json['name']);
  }
}
