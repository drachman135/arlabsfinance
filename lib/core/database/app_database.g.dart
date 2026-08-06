// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $ClientProfilesTable extends ClientProfiles
    with TableInfo<$ClientProfilesTable, ClientProfile> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ClientProfilesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _emailMeta = const VerificationMeta('email');
  @override
  late final GeneratedColumn<String> email = GeneratedColumn<String>(
    'email',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _phoneMeta = const VerificationMeta('phone');
  @override
  late final GeneratedColumn<String> phone = GeneratedColumn<String>(
    'phone',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [id, name, email, phone, updatedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'client_profiles';
  @override
  VerificationContext validateIntegrity(
    Insertable<ClientProfile> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('email')) {
      context.handle(
        _emailMeta,
        email.isAcceptableOrUnknown(data['email']!, _emailMeta),
      );
    } else if (isInserting) {
      context.missing(_emailMeta);
    }
    if (data.containsKey('phone')) {
      context.handle(
        _phoneMeta,
        phone.isAcceptableOrUnknown(data['phone']!, _phoneMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ClientProfile map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ClientProfile(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      email: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}email'],
      )!,
      phone: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}phone'],
      ),
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      ),
    );
  }

  @override
  $ClientProfilesTable createAlias(String alias) {
    return $ClientProfilesTable(attachedDatabase, alias);
  }
}

class ClientProfile extends DataClass implements Insertable<ClientProfile> {
  final String id;
  final String name;
  final String email;
  final String? phone;
  final DateTime? updatedAt;
  const ClientProfile({
    required this.id,
    required this.name,
    required this.email,
    this.phone,
    this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    map['email'] = Variable<String>(email);
    if (!nullToAbsent || phone != null) {
      map['phone'] = Variable<String>(phone);
    }
    if (!nullToAbsent || updatedAt != null) {
      map['updated_at'] = Variable<DateTime>(updatedAt);
    }
    return map;
  }

  ClientProfilesCompanion toCompanion(bool nullToAbsent) {
    return ClientProfilesCompanion(
      id: Value(id),
      name: Value(name),
      email: Value(email),
      phone: phone == null && nullToAbsent
          ? const Value.absent()
          : Value(phone),
      updatedAt: updatedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(updatedAt),
    );
  }

  factory ClientProfile.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ClientProfile(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      email: serializer.fromJson<String>(json['email']),
      phone: serializer.fromJson<String?>(json['phone']),
      updatedAt: serializer.fromJson<DateTime?>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'email': serializer.toJson<String>(email),
      'phone': serializer.toJson<String?>(phone),
      'updatedAt': serializer.toJson<DateTime?>(updatedAt),
    };
  }

  ClientProfile copyWith({
    String? id,
    String? name,
    String? email,
    Value<String?> phone = const Value.absent(),
    Value<DateTime?> updatedAt = const Value.absent(),
  }) => ClientProfile(
    id: id ?? this.id,
    name: name ?? this.name,
    email: email ?? this.email,
    phone: phone.present ? phone.value : this.phone,
    updatedAt: updatedAt.present ? updatedAt.value : this.updatedAt,
  );
  ClientProfile copyWithCompanion(ClientProfilesCompanion data) {
    return ClientProfile(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      email: data.email.present ? data.email.value : this.email,
      phone: data.phone.present ? data.phone.value : this.phone,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ClientProfile(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('email: $email, ')
          ..write('phone: $phone, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, email, phone, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ClientProfile &&
          other.id == this.id &&
          other.name == this.name &&
          other.email == this.email &&
          other.phone == this.phone &&
          other.updatedAt == this.updatedAt);
}

class ClientProfilesCompanion extends UpdateCompanion<ClientProfile> {
  final Value<String> id;
  final Value<String> name;
  final Value<String> email;
  final Value<String?> phone;
  final Value<DateTime?> updatedAt;
  final Value<int> rowid;
  const ClientProfilesCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.email = const Value.absent(),
    this.phone = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ClientProfilesCompanion.insert({
    required String id,
    required String name,
    required String email,
    this.phone = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       name = Value(name),
       email = Value(email);
  static Insertable<ClientProfile> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? email,
    Expression<String>? phone,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (email != null) 'email': email,
      if (phone != null) 'phone': phone,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ClientProfilesCompanion copyWith({
    Value<String>? id,
    Value<String>? name,
    Value<String>? email,
    Value<String?>? phone,
    Value<DateTime?>? updatedAt,
    Value<int>? rowid,
  }) {
    return ClientProfilesCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (email.present) {
      map['email'] = Variable<String>(email.value);
    }
    if (phone.present) {
      map['phone'] = Variable<String>(phone.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ClientProfilesCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('email: $email, ')
          ..write('phone: $phone, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $FinancialSummariesTable extends FinancialSummaries
    with TableInfo<$FinancialSummariesTable, FinancialSummary> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $FinancialSummariesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _clientIdMeta = const VerificationMeta(
    'clientId',
  );
  @override
  late final GeneratedColumn<String> clientId = GeneratedColumn<String>(
    'client_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _totalReceivableMeta = const VerificationMeta(
    'totalReceivable',
  );
  @override
  late final GeneratedColumn<double> totalReceivable = GeneratedColumn<double>(
    'total_receivable',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0.0),
  );
  static const VerificationMeta _outstandingMeta = const VerificationMeta(
    'outstanding',
  );
  @override
  late final GeneratedColumn<double> outstanding = GeneratedColumn<double>(
    'outstanding',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0.0),
  );
  static const VerificationMeta _paidMeta = const VerificationMeta('paid');
  @override
  late final GeneratedColumn<double> paid = GeneratedColumn<double>(
    'paid',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0.0),
  );
  static const VerificationMeta _nextDueAmountMeta = const VerificationMeta(
    'nextDueAmount',
  );
  @override
  late final GeneratedColumn<double> nextDueAmount = GeneratedColumn<double>(
    'next_due_amount',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0.0),
  );
  static const VerificationMeta _nextDueDateMeta = const VerificationMeta(
    'nextDueDate',
  );
  @override
  late final GeneratedColumn<DateTime> nextDueDate = GeneratedColumn<DateTime>(
    'next_due_date',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    clientId,
    totalReceivable,
    outstanding,
    paid,
    nextDueAmount,
    nextDueDate,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'financial_summaries';
  @override
  VerificationContext validateIntegrity(
    Insertable<FinancialSummary> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('client_id')) {
      context.handle(
        _clientIdMeta,
        clientId.isAcceptableOrUnknown(data['client_id']!, _clientIdMeta),
      );
    } else if (isInserting) {
      context.missing(_clientIdMeta);
    }
    if (data.containsKey('total_receivable')) {
      context.handle(
        _totalReceivableMeta,
        totalReceivable.isAcceptableOrUnknown(
          data['total_receivable']!,
          _totalReceivableMeta,
        ),
      );
    }
    if (data.containsKey('outstanding')) {
      context.handle(
        _outstandingMeta,
        outstanding.isAcceptableOrUnknown(
          data['outstanding']!,
          _outstandingMeta,
        ),
      );
    }
    if (data.containsKey('paid')) {
      context.handle(
        _paidMeta,
        paid.isAcceptableOrUnknown(data['paid']!, _paidMeta),
      );
    }
    if (data.containsKey('next_due_amount')) {
      context.handle(
        _nextDueAmountMeta,
        nextDueAmount.isAcceptableOrUnknown(
          data['next_due_amount']!,
          _nextDueAmountMeta,
        ),
      );
    }
    if (data.containsKey('next_due_date')) {
      context.handle(
        _nextDueDateMeta,
        nextDueDate.isAcceptableOrUnknown(
          data['next_due_date']!,
          _nextDueDateMeta,
        ),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {clientId};
  @override
  FinancialSummary map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return FinancialSummary(
      clientId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}client_id'],
      )!,
      totalReceivable: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}total_receivable'],
      )!,
      outstanding: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}outstanding'],
      )!,
      paid: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}paid'],
      )!,
      nextDueAmount: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}next_due_amount'],
      )!,
      nextDueDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}next_due_date'],
      ),
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      ),
    );
  }

  @override
  $FinancialSummariesTable createAlias(String alias) {
    return $FinancialSummariesTable(attachedDatabase, alias);
  }
}

class FinancialSummary extends DataClass
    implements Insertable<FinancialSummary> {
  final String clientId;
  final double totalReceivable;
  final double outstanding;
  final double paid;
  final double nextDueAmount;
  final DateTime? nextDueDate;
  final DateTime? updatedAt;
  const FinancialSummary({
    required this.clientId,
    required this.totalReceivable,
    required this.outstanding,
    required this.paid,
    required this.nextDueAmount,
    this.nextDueDate,
    this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['client_id'] = Variable<String>(clientId);
    map['total_receivable'] = Variable<double>(totalReceivable);
    map['outstanding'] = Variable<double>(outstanding);
    map['paid'] = Variable<double>(paid);
    map['next_due_amount'] = Variable<double>(nextDueAmount);
    if (!nullToAbsent || nextDueDate != null) {
      map['next_due_date'] = Variable<DateTime>(nextDueDate);
    }
    if (!nullToAbsent || updatedAt != null) {
      map['updated_at'] = Variable<DateTime>(updatedAt);
    }
    return map;
  }

  FinancialSummariesCompanion toCompanion(bool nullToAbsent) {
    return FinancialSummariesCompanion(
      clientId: Value(clientId),
      totalReceivable: Value(totalReceivable),
      outstanding: Value(outstanding),
      paid: Value(paid),
      nextDueAmount: Value(nextDueAmount),
      nextDueDate: nextDueDate == null && nullToAbsent
          ? const Value.absent()
          : Value(nextDueDate),
      updatedAt: updatedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(updatedAt),
    );
  }

  factory FinancialSummary.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return FinancialSummary(
      clientId: serializer.fromJson<String>(json['clientId']),
      totalReceivable: serializer.fromJson<double>(json['totalReceivable']),
      outstanding: serializer.fromJson<double>(json['outstanding']),
      paid: serializer.fromJson<double>(json['paid']),
      nextDueAmount: serializer.fromJson<double>(json['nextDueAmount']),
      nextDueDate: serializer.fromJson<DateTime?>(json['nextDueDate']),
      updatedAt: serializer.fromJson<DateTime?>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'clientId': serializer.toJson<String>(clientId),
      'totalReceivable': serializer.toJson<double>(totalReceivable),
      'outstanding': serializer.toJson<double>(outstanding),
      'paid': serializer.toJson<double>(paid),
      'nextDueAmount': serializer.toJson<double>(nextDueAmount),
      'nextDueDate': serializer.toJson<DateTime?>(nextDueDate),
      'updatedAt': serializer.toJson<DateTime?>(updatedAt),
    };
  }

  FinancialSummary copyWith({
    String? clientId,
    double? totalReceivable,
    double? outstanding,
    double? paid,
    double? nextDueAmount,
    Value<DateTime?> nextDueDate = const Value.absent(),
    Value<DateTime?> updatedAt = const Value.absent(),
  }) => FinancialSummary(
    clientId: clientId ?? this.clientId,
    totalReceivable: totalReceivable ?? this.totalReceivable,
    outstanding: outstanding ?? this.outstanding,
    paid: paid ?? this.paid,
    nextDueAmount: nextDueAmount ?? this.nextDueAmount,
    nextDueDate: nextDueDate.present ? nextDueDate.value : this.nextDueDate,
    updatedAt: updatedAt.present ? updatedAt.value : this.updatedAt,
  );
  FinancialSummary copyWithCompanion(FinancialSummariesCompanion data) {
    return FinancialSummary(
      clientId: data.clientId.present ? data.clientId.value : this.clientId,
      totalReceivable: data.totalReceivable.present
          ? data.totalReceivable.value
          : this.totalReceivable,
      outstanding: data.outstanding.present
          ? data.outstanding.value
          : this.outstanding,
      paid: data.paid.present ? data.paid.value : this.paid,
      nextDueAmount: data.nextDueAmount.present
          ? data.nextDueAmount.value
          : this.nextDueAmount,
      nextDueDate: data.nextDueDate.present
          ? data.nextDueDate.value
          : this.nextDueDate,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('FinancialSummary(')
          ..write('clientId: $clientId, ')
          ..write('totalReceivable: $totalReceivable, ')
          ..write('outstanding: $outstanding, ')
          ..write('paid: $paid, ')
          ..write('nextDueAmount: $nextDueAmount, ')
          ..write('nextDueDate: $nextDueDate, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    clientId,
    totalReceivable,
    outstanding,
    paid,
    nextDueAmount,
    nextDueDate,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is FinancialSummary &&
          other.clientId == this.clientId &&
          other.totalReceivable == this.totalReceivable &&
          other.outstanding == this.outstanding &&
          other.paid == this.paid &&
          other.nextDueAmount == this.nextDueAmount &&
          other.nextDueDate == this.nextDueDate &&
          other.updatedAt == this.updatedAt);
}

class FinancialSummariesCompanion extends UpdateCompanion<FinancialSummary> {
  final Value<String> clientId;
  final Value<double> totalReceivable;
  final Value<double> outstanding;
  final Value<double> paid;
  final Value<double> nextDueAmount;
  final Value<DateTime?> nextDueDate;
  final Value<DateTime?> updatedAt;
  final Value<int> rowid;
  const FinancialSummariesCompanion({
    this.clientId = const Value.absent(),
    this.totalReceivable = const Value.absent(),
    this.outstanding = const Value.absent(),
    this.paid = const Value.absent(),
    this.nextDueAmount = const Value.absent(),
    this.nextDueDate = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  FinancialSummariesCompanion.insert({
    required String clientId,
    this.totalReceivable = const Value.absent(),
    this.outstanding = const Value.absent(),
    this.paid = const Value.absent(),
    this.nextDueAmount = const Value.absent(),
    this.nextDueDate = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : clientId = Value(clientId);
  static Insertable<FinancialSummary> custom({
    Expression<String>? clientId,
    Expression<double>? totalReceivable,
    Expression<double>? outstanding,
    Expression<double>? paid,
    Expression<double>? nextDueAmount,
    Expression<DateTime>? nextDueDate,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (clientId != null) 'client_id': clientId,
      if (totalReceivable != null) 'total_receivable': totalReceivable,
      if (outstanding != null) 'outstanding': outstanding,
      if (paid != null) 'paid': paid,
      if (nextDueAmount != null) 'next_due_amount': nextDueAmount,
      if (nextDueDate != null) 'next_due_date': nextDueDate,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  FinancialSummariesCompanion copyWith({
    Value<String>? clientId,
    Value<double>? totalReceivable,
    Value<double>? outstanding,
    Value<double>? paid,
    Value<double>? nextDueAmount,
    Value<DateTime?>? nextDueDate,
    Value<DateTime?>? updatedAt,
    Value<int>? rowid,
  }) {
    return FinancialSummariesCompanion(
      clientId: clientId ?? this.clientId,
      totalReceivable: totalReceivable ?? this.totalReceivable,
      outstanding: outstanding ?? this.outstanding,
      paid: paid ?? this.paid,
      nextDueAmount: nextDueAmount ?? this.nextDueAmount,
      nextDueDate: nextDueDate ?? this.nextDueDate,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (clientId.present) {
      map['client_id'] = Variable<String>(clientId.value);
    }
    if (totalReceivable.present) {
      map['total_receivable'] = Variable<double>(totalReceivable.value);
    }
    if (outstanding.present) {
      map['outstanding'] = Variable<double>(outstanding.value);
    }
    if (paid.present) {
      map['paid'] = Variable<double>(paid.value);
    }
    if (nextDueAmount.present) {
      map['next_due_amount'] = Variable<double>(nextDueAmount.value);
    }
    if (nextDueDate.present) {
      map['next_due_date'] = Variable<DateTime>(nextDueDate.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('FinancialSummariesCompanion(')
          ..write('clientId: $clientId, ')
          ..write('totalReceivable: $totalReceivable, ')
          ..write('outstanding: $outstanding, ')
          ..write('paid: $paid, ')
          ..write('nextDueAmount: $nextDueAmount, ')
          ..write('nextDueDate: $nextDueDate, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $RecentTransactionsTable extends RecentTransactions
    with TableInfo<$RecentTransactionsTable, RecentTransaction> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RecentTransactionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _clientIdMeta = const VerificationMeta(
    'clientId',
  );
  @override
  late final GeneratedColumn<String> clientId = GeneratedColumn<String>(
    'client_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _amountMeta = const VerificationMeta('amount');
  @override
  late final GeneratedColumn<double> amount = GeneratedColumn<double>(
    'amount',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<DateTime> date = GeneratedColumn<DateTime>(
    'date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
    'type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    clientId,
    title,
    amount,
    date,
    type,
    status,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'recent_transactions';
  @override
  VerificationContext validateIntegrity(
    Insertable<RecentTransaction> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('client_id')) {
      context.handle(
        _clientIdMeta,
        clientId.isAcceptableOrUnknown(data['client_id']!, _clientIdMeta),
      );
    } else if (isInserting) {
      context.missing(_clientIdMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('amount')) {
      context.handle(
        _amountMeta,
        amount.isAcceptableOrUnknown(data['amount']!, _amountMeta),
      );
    } else if (isInserting) {
      context.missing(_amountMeta);
    }
    if (data.containsKey('date')) {
      context.handle(
        _dateMeta,
        date.isAcceptableOrUnknown(data['date']!, _dateMeta),
      );
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('type')) {
      context.handle(
        _typeMeta,
        type.isAcceptableOrUnknown(data['type']!, _typeMeta),
      );
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    } else if (isInserting) {
      context.missing(_statusMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  RecentTransaction map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return RecentTransaction(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      clientId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}client_id'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      amount: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}amount'],
      )!,
      date: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}date'],
      )!,
      type: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}type'],
      )!,
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
    );
  }

  @override
  $RecentTransactionsTable createAlias(String alias) {
    return $RecentTransactionsTable(attachedDatabase, alias);
  }
}

class RecentTransaction extends DataClass
    implements Insertable<RecentTransaction> {
  final String id;
  final String clientId;
  final String title;
  final double amount;
  final DateTime date;

  /// Type of transaction: 'debt', 'payment', 'reminder'
  final String type;

  /// Status: 'pending', 'paid', 'overdue'
  final String status;
  const RecentTransaction({
    required this.id,
    required this.clientId,
    required this.title,
    required this.amount,
    required this.date,
    required this.type,
    required this.status,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['client_id'] = Variable<String>(clientId);
    map['title'] = Variable<String>(title);
    map['amount'] = Variable<double>(amount);
    map['date'] = Variable<DateTime>(date);
    map['type'] = Variable<String>(type);
    map['status'] = Variable<String>(status);
    return map;
  }

  RecentTransactionsCompanion toCompanion(bool nullToAbsent) {
    return RecentTransactionsCompanion(
      id: Value(id),
      clientId: Value(clientId),
      title: Value(title),
      amount: Value(amount),
      date: Value(date),
      type: Value(type),
      status: Value(status),
    );
  }

  factory RecentTransaction.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return RecentTransaction(
      id: serializer.fromJson<String>(json['id']),
      clientId: serializer.fromJson<String>(json['clientId']),
      title: serializer.fromJson<String>(json['title']),
      amount: serializer.fromJson<double>(json['amount']),
      date: serializer.fromJson<DateTime>(json['date']),
      type: serializer.fromJson<String>(json['type']),
      status: serializer.fromJson<String>(json['status']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'clientId': serializer.toJson<String>(clientId),
      'title': serializer.toJson<String>(title),
      'amount': serializer.toJson<double>(amount),
      'date': serializer.toJson<DateTime>(date),
      'type': serializer.toJson<String>(type),
      'status': serializer.toJson<String>(status),
    };
  }

  RecentTransaction copyWith({
    String? id,
    String? clientId,
    String? title,
    double? amount,
    DateTime? date,
    String? type,
    String? status,
  }) => RecentTransaction(
    id: id ?? this.id,
    clientId: clientId ?? this.clientId,
    title: title ?? this.title,
    amount: amount ?? this.amount,
    date: date ?? this.date,
    type: type ?? this.type,
    status: status ?? this.status,
  );
  RecentTransaction copyWithCompanion(RecentTransactionsCompanion data) {
    return RecentTransaction(
      id: data.id.present ? data.id.value : this.id,
      clientId: data.clientId.present ? data.clientId.value : this.clientId,
      title: data.title.present ? data.title.value : this.title,
      amount: data.amount.present ? data.amount.value : this.amount,
      date: data.date.present ? data.date.value : this.date,
      type: data.type.present ? data.type.value : this.type,
      status: data.status.present ? data.status.value : this.status,
    );
  }

  @override
  String toString() {
    return (StringBuffer('RecentTransaction(')
          ..write('id: $id, ')
          ..write('clientId: $clientId, ')
          ..write('title: $title, ')
          ..write('amount: $amount, ')
          ..write('date: $date, ')
          ..write('type: $type, ')
          ..write('status: $status')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, clientId, title, amount, date, type, status);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is RecentTransaction &&
          other.id == this.id &&
          other.clientId == this.clientId &&
          other.title == this.title &&
          other.amount == this.amount &&
          other.date == this.date &&
          other.type == this.type &&
          other.status == this.status);
}

class RecentTransactionsCompanion extends UpdateCompanion<RecentTransaction> {
  final Value<String> id;
  final Value<String> clientId;
  final Value<String> title;
  final Value<double> amount;
  final Value<DateTime> date;
  final Value<String> type;
  final Value<String> status;
  final Value<int> rowid;
  const RecentTransactionsCompanion({
    this.id = const Value.absent(),
    this.clientId = const Value.absent(),
    this.title = const Value.absent(),
    this.amount = const Value.absent(),
    this.date = const Value.absent(),
    this.type = const Value.absent(),
    this.status = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  RecentTransactionsCompanion.insert({
    required String id,
    required String clientId,
    required String title,
    required double amount,
    required DateTime date,
    required String type,
    required String status,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       clientId = Value(clientId),
       title = Value(title),
       amount = Value(amount),
       date = Value(date),
       type = Value(type),
       status = Value(status);
  static Insertable<RecentTransaction> custom({
    Expression<String>? id,
    Expression<String>? clientId,
    Expression<String>? title,
    Expression<double>? amount,
    Expression<DateTime>? date,
    Expression<String>? type,
    Expression<String>? status,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (clientId != null) 'client_id': clientId,
      if (title != null) 'title': title,
      if (amount != null) 'amount': amount,
      if (date != null) 'date': date,
      if (type != null) 'type': type,
      if (status != null) 'status': status,
      if (rowid != null) 'rowid': rowid,
    });
  }

  RecentTransactionsCompanion copyWith({
    Value<String>? id,
    Value<String>? clientId,
    Value<String>? title,
    Value<double>? amount,
    Value<DateTime>? date,
    Value<String>? type,
    Value<String>? status,
    Value<int>? rowid,
  }) {
    return RecentTransactionsCompanion(
      id: id ?? this.id,
      clientId: clientId ?? this.clientId,
      title: title ?? this.title,
      amount: amount ?? this.amount,
      date: date ?? this.date,
      type: type ?? this.type,
      status: status ?? this.status,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (clientId.present) {
      map['client_id'] = Variable<String>(clientId.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (amount.present) {
      map['amount'] = Variable<double>(amount.value);
    }
    if (date.present) {
      map['date'] = Variable<DateTime>(date.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RecentTransactionsCompanion(')
          ..write('id: $id, ')
          ..write('clientId: $clientId, ')
          ..write('title: $title, ')
          ..write('amount: $amount, ')
          ..write('date: $date, ')
          ..write('type: $type, ')
          ..write('status: $status, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ChatRoomsTable extends ChatRooms
    with TableInfo<$ChatRoomsTable, ChatRoomTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ChatRoomsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _clientIdMeta = const VerificationMeta(
    'clientId',
  );
  @override
  late final GeneratedColumn<String> clientId = GeneratedColumn<String>(
    'client_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _ownerIdMeta = const VerificationMeta(
    'ownerId',
  );
  @override
  late final GeneratedColumn<String> ownerId = GeneratedColumn<String>(
    'owner_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _ownerNameMeta = const VerificationMeta(
    'ownerName',
  );
  @override
  late final GeneratedColumn<String> ownerName = GeneratedColumn<String>(
    'owner_name',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _ownerAvatarMeta = const VerificationMeta(
    'ownerAvatar',
  );
  @override
  late final GeneratedColumn<String> ownerAvatar = GeneratedColumn<String>(
    'owner_avatar',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _lastMessageMeta = const VerificationMeta(
    'lastMessage',
  );
  @override
  late final GeneratedColumn<String> lastMessage = GeneratedColumn<String>(
    'last_message',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _lastMessageTimeMeta = const VerificationMeta(
    'lastMessageTime',
  );
  @override
  late final GeneratedColumn<DateTime> lastMessageTime =
      GeneratedColumn<DateTime>(
        'last_message_time',
        aliasedName,
        true,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _unreadCountMeta = const VerificationMeta(
    'unreadCount',
  );
  @override
  late final GeneratedColumn<int> unreadCount = GeneratedColumn<int>(
    'unread_count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    clientId,
    ownerId,
    ownerName,
    ownerAvatar,
    lastMessage,
    lastMessageTime,
    unreadCount,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'chat_rooms';
  @override
  VerificationContext validateIntegrity(
    Insertable<ChatRoomTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('client_id')) {
      context.handle(
        _clientIdMeta,
        clientId.isAcceptableOrUnknown(data['client_id']!, _clientIdMeta),
      );
    } else if (isInserting) {
      context.missing(_clientIdMeta);
    }
    if (data.containsKey('owner_id')) {
      context.handle(
        _ownerIdMeta,
        ownerId.isAcceptableOrUnknown(data['owner_id']!, _ownerIdMeta),
      );
    } else if (isInserting) {
      context.missing(_ownerIdMeta);
    }
    if (data.containsKey('owner_name')) {
      context.handle(
        _ownerNameMeta,
        ownerName.isAcceptableOrUnknown(data['owner_name']!, _ownerNameMeta),
      );
    }
    if (data.containsKey('owner_avatar')) {
      context.handle(
        _ownerAvatarMeta,
        ownerAvatar.isAcceptableOrUnknown(
          data['owner_avatar']!,
          _ownerAvatarMeta,
        ),
      );
    }
    if (data.containsKey('last_message')) {
      context.handle(
        _lastMessageMeta,
        lastMessage.isAcceptableOrUnknown(
          data['last_message']!,
          _lastMessageMeta,
        ),
      );
    }
    if (data.containsKey('last_message_time')) {
      context.handle(
        _lastMessageTimeMeta,
        lastMessageTime.isAcceptableOrUnknown(
          data['last_message_time']!,
          _lastMessageTimeMeta,
        ),
      );
    }
    if (data.containsKey('unread_count')) {
      context.handle(
        _unreadCountMeta,
        unreadCount.isAcceptableOrUnknown(
          data['unread_count']!,
          _unreadCountMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ChatRoomTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ChatRoomTableData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      clientId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}client_id'],
      )!,
      ownerId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}owner_id'],
      )!,
      ownerName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}owner_name'],
      ),
      ownerAvatar: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}owner_avatar'],
      ),
      lastMessage: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}last_message'],
      ),
      lastMessageTime: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}last_message_time'],
      ),
      unreadCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}unread_count'],
      )!,
    );
  }

  @override
  $ChatRoomsTable createAlias(String alias) {
    return $ChatRoomsTable(attachedDatabase, alias);
  }
}

class ChatRoomTableData extends DataClass
    implements Insertable<ChatRoomTableData> {
  final String id;
  final String clientId;
  final String ownerId;
  final String? ownerName;
  final String? ownerAvatar;
  final String? lastMessage;
  final DateTime? lastMessageTime;
  final int unreadCount;
  const ChatRoomTableData({
    required this.id,
    required this.clientId,
    required this.ownerId,
    this.ownerName,
    this.ownerAvatar,
    this.lastMessage,
    this.lastMessageTime,
    required this.unreadCount,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['client_id'] = Variable<String>(clientId);
    map['owner_id'] = Variable<String>(ownerId);
    if (!nullToAbsent || ownerName != null) {
      map['owner_name'] = Variable<String>(ownerName);
    }
    if (!nullToAbsent || ownerAvatar != null) {
      map['owner_avatar'] = Variable<String>(ownerAvatar);
    }
    if (!nullToAbsent || lastMessage != null) {
      map['last_message'] = Variable<String>(lastMessage);
    }
    if (!nullToAbsent || lastMessageTime != null) {
      map['last_message_time'] = Variable<DateTime>(lastMessageTime);
    }
    map['unread_count'] = Variable<int>(unreadCount);
    return map;
  }

  ChatRoomsCompanion toCompanion(bool nullToAbsent) {
    return ChatRoomsCompanion(
      id: Value(id),
      clientId: Value(clientId),
      ownerId: Value(ownerId),
      ownerName: ownerName == null && nullToAbsent
          ? const Value.absent()
          : Value(ownerName),
      ownerAvatar: ownerAvatar == null && nullToAbsent
          ? const Value.absent()
          : Value(ownerAvatar),
      lastMessage: lastMessage == null && nullToAbsent
          ? const Value.absent()
          : Value(lastMessage),
      lastMessageTime: lastMessageTime == null && nullToAbsent
          ? const Value.absent()
          : Value(lastMessageTime),
      unreadCount: Value(unreadCount),
    );
  }

  factory ChatRoomTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ChatRoomTableData(
      id: serializer.fromJson<String>(json['id']),
      clientId: serializer.fromJson<String>(json['clientId']),
      ownerId: serializer.fromJson<String>(json['ownerId']),
      ownerName: serializer.fromJson<String?>(json['ownerName']),
      ownerAvatar: serializer.fromJson<String?>(json['ownerAvatar']),
      lastMessage: serializer.fromJson<String?>(json['lastMessage']),
      lastMessageTime: serializer.fromJson<DateTime?>(json['lastMessageTime']),
      unreadCount: serializer.fromJson<int>(json['unreadCount']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'clientId': serializer.toJson<String>(clientId),
      'ownerId': serializer.toJson<String>(ownerId),
      'ownerName': serializer.toJson<String?>(ownerName),
      'ownerAvatar': serializer.toJson<String?>(ownerAvatar),
      'lastMessage': serializer.toJson<String?>(lastMessage),
      'lastMessageTime': serializer.toJson<DateTime?>(lastMessageTime),
      'unreadCount': serializer.toJson<int>(unreadCount),
    };
  }

  ChatRoomTableData copyWith({
    String? id,
    String? clientId,
    String? ownerId,
    Value<String?> ownerName = const Value.absent(),
    Value<String?> ownerAvatar = const Value.absent(),
    Value<String?> lastMessage = const Value.absent(),
    Value<DateTime?> lastMessageTime = const Value.absent(),
    int? unreadCount,
  }) => ChatRoomTableData(
    id: id ?? this.id,
    clientId: clientId ?? this.clientId,
    ownerId: ownerId ?? this.ownerId,
    ownerName: ownerName.present ? ownerName.value : this.ownerName,
    ownerAvatar: ownerAvatar.present ? ownerAvatar.value : this.ownerAvatar,
    lastMessage: lastMessage.present ? lastMessage.value : this.lastMessage,
    lastMessageTime: lastMessageTime.present
        ? lastMessageTime.value
        : this.lastMessageTime,
    unreadCount: unreadCount ?? this.unreadCount,
  );
  ChatRoomTableData copyWithCompanion(ChatRoomsCompanion data) {
    return ChatRoomTableData(
      id: data.id.present ? data.id.value : this.id,
      clientId: data.clientId.present ? data.clientId.value : this.clientId,
      ownerId: data.ownerId.present ? data.ownerId.value : this.ownerId,
      ownerName: data.ownerName.present ? data.ownerName.value : this.ownerName,
      ownerAvatar: data.ownerAvatar.present
          ? data.ownerAvatar.value
          : this.ownerAvatar,
      lastMessage: data.lastMessage.present
          ? data.lastMessage.value
          : this.lastMessage,
      lastMessageTime: data.lastMessageTime.present
          ? data.lastMessageTime.value
          : this.lastMessageTime,
      unreadCount: data.unreadCount.present
          ? data.unreadCount.value
          : this.unreadCount,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ChatRoomTableData(')
          ..write('id: $id, ')
          ..write('clientId: $clientId, ')
          ..write('ownerId: $ownerId, ')
          ..write('ownerName: $ownerName, ')
          ..write('ownerAvatar: $ownerAvatar, ')
          ..write('lastMessage: $lastMessage, ')
          ..write('lastMessageTime: $lastMessageTime, ')
          ..write('unreadCount: $unreadCount')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    clientId,
    ownerId,
    ownerName,
    ownerAvatar,
    lastMessage,
    lastMessageTime,
    unreadCount,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ChatRoomTableData &&
          other.id == this.id &&
          other.clientId == this.clientId &&
          other.ownerId == this.ownerId &&
          other.ownerName == this.ownerName &&
          other.ownerAvatar == this.ownerAvatar &&
          other.lastMessage == this.lastMessage &&
          other.lastMessageTime == this.lastMessageTime &&
          other.unreadCount == this.unreadCount);
}

class ChatRoomsCompanion extends UpdateCompanion<ChatRoomTableData> {
  final Value<String> id;
  final Value<String> clientId;
  final Value<String> ownerId;
  final Value<String?> ownerName;
  final Value<String?> ownerAvatar;
  final Value<String?> lastMessage;
  final Value<DateTime?> lastMessageTime;
  final Value<int> unreadCount;
  final Value<int> rowid;
  const ChatRoomsCompanion({
    this.id = const Value.absent(),
    this.clientId = const Value.absent(),
    this.ownerId = const Value.absent(),
    this.ownerName = const Value.absent(),
    this.ownerAvatar = const Value.absent(),
    this.lastMessage = const Value.absent(),
    this.lastMessageTime = const Value.absent(),
    this.unreadCount = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ChatRoomsCompanion.insert({
    required String id,
    required String clientId,
    required String ownerId,
    this.ownerName = const Value.absent(),
    this.ownerAvatar = const Value.absent(),
    this.lastMessage = const Value.absent(),
    this.lastMessageTime = const Value.absent(),
    this.unreadCount = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       clientId = Value(clientId),
       ownerId = Value(ownerId);
  static Insertable<ChatRoomTableData> custom({
    Expression<String>? id,
    Expression<String>? clientId,
    Expression<String>? ownerId,
    Expression<String>? ownerName,
    Expression<String>? ownerAvatar,
    Expression<String>? lastMessage,
    Expression<DateTime>? lastMessageTime,
    Expression<int>? unreadCount,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (clientId != null) 'client_id': clientId,
      if (ownerId != null) 'owner_id': ownerId,
      if (ownerName != null) 'owner_name': ownerName,
      if (ownerAvatar != null) 'owner_avatar': ownerAvatar,
      if (lastMessage != null) 'last_message': lastMessage,
      if (lastMessageTime != null) 'last_message_time': lastMessageTime,
      if (unreadCount != null) 'unread_count': unreadCount,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ChatRoomsCompanion copyWith({
    Value<String>? id,
    Value<String>? clientId,
    Value<String>? ownerId,
    Value<String?>? ownerName,
    Value<String?>? ownerAvatar,
    Value<String?>? lastMessage,
    Value<DateTime?>? lastMessageTime,
    Value<int>? unreadCount,
    Value<int>? rowid,
  }) {
    return ChatRoomsCompanion(
      id: id ?? this.id,
      clientId: clientId ?? this.clientId,
      ownerId: ownerId ?? this.ownerId,
      ownerName: ownerName ?? this.ownerName,
      ownerAvatar: ownerAvatar ?? this.ownerAvatar,
      lastMessage: lastMessage ?? this.lastMessage,
      lastMessageTime: lastMessageTime ?? this.lastMessageTime,
      unreadCount: unreadCount ?? this.unreadCount,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (clientId.present) {
      map['client_id'] = Variable<String>(clientId.value);
    }
    if (ownerId.present) {
      map['owner_id'] = Variable<String>(ownerId.value);
    }
    if (ownerName.present) {
      map['owner_name'] = Variable<String>(ownerName.value);
    }
    if (ownerAvatar.present) {
      map['owner_avatar'] = Variable<String>(ownerAvatar.value);
    }
    if (lastMessage.present) {
      map['last_message'] = Variable<String>(lastMessage.value);
    }
    if (lastMessageTime.present) {
      map['last_message_time'] = Variable<DateTime>(lastMessageTime.value);
    }
    if (unreadCount.present) {
      map['unread_count'] = Variable<int>(unreadCount.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ChatRoomsCompanion(')
          ..write('id: $id, ')
          ..write('clientId: $clientId, ')
          ..write('ownerId: $ownerId, ')
          ..write('ownerName: $ownerName, ')
          ..write('ownerAvatar: $ownerAvatar, ')
          ..write('lastMessage: $lastMessage, ')
          ..write('lastMessageTime: $lastMessageTime, ')
          ..write('unreadCount: $unreadCount, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ChatMessagesTable extends ChatMessages
    with TableInfo<$ChatMessagesTable, ChatMessageTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ChatMessagesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _roomIdMeta = const VerificationMeta('roomId');
  @override
  late final GeneratedColumn<String> roomId = GeneratedColumn<String>(
    'room_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _senderIdMeta = const VerificationMeta(
    'senderId',
  );
  @override
  late final GeneratedColumn<String> senderId = GeneratedColumn<String>(
    'sender_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _receiverIdMeta = const VerificationMeta(
    'receiverId',
  );
  @override
  late final GeneratedColumn<String> receiverId = GeneratedColumn<String>(
    'receiver_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _contentMeta = const VerificationMeta(
    'content',
  );
  @override
  late final GeneratedColumn<String> content = GeneratedColumn<String>(
    'content',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('sent'),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    roomId,
    senderId,
    receiverId,
    content,
    status,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'chat_messages';
  @override
  VerificationContext validateIntegrity(
    Insertable<ChatMessageTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('room_id')) {
      context.handle(
        _roomIdMeta,
        roomId.isAcceptableOrUnknown(data['room_id']!, _roomIdMeta),
      );
    } else if (isInserting) {
      context.missing(_roomIdMeta);
    }
    if (data.containsKey('sender_id')) {
      context.handle(
        _senderIdMeta,
        senderId.isAcceptableOrUnknown(data['sender_id']!, _senderIdMeta),
      );
    } else if (isInserting) {
      context.missing(_senderIdMeta);
    }
    if (data.containsKey('receiver_id')) {
      context.handle(
        _receiverIdMeta,
        receiverId.isAcceptableOrUnknown(data['receiver_id']!, _receiverIdMeta),
      );
    } else if (isInserting) {
      context.missing(_receiverIdMeta);
    }
    if (data.containsKey('content')) {
      context.handle(
        _contentMeta,
        content.isAcceptableOrUnknown(data['content']!, _contentMeta),
      );
    } else if (isInserting) {
      context.missing(_contentMeta);
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ChatMessageTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ChatMessageTableData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      roomId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}room_id'],
      )!,
      senderId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}sender_id'],
      )!,
      receiverId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}receiver_id'],
      )!,
      content: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}content'],
      )!,
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $ChatMessagesTable createAlias(String alias) {
    return $ChatMessagesTable(attachedDatabase, alias);
  }
}

class ChatMessageTableData extends DataClass
    implements Insertable<ChatMessageTableData> {
  final String id;
  final String roomId;
  final String senderId;
  final String receiverId;
  final String content;
  final String status;
  final DateTime createdAt;
  const ChatMessageTableData({
    required this.id,
    required this.roomId,
    required this.senderId,
    required this.receiverId,
    required this.content,
    required this.status,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['room_id'] = Variable<String>(roomId);
    map['sender_id'] = Variable<String>(senderId);
    map['receiver_id'] = Variable<String>(receiverId);
    map['content'] = Variable<String>(content);
    map['status'] = Variable<String>(status);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  ChatMessagesCompanion toCompanion(bool nullToAbsent) {
    return ChatMessagesCompanion(
      id: Value(id),
      roomId: Value(roomId),
      senderId: Value(senderId),
      receiverId: Value(receiverId),
      content: Value(content),
      status: Value(status),
      createdAt: Value(createdAt),
    );
  }

  factory ChatMessageTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ChatMessageTableData(
      id: serializer.fromJson<String>(json['id']),
      roomId: serializer.fromJson<String>(json['roomId']),
      senderId: serializer.fromJson<String>(json['senderId']),
      receiverId: serializer.fromJson<String>(json['receiverId']),
      content: serializer.fromJson<String>(json['content']),
      status: serializer.fromJson<String>(json['status']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'roomId': serializer.toJson<String>(roomId),
      'senderId': serializer.toJson<String>(senderId),
      'receiverId': serializer.toJson<String>(receiverId),
      'content': serializer.toJson<String>(content),
      'status': serializer.toJson<String>(status),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  ChatMessageTableData copyWith({
    String? id,
    String? roomId,
    String? senderId,
    String? receiverId,
    String? content,
    String? status,
    DateTime? createdAt,
  }) => ChatMessageTableData(
    id: id ?? this.id,
    roomId: roomId ?? this.roomId,
    senderId: senderId ?? this.senderId,
    receiverId: receiverId ?? this.receiverId,
    content: content ?? this.content,
    status: status ?? this.status,
    createdAt: createdAt ?? this.createdAt,
  );
  ChatMessageTableData copyWithCompanion(ChatMessagesCompanion data) {
    return ChatMessageTableData(
      id: data.id.present ? data.id.value : this.id,
      roomId: data.roomId.present ? data.roomId.value : this.roomId,
      senderId: data.senderId.present ? data.senderId.value : this.senderId,
      receiverId: data.receiverId.present
          ? data.receiverId.value
          : this.receiverId,
      content: data.content.present ? data.content.value : this.content,
      status: data.status.present ? data.status.value : this.status,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ChatMessageTableData(')
          ..write('id: $id, ')
          ..write('roomId: $roomId, ')
          ..write('senderId: $senderId, ')
          ..write('receiverId: $receiverId, ')
          ..write('content: $content, ')
          ..write('status: $status, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, roomId, senderId, receiverId, content, status, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ChatMessageTableData &&
          other.id == this.id &&
          other.roomId == this.roomId &&
          other.senderId == this.senderId &&
          other.receiverId == this.receiverId &&
          other.content == this.content &&
          other.status == this.status &&
          other.createdAt == this.createdAt);
}

class ChatMessagesCompanion extends UpdateCompanion<ChatMessageTableData> {
  final Value<String> id;
  final Value<String> roomId;
  final Value<String> senderId;
  final Value<String> receiverId;
  final Value<String> content;
  final Value<String> status;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const ChatMessagesCompanion({
    this.id = const Value.absent(),
    this.roomId = const Value.absent(),
    this.senderId = const Value.absent(),
    this.receiverId = const Value.absent(),
    this.content = const Value.absent(),
    this.status = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ChatMessagesCompanion.insert({
    required String id,
    required String roomId,
    required String senderId,
    required String receiverId,
    required String content,
    this.status = const Value.absent(),
    required DateTime createdAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       roomId = Value(roomId),
       senderId = Value(senderId),
       receiverId = Value(receiverId),
       content = Value(content),
       createdAt = Value(createdAt);
  static Insertable<ChatMessageTableData> custom({
    Expression<String>? id,
    Expression<String>? roomId,
    Expression<String>? senderId,
    Expression<String>? receiverId,
    Expression<String>? content,
    Expression<String>? status,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (roomId != null) 'room_id': roomId,
      if (senderId != null) 'sender_id': senderId,
      if (receiverId != null) 'receiver_id': receiverId,
      if (content != null) 'content': content,
      if (status != null) 'status': status,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ChatMessagesCompanion copyWith({
    Value<String>? id,
    Value<String>? roomId,
    Value<String>? senderId,
    Value<String>? receiverId,
    Value<String>? content,
    Value<String>? status,
    Value<DateTime>? createdAt,
    Value<int>? rowid,
  }) {
    return ChatMessagesCompanion(
      id: id ?? this.id,
      roomId: roomId ?? this.roomId,
      senderId: senderId ?? this.senderId,
      receiverId: receiverId ?? this.receiverId,
      content: content ?? this.content,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (roomId.present) {
      map['room_id'] = Variable<String>(roomId.value);
    }
    if (senderId.present) {
      map['sender_id'] = Variable<String>(senderId.value);
    }
    if (receiverId.present) {
      map['receiver_id'] = Variable<String>(receiverId.value);
    }
    if (content.present) {
      map['content'] = Variable<String>(content.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ChatMessagesCompanion(')
          ..write('id: $id, ')
          ..write('roomId: $roomId, ')
          ..write('senderId: $senderId, ')
          ..write('receiverId: $receiverId, ')
          ..write('content: $content, ')
          ..write('status: $status, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $ClientProfilesTable clientProfiles = $ClientProfilesTable(this);
  late final $FinancialSummariesTable financialSummaries =
      $FinancialSummariesTable(this);
  late final $RecentTransactionsTable recentTransactions =
      $RecentTransactionsTable(this);
  late final $ChatRoomsTable chatRooms = $ChatRoomsTable(this);
  late final $ChatMessagesTable chatMessages = $ChatMessagesTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    clientProfiles,
    financialSummaries,
    recentTransactions,
    chatRooms,
    chatMessages,
  ];
}

typedef $$ClientProfilesTableCreateCompanionBuilder =
    ClientProfilesCompanion Function({
      required String id,
      required String name,
      required String email,
      Value<String?> phone,
      Value<DateTime?> updatedAt,
      Value<int> rowid,
    });
typedef $$ClientProfilesTableUpdateCompanionBuilder =
    ClientProfilesCompanion Function({
      Value<String> id,
      Value<String> name,
      Value<String> email,
      Value<String?> phone,
      Value<DateTime?> updatedAt,
      Value<int> rowid,
    });

class $$ClientProfilesTableFilterComposer
    extends Composer<_$AppDatabase, $ClientProfilesTable> {
  $$ClientProfilesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get email => $composableBuilder(
    column: $table.email,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get phone => $composableBuilder(
    column: $table.phone,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ClientProfilesTableOrderingComposer
    extends Composer<_$AppDatabase, $ClientProfilesTable> {
  $$ClientProfilesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get email => $composableBuilder(
    column: $table.email,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get phone => $composableBuilder(
    column: $table.phone,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ClientProfilesTableAnnotationComposer
    extends Composer<_$AppDatabase, $ClientProfilesTable> {
  $$ClientProfilesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get email =>
      $composableBuilder(column: $table.email, builder: (column) => column);

  GeneratedColumn<String> get phone =>
      $composableBuilder(column: $table.phone, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$ClientProfilesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ClientProfilesTable,
          ClientProfile,
          $$ClientProfilesTableFilterComposer,
          $$ClientProfilesTableOrderingComposer,
          $$ClientProfilesTableAnnotationComposer,
          $$ClientProfilesTableCreateCompanionBuilder,
          $$ClientProfilesTableUpdateCompanionBuilder,
          (
            ClientProfile,
            BaseReferences<_$AppDatabase, $ClientProfilesTable, ClientProfile>,
          ),
          ClientProfile,
          PrefetchHooks Function()
        > {
  $$ClientProfilesTableTableManager(
    _$AppDatabase db,
    $ClientProfilesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ClientProfilesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ClientProfilesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ClientProfilesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> email = const Value.absent(),
                Value<String?> phone = const Value.absent(),
                Value<DateTime?> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ClientProfilesCompanion(
                id: id,
                name: name,
                email: email,
                phone: phone,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String name,
                required String email,
                Value<String?> phone = const Value.absent(),
                Value<DateTime?> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ClientProfilesCompanion.insert(
                id: id,
                name: name,
                email: email,
                phone: phone,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ClientProfilesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ClientProfilesTable,
      ClientProfile,
      $$ClientProfilesTableFilterComposer,
      $$ClientProfilesTableOrderingComposer,
      $$ClientProfilesTableAnnotationComposer,
      $$ClientProfilesTableCreateCompanionBuilder,
      $$ClientProfilesTableUpdateCompanionBuilder,
      (
        ClientProfile,
        BaseReferences<_$AppDatabase, $ClientProfilesTable, ClientProfile>,
      ),
      ClientProfile,
      PrefetchHooks Function()
    >;
typedef $$FinancialSummariesTableCreateCompanionBuilder =
    FinancialSummariesCompanion Function({
      required String clientId,
      Value<double> totalReceivable,
      Value<double> outstanding,
      Value<double> paid,
      Value<double> nextDueAmount,
      Value<DateTime?> nextDueDate,
      Value<DateTime?> updatedAt,
      Value<int> rowid,
    });
typedef $$FinancialSummariesTableUpdateCompanionBuilder =
    FinancialSummariesCompanion Function({
      Value<String> clientId,
      Value<double> totalReceivable,
      Value<double> outstanding,
      Value<double> paid,
      Value<double> nextDueAmount,
      Value<DateTime?> nextDueDate,
      Value<DateTime?> updatedAt,
      Value<int> rowid,
    });

class $$FinancialSummariesTableFilterComposer
    extends Composer<_$AppDatabase, $FinancialSummariesTable> {
  $$FinancialSummariesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get clientId => $composableBuilder(
    column: $table.clientId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get totalReceivable => $composableBuilder(
    column: $table.totalReceivable,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get outstanding => $composableBuilder(
    column: $table.outstanding,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get paid => $composableBuilder(
    column: $table.paid,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get nextDueAmount => $composableBuilder(
    column: $table.nextDueAmount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get nextDueDate => $composableBuilder(
    column: $table.nextDueDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$FinancialSummariesTableOrderingComposer
    extends Composer<_$AppDatabase, $FinancialSummariesTable> {
  $$FinancialSummariesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get clientId => $composableBuilder(
    column: $table.clientId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get totalReceivable => $composableBuilder(
    column: $table.totalReceivable,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get outstanding => $composableBuilder(
    column: $table.outstanding,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get paid => $composableBuilder(
    column: $table.paid,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get nextDueAmount => $composableBuilder(
    column: $table.nextDueAmount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get nextDueDate => $composableBuilder(
    column: $table.nextDueDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$FinancialSummariesTableAnnotationComposer
    extends Composer<_$AppDatabase, $FinancialSummariesTable> {
  $$FinancialSummariesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get clientId =>
      $composableBuilder(column: $table.clientId, builder: (column) => column);

  GeneratedColumn<double> get totalReceivable => $composableBuilder(
    column: $table.totalReceivable,
    builder: (column) => column,
  );

  GeneratedColumn<double> get outstanding => $composableBuilder(
    column: $table.outstanding,
    builder: (column) => column,
  );

  GeneratedColumn<double> get paid =>
      $composableBuilder(column: $table.paid, builder: (column) => column);

  GeneratedColumn<double> get nextDueAmount => $composableBuilder(
    column: $table.nextDueAmount,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get nextDueDate => $composableBuilder(
    column: $table.nextDueDate,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$FinancialSummariesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $FinancialSummariesTable,
          FinancialSummary,
          $$FinancialSummariesTableFilterComposer,
          $$FinancialSummariesTableOrderingComposer,
          $$FinancialSummariesTableAnnotationComposer,
          $$FinancialSummariesTableCreateCompanionBuilder,
          $$FinancialSummariesTableUpdateCompanionBuilder,
          (
            FinancialSummary,
            BaseReferences<
              _$AppDatabase,
              $FinancialSummariesTable,
              FinancialSummary
            >,
          ),
          FinancialSummary,
          PrefetchHooks Function()
        > {
  $$FinancialSummariesTableTableManager(
    _$AppDatabase db,
    $FinancialSummariesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$FinancialSummariesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$FinancialSummariesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$FinancialSummariesTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> clientId = const Value.absent(),
                Value<double> totalReceivable = const Value.absent(),
                Value<double> outstanding = const Value.absent(),
                Value<double> paid = const Value.absent(),
                Value<double> nextDueAmount = const Value.absent(),
                Value<DateTime?> nextDueDate = const Value.absent(),
                Value<DateTime?> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => FinancialSummariesCompanion(
                clientId: clientId,
                totalReceivable: totalReceivable,
                outstanding: outstanding,
                paid: paid,
                nextDueAmount: nextDueAmount,
                nextDueDate: nextDueDate,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String clientId,
                Value<double> totalReceivable = const Value.absent(),
                Value<double> outstanding = const Value.absent(),
                Value<double> paid = const Value.absent(),
                Value<double> nextDueAmount = const Value.absent(),
                Value<DateTime?> nextDueDate = const Value.absent(),
                Value<DateTime?> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => FinancialSummariesCompanion.insert(
                clientId: clientId,
                totalReceivable: totalReceivable,
                outstanding: outstanding,
                paid: paid,
                nextDueAmount: nextDueAmount,
                nextDueDate: nextDueDate,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$FinancialSummariesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $FinancialSummariesTable,
      FinancialSummary,
      $$FinancialSummariesTableFilterComposer,
      $$FinancialSummariesTableOrderingComposer,
      $$FinancialSummariesTableAnnotationComposer,
      $$FinancialSummariesTableCreateCompanionBuilder,
      $$FinancialSummariesTableUpdateCompanionBuilder,
      (
        FinancialSummary,
        BaseReferences<
          _$AppDatabase,
          $FinancialSummariesTable,
          FinancialSummary
        >,
      ),
      FinancialSummary,
      PrefetchHooks Function()
    >;
typedef $$RecentTransactionsTableCreateCompanionBuilder =
    RecentTransactionsCompanion Function({
      required String id,
      required String clientId,
      required String title,
      required double amount,
      required DateTime date,
      required String type,
      required String status,
      Value<int> rowid,
    });
typedef $$RecentTransactionsTableUpdateCompanionBuilder =
    RecentTransactionsCompanion Function({
      Value<String> id,
      Value<String> clientId,
      Value<String> title,
      Value<double> amount,
      Value<DateTime> date,
      Value<String> type,
      Value<String> status,
      Value<int> rowid,
    });

class $$RecentTransactionsTableFilterComposer
    extends Composer<_$AppDatabase, $RecentTransactionsTable> {
  $$RecentTransactionsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get clientId => $composableBuilder(
    column: $table.clientId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get amount => $composableBuilder(
    column: $table.amount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );
}

class $$RecentTransactionsTableOrderingComposer
    extends Composer<_$AppDatabase, $RecentTransactionsTable> {
  $$RecentTransactionsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get clientId => $composableBuilder(
    column: $table.clientId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get amount => $composableBuilder(
    column: $table.amount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$RecentTransactionsTableAnnotationComposer
    extends Composer<_$AppDatabase, $RecentTransactionsTable> {
  $$RecentTransactionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get clientId =>
      $composableBuilder(column: $table.clientId, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<double> get amount =>
      $composableBuilder(column: $table.amount, builder: (column) => column);

  GeneratedColumn<DateTime> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);
}

class $$RecentTransactionsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $RecentTransactionsTable,
          RecentTransaction,
          $$RecentTransactionsTableFilterComposer,
          $$RecentTransactionsTableOrderingComposer,
          $$RecentTransactionsTableAnnotationComposer,
          $$RecentTransactionsTableCreateCompanionBuilder,
          $$RecentTransactionsTableUpdateCompanionBuilder,
          (
            RecentTransaction,
            BaseReferences<
              _$AppDatabase,
              $RecentTransactionsTable,
              RecentTransaction
            >,
          ),
          RecentTransaction,
          PrefetchHooks Function()
        > {
  $$RecentTransactionsTableTableManager(
    _$AppDatabase db,
    $RecentTransactionsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$RecentTransactionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$RecentTransactionsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$RecentTransactionsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> clientId = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<double> amount = const Value.absent(),
                Value<DateTime> date = const Value.absent(),
                Value<String> type = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => RecentTransactionsCompanion(
                id: id,
                clientId: clientId,
                title: title,
                amount: amount,
                date: date,
                type: type,
                status: status,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String clientId,
                required String title,
                required double amount,
                required DateTime date,
                required String type,
                required String status,
                Value<int> rowid = const Value.absent(),
              }) => RecentTransactionsCompanion.insert(
                id: id,
                clientId: clientId,
                title: title,
                amount: amount,
                date: date,
                type: type,
                status: status,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$RecentTransactionsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $RecentTransactionsTable,
      RecentTransaction,
      $$RecentTransactionsTableFilterComposer,
      $$RecentTransactionsTableOrderingComposer,
      $$RecentTransactionsTableAnnotationComposer,
      $$RecentTransactionsTableCreateCompanionBuilder,
      $$RecentTransactionsTableUpdateCompanionBuilder,
      (
        RecentTransaction,
        BaseReferences<
          _$AppDatabase,
          $RecentTransactionsTable,
          RecentTransaction
        >,
      ),
      RecentTransaction,
      PrefetchHooks Function()
    >;
typedef $$ChatRoomsTableCreateCompanionBuilder =
    ChatRoomsCompanion Function({
      required String id,
      required String clientId,
      required String ownerId,
      Value<String?> ownerName,
      Value<String?> ownerAvatar,
      Value<String?> lastMessage,
      Value<DateTime?> lastMessageTime,
      Value<int> unreadCount,
      Value<int> rowid,
    });
typedef $$ChatRoomsTableUpdateCompanionBuilder =
    ChatRoomsCompanion Function({
      Value<String> id,
      Value<String> clientId,
      Value<String> ownerId,
      Value<String?> ownerName,
      Value<String?> ownerAvatar,
      Value<String?> lastMessage,
      Value<DateTime?> lastMessageTime,
      Value<int> unreadCount,
      Value<int> rowid,
    });

class $$ChatRoomsTableFilterComposer
    extends Composer<_$AppDatabase, $ChatRoomsTable> {
  $$ChatRoomsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get clientId => $composableBuilder(
    column: $table.clientId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get ownerId => $composableBuilder(
    column: $table.ownerId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get ownerName => $composableBuilder(
    column: $table.ownerName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get ownerAvatar => $composableBuilder(
    column: $table.ownerAvatar,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get lastMessage => $composableBuilder(
    column: $table.lastMessage,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get lastMessageTime => $composableBuilder(
    column: $table.lastMessageTime,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get unreadCount => $composableBuilder(
    column: $table.unreadCount,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ChatRoomsTableOrderingComposer
    extends Composer<_$AppDatabase, $ChatRoomsTable> {
  $$ChatRoomsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get clientId => $composableBuilder(
    column: $table.clientId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get ownerId => $composableBuilder(
    column: $table.ownerId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get ownerName => $composableBuilder(
    column: $table.ownerName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get ownerAvatar => $composableBuilder(
    column: $table.ownerAvatar,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get lastMessage => $composableBuilder(
    column: $table.lastMessage,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get lastMessageTime => $composableBuilder(
    column: $table.lastMessageTime,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get unreadCount => $composableBuilder(
    column: $table.unreadCount,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ChatRoomsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ChatRoomsTable> {
  $$ChatRoomsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get clientId =>
      $composableBuilder(column: $table.clientId, builder: (column) => column);

  GeneratedColumn<String> get ownerId =>
      $composableBuilder(column: $table.ownerId, builder: (column) => column);

  GeneratedColumn<String> get ownerName =>
      $composableBuilder(column: $table.ownerName, builder: (column) => column);

  GeneratedColumn<String> get ownerAvatar => $composableBuilder(
    column: $table.ownerAvatar,
    builder: (column) => column,
  );

  GeneratedColumn<String> get lastMessage => $composableBuilder(
    column: $table.lastMessage,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get lastMessageTime => $composableBuilder(
    column: $table.lastMessageTime,
    builder: (column) => column,
  );

  GeneratedColumn<int> get unreadCount => $composableBuilder(
    column: $table.unreadCount,
    builder: (column) => column,
  );
}

class $$ChatRoomsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ChatRoomsTable,
          ChatRoomTableData,
          $$ChatRoomsTableFilterComposer,
          $$ChatRoomsTableOrderingComposer,
          $$ChatRoomsTableAnnotationComposer,
          $$ChatRoomsTableCreateCompanionBuilder,
          $$ChatRoomsTableUpdateCompanionBuilder,
          (
            ChatRoomTableData,
            BaseReferences<_$AppDatabase, $ChatRoomsTable, ChatRoomTableData>,
          ),
          ChatRoomTableData,
          PrefetchHooks Function()
        > {
  $$ChatRoomsTableTableManager(_$AppDatabase db, $ChatRoomsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ChatRoomsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ChatRoomsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ChatRoomsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> clientId = const Value.absent(),
                Value<String> ownerId = const Value.absent(),
                Value<String?> ownerName = const Value.absent(),
                Value<String?> ownerAvatar = const Value.absent(),
                Value<String?> lastMessage = const Value.absent(),
                Value<DateTime?> lastMessageTime = const Value.absent(),
                Value<int> unreadCount = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ChatRoomsCompanion(
                id: id,
                clientId: clientId,
                ownerId: ownerId,
                ownerName: ownerName,
                ownerAvatar: ownerAvatar,
                lastMessage: lastMessage,
                lastMessageTime: lastMessageTime,
                unreadCount: unreadCount,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String clientId,
                required String ownerId,
                Value<String?> ownerName = const Value.absent(),
                Value<String?> ownerAvatar = const Value.absent(),
                Value<String?> lastMessage = const Value.absent(),
                Value<DateTime?> lastMessageTime = const Value.absent(),
                Value<int> unreadCount = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ChatRoomsCompanion.insert(
                id: id,
                clientId: clientId,
                ownerId: ownerId,
                ownerName: ownerName,
                ownerAvatar: ownerAvatar,
                lastMessage: lastMessage,
                lastMessageTime: lastMessageTime,
                unreadCount: unreadCount,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ChatRoomsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ChatRoomsTable,
      ChatRoomTableData,
      $$ChatRoomsTableFilterComposer,
      $$ChatRoomsTableOrderingComposer,
      $$ChatRoomsTableAnnotationComposer,
      $$ChatRoomsTableCreateCompanionBuilder,
      $$ChatRoomsTableUpdateCompanionBuilder,
      (
        ChatRoomTableData,
        BaseReferences<_$AppDatabase, $ChatRoomsTable, ChatRoomTableData>,
      ),
      ChatRoomTableData,
      PrefetchHooks Function()
    >;
typedef $$ChatMessagesTableCreateCompanionBuilder =
    ChatMessagesCompanion Function({
      required String id,
      required String roomId,
      required String senderId,
      required String receiverId,
      required String content,
      Value<String> status,
      required DateTime createdAt,
      Value<int> rowid,
    });
typedef $$ChatMessagesTableUpdateCompanionBuilder =
    ChatMessagesCompanion Function({
      Value<String> id,
      Value<String> roomId,
      Value<String> senderId,
      Value<String> receiverId,
      Value<String> content,
      Value<String> status,
      Value<DateTime> createdAt,
      Value<int> rowid,
    });

class $$ChatMessagesTableFilterComposer
    extends Composer<_$AppDatabase, $ChatMessagesTable> {
  $$ChatMessagesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get roomId => $composableBuilder(
    column: $table.roomId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get senderId => $composableBuilder(
    column: $table.senderId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get receiverId => $composableBuilder(
    column: $table.receiverId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get content => $composableBuilder(
    column: $table.content,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ChatMessagesTableOrderingComposer
    extends Composer<_$AppDatabase, $ChatMessagesTable> {
  $$ChatMessagesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get roomId => $composableBuilder(
    column: $table.roomId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get senderId => $composableBuilder(
    column: $table.senderId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get receiverId => $composableBuilder(
    column: $table.receiverId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get content => $composableBuilder(
    column: $table.content,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ChatMessagesTableAnnotationComposer
    extends Composer<_$AppDatabase, $ChatMessagesTable> {
  $$ChatMessagesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get roomId =>
      $composableBuilder(column: $table.roomId, builder: (column) => column);

  GeneratedColumn<String> get senderId =>
      $composableBuilder(column: $table.senderId, builder: (column) => column);

  GeneratedColumn<String> get receiverId => $composableBuilder(
    column: $table.receiverId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get content =>
      $composableBuilder(column: $table.content, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$ChatMessagesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ChatMessagesTable,
          ChatMessageTableData,
          $$ChatMessagesTableFilterComposer,
          $$ChatMessagesTableOrderingComposer,
          $$ChatMessagesTableAnnotationComposer,
          $$ChatMessagesTableCreateCompanionBuilder,
          $$ChatMessagesTableUpdateCompanionBuilder,
          (
            ChatMessageTableData,
            BaseReferences<
              _$AppDatabase,
              $ChatMessagesTable,
              ChatMessageTableData
            >,
          ),
          ChatMessageTableData,
          PrefetchHooks Function()
        > {
  $$ChatMessagesTableTableManager(_$AppDatabase db, $ChatMessagesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ChatMessagesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ChatMessagesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ChatMessagesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> roomId = const Value.absent(),
                Value<String> senderId = const Value.absent(),
                Value<String> receiverId = const Value.absent(),
                Value<String> content = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ChatMessagesCompanion(
                id: id,
                roomId: roomId,
                senderId: senderId,
                receiverId: receiverId,
                content: content,
                status: status,
                createdAt: createdAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String roomId,
                required String senderId,
                required String receiverId,
                required String content,
                Value<String> status = const Value.absent(),
                required DateTime createdAt,
                Value<int> rowid = const Value.absent(),
              }) => ChatMessagesCompanion.insert(
                id: id,
                roomId: roomId,
                senderId: senderId,
                receiverId: receiverId,
                content: content,
                status: status,
                createdAt: createdAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ChatMessagesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ChatMessagesTable,
      ChatMessageTableData,
      $$ChatMessagesTableFilterComposer,
      $$ChatMessagesTableOrderingComposer,
      $$ChatMessagesTableAnnotationComposer,
      $$ChatMessagesTableCreateCompanionBuilder,
      $$ChatMessagesTableUpdateCompanionBuilder,
      (
        ChatMessageTableData,
        BaseReferences<_$AppDatabase, $ChatMessagesTable, ChatMessageTableData>,
      ),
      ChatMessageTableData,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$ClientProfilesTableTableManager get clientProfiles =>
      $$ClientProfilesTableTableManager(_db, _db.clientProfiles);
  $$FinancialSummariesTableTableManager get financialSummaries =>
      $$FinancialSummariesTableTableManager(_db, _db.financialSummaries);
  $$RecentTransactionsTableTableManager get recentTransactions =>
      $$RecentTransactionsTableTableManager(_db, _db.recentTransactions);
  $$ChatRoomsTableTableManager get chatRooms =>
      $$ChatRoomsTableTableManager(_db, _db.chatRooms);
  $$ChatMessagesTableTableManager get chatMessages =>
      $$ChatMessagesTableTableManager(_db, _db.chatMessages);
}
