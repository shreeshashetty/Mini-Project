import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:campus_care/TechnicianApp/TechnicianHomePage.dart';

class TechnicianCompletedPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Completed Tasks'),
        backgroundColor: Colors.lightGreen,
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Image.asset(
              'assets/images/logogreen.jpg',
              width: 40,
              height: 40,
            ),
          ),
        ],
      ),
      body: CompletedComplaintList(),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
            icon: Icon(Icons.build),
            label: 'Completed Tasks',
          ),
        ],
        backgroundColor: Colors.lightGreen,
        onTap: (index) {
          if (index == 0) {
            // Navigate to TechnicianHomePage when "Home" icon is pressed
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => TechnicianHomePage()),
            );
          }
        },
      ),
    );
  }
}

class CompletedComplaintList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('Complaints')
          .where('completed', isEqualTo: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Center(child: Text('No completed tasks available.'));
        }

        var complaints = snapshot.data!.docs;
        List<CompletedComplaintCard> complaintCards = [];
        for (var complaint in complaints) {
          var data = complaint.data() as Map<String, dynamic>;

          var building = data['building'];
          var object = data['object'];
          var description = data['description'];
          var complaintId = complaint.id;

          var card = CompletedComplaintCard(
            building: building,
            object: object,
            description: description,
            complaintId: complaintId,
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

class CompletedComplaintCard extends StatelessWidget {
  final String building;
  final String object;
  final String description;
  final String complaintId;

  CompletedComplaintCard({
    required this.building,
    required this.object,
    required this.description,
    required this.complaintId,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Show details popup screen when the box is clicked
        _showDetailsPopup(context, complaintId);
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

  void _showDetailsPopup(BuildContext context, String complaintId) {
    // Retrieve complaint details from Firestore
    FirebaseFirestore.instance
        .collection('Complaints')
        .doc(complaintId)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        var data = documentSnapshot.data() as Map<String, dynamic>;

        var name = data['name'];
        var phoneNumber = data['phoneNumber'];
        var building = data['building'];
        var room = data['room'];
        var roomNo = data['roomNo'];
        var floor = data['floor'];
        var object = data['object'];
        var description = data['description'];

        // Show details popup screen when the box is clicked
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Completed Task Details'),
              content: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Name: $name'),
                  Text('Phone Number: $phoneNumber'),
                  Text('Building: $building'),
                  Text('Room: $room'),
                  Text('Room No: $roomNo'),
                  Text('Floor: $floor'),
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
      } else {
        print('Document does not exist on the database');
      }
    }).catchError((error) {
      print('Error getting document: $error');
    });
  }
}
