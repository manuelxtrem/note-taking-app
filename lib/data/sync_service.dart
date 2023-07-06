import 'dart:async';

import 'package:flutter/material.dart';

mixin SyncServiceMixin<T extends StatefulWidget> on State<T>, WidgetsBindingObserver {
  final Duration syncInterval = const Duration(seconds: 15);
  Timer? syncTimer;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      syncOfflineNotes();
      startSyncTimer();
    });
  }

  @override
  void dispose() {
    cancelSyncTimer();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      // App resumed from background, start syncing
      startSyncTimer();
    } else if (state == AppLifecycleState.paused) {
      // App paused, cancel the sync timer
      cancelSyncTimer();
    }
  }

  void startSyncTimer() {
    syncTimer = Timer.periodic(syncInterval, (_) {
      syncOfflineNotes();
    });
  }

  void cancelSyncTimer() {
    syncTimer?.cancel();
    syncTimer = null;
  }

  void syncOfflineNotes() => throw UnimplementedError();
}
