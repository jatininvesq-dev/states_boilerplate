import 'package:either_dart/either.dart';
import '../entities/counter_entity.dart';
import '../repositories/counter_repository.dart';

class IncrementCounterUseCase {
  final CounterRepository repository;

  IncrementCounterUseCase(this.repository);

  Future<Either<Exception, CounterEntity>> call() async {
    return await repository.incrementCounter();
  }
}
