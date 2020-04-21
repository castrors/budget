import 'dart:async';
import 'dart:core';

import 'record_entity.dart';

abstract class ReactiveRecordsRepository {
  Future<void> addNewRecord(RecordEntity record);

  Future<void> deleteRecord(List<String> idList);

  Stream<List<RecordEntity>> records();

  Future<void> updateRecord(RecordEntity record);
}
