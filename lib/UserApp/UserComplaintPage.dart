import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserComplaintPage extends StatefulWidget {
  @override
  _UserComplaintPageState createState() => _UserComplaintPageState();
}

class _UserComplaintPageState extends State<UserComplaintPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Complaints'),
        backgroundColor: Colors.lightGreen,
        actions: [
          Padding(
            padding: const EdgeInsets.all(0),
            child: Image.asset(
              'assets/images/logogreen.jpg', // Replace with your image path
              width: 80, // Set the desired width
              height: 80, // Set the desired height
            ),
          ),
        ],
      ),
      body: ComplaintList(),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
              icon: Icon(Icons.build), label: 'My Complaints'),
        ],
        backgroundColor: Colors.lightGreen,
        onTap: (index) {
          if (index == 0) {
            // Navigate to UserHomePage when "Home" icon is pressed
            Navigator.pop(context);
          }
        },
      ),
    );
  }
}

class ComplaintList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('Complaints')
          .where('completed', isEqualTo: false) // Filter by completed: false
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Center(child: Text('No complaints available.'));
        }

        var complaints = snapshot.data!.docs;
        List<ComplaintCard> complaintCards = [];
        for (var complaint in complaints) {
          var data = complaint.data() as Map<String, dynamic>;

          var building = data['building'];
          var object = data['object'];
          var name = data['name'] ?? ''; // Check for null
          var phoneNumber = data['phoneNumber'] ?? ''; // Check for null
          var floor = data['floor'] ?? ''; // Check for null
          var room = data['room'] ?? ''; // Check for null
          var roomNo = data['roomNo'] ?? ''; // Check for null
          var description = data['description'] ?? ''; // Check for null
          var timestamp = data['timestamp'];

          var card = ComplaintCard(
            building: building,
            object: object,
            name: name,
            phoneNumber: phoneNumber,
            floor: floor,
            room: room,
            roomNo: roomNo,
            description: description,
            timestamp: timestamp,
          );
          complaintCards.add(card);
        }

        return ListView(
          children: complaintCards,
        );
      },
    );
  }
}

class ComplaintCard extends StatelessWidget {
  final String building;
  final String object;
  final String name;
  final String phoneNumber;
  final String floor;
  final String room;
  final String roomNo;
  final String description;
  final Timestamp timestamp;

  ComplaintCard({
    required this.building,
    required this.object,
    required this.name,
    required this.phoneNumber,
    required this.floor,
    required this.room,
    required this.roomNo,
    required this.description,
    required this.timestamp,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Show details popup screen when the box is clicked
        _showDetailsPopup(context);
      },
      child: Card(
        margin: EdgeInsets.all(10),
        child: ListTile(
          title: Text('Building: $building'),
          subtitle: Text('Object: $object'),
        ),
      ),
    );
  }

  void _showDetailsPopup(BuildContext context) {
    // Implement the details popup screen here
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Complaint Details'),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Name: $name'),
              Text('Phone Number: $phoneNumber'),
              Text('Building: $building'),
              Text('Floor: $floor'),
              Text('Room: $room'),
              Text('Room No: $roomNo'),
              Text('Object: $object'),
              Text('Description: $description'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }
}
