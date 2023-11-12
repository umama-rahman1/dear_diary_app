import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'diary_entry_view.dart';
import 'package:dear_diary_app/diary_firestore_model/diary_entry_model.dart';
import 'package:dear_diary_app/controller/diary_entry_service.dart';

class DiaryLogFirebaseView extends StatelessWidget {
  DiaryLogFirebaseView({Key? key}) : super(key: key);

  // Instance of DiaryEntryService to interact with Firestore for CRUD operations on diary entries.
  final DiaryEntryService diaryEntryService = DiaryEntryService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // App bar with a title and a logout button.
      appBar: AppBar(
        title: Text("Dear Diary"),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            // Sign out the user on pressing the logout button.
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
            },
          ),
        ],
      ),
      // Body of the widget using a StreamBuilder to listen for changes
      // in the diary entries collection and reflect them in the UI in real-time.
      body: StreamBuilder<List<DiaryEntry>>(
        stream: diaryEntryService.getUsersDiaryEntries(),
        builder: (context, snapshot) {
          // Show a loading indicator until data is fetched from Firestore.
          if (!snapshot.hasData) return CircularProgressIndicator();
          final entries = snapshot.data!;

          // Build a list of diary entries using ListView.builder.
          return ListView.builder(
            itemCount: entries.length,
            itemBuilder: (context, index) {
              final entry = entries[index];
              // Display each diary entry's date, title, and content.
              return ListTile(
                title: Text(entry.date.toString()),
                subtitle: Text(entry.description),
                onTap: () {
                  // TODO: Handle tapping on a diary entry to view details.
                },
                // TODO: In the future, edit and delete buttons can be added here.
              );
            },
          );
        },
      ),
      // Floating action button to open a dialog for adding a new diary entry.
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Display the AddDiaryEntryDialog when the button is pressed.
          showDialog(
            context: context,
            builder: (context) => DiaryEntryView(),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}


// import 'package:flutter/material.dart';
// import 'package:dear_diary_app/diary_firestore_model/diary_entry_model.dart';
// import 'package:dear_diary_app/controller/diary_entry_service.dart';

// class DiaryLogView extends StatelessWidget {
//   final DiaryEntryService diaryEntryService = DiaryEntryService();

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Diary Log'),
//       ),
//       body: StreamBuilder<List<DiaryEntry>>(
//         stream: diaryEntryService.getUsersDiaryEntries(),
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return Center(
//               child: CircularProgressIndicator(),
//             );
//           } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
//             return Center(
//               child: Text('No diary entries found.'),
//             );
//           } else {
//             return ListView.builder(
//               itemCount: snapshot.data!.length,
//               itemBuilder: (context, index) {
//                 return DiaryEntryCard(
//                   diaryEntry: snapshot.data![index],
//                   onDelete: () {
//                     // Handle onDelete if needed
//                     // For example, you can show a confirmation dialog
//                     // and then call diaryEntryService.removeDiaryEntry
//                     // to delete the entry from Firestore.
//                   },
//                 );
//               },
//             );
//           }
//         },
//       ),
//     );
//   }
// }

// class DiaryEntryCard extends StatelessWidget {
//   final DiaryEntry diaryEntry;
//   final VoidCallback onDelete;

//   DiaryEntryCard({required this.diaryEntry, required this.onDelete});

//   @override
//   Widget build(BuildContext context) {
//     return Dismissible(
//       key: Key(diaryEntry.id!),
//       onDismissed: (_) {
//         onDelete();
//       },
//       background: Container(
//         color: Colors.red,
//         child: Icon(
//           Icons.delete,
//           color: Colors.white,
//         ),
//         alignment: Alignment.centerRight,
//         padding: EdgeInsets.only(right: 16.0),
//       ),
//       child: Card(
//         margin: EdgeInsets.all(8.0),
//         child: ListTile(
//           title: Text(
//             'Date: ${diaryEntry.date.toLocal()}',
//             style: TextStyle(fontWeight: FontWeight.bold),
//           ),
//           subtitle: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text('Description: ${diaryEntry.description}'),
//               Text('Rating: ${diaryEntry.rating}'),
//             ],
//           ),
//           onTap: () {
//             // Handle onTap if needed
//           },
//           onLongPress: () {
//             // Handle onLongPress if needed
//           },
//         ),
//       ),
//     );
//   }
// }

// void main() {
//   runApp(MaterialApp(
//     home: DiaryLogView(),
//   ));
// }
