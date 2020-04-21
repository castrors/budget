import 'dart:async';
import 'dart:core';

import 'package:meta/meta.dart';
import 'package:rxdart/subjects.dart';
import 'package:budget_repository_core/budget_repository_core.dart';

class ReactiveLocalStorageRepository implements ReactiveRecordsRepository {
  final RecordsRepository _repository;
  final BehaviorSubject<List<RecordEntity>> _subject;
  bool _loaded = false;

  ReactiveLocalStorageRepository({
    @required RecordsRepository repository,
    List<RecordEntity> seedValue,
  })  : _repository = repository,
        _subject = seedValue != null
            ? BehaviorSubject<List<RecordEntity>>.seeded(seedValue)
            : BehaviorSubject<List<RecordEntity>>();

  @override
  Future<void> addNewRecord(RecordEntity record) async {
    _subject.add([..._subject.value, record]);

    await _repository.saveRecords(_subject.value);
  }

  @override
  Future<void> deleteRecord(List<String> idList) async {
    _subject.add(
      List<RecordEntity>.unmodifiable(_subject.value.fold<List<RecordEntity>>(
        <RecordEntity>[],
        (prev, entity) {
          return idList.contains(entity.id) ? prev : (prev..add(entity));
        },
      )),
    );

    await _repository.saveRecords(_subject.value);
  }

  @override
  Stream<List<RecordEntity>> records() {
    if (!_loaded) _loadRecords();

    return _subject.stream;
  }

  void _loadRecords() {
    _loaded = true;

    _repository.loadRecords().then((entities) {
      _subject.add(List<RecordEntity>.unmodifiable(
        [if (_subject.value != null) ..._subject.value, ...entities],
      ));
    });
  }

  @override
  Future<void> updateRecord(RecordEntity update) async {
    _subject.add(
      List<RecordEntity>.unmodifiable(_subject.value.fold<List<RecordEntity>>(
        <RecordEntity>[],
        (prev, entity) => prev..add(entity.id == update.id ? update : entity),
      )),
    );

    await _repository.saveRecords(_subject.value);
  }
}
