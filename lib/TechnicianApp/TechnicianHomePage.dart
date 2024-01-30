import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:campus_care/Firestore/FirestoreService.dart';
import 'package:campus_care/TechnicianApp/TechnicianCompletedPage.dart';

class TechnicianHomePage extends StatefulWidget {
  @override
  _TechnicianHomePageState createState() => _TechnicianHomePageState();
}

class _TechnicianHomePageState extends State<TechnicianHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(''),
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
      body: ComplaintList(),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
            icon: Icon(Icons.build),
            label: 'My Complaints',
          ),
        ],
        backgroundColor: Colors.lightGreen,
        onTap: (index) {
          if (index == 1) {
            // Navigate to TechnicianCompletedPage when "My Complaints" icon is pressed
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => TechnicianCompletedPage()),
            );
          }
        },
      ),
    );
  }
}

class ComplaintList extends StatelessWidget {
  final firestoreInstance = FirebaseFirestore.instance;
  static List<QueryDocumentSnapshot<Object?>> complaints = [];
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: firestoreInstance
          .collection('Complaints')
          .where('completed', isEqualTo: false)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(child: Text('No pending complaints available.'));
        }

        complaints = snapshot.data!.docs;
        complaints.sort((a, b) {
          var roomPriorityA = a[
              'roomPriority']; // Replace 'roomPriority' with the actual field name
          var roomPriorityB = b['roomPriority'];

          return roomPriorityA.compareTo(roomPriorityB);
        });

        List<ComplaintCard> complaintCards = [];
        for (var complaint in complaints) {
          var data = complaint.data() as Map<String, dynamic>;

          var building = data['building'];
          var object = data['object'];
          var complaintId = complaint.id;

          var card = ComplaintCard(
            complaintId: complaintId,
            building: building,
            object: object,
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
  final String complaintId;

  ComplaintCard({
    required this.building,
    required this.object,
    required this.complaintId,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Show details popup screen when the box is clicked
        _showDetailsPopup(context);
      },
      child: Card(
        margin: const EdgeInsets.all(10),
        child: ListTile(
          title: Text('Building: $building'),
          subtitle: Text('Object: $object'),
        ),
      ),
    );
  }

  void _showDetailsPopup(BuildContext context) async {
    // Get complete details from Firestore based on complaintId
    var complaintDetails =
        await FirestoreService().getComplaintDetails(complaintId);

    // Implement the details popup screen here
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Complaint Details'),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Name: ${complaintDetails['name']}'),
              Text('Phone Number: ${complaintDetails['phonenumber']}'),
              Text('Building: ${complaintDetails['building']}'),
              Text('Room: ${complaintDetails['room']}'),
              Text('Room No: ${complaintDetails['roomno']}'),
              Text('Floor: ${complaintDetails['floor']}'),
              Text('Object: ${complaintDetails['object']}'),
              Text('Description: ${complaintDetails['description']}'),
            ],
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                // Handle marking the complaint as repaired
                _markAsRepaired(complaintId);
                Navigator.pop(context);
              },
              child: const Text('Repaired'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  void _markAsRepaired(String complaintId) {
    // Call FirestoreService to update completed field to true
    FirestoreService().updateCompletedStatus(complaintId, true);
  }
}
