// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_presence_service.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(TypingState)
final typingStateProvider = TypingStateFamily._();

final class TypingStateProvider extends $NotifierProvider<TypingState, bool> {
  TypingStateProvider._({
    required TypingStateFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'typingStateProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$typingStateHash();

  @override
  String toString() {
    return r'typingStateProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  TypingState create() => TypingState();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is TypingStateProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$typingStateHash() => r'436860e2a3141224a3639b08577ea0b3ea6382b8';

final class TypingStateFamily extends $Family
    with $ClassFamilyOverride<TypingState, bool, bool, bool, String> {
  TypingStateFamily._()
    : super(
        retry: null,
        name: r'typingStateProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  TypingStateProvider call(String roomId) =>
      TypingStateProvider._(argument: roomId, from: this);

  @override
  String toString() => r'typingStateProvider';
}

abstract class _$TypingState extends $Notifier<bool> {
  late final _$args = ref.$arg as String;
  String get roomId => _$args;

  bool build(String roomId);
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<bool, bool>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<bool, bool>,
              bool,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, () => build(_$args));
  }
}

@ProviderFor(PresenceState)
final presenceStateProvider = PresenceStateFamily._();

final class PresenceStateProvider
    extends $NotifierProvider<PresenceState, bool> {
  PresenceStateProvider._({
    required PresenceStateFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'presenceStateProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$presenceStateHash();

  @override
  String toString() {
    return r'presenceStateProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  PresenceState create() => PresenceState();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is PresenceStateProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$presenceStateHash() => r'a112bb6750aecdb9e1ba68f63c738c1127c360e7';

final class PresenceStateFamily extends $Family
    with $ClassFamilyOverride<PresenceState, bool, bool, bool, String> {
  PresenceStateFamily._()
    : super(
        retry: null,
        name: r'presenceStateProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  PresenceStateProvider call(String userId) =>
      PresenceStateProvider._(argument: userId, from: this);

  @override
  String toString() => r'presenceStateProvider';
}

abstract class _$PresenceState extends $Notifier<bool> {
  late final _$args = ref.$arg as String;
  String get userId => _$args;

  bool build(String userId);
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<bool, bool>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<bool, bool>,
              bool,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, () => build(_$args));
  }
}
