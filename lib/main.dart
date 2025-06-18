import 'package:flutter/material.dart';
import 'package:sms_advanced/sms_advanced.dart';
import 'contacts.dart';


/*
Notes:
You can't have multiple people with the same name
Use the edit contact page to create new ones by just entering a blank contact
If a part is missing then do an alert

if contact has no key then no encryption is done (i.e it sends plain text)

to format phone numbers maybe use the "phone_numbers_parser" package

have a "generate key" button beside the key field 
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
    SmsQuery query = SmsQuery();
    return MaterialApp(
      title: 'Vidar', 
      home: ContactListPage(contactList, query),
    );
  }
}
