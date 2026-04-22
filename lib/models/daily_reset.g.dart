// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'daily_reset.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetDailyResetCollection on Isar {
  IsarCollection<DailyReset> get dailyResets => this.collection();
}

const DailyResetSchema = CollectionSchema(
  name: r'DailyReset',
  id: -5140972070277797784,
  properties: {
    r'action': PropertySchema(
      id: 0,
      name: r'action',
      type: IsarType.string,
    ),
    r'breakTimeAfterReset': PropertySchema(
      id: 1,
      name: r'breakTimeAfterReset',
      type: IsarType.long,
    ),
    r'breakTimeBeforeReset': PropertySchema(
      id: 2,
      name: r'breakTimeBeforeReset',
      type: IsarType.long,
    ),
    r'executedAt': PropertySchema(
      id: 3,
      name: r'executedAt',
      type: IsarType.dateTime,
    ),
    r'isManual': PropertySchema(
      id: 4,
      name: r'isManual',
      type: IsarType.bool,
    ),
    r'keptBreakSeconds': PropertySchema(
      id: 5,
      name: r'keptBreakSeconds',
      type: IsarType.long,
    ),
    r'resetDate': PropertySchema(
      id: 6,
      name: r'resetDate',
      type: IsarType.dateTime,
    ),
    r'subjectDataBeforeReset': PropertySchema(
      id: 7,
      name: r'subjectDataBeforeReset',
      type: IsarType.stringList,
    )
  },
  estimateSize: _dailyResetEstimateSize,
  serialize: _dailyResetSerialize,
  deserialize: _dailyResetDeserialize,
  deserializeProp: _dailyResetDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {},
  embeddedSchemas: {},
  getId: _dailyResetGetId,
  getLinks: _dailyResetGetLinks,
  attach: _dailyResetAttach,
  version: '3.1.0+1',
);

int _dailyResetEstimateSize(
  DailyReset object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.action.length * 3;
  bytesCount += 3 + object.subjectDataBeforeReset.length * 3;
  {
    for (var i = 0; i < object.subjectDataBeforeReset.length; i++) {
      final value = object.subjectDataBeforeReset[i];
      bytesCount += value.length * 3;
    }
  }
  return bytesCount;
}

void _dailyResetSerialize(
  DailyReset object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.action);
  writer.writeLong(offsets[1], object.breakTimeAfterReset);
  writer.writeLong(offsets[2], object.breakTimeBeforeReset);
  writer.writeDateTime(offsets[3], object.executedAt);
  writer.writeBool(offsets[4], object.isManual);
  writer.writeLong(offsets[5], object.keptBreakSeconds);
  writer.writeDateTime(offsets[6], object.resetDate);
  writer.writeStringList(offsets[7], object.subjectDataBeforeReset);
}

DailyReset _dailyResetDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = DailyReset(
    action: reader.readString(offsets[0]),
    breakTimeAfterReset: reader.readLong(offsets[1]),
    breakTimeBeforeReset: reader.readLong(offsets[2]),
    isManual: reader.readBoolOrNull(offsets[4]) ?? false,
    keptBreakSeconds: reader.readLongOrNull(offsets[5]),
    resetDate: reader.readDateTime(offsets[6]),
  );
  object.executedAt = reader.readDateTime(offsets[3]);
  object.id = id;
  object.subjectDataBeforeReset = reader.readStringList(offsets[7]) ?? [];
  return object;
}

P _dailyResetDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readString(offset)) as P;
    case 1:
      return (reader.readLong(offset)) as P;
    case 2:
      return (reader.readLong(offset)) as P;
    case 3:
      return (reader.readDateTime(offset)) as P;
    case 4:
      return (reader.readBoolOrNull(offset) ?? false) as P;
    case 5:
      return (reader.readLongOrNull(offset)) as P;
    case 6:
      return (reader.readDateTime(offset)) as P;
    case 7:
      return (reader.readStringList(offset) ?? []) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _dailyResetGetId(DailyReset object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _dailyResetGetLinks(DailyReset object) {
  return [];
}

void _dailyResetAttach(IsarCollection<dynamic> col, Id id, DailyReset object) {
  object.id = id;
}

extension DailyResetQueryWhereSort
    on QueryBuilder<DailyReset, DailyReset, QWhere> {
  QueryBuilder<DailyReset, DailyReset, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension DailyResetQueryWhere
    on QueryBuilder<DailyReset, DailyReset, QWhereClause> {
  QueryBuilder<DailyReset, DailyReset, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<DailyReset, DailyReset, QAfterWhereClause> idNotEqualTo(Id id) {
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

  QueryBuilder<DailyReset, DailyReset, QAfterWhereClause> idGreaterThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<DailyReset, DailyReset, QAfterWhereClause> idLessThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<DailyReset, DailyReset, QAfterWhereClause> idBetween(
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

extension DailyResetQueryFilter
    on QueryBuilder<DailyReset, DailyReset, QFilterCondition> {
  QueryBuilder<DailyReset, DailyReset, QAfterFilterCondition> actionEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'action',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DailyReset, DailyReset, QAfterFilterCondition> actionGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'action',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DailyReset, DailyReset, QAfterFilterCondition> actionLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'action',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DailyReset, DailyReset, QAfterFilterCondition> actionBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'action',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DailyReset, DailyReset, QAfterFilterCondition> actionStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'action',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DailyReset, DailyReset, QAfterFilterCondition> actionEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'action',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DailyReset, DailyReset, QAfterFilterCondition> actionContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'action',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DailyReset, DailyReset, QAfterFilterCondition> actionMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'action',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DailyReset, DailyReset, QAfterFilterCondition> actionIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'action',
        value: '',
      ));
    });
  }

  QueryBuilder<DailyReset, DailyReset, QAfterFilterCondition>
      actionIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'action',
        value: '',
      ));
    });
  }

  QueryBuilder<DailyReset, DailyReset, QAfterFilterCondition>
      breakTimeAfterResetEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'breakTimeAfterReset',
        value: value,
      ));
    });
  }

  QueryBuilder<DailyReset, DailyReset, QAfterFilterCondition>
      breakTimeAfterResetGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'breakTimeAfterReset',
        value: value,
      ));
    });
  }

  QueryBuilder<DailyReset, DailyReset, QAfterFilterCondition>
      breakTimeAfterResetLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'breakTimeAfterReset',
        value: value,
      ));
    });
  }

  QueryBuilder<DailyReset, DailyReset, QAfterFilterCondition>
      breakTimeAfterResetBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'breakTimeAfterReset',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<DailyReset, DailyReset, QAfterFilterCondition>
      breakTimeBeforeResetEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'breakTimeBeforeReset',
        value: value,
      ));
    });
  }

  QueryBuilder<DailyReset, DailyReset, QAfterFilterCondition>
      breakTimeBeforeResetGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'breakTimeBeforeReset',
        value: value,
      ));
    });
  }

  QueryBuilder<DailyReset, DailyReset, QAfterFilterCondition>
      breakTimeBeforeResetLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'breakTimeBeforeReset',
        value: value,
      ));
    });
  }

  QueryBuilder<DailyReset, DailyReset, QAfterFilterCondition>
      breakTimeBeforeResetBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'breakTimeBeforeReset',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<DailyReset, DailyReset, QAfterFilterCondition> executedAtEqualTo(
      DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'executedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<DailyReset, DailyReset, QAfterFilterCondition>
      executedAtGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'executedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<DailyReset, DailyReset, QAfterFilterCondition>
      executedAtLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'executedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<DailyReset, DailyReset, QAfterFilterCondition> executedAtBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'executedAt',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<DailyReset, DailyReset, QAfterFilterCondition> idEqualTo(
      Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<DailyReset, DailyReset, QAfterFilterCondition> idGreaterThan(
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

  QueryBuilder<DailyReset, DailyReset, QAfterFilterCondition> idLessThan(
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

  QueryBuilder<DailyReset, DailyReset, QAfterFilterCondition> idBetween(
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

  QueryBuilder<DailyReset, DailyReset, QAfterFilterCondition> isManualEqualTo(
      bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isManual',
        value: value,
      ));
    });
  }

  QueryBuilder<DailyReset, DailyReset, QAfterFilterCondition>
      keptBreakSecondsIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'keptBreakSeconds',
      ));
    });
  }

  QueryBuilder<DailyReset, DailyReset, QAfterFilterCondition>
      keptBreakSecondsIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'keptBreakSeconds',
      ));
    });
  }

  QueryBuilder<DailyReset, DailyReset, QAfterFilterCondition>
      keptBreakSecondsEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'keptBreakSeconds',
        value: value,
      ));
    });
  }

  QueryBuilder<DailyReset, DailyReset, QAfterFilterCondition>
      keptBreakSecondsGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'keptBreakSeconds',
        value: value,
      ));
    });
  }

  QueryBuilder<DailyReset, DailyReset, QAfterFilterCondition>
      keptBreakSecondsLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'keptBreakSeconds',
        value: value,
      ));
    });
  }

  QueryBuilder<DailyReset, DailyReset, QAfterFilterCondition>
      keptBreakSecondsBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'keptBreakSeconds',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<DailyReset, DailyReset, QAfterFilterCondition> resetDateEqualTo(
      DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'resetDate',
        value: value,
      ));
    });
  }

  QueryBuilder<DailyReset, DailyReset, QAfterFilterCondition>
      resetDateGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'resetDate',
        value: value,
      ));
    });
  }

  QueryBuilder<DailyReset, DailyReset, QAfterFilterCondition> resetDateLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'resetDate',
        value: value,
      ));
    });
  }

  QueryBuilder<DailyReset, DailyReset, QAfterFilterCondition> resetDateBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'resetDate',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<DailyReset, DailyReset, QAfterFilterCondition>
      subjectDataBeforeResetElementEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'subjectDataBeforeReset',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DailyReset, DailyReset, QAfterFilterCondition>
      subjectDataBeforeResetElementGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'subjectDataBeforeReset',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DailyReset, DailyReset, QAfterFilterCondition>
      subjectDataBeforeResetElementLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'subjectDataBeforeReset',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DailyReset, DailyReset, QAfterFilterCondition>
      subjectDataBeforeResetElementBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'subjectDataBeforeReset',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DailyReset, DailyReset, QAfterFilterCondition>
      subjectDataBeforeResetElementStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'subjectDataBeforeReset',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DailyReset, DailyReset, QAfterFilterCondition>
      subjectDataBeforeResetElementEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'subjectDataBeforeReset',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DailyReset, DailyReset, QAfterFilterCondition>
      subjectDataBeforeResetElementContains(String value,
          {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'subjectDataBeforeReset',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DailyReset, DailyReset, QAfterFilterCondition>
      subjectDataBeforeResetElementMatches(String pattern,
          {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'subjectDataBeforeReset',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DailyReset, DailyReset, QAfterFilterCondition>
      subjectDataBeforeResetElementIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'subjectDataBeforeReset',
        value: '',
      ));
    });
  }

  QueryBuilder<DailyReset, DailyReset, QAfterFilterCondition>
      subjectDataBeforeResetElementIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'subjectDataBeforeReset',
        value: '',
      ));
    });
  }

  QueryBuilder<DailyReset, DailyReset, QAfterFilterCondition>
      subjectDataBeforeResetLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'subjectDataBeforeReset',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<DailyReset, DailyReset, QAfterFilterCondition>
      subjectDataBeforeResetIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'subjectDataBeforeReset',
        0,
        true,
        0,
        true,
      );
    });
  }

  QueryBuilder<DailyReset, DailyReset, QAfterFilterCondition>
      subjectDataBeforeResetIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'subjectDataBeforeReset',
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<DailyReset, DailyReset, QAfterFilterCondition>
      subjectDataBeforeResetLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'subjectDataBeforeReset',
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<DailyReset, DailyReset, QAfterFilterCondition>
      subjectDataBeforeResetLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'subjectDataBeforeReset',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<DailyReset, DailyReset, QAfterFilterCondition>
      subjectDataBeforeResetLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'subjectDataBeforeReset',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }
}

extension DailyResetQueryObject
    on QueryBuilder<DailyReset, DailyReset, QFilterCondition> {}

extension DailyResetQueryLinks
    on QueryBuilder<DailyReset, DailyReset, QFilterCondition> {}

extension DailyResetQuerySortBy
    on QueryBuilder<DailyReset, DailyReset, QSortBy> {
  QueryBuilder<DailyReset, DailyReset, QAfterSortBy> sortByAction() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'action', Sort.asc);
    });
  }

  QueryBuilder<DailyReset, DailyReset, QAfterSortBy> sortByActionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'action', Sort.desc);
    });
  }

  QueryBuilder<DailyReset, DailyReset, QAfterSortBy>
      sortByBreakTimeAfterReset() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'breakTimeAfterReset', Sort.asc);
    });
  }

  QueryBuilder<DailyReset, DailyReset, QAfterSortBy>
      sortByBreakTimeAfterResetDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'breakTimeAfterReset', Sort.desc);
    });
  }

  QueryBuilder<DailyReset, DailyReset, QAfterSortBy>
      sortByBreakTimeBeforeReset() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'breakTimeBeforeReset', Sort.asc);
    });
  }

  QueryBuilder<DailyReset, DailyReset, QAfterSortBy>
      sortByBreakTimeBeforeResetDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'breakTimeBeforeReset', Sort.desc);
    });
  }

  QueryBuilder<DailyReset, DailyReset, QAfterSortBy> sortByExecutedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'executedAt', Sort.asc);
    });
  }

  QueryBuilder<DailyReset, DailyReset, QAfterSortBy> sortByExecutedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'executedAt', Sort.desc);
    });
  }

  QueryBuilder<DailyReset, DailyReset, QAfterSortBy> sortByIsManual() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isManual', Sort.asc);
    });
  }

  QueryBuilder<DailyReset, DailyReset, QAfterSortBy> sortByIsManualDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isManual', Sort.desc);
    });
  }

  QueryBuilder<DailyReset, DailyReset, QAfterSortBy> sortByKeptBreakSeconds() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'keptBreakSeconds', Sort.asc);
    });
  }

  QueryBuilder<DailyReset, DailyReset, QAfterSortBy>
      sortByKeptBreakSecondsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'keptBreakSeconds', Sort.desc);
    });
  }

  QueryBuilder<DailyReset, DailyReset, QAfterSortBy> sortByResetDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'resetDate', Sort.asc);
    });
  }

  QueryBuilder<DailyReset, DailyReset, QAfterSortBy> sortByResetDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'resetDate', Sort.desc);
    });
  }
}

extension DailyResetQuerySortThenBy
    on QueryBuilder<DailyReset, DailyReset, QSortThenBy> {
  QueryBuilder<DailyReset, DailyReset, QAfterSortBy> thenByAction() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'action', Sort.asc);
    });
  }

  QueryBuilder<DailyReset, DailyReset, QAfterSortBy> thenByActionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'action', Sort.desc);
    });
  }

  QueryBuilder<DailyReset, DailyReset, QAfterSortBy>
      thenByBreakTimeAfterReset() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'breakTimeAfterReset', Sort.asc);
    });
  }

  QueryBuilder<DailyReset, DailyReset, QAfterSortBy>
      thenByBreakTimeAfterResetDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'breakTimeAfterReset', Sort.desc);
    });
  }

  QueryBuilder<DailyReset, DailyReset, QAfterSortBy>
      thenByBreakTimeBeforeReset() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'breakTimeBeforeReset', Sort.asc);
    });
  }

  QueryBuilder<DailyReset, DailyReset, QAfterSortBy>
      thenByBreakTimeBeforeResetDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'breakTimeBeforeReset', Sort.desc);
    });
  }

  QueryBuilder<DailyReset, DailyReset, QAfterSortBy> thenByExecutedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'executedAt', Sort.asc);
    });
  }

  QueryBuilder<DailyReset, DailyReset, QAfterSortBy> thenByExecutedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'executedAt', Sort.desc);
    });
  }

  QueryBuilder<DailyReset, DailyReset, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<DailyReset, DailyReset, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<DailyReset, DailyReset, QAfterSortBy> thenByIsManual() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isManual', Sort.asc);
    });
  }

  QueryBuilder<DailyReset, DailyReset, QAfterSortBy> thenByIsManualDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isManual', Sort.desc);
    });
  }

  QueryBuilder<DailyReset, DailyReset, QAfterSortBy> thenByKeptBreakSeconds() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'keptBreakSeconds', Sort.asc);
    });
  }

  QueryBuilder<DailyReset, DailyReset, QAfterSortBy>
      thenByKeptBreakSecondsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'keptBreakSeconds', Sort.desc);
    });
  }

  QueryBuilder<DailyReset, DailyReset, QAfterSortBy> thenByResetDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'resetDate', Sort.asc);
    });
  }

  QueryBuilder<DailyReset, DailyReset, QAfterSortBy> thenByResetDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'resetDate', Sort.desc);
    });
  }
}

extension DailyResetQueryWhereDistinct
    on QueryBuilder<DailyReset, DailyReset, QDistinct> {
  QueryBuilder<DailyReset, DailyReset, QDistinct> distinctByAction(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'action', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<DailyReset, DailyReset, QDistinct>
      distinctByBreakTimeAfterReset() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'breakTimeAfterReset');
    });
  }

  QueryBuilder<DailyReset, DailyReset, QDistinct>
      distinctByBreakTimeBeforeReset() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'breakTimeBeforeReset');
    });
  }

  QueryBuilder<DailyReset, DailyReset, QDistinct> distinctByExecutedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'executedAt');
    });
  }

  QueryBuilder<DailyReset, DailyReset, QDistinct> distinctByIsManual() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isManual');
    });
  }

  QueryBuilder<DailyReset, DailyReset, QDistinct> distinctByKeptBreakSeconds() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'keptBreakSeconds');
    });
  }

  QueryBuilder<DailyReset, DailyReset, QDistinct> distinctByResetDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'resetDate');
    });
  }

  QueryBuilder<DailyReset, DailyReset, QDistinct>
      distinctBySubjectDataBeforeReset() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'subjectDataBeforeReset');
    });
  }
}

extension DailyResetQueryProperty
    on QueryBuilder<DailyReset, DailyReset, QQueryProperty> {
  QueryBuilder<DailyReset, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<DailyReset, String, QQueryOperations> actionProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'action');
    });
  }

  QueryBuilder<DailyReset, int, QQueryOperations>
      breakTimeAfterResetProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'breakTimeAfterReset');
    });
  }

  QueryBuilder<DailyReset, int, QQueryOperations>
      breakTimeBeforeResetProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'breakTimeBeforeReset');
    });
  }

  QueryBuilder<DailyReset, DateTime, QQueryOperations> executedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'executedAt');
    });
  }

  QueryBuilder<DailyReset, bool, QQueryOperations> isManualProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isManual');
    });
  }

  QueryBuilder<DailyReset, int?, QQueryOperations> keptBreakSecondsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'keptBreakSeconds');
    });
  }

  QueryBuilder<DailyReset, DateTime, QQueryOperations> resetDateProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'resetDate');
    });
  }

  QueryBuilder<DailyReset, List<String>, QQueryOperations>
      subjectDataBeforeResetProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'subjectDataBeforeReset');
    });
  }
}
