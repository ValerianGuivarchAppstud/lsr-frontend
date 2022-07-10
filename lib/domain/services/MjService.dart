import 'package:lsr/domain/models/Mj.dart';
import 'package:lsr/domain/models/MjSheet.dart';
import 'package:lsr/domain/providers/IMjProvider.dart';
import 'package:lsr/domain/providers/IStorageProvider.dart';


class MjService {
  IMjProvider mjProvider;

  MjService({required this.mjProvider});

  Future<MjSheet?> getMj(List<String> pj, List<String> pnj) async {
    return await this.mjProvider.get(pj, pnj);
  }

}
