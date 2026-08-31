class CloudAccount {
  final String id;
  final String providerName; // es. "Google Drive", "OneDrive"
  final String email;

  CloudAccount({
    required this.id,
    required this.providerName,
    required this.email,
  });
}
