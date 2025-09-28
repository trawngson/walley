import 'package:flutter/material.dart';
import 'package:walley/util/user_defaults_util.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});
  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _tips = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final tips = await UserDefaultsUtil.getBool('show_tips', defaultValue: true);
    if (!mounted) return;
    setState(() => _tips = tips);
  }

  Future<void> _setTips(bool v) async {
    setState(() => _tips = v);
    await UserDefaultsUtil.setBool('show_tips', v);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        children: [
          SwitchListTile(
            title: const Text('Show finance tips'),
            subtitle: const Text('Toggle the quote card visibility'),
            value: _tips,
            onChanged: _setTips,
          ),
        ],
      ),
    );
  }
}
