import 'dart:convert';

import 'package:key_value_store/key_value_store.dart';
import 'package:budget_repository_core/budget_repository_core.dart';

class KeyValueStorage implements RecordsRepository {
  final String key;
  final KeyValueStore store;
  final JsonCodec codec;

  const KeyValueStorage(this.key, this.store, [this.codec = json]);

  @override
  Future<List<RecordEntity>> loadRecords() async {
    return codec
        .decode(store.getString(key))['records']
        .cast<Map<String, Object>>()
        .map<RecordEntity>(RecordEntity.fromJson)
        .toList(growable: false);
  }

  @override
  Future<bool> saveRecords(List<RecordEntity> records) {
    return store.setString(
      key,
      codec.encode({
        'records': records.map((record) => record.toJson()).toList(),
      }),
    );
  }
}
