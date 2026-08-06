// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dashboard_viewmodel.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// ViewModel for Dashboard.
///
/// Listens to local Drift cache and triggers background syncs.

@ProviderFor(DashboardViewModel)
final dashboardViewModelProvider = DashboardViewModelProvider._();

/// ViewModel for Dashboard.
///
/// Listens to local Drift cache and triggers background syncs.
final class DashboardViewModelProvider
    extends $NotifierProvider<DashboardViewModel, DashboardState> {
  /// ViewModel for Dashboard.
  ///
  /// Listens to local Drift cache and triggers background syncs.
  DashboardViewModelProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'dashboardViewModelProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$dashboardViewModelHash();

  @$internal
  @override
  DashboardViewModel create() => DashboardViewModel();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(DashboardState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<DashboardState>(value),
    );
  }
}

String _$dashboardViewModelHash() =>
    r'97732f83b92178fab86ed559b7ccee004a4b8f62';

/// ViewModel for Dashboard.
///
/// Listens to local Drift cache and triggers background syncs.

abstract class _$DashboardViewModel extends $Notifier<DashboardState> {
  DashboardState build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<DashboardState, DashboardState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<DashboardState, DashboardState>,
              DashboardState,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
