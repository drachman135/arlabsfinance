// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_room_viewmodel.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(ChatRoomViewModel)
final chatRoomViewModelProvider = ChatRoomViewModelFamily._();

final class ChatRoomViewModelProvider
    extends $NotifierProvider<ChatRoomViewModel, List<ChatMessage>> {
  ChatRoomViewModelProvider._({
    required ChatRoomViewModelFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'chatRoomViewModelProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$chatRoomViewModelHash();

  @override
  String toString() {
    return r'chatRoomViewModelProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  ChatRoomViewModel create() => ChatRoomViewModel();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<ChatMessage> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<List<ChatMessage>>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is ChatRoomViewModelProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$chatRoomViewModelHash() => r'454767ecdee277b8b7211a52db6f94640284d712';

final class ChatRoomViewModelFamily extends $Family
    with
        $ClassFamilyOverride<
          ChatRoomViewModel,
          List<ChatMessage>,
          List<ChatMessage>,
          List<ChatMessage>,
          String
        > {
  ChatRoomViewModelFamily._()
    : super(
        retry: null,
        name: r'chatRoomViewModelProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  ChatRoomViewModelProvider call(String roomId) =>
      ChatRoomViewModelProvider._(argument: roomId, from: this);

  @override
  String toString() => r'chatRoomViewModelProvider';
}

abstract class _$ChatRoomViewModel extends $Notifier<List<ChatMessage>> {
  late final _$args = ref.$arg as String;
  String get roomId => _$args;

  List<ChatMessage> build(String roomId);
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<List<ChatMessage>, List<ChatMessage>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<List<ChatMessage>, List<ChatMessage>>,
              List<ChatMessage>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, () => build(_$args));
  }
}
