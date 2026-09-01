import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../providers/providers.dart';
import '../../widgets/app_card.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // "Ascoltiamo" i cambiamenti di stato degli account tramite Riverpod
    final accounts = ref.watch(cloudAccountsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('AIMODrive'),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text(
                'AIMODrive Menu',
                style: TextStyle(color: Colors.white, fontSize: 24),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Impostazioni'),
              onTap: () {
                context.pop(); // Chiude il drawer
                context.push('/settings'); // Naviga usando GoRouter
              },
            ),
          ],
        ),
      ),
      body: accounts.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Nessun provider collegato.'),
                  const SizedBox(height: 24),
                  // Bottone Google Drive
                  FilledButton.icon(
                    onPressed: () {
                      ref.read(cloudAccountsProvider.notifier).signInWithGoogle();
                    },
                    icon: const Icon(Icons.add_to_drive),
                    label: const Text('Collega Google Drive'),
                  ),
                  const SizedBox(height: 16),
                  // Bottone Mega
                  FilledButton.icon(
                    onPressed: () => _showMegaLoginDialog(context, ref),
                    icon: const Icon(Icons.cloud_sync),
                    label: const Text('Collega account Mega'),
                    style: FilledButton.styleFrom(
                      backgroundColor: Colors.red[700], 
                    ),
                  ),
                ],
              ),
            )
          : ListView.builder(
              itemCount: accounts.length,
              itemBuilder: (context, index) {
                final account = accounts[index];
                
                // Determina l'icona e il colore in base al provider
                final isMega = account.providerName.toLowerCase() == 'mega';
                final iconColor = isMega ? Colors.red[700] : Colors.green;
                final providerIcon = isMega ? Icons.cloud : Icons.cloud_done;

                return AppCard(
                  child: ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: Icon(providerIcon, color: iconColor, size: 40),
                    title: Text(
                      account.providerName,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(account.email),
                    trailing: IconButton(
                      icon: const Icon(Icons.logout, color: Colors.grey),
                      tooltip: 'Scollega account',
                      onPressed: () {
                        // Rimuove l'account dalla lista
                        ref.read(cloudAccountsProvider.notifier).removeAccount(account.id);
                      },
                    ),
                  ),
                );
              },
            ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: 0,
        onDestinationSelected: (int index) {
          // Logica futura per la navigazione tra i tab
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.folder),
            label: 'I miei file',
          ),
          NavigationDestination(
            icon: Icon(Icons.cloud),
            label: 'Provider',
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Azione generica (es. nuovo file/cartella in futuro)
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  // Finestra di dialogo per il login a Mega
  void _showMegaLoginDialog(BuildContext context, WidgetRef ref) {
    final emailController = TextEditingController();
    final passwordController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Login Mega'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: emailController,
                decoration: const InputDecoration(labelText: 'Email'),
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 8),
              TextField(
                controller: passwordController,
                decoration: const InputDecoration(labelText: 'Password'),
                obscureText: true,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => context.pop(), // Chiude la modale senza fare nulla
              child: const Text('Annulla'),
            ),
            FilledButton(
              onPressed: () async {
                // Avvia il login tramite Riverpod usando i dati inseriti
                final success = await ref.read(cloudAccountsProvider.notifier).signInWithMega(
                  emailController.text,
                  passwordController.text,
                );
                
                // Se il login riesce ed il widget è ancora attivo, chiude la modale
                if (success && context.mounted) {
                  context.pop();
                }
              },
              child: const Text('Accedi'),
            ),
          ],
        );
      },
    );
  }
}
