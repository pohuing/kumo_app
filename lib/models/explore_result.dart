import 'package:equatable/equatable.dart';

class ExploreResult extends Equatable{
  final String name;
  final String absolutePath;
  final bool canWrite;
  final bool canDelete;

  ExploreResult(this.name, this.absolutePath, this.canWrite, this.canDelete);

  @override
  List<Object?> get props => [name, absolutePath, canWrite, canDelete];

  static ExploreResult fromJSON(Map<String, dynamic> data){
    var name = data['name'];
    var absolutePath = data['absolutePath'];
    var canWrite = data['canWrite'] ?? false;
    var canDelete = data['canDelete'] ?? false;

    return ExploreResult(name, absolutePath, canWrite, canDelete);
  }
}