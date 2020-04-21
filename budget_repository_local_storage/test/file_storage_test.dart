import 'dart:io';

import 'package:test/test.dart';
import 'package:budget_repository_core/budget_repository_core.dart';
import 'package:budget_repository_local_storage/budget_repository_local_storage.dart';

void main() {
  group('FileStorage', () {
    final records = [RecordEntity(
                '1',
                10.0,
                'Lunch',
                DateTime(2020, 1, 2),
                true,
              ),];
    final directory = Directory.systemTemp.createTemp('__storage_test__');
    final storage = FileStorage(
      '_test_tag_',
      () => directory,
    );

    tearDownAll(() async {
      final tempDirectory = await directory;

      tempDirectory.deleteSync(recursive: true);
    });

    test('Should persist RecordEntities to disk', () async {
      final file = await storage.saveRecords(records);

      expect(file.existsSync(), isTrue);
    });

    test('Should load RecordEntities from disk', () async {
      final loadedRecords = await storage.loadRecords();

      expect(loadedRecords, records);
    });
  });
}
