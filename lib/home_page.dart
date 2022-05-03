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
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
                Navigator.of(context).push(PageRouteBuilder(
                  transitionDuration: Duration(milliseconds: 100),
                  transitionsBuilder:
                      (context, animation, secondaryAnimation, child) {
                    // return ScaleTransition(
                    //   scale: animation,
                    //   child: child,
                    //   alignment: Alignment.center,
                    // );
                    return SlideTransition(
                      position: Tween<Offset>(
                        begin: Offset(1, 0),
                        end: Offset.zero,
                      ).animate(CurvedAnimation(
                          parent: animation, curve: Curves.easeOutQuad)),
                      child: child,
                    );
                  },
                  pageBuilder: (context, animation, secondaryAnimation) {
                    return TestPage();
                  },
                ));
              },
              child: Text('To test page'),
            )
          ],
        ),
      ),
    );
  }

  void signOut() {
    FirebaseAuth.instance.signOut();
  }
}
