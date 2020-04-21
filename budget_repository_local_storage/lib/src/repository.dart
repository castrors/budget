import 'dart:async';
import 'dart:core';

import 'package:meta/meta.dart';
import 'package:budget_repository_core/budget_repository_core.dart';
import 'web_client.dart';

class LocalStorageRepository implements RecordsRepository {
  final RecordsRepository localStorage;
  final RecordsRepository webClient;

  const LocalStorageRepository({
    @required this.localStorage,
    this.webClient = const WebClient(),
  });

  @override
  Future<List<RecordEntity>> loadRecords() async {
    try {
      return await localStorage.loadRecords();
    } catch (e) {
      final records = await webClient.loadRecords();

      await localStorage.saveRecords(records);

      return records;
    }
  }

  
  @override
  Future saveRecords(List<RecordEntity> records) {
    return Future.wait<dynamic>([
      localStorage.saveRecords(records),
      webClient.saveRecords(records),
    ]);
  }
}
