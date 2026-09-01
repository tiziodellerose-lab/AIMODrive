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
