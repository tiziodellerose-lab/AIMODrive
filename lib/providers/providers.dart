import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/cloud_account.dart';

// Provider iniziale per gestire la lista degli account cloud connessi
final cloudAccountsProvider = StateProvider<List<CloudAccount>>((ref) {
  // In questa Release 0.1 partiamo con una lista vuota
  return [];
});
