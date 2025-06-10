import 'package:flutter/material.dart';
import 'contacts.dart';


/*
Notes:
You can't have multiple people with the same name

*/

void main() {
  runApp(App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    ContactList contactList = ContactList([
      Contact("Bob", "testkey", ""),
      Contact("John", "testkey", ""),
      Contact("Jack", "testkey", ""),
      Contact("Jeff", "testkey", ""),
      Contact("Geff", "testkey", ""),
      Contact("Garry", "testkey", ""),
      Contact("Larry", "testkey", ""),
      Contact("Barry", "testkey", ""),
      Contact("Harry", "testkey", ""),
      Contact("Gaylord", "testkey", ""),
      Contact("Timmy", "testkey", ""),
      Contact("Jimmy", "testkey", ""),
      Contact("Soap", "testkey", ""),
      Contact("Price", "testkey", ""),
      Contact("Ghost", "testkey", ""),
    ]);
    return MaterialApp(
      title: 'Vidar', 
      home: ContactListPage(contactList),
    );
  }
}
