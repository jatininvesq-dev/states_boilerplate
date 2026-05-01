import 'package:either_dart/either.dart';
import '../entities/counter_entity.dart';
import '../repositories/counter_repository.dart';

class ResetCounterUseCase {
  final CounterRepository repository;

  ResetCounterUseCase(this.repository);

  Future<Either<Exception, CounterEntity>> call() async {
    return await repository.resetCounter();
  }
}
