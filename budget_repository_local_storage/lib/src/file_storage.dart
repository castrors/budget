import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:budget_repository_core/budget_repository_core.dart';

class FileStorage implements RecordsRepository {
  final String tag;
  final Future<Directory> Function() getDirectory;

  const FileStorage(
    this.tag,
    this.getDirectory,
  );

  @override
  Future<List<RecordEntity>> loadRecords() async {
    final file = await _getLocalFile();
    final string = await file.readAsString();
    final json = JsonDecoder().convert(string);
    final records = (json['records'])
        .map<RecordEntity>((record) => RecordEntity.fromJson(record))
        .toList();

    return records;
  }

  @override
  Future<File> saveRecords(List<RecordEntity> records) async {
    final file = await _getLocalFile();

    return file.writeAsString(JsonEncoder().convert({
      'records': records.map((record) => record.toJson()).toList(),
    }));
  }

  Future<File> _getLocalFile() async {
    final dir = await getDirectory();

    return File('${dir.path}/ArchSampleStorage__$tag.json');
  }

  Future<FileSystemEntity> clean() async {
    final file = await _getLocalFile();

    return file.delete();
  }
}
