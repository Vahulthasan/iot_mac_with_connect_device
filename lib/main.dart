import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const SmartLEDApp());
}

class SmartLEDApp extends StatelessWidget {
  const SmartLEDApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Smart LED App',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const LEDControlPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class LEDControlPage extends StatefulWidget {
  const LEDControlPage({super.key});

  @override
  State<LEDControlPage> createState() => _LEDControlPageState();
}

class _LEDControlPageState extends State<LEDControlPage> {
  final TextEditingController _ipController = TextEditingController();
  final Map<int, bool> _switches = {1: false, 2: false, 3: false, 4: false};
  bool _isConnected = true;

  @override
  void initState() {
    super.initState();
    _checkConnection();
  }

  Future<void> _checkConnection() async {
    final connectivity = await Connectivity().checkConnectivity();
    setState(() {
      _isConnected = connectivity != ConnectivityResult.none;
    });

    Connectivity().onConnectivityChanged.listen((result) {
      setState(() {
        _isConnected = result != ConnectivityResult.none;
      });
    });
  }

  Future<void> toggleLED(int light, bool isOn) async {
    final ip = _ipController.text.trim();
    if (ip.isEmpty) return;

    final url = Uri.parse('http://$ip/light$light/${isOn ? "on" : "off"}');
    try {
      await http.get(url);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to reach device: $e")),
      );
    }
  }

  Future<void> _logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', false);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Logged out')),
    );
  }

  Widget lightSwitch(int light) {
    return SwitchListTile(
      title: Text("Light $light"),
      value: _switches[light]!,
      onChanged: !_isConnected
          ? null
          : (value) {
        setState(() {
          _switches[light] = value;
        });
        toggleLED(light, value);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Masters LED Controller"),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: _logout,
            tooltip: 'Logout',
          ),
        ],
      ),
      body: AnimatedOpacity(
        opacity: _isConnected ? 1.0 : 0.3,
        duration: const Duration(milliseconds: 500),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: _ipController,
                  decoration: const InputDecoration(
                    labelText: "Enter Device IP (e.g. 192.168.4.1)",
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.url,
                ),
                const SizedBox(height: 20),
                ...[1, 2, 3, 4].map(lightSwitch),
                const SizedBox(height: 30),
                const Divider(),
                const Text(
                  "🛒 Vahul Store",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const Text("📍kadai theru ,Thennampulam, Vedaranyam, Nagappatinam"),
                const Text("📍please call any hardware issues on below number"),
                const Text("📞 +91 6382969831"),
                const Text("code word is vahul ah"),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
