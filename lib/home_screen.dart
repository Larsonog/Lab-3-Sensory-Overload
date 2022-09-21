import 'package:flutter/material.dart';
import 'package:overexpose_journal/data_storage_handler.dart';
import 'package:overexpose_journal/home_screen_entry.dart';
import 'package:overexpose_journal/journal_entry.dart';
//import 'dart:html';
import 'dart:async';

import 'package:overexpose_journal/journal_entry_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  //final String title;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
}

class _HomeScreenState extends State<HomeScreen> {
  // list of lists of journal entries
  // sort list
  // list sort funtion defines the rule we use

  Future<List<List<JournalEntry>>> _newFuture() async {
    final DataHandler dhandler = DataHandler.instance;
    List<JournalEntry> jentry =
        await dhandler.getAllEntries(); // gets all entries
    jentry.sort(((a, b) => a.date.compareTo(b.date))); // sort by date
    List<List<JournalEntry>> weekList = sortWeek(jentry);
    return weekList;
  }

  List<List<JournalEntry>> sortWeek(List<JournalEntry> jlist) {
    // puts date entries into weeks
    DateTime end = DateTime.utc(0);
    List<JournalEntry> week = [];
    List<List<JournalEntry>> returnList = [];
    for (int i = 0; i < jlist.length; i++) {
      DateTime currDate = jlist[i].date;
      if (currDate.isBefore(end)) {
        week.add(jlist[i]);
      } else {
        List<JournalEntry> addList = [];
        addList.addAll(week);
        if (addList.isNotEmpty) {
          returnList.add(addList);
        }
        week = [];
        week.add(jlist[i]);
        int days = currDate.difference(end).inDays + (7 - currDate.weekday);
        end = end.add(Duration(days: days));
      }
    }
    returnList.add(week);
    return returnList;
  }

  void _handleNavigateEntryPage(JournalEntry entry) {
    setState(() {
      Navigator.pushNamed(context, '/entry', arguments: JournalEntryArguments(journalEntry: entry));
    });
  }

  @override
  Widget build(BuildContext context) {
    final PageController controller = PageController();

    return Scaffold(
      appBar: AppBar(title: const Text('OverExpose Journal')),
      body: FutureBuilder(
        future: _newFuture(),
        builder: (context, AsyncSnapshot<List<List<JournalEntry>>> snapshot) {
          if (snapshot.hasData) {
            return PageView(
              controller: controller,
              children: snapshot.data!.map((list) {
                return Column(
                  children: [
                    //header with week value
                    Expanded(
                      child: ListView.separated(
                        itemCount: list.length,
                        itemBuilder: ((context, index) {
                          return HomeEntryItem(item: list[index], onNavigateEntryScreen: _handleNavigateEntryPage);
                        }),
                        separatorBuilder: (context, index) {
                          return Divider(
                            indent: 8.0,
                            endIndent: 8.0,
                            thickness: 1.0,
                            color: Theme.of(context).primaryColor,
                          );
                        },
                      ),
                    ),
                  ],
                );
              }).toList(),
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.pushNamed(context, '/camera');
          setState(() {});
        },
        child: const Icon(Icons.camera_alt),
      ),
    );
  }
}
//Getalldataentries

//future
// map list of list in pageview (week like) // page view has list view
// custom widget for each list item
/// in list of list items
