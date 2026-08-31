import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
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
      body: const Center(
        child: Text('Nessun file presente. Aggiungi un provider Cloud.'),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: 0,
        onDestinationSelected: (int index) {
          // Logica per cambiare tab in futuro
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
