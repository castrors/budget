import 'dart:async';
import 'dart:core';

import 'record_entity.dart';

abstract class RecordsRepository {
  Future<List<RecordEntity>> loadRecords();

  Future saveRecords(List<RecordEntity> records);
}
