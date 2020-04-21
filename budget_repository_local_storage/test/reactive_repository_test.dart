// Copyright 2018 The Flutter Architecture Sample Authors. All rights reserved.
// Use of this source code is governed by the MIT license that can be found
// in the LICENSE file.

import 'dart:async';

import 'package:mockito/mockito.dart';
import 'package:test/test.dart';
import 'package:budget_repository_core/budget_repository_core.dart';
import 'package:budget_repository_local_storage/budget_repository_local_storage.dart';

class MockRecordsRepository extends Mock implements RecordsRepository {}

void main() {
  group('ReactiveRecordsRepository', () {
    List<RecordEntity> createRecords([String task = 'Task']) {
      return [
        RecordEntity(
          '1',
          10.0,
          'Lunch',
          DateTime(2020, 1, 2),
          true,
        ),
        RecordEntity(
          '2',
          20.0,
          'Breakfast',
          DateTime(2020, 1, 2),
          true,
        ),
        RecordEntity(
          '3',
          30.0,
          'Dinner',
          DateTime(2020, 1, 2),
          true,
        ),
      ];
    }

    test('should load todos from the base repo and send them to the client',
        () {
      final records = createRecords();
      final repository = MockRecordsRepository();
      final reactiveRepository = ReactiveLocalStorageRepository(
        repository: repository,
        seedValue: records,
      );

      when(repository.loadRecords())
          .thenAnswer((_) => Future.value(<RecordEntity>[]));

      expect(reactiveRepository.records(), emits(records));
    });

    test('should only load from the base repo once', () {
      final records = createRecords();
      final repository = MockRecordsRepository();
      final reactiveRepository = ReactiveLocalStorageRepository(
        repository: repository,
        seedValue: records,
      );

      when(repository.loadRecords()).thenAnswer((_) => Future.value(records));

      expect(reactiveRepository.records(), emits(records));
      expect(reactiveRepository.records(), emits(records));

      verify(repository.loadRecords()).called(1);
    });

    test('should add records to the repository and emit the change', () async {
      final records = createRecords();
      final repository = MockRecordsRepository();
      final reactiveRepository = ReactiveLocalStorageRepository(
        repository: repository,
        seedValue: [],
      );

      when(repository.loadRecords())
          .thenAnswer((_) => Future.value(<RecordEntity>[]));
      when(repository.saveRecords(records)).thenAnswer((_) => Future.value());

      await reactiveRepository.addNewRecord(records.first);

      verify(repository.saveRecords(any));
      expect(reactiveRepository.records(), emits([records.first]));
    });

    test('should update a todo in the repository and emit the change',
        () async {
      final records = createRecords();
      final repository = MockRecordsRepository();
      final reactiveRepository = ReactiveLocalStorageRepository(
        repository: repository,
        seedValue: records,
      );
      final update = createRecords('task');

      when(repository.loadRecords()).thenAnswer((_) => Future.value(records));
      when(repository.saveRecords(any)).thenAnswer((_) => Future.value());

      await reactiveRepository.updateRecord(update.first);

      verify(repository.saveRecords(any));
      expect(
        reactiveRepository.records(),
        emits([update[0], records[1], records[2]]),
      );
    });

    test('should remove records from the repo and emit the change', () async {
      final repository = MockRecordsRepository();
      final records = createRecords();
      final reactiveRepository = ReactiveLocalStorageRepository(
        repository: repository,
        seedValue: records,
      );
      final future = Future.value(records);

      when(repository.loadRecords()).thenAnswer((_) => future);
      when(repository.saveRecords(any)).thenAnswer((_) => Future.value());

      await reactiveRepository.deleteRecord([records.first.id, records.last.id]);

      verify(repository.saveRecords(any));
      expect(reactiveRepository.records(), emits([records[1]]));
    });
  });
}
