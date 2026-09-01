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
                    onPressed: () {
                      // Richiama il metodo di login che abbiamo creato
                      ref.read(cloudAccountsProvider.notifier).signInWithGoogle();
                    },
                    icon: const Icon(Icons.add_to_drive),
                    label: const Text('Collega Google Drive'),
                  ),
                ],
              ),
            )
          : ListView.builder(
              itemCount: accounts.length,
              itemBuilder: (context, index) {
                final account = accounts[index];
                return AppCard( // Utilizziamo il widget riutilizzabile creato in precedenza
                  child: ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: const Icon(Icons.cloud_done, color: Colors.green, size: 40),
                    title: Text(
                      account.providerName,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(account.email),
                    trailing: IconButton(
                      icon: const Icon(Icons.logout, color: Colors.red),
                      onPressed: () {
                        // Implementeremo la disconnessione in seguito
                      },
                    ),
                  ),
                );
              },
            ),
            
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
