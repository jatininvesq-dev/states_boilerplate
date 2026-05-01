import '../../domain/entities/counter_entity.dart';

class CounterModel extends CounterEntity {
  CounterModel({required super.value});

  factory CounterModel.fromEntity(CounterEntity entity) {
    return CounterModel(value: entity.value);
  }

  factory CounterModel.fromJson(Map<String, dynamic> json) {
    return CounterModel(value: json['value'] as int? ?? 0);
  }

  Map<String, dynamic> toJson() => {'value': value};

  CounterEntity toEntity() => CounterEntity(value: value);
}
