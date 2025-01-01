import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class ToggleValuePage extends StatefulWidget {
  const ToggleValuePage({super.key});

  @override
  ToggleValuePageState createState() => ToggleValuePageState();
}

class ToggleValuePageState extends State<ToggleValuePage> {
  // Firebase Realtime Database references
  final DatabaseReference _redLedRef =
      FirebaseDatabase.instance.ref('/red_led');
  final DatabaseReference _blueLedRef =
      FirebaseDatabase.instance.ref('/blue_led');
  final DatabaseReference _extraButtonRef =
      FirebaseDatabase.instance.ref('/extra_button');

  bool _redLedValue = false;
  bool _blueLedValue = false;
  bool _extraButtonValue = false;

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

    _extraButtonRef.onValue.listen((event) {
      setState(() {
        _extraButtonValue = (event.snapshot.value as bool?) ?? false;
      });
    });
  }

  Future<void> _fetchCurrentValues() async {
    try {
      final redSnapshot = await _redLedRef.get();
      final blueSnapshot = await _blueLedRef.get();
      final extraButtonSnapshot = await _extraButtonRef.get();

      setState(() {
        _redLedValue = (redSnapshot.value as bool?) ?? false;
        _blueLedValue = (blueSnapshot.value as bool?) ?? false;
        _extraButtonValue = (extraButtonSnapshot.value as bool?) ?? false;
      });
    } catch (error) {
      print('Error fetching initial values: $error');
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

  Future<void> _toggleExtraButton() async {
    await _toggleValue(_extraButtonRef, _extraButtonValue, (newValue) {
      setState(() {
        _extraButtonValue = newValue;
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
        title: Text(
          'LED Control',
          style: TextStyle(
              color: Colors.white), // Change navbar text color to white
        ),
        backgroundColor:
            Colors.deepPurple[900], // Change navbar color to dark purple
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.deepPurple, Colors.purpleAccent],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  children: [
                    Container(
                      color: Colors.white
                          .withOpacity(0.2), // Add a flat color background
                      padding: EdgeInsets.all(10),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: EdgeInsets.all(5),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(
                                      0.5), // Background color for icon
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  Icons.warning,
                                  color: _redLedValue
                                      ? Colors.red
                                      : Colors.red.withOpacity(0.3),
                                  size: 30.0,
                                ),
                              ),
                              SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  'Gas Leak: $_redLedValue',
                                  style: TextStyle(
                                      fontSize: 20,
                                      color: Colors
                                          .white), // Change text color to white
                                ),
                              ),
                            ],
                          ),
                          ElevatedButton(
                            onPressed: _toggleRedLed,
                            child: Text(_redLedValue
                                ? 'Turn Gas Leak Off'
                                : 'Turn Gas Leak On'),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 20),
                    Container(
                      color: Colors.white
                          .withOpacity(0.2), // Add a flat color background
                      padding: EdgeInsets.all(10),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: EdgeInsets.all(5),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(
                                      0.5), // Background color for icon
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  Icons.water_damage,
                                  color: _blueLedValue
                                      ? Colors.blue
                                      : Colors.blue.withOpacity(0.3),
                                  size: 30.0,
                                ),
                              ),
                              SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  'Water Leak: $_blueLedValue',
                                  style: TextStyle(
                                      fontSize: 20,
                                      color: Colors
                                          .white), // Change text color to white
                                ),
                              ),
                            ],
                          ),
                          ElevatedButton(
                            onPressed: _toggleBlueLed,
                            child: Text(_blueLedValue
                                ? 'Turn Water Leak Off'
                                : 'Turn Water Leak On'),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 20),
                    Container(
                      color: Colors.white
                          .withOpacity(0.2), // Add a flat color background
                      padding: EdgeInsets.all(10),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  'Extra Button Value: $_extraButtonValue',
                                  style: TextStyle(
                                      fontSize: 20,
                                      color: Colors
                                          .white), // Change text color to white
                                ),
                              ),
                            ],
                          ),
                          ElevatedButton(
                            onPressed: _toggleExtraButton,
                            child: Text(_extraButtonValue
                                ? 'Turn Extra Button Off'
                                : 'Turn Extra Button On'),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
