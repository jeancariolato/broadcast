import 'package:flutter/material.dart';
import 'package:battery_plus/battery_plus.dart';
import 'package:url_launcher/url_launcher.dart';

void main() {
  runApp(const BatteryMonitorApp());
}

class BatteryMonitorApp extends StatelessWidget {
  const BatteryMonitorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Monitor de Bateria',
      home: BatteryHomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class BatteryHomePage extends StatefulWidget {
  const BatteryHomePage({super.key});

  @override
  State<BatteryHomePage> createState() => _BatteryHomePageState();
}

class _BatteryHomePageState extends State<BatteryHomePage> {
  final Battery _battery = Battery();
  int _batteryLevel = 100;

  @override
  void initState() {
    super.initState();
    _checkBatteryLevel();

    _battery.onBatteryStateChanged.listen((BatteryState state) {
      setState(() {
      });
      _checkBatteryLevel();
    });
  }

  Future<void> _checkBatteryLevel() async {
    final level = await _battery.batteryLevel;
    setState(() {
      _batteryLevel = level;
    });

    if (level < 20) {
      _showBatteryWarning();
    }
  }

  void _showBatteryWarning() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Bateria abaixo de 20%! Conecte o carregador.'),
        duration: Duration(seconds: 5),
        backgroundColor: Colors.red,
      ),
    );
  }

  void _launchGitHub() async {
    const url = 'https://github.com/jeancariolato'; 
    if (!await launchUrl(Uri.parse(url))) {
      throw Exception('Não foi possível abrir $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Monitor de Bateria'),
        actions: [
          IconButton(
            icon: const Icon(Icons.code),
            onPressed: _launchGitHub,
            tooltip: 'Ver GitHub',
          )
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('🔋 Nível da bateria: $_batteryLevel%'),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              icon: const Icon(Icons.link),
              label: const Text('Abrir Perfil no GitHub'),
              onPressed: _launchGitHub,
            )
          ],
        ),
      ),
    );
  }
}
