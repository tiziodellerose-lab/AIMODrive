import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/cloud_account.dart';
import '../services/google_drive_service.dart';
import '../services/mega_service.dart';

// 1. Provider base per iniettare i servizi cloud
final googleDriveServiceProvider = Provider((ref) => GoogleDriveService());
final megaServiceProvider = Provider((ref) => MegaService());

// 2. Provider globale per lo stato degli account connessi
final cloudAccountsProvider = StateNotifierProvider<CloudAccountsNotifier, List<CloudAccount>>((ref) {
  return CloudAccountsNotifier(
    ref.watch(googleDriveServiceProvider),
    ref.watch(megaServiceProvider),
  );
});

// 3. Notifier (ViewModel) che gestisce la logica di business
class CloudAccountsNotifier extends StateNotifier<List<CloudAccount>> {
  final GoogleDriveService _driveService;
  final MegaService _megaService;

  CloudAccountsNotifier(this._driveService, this._megaService) : super([]);

  // Logica di autenticazione per Google Drive
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

  // Logica di autenticazione per Mega (tramite email e password)
  Future<bool> signInWithMega(String email, String password) async {
    final success = await _megaService.loginWithCredentials(email, password);
    
    if (success) {
      final newAccount = CloudAccount(
        id: DateTime.now().millisecondsSinceEpoch.toString(), // ID univoco generato localmente per ora
        providerName: 'Mega',
        email: email,
      );
      // Aggiorna lo stato immutabile aggiungendo il nuovo account
      state = [...state, newAccount];
      return true;
    }
    return false;
  }

  // Metodo per disconnettere e rimuovere un account dalla UI
  void removeAccount(String id) {
    state = state.where((account) => account.id != id).toList();
  }
}
