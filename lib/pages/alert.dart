import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

class AlertPage extends StatefulWidget {
  const AlertPage({super.key});

  @override
  State<AlertPage> createState() => _AlertPageState();
}

class _AlertPageState extends State<AlertPage> {
  final currentUser = FirebaseAuth.instance.currentUser;

  Future<String> getImageUrl(String det) async {
    Reference ref = FirebaseStorage.instance.ref().child('uploads/$det.jpg');
    try {
      // Get the download URL
      final url = await ref.getDownloadURL();
      return url;
    } catch (e) {
      // If any error occurs, return a default image URL or an empty string
      return '';
    }
  }

  void showImageDialog(String imageUrl) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          child: Container(
            padding: EdgeInsets.all(10),
            child: Image.network(
              imageUrl,
              fit: BoxFit.contain,
            ),
          ),
        );
      },
    );
  }

  bool isNew(DateTime timestamp) {
    // Consider a violation new if it's less than 24 hours old
    return timestamp.isAfter(DateTime.now().subtract(Duration(hours: 24)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Alerts and Violations'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(currentUser!.email)
            .collection('violations')
            .orderBy('timestamp', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
            return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                var document = snapshot.data!.docs[index];
                var det = document.id;
                var timestamp = (document['timestamp'] as Timestamp).toDate();
                return FutureBuilder(
                  future: getImageUrl(det),
                  builder: (context, AsyncSnapshot<String> imageSnapshot) {
                    return Container(
                      color: isNew(timestamp) ? Colors.yellow[100] : Colors.grey[300],
                      child: ListTile(
                        title: Text(document['violation'] ?? 'No description'),
                        subtitle: Text(timestamp.toString()),
                        leading: GestureDetector(
                          onTap: () {
                            if (imageSnapshot.data!.isNotEmpty) {
                              showImageDialog(imageSnapshot.data!);
                            }
                          },
                          child: imageSnapshot.data!.isNotEmpty
                              ? Image.network(
                            imageSnapshot.data!,
                            width: 100,
                            height: 100,
                            fit: BoxFit.cover,
                          )
                              : Icon(Icons.broken_image),
                        ),
                      ),
                    );
                  },
                );
              },
            );
          } else {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.notifications_outlined,
                    size: 150,
                    color: Color(0x6642aec0),
                  ),
                  Text(
                    'Nothing to alert.',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Color(0x6642aec0),
                    ),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
