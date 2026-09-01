import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../providers/providers.dart';
import '../../widgets/app_card.dart';

// Cambiato da StatelessWidget a ConsumerWidget per usare Riverpod
class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // "Ascoltiamo" la lista degli account cloud connessi
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
                context.push('/settings');
              },
            ),
          ],
        ),
      ),
      
      // Il body cambia in base alla presenza o meno di account connessi
body: accounts.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Nessun provider collegato.'),
                  const SizedBox(height: 16),
                  FilledButton.icon(
                    onPressed: () => _showMegaLoginDialog(context, ref),
                    icon: const Icon(Icons.cloud_sync),
                    label: const Text('Collega account Mega'),
                    style: FilledButton.styleFrom(
                      backgroundColor: Colors.red[700], // Colore tipico di Mega
                    ),
                  ),
                ],
              ),
            )
          : ListView.builder(
              itemCount: accounts.length,
              // ... (Manteniamo il ListView.builder precedente per mostrare la card)
              itemBuilder: (context, index) {
                final account = accounts[index];
                return AppCard(
                  child: ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: Icon(Icons.cloud, color: Colors.red[700], size: 40),
                    title: Text(
                      account.providerName,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(account.email),
                    trailing: IconButton(
                      icon: const Icon(Icons.logout, color: Colors.grey),
                      onPressed: () {}, // Futuro logout
                    ),
                  ),
                );
              }
            ),
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
              TextField(
                controller: passwordController,
                decoration: const InputDecoration(labelText: 'Password'),
                obscureText: true,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => context.pop(),
              child: const Text('Annulla'),
            ),
            FilledButton(
              onPressed: () async {
                // Avvia il login tramite Riverpod
                final success = await ref.read(cloudAccountsProvider.notifier).signInWithMega(
                  emailController.text,
                  passwordController.text,
                );
                
                if (success && context.mounted) {
                  context.pop(); // Chiude il dialog se il login ha successo
                }
              },
              child: const Text('Accedi'),
            ),
          ],
        );
      },
    );
  }      
      bottomNavigationBar: NavigationBar(
        selectedIndex: 0,
        onDestinationSelected: (int index) {
          // Logica per cambiare tab
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
        onPressed: () {},
        child: const Icon(Icons.add),
      ),
    );
  }
}
