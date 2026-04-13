import 'package:flutter/material.dart';

void main() {
  runApp(const AppGeneratorApp());
}

class AppGeneratorApp extends StatelessWidget {
  const AppGeneratorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Generatore di App IA',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
      ),
      home: const HomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _promptController = TextEditingController();
  bool _isGenerating = false;
  final List<GeneratedApp> _generatedApps = [];

  void _generateApp() async {
    if (_promptController.text.trim().isEmpty) return;

    setState(() {
      _isGenerating = true;
    });

    // Simula il tempo di generazione dell'IA
    await Future.delayed(const Duration(seconds: 3));

    final newApp = GeneratedApp(
      name: _extractAppName(_promptController.text),
      description: _promptController.text,
      date: DateTime.now(),
      downloadUrl: 'https://example.com/download/${DateTime.now().millisecondsSinceEpoch}',
    );

    setState(() {
      _isGenerating = false;
      _generatedApps.insert(0, newApp);
      _promptController.clear();
    });

    if (mounted) {
      _showAppReadyDialog(newApp);
    }
  }

  String _extractAppName(String prompt) {
    final words = prompt.split(' ');
    if (words.length > 3) {
      return '${words.take(2).join(' ')} App';
    }
    return 'La Mia App';
  }

  void _showAppReadyDialog(GeneratedApp app) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('App Generata con Successo! 🎉'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Nome: ${app.name}', style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text('Descrizione: ${app.description}'),
            const SizedBox(height: 16),
            const Text('La tua app è pronta per essere scaricata o condivisa tramite link. Tutto è gratuito al 100% e illimitato!'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Chiudi'),
          ),
          FilledButton.icon(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Link copiato negli appunti!')),
              );
              Navigator.pop(context);
            },
            icon: const Icon(Icons.link),
            label: const Text('Copia Link'),
          ),
          FilledButton.icon(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Download avviato...')),
              );
              Navigator.pop(context);
            },
            icon: const Icon(Icons.download),
            label: const Text('Scarica'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Generatore di App IA', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Descrivi l\'app che vuoi creare',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'La nostra IA genererà un\'app completa e pronta all\'uso per te. 100% Gratuita. Generazioni illimitate.',
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 24),
            TextField(
              controller: _promptController,
              maxLines: 4,
              decoration: InputDecoration(
                hintText: 'es. Un\'app per il fitness che conta i miei passi e le calorie...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 56,
              child: FilledButton(
                onPressed: _isGenerating ? null : _generateApp,
                style: FilledButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: _isGenerating
                    ? const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(width: 12),
                          Text('L\'IA sta creando la tua app...', style: TextStyle(fontSize: 16)),
                        ],
                      )
                    : const Text(
                        'Genera App ✨',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
              ),
            ),
            const SizedBox(height: 32),
            const Text(
              'Le tue App Generate',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: _generatedApps.isEmpty
                  ? const Center(
                      child: Text(
                        'Nessuna app generata ancora.\nInizia descrivendo la tua idea qui sopra!',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.grey),
                      ),
                    )
                  : ListView.builder(
                      itemCount: _generatedApps.length,
                      itemBuilder: (context, index) {
                        final app = _generatedApps[index];
                        return Card(
                          margin: const EdgeInsets.only(bottom: 12),
                          child: ListTile(
                            contentPadding: const EdgeInsets.all(16),
                            leading: CircleAvatar(
                              backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                              child: const Icon(Icons.apps),
                            ),
                            title: Text(app.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                            subtitle: Text(
                              app.description,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.link),
                                  tooltip: 'Copia Link',
                                  onPressed: () {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(content: Text('Link copiato negli appunti!')),
                                    );
                                  },
                                ),
                                IconButton(
                                  icon: const Icon(Icons.download),
                                  tooltip: 'Scarica',
                                  onPressed: () {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(content: Text('Download avviato...')),
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class GeneratedApp {
  final String name;
  final String description;
  final DateTime date;
  final String downloadUrl;

  GeneratedApp({
    required this.name,
    required this.description,
    required this.date,
    required this.downloadUrl,
  });
}
