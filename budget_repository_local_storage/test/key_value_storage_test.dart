// Copyright 2018 The Flutter Architecture Sample Authors. All rights reserved.
// Use of this source code is governed by the MIT license that can be found
// in the LICENSE file.

import 'package:key_value_store/key_value_store.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';
import 'package:budget_repository_core/budget_repository_core.dart';
import 'package:budget_repository_local_storage/budget_repository_local_storage.dart';

class MockKeyValueStore extends Mock implements KeyValueStore {}

void main() {
  group('KeyValueStorage', () {
    final store = MockKeyValueStore();
    final records = [
      RecordEntity(
        '1',
        10.0,
        'Lunch',
        DateTime(2020, 1, 2),
        true,
      ),
    ];
    final recordsJson =
        '{"records":[{"id":"1","amount": 10.0,"description":"Lunch","date": 1577934000000, "isExpense": true}]}';
    final storage = KeyValueStorage('T', store);

    test('Should persist RecordEntities to the store', () async {
      await storage.saveRecords(records);

      verify(store.setString('T', recordsJson));
    });

    test('Should load RecordEntities from disk', () async {
      when(store.getString('T')).thenReturn(recordsJson);

      expect(await storage.loadRecords(), records);
    });
  });
}
