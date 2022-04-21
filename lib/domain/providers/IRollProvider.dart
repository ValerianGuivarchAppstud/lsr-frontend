import 'package:lsr/domain/models/Roll.dart';

abstract class IRollProvider {
  Stream<Set<Roll>> send(Roll roll);
}