import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecases.dart';
import '../entities/number_trivia.dart';
import '../repositories/number_trivia_repository.dart';

@lazySingleton
class GetRandomNumberTriviaFun extends UseCase<NumberTrivia, NoParams> {
  final NumberTriviaRepository repository;

  GetRandomNumberTriviaFun(this.repository);

  Future<Either<Failure, NumberTrivia>> call(NoParams) async {
    return await repository.getRandomNumberTrivia();
  }
}
