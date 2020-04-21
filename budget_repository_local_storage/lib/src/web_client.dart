import 'dart:async';

import 'package:budget_repository_core/budget_repository_core.dart';


class WebClient implements RecordsRepository {
  final Duration delay;

  const WebClient([this.delay = const Duration(milliseconds: 3000)]);

  /// Mock that "fetches" some Todos from a "web service" after a short delay
  @override
  Future<List<RecordEntity>> loadRecords() async {
    return Future.delayed(
        delay,
        () => [
              RecordEntity(
                '1',
                10.0,
                'Lunch',
                DateTime(2020, 1, 2),
                false,
              ),
              RecordEntity(
                '2',
                20.0,
                'Breakfast',
                DateTime(2020, 2, 3),
                false,
              ),
            ]);
  }

  /// Mock that returns true or false for success or failure. In this case,
  /// it will "Always Succeed"
  @override
  Future<bool> saveRecords(List<RecordEntity> todos) async {
    return Future.value(true);
  }
}
