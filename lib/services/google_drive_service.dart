import 'package:google_sign_in/google_sign_in.dart';
import '../models/cloud_account.dart';
import 'cloud_service.dart';

class GoogleDriveService implements CloudService {
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: [
      'https://www.googleapis.com/auth/drive.readonly',
    ],
  );

  @override
  Future<bool> authenticate() async {
    try {
      final GoogleSignInAccount? account = await _googleSignIn.signIn();
      return account != null;
    } catch (error) {
      return false;
    }
  }

  @override
  Future<void> disconnect() async {
    await _googleSignIn.signOut();
  }

  @override
  Future<List<String>> listFiles(CloudAccount account) async {
    // Il File Explorer verrà implementato nella Release 0.3
    return [];
  }
  
  GoogleSignInAccount? get currentUser => _googleSignIn.currentUser;
}
