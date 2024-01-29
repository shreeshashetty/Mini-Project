import 'package:flutter/material.dart';
import 'package:campus_care/UserApp/UserComplaintPage.dart';
import 'package:campus_care/Firestore/FirestoreService.dart';

class UserHomePage extends StatefulWidget {
  @override
  _UserHomePageState createState() => _UserHomePageState();
}

class _UserHomePageState extends State<UserHomePage> {
  String name = '';
  String phoneNumber = '';
  String building = '';
  String floor = '';
  String room = 'None';
  String roomNo = '';
  String object = '';
  String description = '';
  String submitMessage = '';
  String nameError = '';
  String phoneNumberError = '';
  String roomError = '';

  final List<String> roomItems = [
    'None',
    'Classroom',
    'Office/Staffroom',
    'Corridor',
    'Auditorium',
    'Library',
    'Laboratory',
    'Restroom',
    'Parking',
    'Indoor Stadium',
    'Other',
  ];

  final Map<String, int> roomTypePriorities = {
    'None': 0,
    'Classroom': 2,
    'Office/Staffroom': 1,
    'Corridor': 7,
    'Auditorium': 5,
    'Library': 4,
    'Laboratory': 3,
    'Restroom': 8,
    'Parking': 9,
    'Indoor Stadium': 6,
    'Other': 10,
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Welcome!'),
        backgroundColor: Colors.lightGreen,
        actions: [
          Padding(
            padding: const EdgeInsets.all(0),
            child: Image.asset(
              'assets/images/logogreen.jpg',
              width: 80,
              height: 80,
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Enter your complaint',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 20),
                TextField(
                  onChanged: (value) {
                    setState(() {
                      name = value;
                      nameError = '';
                    });
                  },
                  decoration: InputDecoration(
                    labelText: 'Name',
                    errorText: nameError,
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black, width: 1.0),
                    ),
                    fillColor: Colors.white,
                    filled: true,
                  ),
                ),
                SizedBox(height: 10),
                TextField(
                  onChanged: (value) {
                    setState(() {
                      phoneNumber = value;
                      phoneNumberError = '';
                    });
                  },
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(
                    labelText: 'Phone Number',
                    errorText: phoneNumberError,
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black, width: 1.0),
                    ),
                    fillColor: Colors.white,
                    filled: true,
                  ),
                ),
                SizedBox(height: 10),
                TextField(
                  onChanged: (value) {
                    building = value;
                  },
                  decoration: InputDecoration(
                    labelText: 'Building',
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black, width: 1.0),
                    ),
                    fillColor: Colors.white,
                    filled: true,
                  ),
                ),
                SizedBox(height: 10),
                TextField(
                  onChanged: (value) {
                    floor = value;
                  },
                  decoration: InputDecoration(
                    labelText: 'Floor',
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black, width: 1.0),
                    ),
                    fillColor: Colors.white,
                    filled: true,
                  ),
                ),
                SizedBox(height: 10),
                DropdownButtonFormField<String>(
                  value: room,
                  onChanged: (String? newValue) {
                    setState(() {
                      room = newValue ?? 'None';
                      roomError = '';
                    });
                  },
                  items: roomTypePriorities.keys.map<DropdownMenuItem<String>>(
                    (String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    },
                  ).toList(),
                  decoration: InputDecoration(
                    labelText: 'Room',
                    errorText: roomError,
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black, width: 1.0),
                    ),
                    fillColor: Colors.white,
                    filled: true,
                  ),
                ),
                SizedBox(height: 10),
                TextField(
                  onChanged: (value) {
                    roomNo = value;
                  },
                  decoration: InputDecoration(
                    labelText: 'Room No',
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black, width: 1.0),
                    ),
                    fillColor: Colors.white,
                    filled: true,
                  ),
                ),
                SizedBox(height: 10),
                TextField(
                  onChanged: (value) {
                    object = value;
                  },
                  decoration: InputDecoration(
                    labelText: 'Object',
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black, width: 1.0),
                    ),
                    fillColor: Colors.white,
                    filled: true,
                  ),
                ),
                SizedBox(height: 10),
                TextField(
                  onChanged: (value) {
                    description = value;
                  },
                  maxLines: 4,
                  decoration: InputDecoration(
                    labelText: 'Description',
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black, width: 1.0),
                    ),
                    fillColor: Colors.white,
                    filled: true,
                  ),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    submitComplaint(context);
                  },
                  style: ElevatedButton.styleFrom(
                    primary: Colors.lightGreen,
                    onPrimary: Colors.white,
                  ),
                  child: Text('Complain'),
                ),
                SizedBox(height: 20),
                Text(
                  submitMessage,
                  style: TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
              icon: Icon(Icons.build), label: 'My complaint'),
        ],
        backgroundColor: Colors.lightGreen,
        onTap: (index) {
          if (index == 1) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => UserComplaintPage()),
            );
          }
        },
      ),
    );
  }

  void submitComplaint(BuildContext context) {
    if (name.length < 3) {
      setState(() {
        nameError = 'Name must be at least 3 characters';
        submitMessage = '';
      });
    } else if (!phoneNumber.startsWith('+91') || phoneNumber.length != 13) {
      setState(() {
        phoneNumberError = 'Phone must be +91xxxxxxxxxx';
        submitMessage = '';
      });
    } else if (room == 'None') {
      setState(() {
        roomError = 'Please select the room';
        submitMessage = '';
      });
    } else if (building.isNotEmpty &&
        floor.isNotEmpty &&
        roomNo.isNotEmpty &&
        object.isNotEmpty &&
        description.isNotEmpty) {
      FirestoreService().addComplaint(
        name: name,
        phoneNumber: phoneNumber,
        building: building,
        floor: floor,
        room: room,
        roomNo: roomNo,
        object: object,
        description: description,
        roomPriority: roomTypePriorities[room]!,
        timestamp: DateTime.now(),
        completed: false,
      );

      // Display popup
      _showSubmissionPopup(context);
    } else {
      setState(() {
        submitMessage = 'Please fill out all fields correctly.';
      });
    }
  }

  void _showSubmissionPopup(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Complaint Submitted'),
          content: Text('Your complaint is successfully registered.'),
          actions: [
            TextButton(
              onPressed: () {
                // Close the popup and navigate back to UserHomePage
                Navigator.pop(context);
                // Refresh the UserHomePage
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => UserHomePage()),
                );
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }
}
