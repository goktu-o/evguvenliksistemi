import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: ToggleValuePage(),
    );
  }
}

class ToggleValuePage extends StatefulWidget {
  @override
  _ToggleValuePageState createState() => _ToggleValuePageState();
}

class _ToggleValuePageState extends State<ToggleValuePage> {
  // Firebase Realtime Database referansı
  final DatabaseReference _dbRef =
      FirebaseDatabase.instance.ref('/test/stream/toggle_value');

  bool _currentValue = false;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchCurrentValue();
  }

  Future<void> _fetchCurrentValue() async {
    try {
      final DataSnapshot snapshot = await _dbRef.get();
      setState(() {
        _currentValue = (snapshot.value as bool?) ?? false;
        _isLoading = false;
      });
    } catch (error) {
      print('Error fetching value: $error');
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _toggleValue() async {
    try {
      final newValue = !_currentValue;
      await _dbRef.set(newValue);
      setState(() {
        _currentValue = newValue;
      });
    } catch (error) {
      print('Error toggling value: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to toggle value')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Firebase Toggle'),
      ),
      body: Center(
        child: _isLoading
            ? CircularProgressIndicator()
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Current Value: $_currentValue',
                    style: TextStyle(fontSize: 20),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _toggleValue,
                    child: Text('Toggle Value'),
                  ),
                ],
              ),
      ),
    );
  }
}
