import 'package:dartz/dartz.dart';

import '../error/failure.dart';

class InputConverter {
  Either<Failure, double> stringToUnsignedDouble(String str) {
    try {
      final number = double.parse(str);
      if (number < 0) throw const FormatException();

      return Right(number);
    } on FormatException {
      return Left(InvalidInputFailure());
    }
  }

  stringToUnsignedInteger(String str) {}
}
