// Copyright 2018 The Flutter Architecture Sample Authors. All rights reserved.
// Use of this source code is governed by the MIT license that can be found
// in the LICENSE file.

class CategoryEntity {
  final int id;
  final String title;
  final int color;

  CategoryEntity(this.id, this.title, this.color);

  @override
  int get hashCode => id.hashCode ^ title.hashCode ^ color.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CategoryEntity &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          title == other.title &&
          color == other.color;

  Map<String, Object> toJson() {
    return {
      'id': id,
      'title': title,
      'color': color,
    };
  }

  @override
  String toString() {
    return 'CategoryEntity{id: $id, title: $title, color: $color}';
  }

  static CategoryEntity fromJson(Map<String, Object> json) {
    return CategoryEntity(
      json['id'] as int,
      json['title'] as String,
      json['color'] as int,
    );
  }
}
