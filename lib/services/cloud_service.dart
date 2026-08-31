import '../models/cloud_account.dart';

abstract class CloudService {
  Future<bool> authenticate();
  Future<void> disconnect();
  Future<List<String>> listFiles(CloudAccount account);
}
