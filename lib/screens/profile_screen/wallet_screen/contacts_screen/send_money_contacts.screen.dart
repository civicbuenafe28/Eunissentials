import 'package:flutter/material.dart';
import 'send_money_compute.screen.dart';

class SendMoneyContactsScreen extends StatefulWidget {
  @override
  _SendMoneyContactsScreenState createState() => _SendMoneyContactsScreenState();
}

class _SendMoneyContactsScreenState extends State<SendMoneyContactsScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  final Map<String, List<Map<String, String>>> contactGroups = {
    'A': [{'username': 'Axel Doe', 'contact': '+1234567890'}],
    'B': [{'username': 'Blake Smith', 'contact': '+0987654321'}],
    'C': [{'username': 'Chris Evans', 'contact': '+1122334455'}],
    'D': [{'username': 'Diana Prince', 'contact': '+5566778899'}],
  };

  Map<String, List<Map<String, String>>> get filteredContactGroups {
    if (_searchQuery.isEmpty) return contactGroups;

    final Map<String, List<Map<String, String>>> filtered = {};

    contactGroups.forEach((key, contacts) {
      final matches = contacts.where((contact) {
        final name = contact['username']!.toLowerCase();
        final number = contact['contact']!.toLowerCase();
        return name.contains(_searchQuery.toLowerCase()) ||
            number.contains(_searchQuery.toLowerCase());
      }).toList();

      if (matches.isNotEmpty) {
        filtered[key] = matches;
      }
    });

    final Map<String, List<Map<String, String>>> groupedContacts = {};
    filtered.forEach((key, contacts) {
      for (var contact in contacts) {
        final firstLetter = contact['username']![0].toUpperCase();
        if (!groupedContacts.containsKey(firstLetter)) {
          groupedContacts[firstLetter] = [];
        }
        groupedContacts[firstLetter]!.add(contact);
      }
    });

    final sortedKeys = groupedContacts.keys.toList()..sort();
    final sortedGroupedContacts = <String, List<Map<String, String>>>{};
    for (var key in sortedKeys) {
      sortedGroupedContacts[key] = groupedContacts[key]!;
    }

    return sortedGroupedContacts;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Color(0xFF7B1113), // Maroon color for the header
        leading: InkWell(
          onTap: () {
            Navigator.of(context).pop();
          },
          child: Icon(Icons.arrow_back, color: Colors.white),
        ),
        title: Text(
          'Send Money To',
          style: TextStyle(
              fontSize: 22, color: Colors.white, fontWeight: FontWeight.w900),
        ),
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Search Label
            Padding(
              padding: const EdgeInsets.only(top: 16.0, left: 16),
              child: Text('Search',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: Colors.black)),
            ),

            // Search Input
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                controller: _searchController,
                onChanged: (value) {
                  setState(() {
                    _searchQuery = value;
                  });
                },
                decoration: InputDecoration(
                  hintText: 'Enter username/phone no.',
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(50),
                    borderSide: BorderSide(color: Colors.grey.shade400),
                  ),
                  contentPadding:
                  EdgeInsets.symmetric(horizontal: 20, vertical: 0),
                ),
              ),
            ),

            // Contacts Container
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Container(
                  decoration: BoxDecoration(
                    color: Color(0xFF7B1113), // Maroon background
                    borderRadius: BorderRadius.circular(20),
                  ),
                  padding: EdgeInsets.all(10),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.black, width: 1),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding:
                          const EdgeInsets.only(top: 16.0, left: 16.0),
                          child: Text('Contacts',
                              style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black)),
                        ),
                        Expanded(
                          child: filteredContactGroups.isEmpty
                              ? Center(child: Text('No contacts found'))
                              : ListView(
                            children:
                            filteredContactGroups.entries.map((entry) {
                              return Column(
                                crossAxisAlignment:
                                CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 16, vertical: 10),
                                    child: Text(entry.key,
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold)),
                                  ),
                                  ...entry.value.map((contact) {
                                    return Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 16),
                                      child: Column(
                                        children: [
                                          ListTile(
                                            leading: CircleAvatar(
                                              backgroundColor: Colors
                                                  .grey.shade300,
                                              child: Icon(Icons.person,
                                                  color: Colors
                                                      .grey.shade700),
                                            ),
                                            title: Text(
                                              contact['username']!,
                                              style: TextStyle(
                                                  fontWeight:
                                                  FontWeight.bold),
                                            ),
                                            subtitle: Text(
                                                contact['contact']!),
                                            onTap: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (_) =>
                                                      SendMoneyScreen(
                                                        username:
                                                        contact['username']!,
                                                        contact:
                                                        contact['contact']!,
                                                      ),
                                                ),
                                              );
                                            },
                                          ),
                                          Divider()
                                        ],
                                      ),
                                    );
                                  }).toList(),
                                ],
                              );
                            }).toList(),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}