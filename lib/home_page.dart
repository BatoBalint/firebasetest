import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebasetest/test_page.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser!;
    Stream<QuerySnapshot> ingridientsStream =
        FirebaseFirestore.instance.collection('ingridient').snapshots();

    return Scaffold(
      drawer: Drawer(
        child: Column(
          children: [
            ListTile(
              title: const Text(
                'Log out',
                style: TextStyle(color: Colors.red),
              ),
              onTap: signOut,
            ),
            ListTile(
              title: const Text(
                'Close drawer',
                style: TextStyle(color: Colors.orange),
              ),
              onTap: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Builder(builder: (context) {
              return IconButton(
                onPressed: () {
                  Scaffold.of(context).openDrawer();
                },
                icon: Icon(Icons.menu),
              );
            }),
            const Text(
              'Currently logged in as',
              style: TextStyle(color: Colors.grey),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Text(
                user.email!,
                style: const TextStyle(fontSize: 24),
              ),
            ),
            Container(
              height: 400,
              child: StreamBuilder(
                stream: ingridientsStream,
                builder: (
                  BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot,
                ) {
                  if (snapshot.hasError) {
                    return const Text('Hiba történt betöltés közben');
                  }
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Text('Töltés folyamatban');
                  }

                  final data = snapshot.requireData;
                  return ListView.builder(
                    itemCount: data.size,
                    itemBuilder: (context, index) {
                      return Text(
                        data.docs[index]['name'],
                        style: const TextStyle(fontSize: 18),
                      );
                    },
                  );
                },
              ),
            ),
            ElevatedButton(
              onPressed: () {
                openTestPage(context);
              },
              child: Text('To test page'),
            )
          ],
        ),
      ),
    );
  }

  void openTestPage(BuildContext context) {
    getIngridients();
    Navigator.of(context).push(PageRouteBuilder(
      transitionDuration: const Duration(milliseconds: 150),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(1, 0),
            end: Offset.zero,
          ).animate(
              CurvedAnimation(parent: animation, curve: Curves.easeInOutQuad)),
          child: child,
        );
      },
      pageBuilder: (context, animation, secondaryAnimation) {
        return TestPage();
      },
    ));
  }

  void getIngridients() async {
    QuerySnapshot<Map<String, dynamic>> ingridients =
        await FirebaseFirestore.instance.collection('ingridient').get();
  }

  void signOut() {
    FirebaseAuth.instance.signOut();
  }
}
