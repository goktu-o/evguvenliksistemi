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
  // Firebase Realtime Database references
  final DatabaseReference _redLedRef =
      FirebaseDatabase.instance.ref('/red_led');
  final DatabaseReference _blueLedRef =
      FirebaseDatabase.instance.ref('/blue_led');
  final DatabaseReference _greenLedRef =
      FirebaseDatabase.instance.ref('/green_led');

  bool _redLedValue = false;
  bool _blueLedValue = false;
  bool _greenLedValue = false;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchCurrentValues();

    // Listen for real-time updates
    _redLedRef.onValue.listen((event) {
      setState(() {
        _redLedValue = (event.snapshot.value as bool?) ?? false;
      });
    });

    _blueLedRef.onValue.listen((event) {
      setState(() {
        _blueLedValue = (event.snapshot.value as bool?) ?? false;
      });
    });

    _greenLedRef.onValue.listen((event) {
      setState(() {
        _greenLedValue = (event.snapshot.value as bool?) ?? false;
      });
    });
  }

  Future<void> _fetchCurrentValues() async {
    try {
      final redSnapshot = await _redLedRef.get();
      final blueSnapshot = await _blueLedRef.get();
      final greenSnapshot = await _greenLedRef.get();

      setState(() {
        _redLedValue = (redSnapshot.value as bool?) ?? false;
        _blueLedValue = (blueSnapshot.value as bool?) ?? false;
        _greenLedValue = (greenSnapshot.value as bool?) ?? false;
        _isLoading = false;
      });
    } catch (error) {
      print('Error fetching values: $error');
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _toggleRedLed() async {
    await _toggleValue(_redLedRef, _redLedValue, (newValue) {
      setState(() {
        _redLedValue = newValue;
      });
    });
  }

  Future<void> _toggleBlueLed() async {
    await _toggleValue(_blueLedRef, _blueLedValue, (newValue) {
      setState(() {
        _blueLedValue = newValue;
      });
    });
  }

  Future<void> _toggleGreenLed() async {
    await _toggleValue(_greenLedRef, _greenLedValue, (newValue) {
      setState(() {
        _greenLedValue = newValue;
      });
    });
  }

  Future<void> _toggleValue(DatabaseReference dbRef, bool currentValue,
      Function(bool) onSuccess) async {
    try {
      final newValue = !currentValue;
      await dbRef.set(newValue);
      onSuccess(newValue);
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
                    'Red LED Value: $_redLedValue',
                    style: TextStyle(fontSize: 20),
                  ),
                  ElevatedButton(
                    onPressed: _toggleRedLed,
                    child: Text('Toggle Red LED'),
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Green LED Value: $_greenLedValue',
                    style: TextStyle(fontSize: 20),
                  ),
                  ElevatedButton(
                    onPressed: _toggleGreenLed,
                    child: Text('Toggle Green LED'),
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Blue LED Value: $_blueLedValue',
                    style: TextStyle(fontSize: 20),
                  ),
                  ElevatedButton(
                    onPressed: _toggleBlueLed,
                    child: Text('Toggle Blue LED'),
                  ),
                ],
              ),
      ),
    );
  }
}
