import 'dart:async';
import 'dart:io';

import 'package:mockito/mockito.dart';
import 'package:test/test.dart';
import 'package:budget_repository_core/budget_repository_core.dart';
import 'package:budget_repository_local_storage/budget_repository_local_storage.dart';

class MockFileStorage extends Mock implements FileStorage {}

class MockWebClient extends Mock implements WebClient {}

void main() {
  group('TodosRepository', () {
    List<RecordEntity> createRecords() {
      return [
        RecordEntity(
          '1',
          10.0,
          'Lunch',
          DateTime(2020, 1, 2),
          true,
        ),
      ];
    }

    test(
        'should load todos from File Storage if they exist without calling the web client',
        () {
      final fileStorage = MockFileStorage();
      final webClient = MockWebClient();
      final repository = LocalStorageRepository(
        localStorage: fileStorage,
        webClient: webClient,
      );
      final records = createRecords();

      when(fileStorage.loadRecords()).thenAnswer((_) => Future.value(records));

      expect(repository.loadRecords(), completion(records));
      verifyNever(webClient.loadRecords());
    });

    test(
        'should fetch records from the Web Client if the file storage throws a synchronous error',
        () async {
      final fileStorage = MockFileStorage();
      final webClient = MockWebClient();
      final repository = LocalStorageRepository(
        localStorage: fileStorage,
        webClient: webClient,
      );
      final records = createRecords();
      
      when(fileStorage.loadRecords()).thenThrow('Uh ohhhh');
      when(webClient.loadRecords()).thenAnswer((_) => Future.value(records));

      expect(await repository.loadRecords(), records);
      verify(webClient.loadRecords());
    });

    test(
        'should fetch records from the Web Client if the File storage returns an async error',
        () async {
      final fileStorage = MockFileStorage();
      final webClient = MockWebClient();
      final repository = LocalStorageRepository(
        localStorage: fileStorage,
        webClient: webClient,
      );
      final records = createRecords();

      when(fileStorage.loadRecords()).thenThrow(Exception('Oh no.'));
      when(webClient.loadRecords()).thenAnswer((_) => Future.value(records));

      expect(await repository.loadRecords(), records);
      verify(webClient.loadRecords());
    });

    test('should persist the records to local disk and the web client', () {
      final fileStorage = MockFileStorage();
      final webClient = MockWebClient();
      final repository = LocalStorageRepository(
        localStorage: fileStorage,
        webClient: webClient,
      );
      final records = createRecords();

      when(fileStorage.saveRecords(records))
          .thenAnswer((_) => Future.value(File('falsch')));
      when(webClient.saveRecords(records)).thenAnswer((_) => Future.value(true));

      // In this case, we just want to verify we're correctly persisting to all
      // the storage mechanisms we care about.
      expect(repository.saveRecords(records), completes);
      verify(fileStorage.saveRecords(records));
      verify(webClient.saveRecords(records));
    });
  });
}
