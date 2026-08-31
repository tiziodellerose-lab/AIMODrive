import 'package:flutter/material.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Impostazioni'),
      ),
      body: ListView(
        children: const [
          ListTile(
            leading: Icon(Icons.color_lens),
            title: Text('Tema'),
            subtitle: Text('Sistema (Predefinito)'),
          ),
          ListTile(
            leading: Icon(Icons.info),
            title: Text('Versione'),
            subtitle: Text('0.1.0'),
          ),
        ],
      ),
    );
  }
}
