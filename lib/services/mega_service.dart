import '../models/cloud_account.dart';
import 'cloud_service.dart';

class MegaService implements CloudService {
  
  // A differenza di Google, per Mega ci servono credenziali esplicite
  Future<bool> loginWithCredentials(String email, String password) async {
    try {
      // TODO: Qui inseriremo l'engine crittografico reale di Mega
      // Simuliamo un'attesa di rete di 2 secondi
      await Future.delayed(const Duration(seconds: 2));
      
      // Simuliamo un login riuscito se i campi non sono vuoti
      return email.isNotEmpty && password.isNotEmpty;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<bool> authenticate() async {
    // Questo metodo dell'interfaccia base non lo usiamo direttamente per Mega
    // perché ci servono i parametri email e password
    throw UnimplementedError('Usa loginWithCredentials per Mega');
  }

  @override
  Future<void> disconnect() async {
    // Logica futura per invalidare la sessione Mega
  }

  @override
  Future<List<String>> listFiles(CloudAccount account) async {
    return [];
  }
}
