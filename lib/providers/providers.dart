import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/cloud_account.dart';
import '../services/google_drive_service.dart';

final googleDriveServiceProvider = Provider((ref) => GoogleDriveService());

final cloudAccountsProvider = StateNotifierProvider<CloudAccountsNotifier, List<CloudAccount>>((ref) {
  return CloudAccountsNotifier(ref.watch(googleDriveServiceProvider));
});

class CloudAccountsNotifier extends StateNotifier<List<CloudAccount>> {
  final GoogleDriveService _driveService;

  CloudAccountsNotifier(this._driveService) : super([]);

  Future<void> signInWithGoogle() async {
    final success = await _driveService.authenticate();
    if (success && _driveService.currentUser != null) {
      final user = _driveService.currentUser!;
      final newAccount = CloudAccount(
        id: user.id,
        providerName: 'Google Drive',
        email: user.email,
      );
      state = [...state, newAccount];
    }
  }
}
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/cloud_account.dart';
import '../services/google_drive_service.dart';
import '../services/mega_service.dart'; // Aggiunto import

final googleDriveServiceProvider = Provider((ref) => GoogleDriveService());
final megaServiceProvider = Provider((ref) => MegaService()); // Nuovo provider

final cloudAccountsProvider = StateNotifierProvider<CloudAccountsNotifier, List<CloudAccount>>((ref) {
  return CloudAccountsNotifier(
    ref.watch(googleDriveServiceProvider),
    ref.watch(megaServiceProvider), // Passiamo anche Mega
  );
});

class CloudAccountsNotifier extends StateNotifier<List<CloudAccount>> {
  final GoogleDriveService _driveService;
  final MegaService _megaService;

  CloudAccountsNotifier(this._driveService, this._megaService) : super([]);

  // ... (Mantieni il vecchio metodo signInWithGoogle se vuoi, o rimuovilo)

  Future<bool> signInWithMega(String email, String password) async {
    final success = await _megaService.loginWithCredentials(email, password);
    
    if (success) {
      final newAccount = CloudAccount(
        id: DateTime.now().millisecondsSinceEpoch.toString(), // ID fittizio per ora
        providerName: 'Mega',
        email: email,
      );
      state = [...state, newAccount];
      return true;
    }
    return false;
  }
}
