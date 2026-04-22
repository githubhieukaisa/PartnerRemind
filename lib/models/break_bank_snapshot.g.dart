// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'break_bank_snapshot.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetBreakBankSnapshotCollection on Isar {
  IsarCollection<BreakBankSnapshot> get breakBankSnapshots => this.collection();
}

const BreakBankSnapshotSchema = CollectionSchema(
  name: r'BreakBankSnapshot',
  id: 6462594371898192861,
  properties: {
    r'createdAt': PropertySchema(
      id: 0,
      name: r'createdAt',
      type: IsarType.dateTime,
    ),
    r'dailyResetPreference': PropertySchema(
      id: 1,
      name: r'dailyResetPreference',
      type: IsarType.string,
    ),
    r'lastUpdated': PropertySchema(
      id: 2,
      name: r'lastUpdated',
      type: IsarType.dateTime,
    ),
    r'partialResetMinutes': PropertySchema(
      id: 3,
      name: r'partialResetMinutes',
      type: IsarType.long,
    ),
    r'totalBreakSeconds': PropertySchema(
      id: 4,
      name: r'totalBreakSeconds',
      type: IsarType.long,
    ),
    r'version': PropertySchema(
      id: 5,
      name: r'version',
      type: IsarType.long,
    )
  },
  estimateSize: _breakBankSnapshotEstimateSize,
  serialize: _breakBankSnapshotSerialize,
  deserialize: _breakBankSnapshotDeserialize,
  deserializeProp: _breakBankSnapshotDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {},
  embeddedSchemas: {},
  getId: _breakBankSnapshotGetId,
  getLinks: _breakBankSnapshotGetLinks,
  attach: _breakBankSnapshotAttach,
  version: '3.1.0+1',
);

int _breakBankSnapshotEstimateSize(
  BreakBankSnapshot object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.dailyResetPreference.length * 3;
  return bytesCount;
}

void _breakBankSnapshotSerialize(
  BreakBankSnapshot object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeDateTime(offsets[0], object.createdAt);
  writer.writeString(offsets[1], object.dailyResetPreference);
  writer.writeDateTime(offsets[2], object.lastUpdated);
  writer.writeLong(offsets[3], object.partialResetMinutes);
  writer.writeLong(offsets[4], object.totalBreakSeconds);
  writer.writeLong(offsets[5], object.version);
}

BreakBankSnapshot _breakBankSnapshotDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = BreakBankSnapshot(
    dailyResetPreference: reader.readStringOrNull(offsets[1]) ?? 'keep_all',
    totalBreakSeconds: reader.readLongOrNull(offsets[4]) ?? 0,
  );
  object.createdAt = reader.readDateTime(offsets[0]);
  object.id = id;
  object.lastUpdated = reader.readDateTime(offsets[2]);
  object.partialResetMinutes = reader.readLongOrNull(offsets[3]);
  object.version = reader.readLong(offsets[5]);
  return object;
}

P _breakBankSnapshotDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readDateTime(offset)) as P;
    case 1:
      return (reader.readStringOrNull(offset) ?? 'keep_all') as P;
    case 2:
      return (reader.readDateTime(offset)) as P;
    case 3:
      return (reader.readLongOrNull(offset)) as P;
    case 4:
      return (reader.readLongOrNull(offset) ?? 0) as P;
    case 5:
      return (reader.readLong(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _breakBankSnapshotGetId(BreakBankSnapshot object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _breakBankSnapshotGetLinks(
    BreakBankSnapshot object) {
  return [];
}

void _breakBankSnapshotAttach(
    IsarCollection<dynamic> col, Id id, BreakBankSnapshot object) {
  object.id = id;
}

extension BreakBankSnapshotQueryWhereSort
    on QueryBuilder<BreakBankSnapshot, BreakBankSnapshot, QWhere> {
  QueryBuilder<BreakBankSnapshot, BreakBankSnapshot, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension BreakBankSnapshotQueryWhere
    on QueryBuilder<BreakBankSnapshot, BreakBankSnapshot, QWhereClause> {
  QueryBuilder<BreakBankSnapshot, BreakBankSnapshot, QAfterWhereClause>
      idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<BreakBankSnapshot, BreakBankSnapshot, QAfterWhereClause>
      idNotEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            )
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            );
      } else {
        return query
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            )
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            );
      }
    });
  }

  QueryBuilder<BreakBankSnapshot, BreakBankSnapshot, QAfterWhereClause>
      idGreaterThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<BreakBankSnapshot, BreakBankSnapshot, QAfterWhereClause>
      idLessThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<BreakBankSnapshot, BreakBankSnapshot, QAfterWhereClause>
      idBetween(
    Id lowerId,
    Id upperId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: lowerId,
        includeLower: includeLower,
        upper: upperId,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension BreakBankSnapshotQueryFilter
    on QueryBuilder<BreakBankSnapshot, BreakBankSnapshot, QFilterCondition> {
  QueryBuilder<BreakBankSnapshot, BreakBankSnapshot, QAfterFilterCondition>
      createdAtEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'createdAt',
        value: value,
      ));
    });
  }

  QueryBuilder<BreakBankSnapshot, BreakBankSnapshot, QAfterFilterCondition>
      createdAtGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'createdAt',
        value: value,
      ));
    });
  }

  QueryBuilder<BreakBankSnapshot, BreakBankSnapshot, QAfterFilterCondition>
      createdAtLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'createdAt',
        value: value,
      ));
    });
  }

  QueryBuilder<BreakBankSnapshot, BreakBankSnapshot, QAfterFilterCondition>
      createdAtBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'createdAt',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<BreakBankSnapshot, BreakBankSnapshot, QAfterFilterCondition>
      dailyResetPreferenceEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'dailyResetPreference',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BreakBankSnapshot, BreakBankSnapshot, QAfterFilterCondition>
      dailyResetPreferenceGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'dailyResetPreference',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BreakBankSnapshot, BreakBankSnapshot, QAfterFilterCondition>
      dailyResetPreferenceLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'dailyResetPreference',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BreakBankSnapshot, BreakBankSnapshot, QAfterFilterCondition>
      dailyResetPreferenceBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'dailyResetPreference',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BreakBankSnapshot, BreakBankSnapshot, QAfterFilterCondition>
      dailyResetPreferenceStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'dailyResetPreference',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BreakBankSnapshot, BreakBankSnapshot, QAfterFilterCondition>
      dailyResetPreferenceEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'dailyResetPreference',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BreakBankSnapshot, BreakBankSnapshot, QAfterFilterCondition>
      dailyResetPreferenceContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'dailyResetPreference',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BreakBankSnapshot, BreakBankSnapshot, QAfterFilterCondition>
      dailyResetPreferenceMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'dailyResetPreference',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BreakBankSnapshot, BreakBankSnapshot, QAfterFilterCondition>
      dailyResetPreferenceIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'dailyResetPreference',
        value: '',
      ));
    });
  }

  QueryBuilder<BreakBankSnapshot, BreakBankSnapshot, QAfterFilterCondition>
      dailyResetPreferenceIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'dailyResetPreference',
        value: '',
      ));
    });
  }

  QueryBuilder<BreakBankSnapshot, BreakBankSnapshot, QAfterFilterCondition>
      idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<BreakBankSnapshot, BreakBankSnapshot, QAfterFilterCondition>
      idGreaterThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<BreakBankSnapshot, BreakBankSnapshot, QAfterFilterCondition>
      idLessThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<BreakBankSnapshot, BreakBankSnapshot, QAfterFilterCondition>
      idBetween(
    Id lower,
    Id upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'id',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<BreakBankSnapshot, BreakBankSnapshot, QAfterFilterCondition>
      lastUpdatedEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'lastUpdated',
        value: value,
      ));
    });
  }

  QueryBuilder<BreakBankSnapshot, BreakBankSnapshot, QAfterFilterCondition>
      lastUpdatedGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'lastUpdated',
        value: value,
      ));
    });
  }

  QueryBuilder<BreakBankSnapshot, BreakBankSnapshot, QAfterFilterCondition>
      lastUpdatedLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'lastUpdated',
        value: value,
      ));
    });
  }

  QueryBuilder<BreakBankSnapshot, BreakBankSnapshot, QAfterFilterCondition>
      lastUpdatedBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'lastUpdated',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<BreakBankSnapshot, BreakBankSnapshot, QAfterFilterCondition>
      partialResetMinutesIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'partialResetMinutes',
      ));
    });
  }

  QueryBuilder<BreakBankSnapshot, BreakBankSnapshot, QAfterFilterCondition>
      partialResetMinutesIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'partialResetMinutes',
      ));
    });
  }

  QueryBuilder<BreakBankSnapshot, BreakBankSnapshot, QAfterFilterCondition>
      partialResetMinutesEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'partialResetMinutes',
        value: value,
      ));
    });
  }

  QueryBuilder<BreakBankSnapshot, BreakBankSnapshot, QAfterFilterCondition>
      partialResetMinutesGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'partialResetMinutes',
        value: value,
      ));
    });
  }

  QueryBuilder<BreakBankSnapshot, BreakBankSnapshot, QAfterFilterCondition>
      partialResetMinutesLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'partialResetMinutes',
        value: value,
      ));
    });
  }

  QueryBuilder<BreakBankSnapshot, BreakBankSnapshot, QAfterFilterCondition>
      partialResetMinutesBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'partialResetMinutes',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<BreakBankSnapshot, BreakBankSnapshot, QAfterFilterCondition>
      totalBreakSecondsEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'totalBreakSeconds',
        value: value,
      ));
    });
  }

  QueryBuilder<BreakBankSnapshot, BreakBankSnapshot, QAfterFilterCondition>
      totalBreakSecondsGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'totalBreakSeconds',
        value: value,
      ));
    });
  }

  QueryBuilder<BreakBankSnapshot, BreakBankSnapshot, QAfterFilterCondition>
      totalBreakSecondsLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'totalBreakSeconds',
        value: value,
      ));
    });
  }

  QueryBuilder<BreakBankSnapshot, BreakBankSnapshot, QAfterFilterCondition>
      totalBreakSecondsBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'totalBreakSeconds',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<BreakBankSnapshot, BreakBankSnapshot, QAfterFilterCondition>
      versionEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'version',
        value: value,
      ));
    });
  }

  QueryBuilder<BreakBankSnapshot, BreakBankSnapshot, QAfterFilterCondition>
      versionGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'version',
        value: value,
      ));
    });
  }

  QueryBuilder<BreakBankSnapshot, BreakBankSnapshot, QAfterFilterCondition>
      versionLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'version',
        value: value,
      ));
    });
  }

  QueryBuilder<BreakBankSnapshot, BreakBankSnapshot, QAfterFilterCondition>
      versionBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'version',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension BreakBankSnapshotQueryObject
    on QueryBuilder<BreakBankSnapshot, BreakBankSnapshot, QFilterCondition> {}

extension BreakBankSnapshotQueryLinks
    on QueryBuilder<BreakBankSnapshot, BreakBankSnapshot, QFilterCondition> {}

extension BreakBankSnapshotQuerySortBy
    on QueryBuilder<BreakBankSnapshot, BreakBankSnapshot, QSortBy> {
  QueryBuilder<BreakBankSnapshot, BreakBankSnapshot, QAfterSortBy>
      sortByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<BreakBankSnapshot, BreakBankSnapshot, QAfterSortBy>
      sortByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<BreakBankSnapshot, BreakBankSnapshot, QAfterSortBy>
      sortByDailyResetPreference() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dailyResetPreference', Sort.asc);
    });
  }

  QueryBuilder<BreakBankSnapshot, BreakBankSnapshot, QAfterSortBy>
      sortByDailyResetPreferenceDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dailyResetPreference', Sort.desc);
    });
  }

  QueryBuilder<BreakBankSnapshot, BreakBankSnapshot, QAfterSortBy>
      sortByLastUpdated() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastUpdated', Sort.asc);
    });
  }

  QueryBuilder<BreakBankSnapshot, BreakBankSnapshot, QAfterSortBy>
      sortByLastUpdatedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastUpdated', Sort.desc);
    });
  }

  QueryBuilder<BreakBankSnapshot, BreakBankSnapshot, QAfterSortBy>
      sortByPartialResetMinutes() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'partialResetMinutes', Sort.asc);
    });
  }

  QueryBuilder<BreakBankSnapshot, BreakBankSnapshot, QAfterSortBy>
      sortByPartialResetMinutesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'partialResetMinutes', Sort.desc);
    });
  }

  QueryBuilder<BreakBankSnapshot, BreakBankSnapshot, QAfterSortBy>
      sortByTotalBreakSeconds() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalBreakSeconds', Sort.asc);
    });
  }

  QueryBuilder<BreakBankSnapshot, BreakBankSnapshot, QAfterSortBy>
      sortByTotalBreakSecondsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalBreakSeconds', Sort.desc);
    });
  }

  QueryBuilder<BreakBankSnapshot, BreakBankSnapshot, QAfterSortBy>
      sortByVersion() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'version', Sort.asc);
    });
  }

  QueryBuilder<BreakBankSnapshot, BreakBankSnapshot, QAfterSortBy>
      sortByVersionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'version', Sort.desc);
    });
  }
}

extension BreakBankSnapshotQuerySortThenBy
    on QueryBuilder<BreakBankSnapshot, BreakBankSnapshot, QSortThenBy> {
  QueryBuilder<BreakBankSnapshot, BreakBankSnapshot, QAfterSortBy>
      thenByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<BreakBankSnapshot, BreakBankSnapshot, QAfterSortBy>
      thenByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<BreakBankSnapshot, BreakBankSnapshot, QAfterSortBy>
      thenByDailyResetPreference() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dailyResetPreference', Sort.asc);
    });
  }

  QueryBuilder<BreakBankSnapshot, BreakBankSnapshot, QAfterSortBy>
      thenByDailyResetPreferenceDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dailyResetPreference', Sort.desc);
    });
  }

  QueryBuilder<BreakBankSnapshot, BreakBankSnapshot, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<BreakBankSnapshot, BreakBankSnapshot, QAfterSortBy>
      thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<BreakBankSnapshot, BreakBankSnapshot, QAfterSortBy>
      thenByLastUpdated() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastUpdated', Sort.asc);
    });
  }

  QueryBuilder<BreakBankSnapshot, BreakBankSnapshot, QAfterSortBy>
      thenByLastUpdatedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastUpdated', Sort.desc);
    });
  }

  QueryBuilder<BreakBankSnapshot, BreakBankSnapshot, QAfterSortBy>
      thenByPartialResetMinutes() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'partialResetMinutes', Sort.asc);
    });
  }

  QueryBuilder<BreakBankSnapshot, BreakBankSnapshot, QAfterSortBy>
      thenByPartialResetMinutesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'partialResetMinutes', Sort.desc);
    });
  }

  QueryBuilder<BreakBankSnapshot, BreakBankSnapshot, QAfterSortBy>
      thenByTotalBreakSeconds() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalBreakSeconds', Sort.asc);
    });
  }

  QueryBuilder<BreakBankSnapshot, BreakBankSnapshot, QAfterSortBy>
      thenByTotalBreakSecondsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalBreakSeconds', Sort.desc);
    });
  }

  QueryBuilder<BreakBankSnapshot, BreakBankSnapshot, QAfterSortBy>
      thenByVersion() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'version', Sort.asc);
    });
  }

  QueryBuilder<BreakBankSnapshot, BreakBankSnapshot, QAfterSortBy>
      thenByVersionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'version', Sort.desc);
    });
  }
}

extension BreakBankSnapshotQueryWhereDistinct
    on QueryBuilder<BreakBankSnapshot, BreakBankSnapshot, QDistinct> {
  QueryBuilder<BreakBankSnapshot, BreakBankSnapshot, QDistinct>
      distinctByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'createdAt');
    });
  }

  QueryBuilder<BreakBankSnapshot, BreakBankSnapshot, QDistinct>
      distinctByDailyResetPreference({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'dailyResetPreference',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<BreakBankSnapshot, BreakBankSnapshot, QDistinct>
      distinctByLastUpdated() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'lastUpdated');
    });
  }

  QueryBuilder<BreakBankSnapshot, BreakBankSnapshot, QDistinct>
      distinctByPartialResetMinutes() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'partialResetMinutes');
    });
  }

  QueryBuilder<BreakBankSnapshot, BreakBankSnapshot, QDistinct>
      distinctByTotalBreakSeconds() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'totalBreakSeconds');
    });
  }

  QueryBuilder<BreakBankSnapshot, BreakBankSnapshot, QDistinct>
      distinctByVersion() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'version');
    });
  }
}

extension BreakBankSnapshotQueryProperty
    on QueryBuilder<BreakBankSnapshot, BreakBankSnapshot, QQueryProperty> {
  QueryBuilder<BreakBankSnapshot, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<BreakBankSnapshot, DateTime, QQueryOperations>
      createdAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'createdAt');
    });
  }

  QueryBuilder<BreakBankSnapshot, String, QQueryOperations>
      dailyResetPreferenceProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'dailyResetPreference');
    });
  }

  QueryBuilder<BreakBankSnapshot, DateTime, QQueryOperations>
      lastUpdatedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'lastUpdated');
    });
  }

  QueryBuilder<BreakBankSnapshot, int?, QQueryOperations>
      partialResetMinutesProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'partialResetMinutes');
    });
  }

  QueryBuilder<BreakBankSnapshot, int, QQueryOperations>
      totalBreakSecondsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'totalBreakSeconds');
    });
  }

  QueryBuilder<BreakBankSnapshot, int, QQueryOperations> versionProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'version');
    });
  }
}
