import 'dart:async';

import 'package:flutter/material.dart';
import 'package:overexpose_journal/journal_entry.dart';
import 'package:overexpose_journal/data_storage_handler.dart';
import 'package:transparent_image/transparent_image.dart';

class JournalEntryScreen extends StatefulWidget {
  const JournalEntryScreen({super.key, this.journalEntry, this.path});

  final JournalEntry? journalEntry;
  final String? path;

  @override
  State<JournalEntryScreen> createState() => _JournalEntryScreenState();
}

class _JournalEntryScreenState extends State<JournalEntryScreen> {


  final DateTime now = DateTime.now();

  final DataHandler dhandler = DataHandler.instance;

  final _entryForm = GlobalKey<FormState>();

  final List<TextEditingController> entryControllers = [TextEditingController(), TextEditingController()];

  @override
  void dispose() {
    entryControllers.map((e) => e.dispose());
    super.dispose();
  }

  Future<FileImage> getImage() async {
    FileImage image;
    if (widget.journalEntry == null) {
      image = await dhandler.getImage(widget.path!);
    } else {
      image = await dhandler.getImage(widget.journalEntry!.path);
    }

    return image;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea (
        child: ListView(
          children: [
            ConstrainedBox(
              constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height - 250),
              child: FutureBuilder(
                future: getImage(),
                builder: (context, AsyncSnapshot<FileImage> snapshot) {
                  if (snapshot.hasData) {
                    return Image(
                      key: const Key('I'),
                      image: snapshot.data!,
                      fit: BoxFit.cover,
                      height: double.infinity,
                      width: double.infinity,
                    );
                  } else {
                    return Image(
                      key: const Key('I'),
                      image: MemoryImage(kTransparentImage),
                      fit: BoxFit.cover,
                      height: double.infinity,
                      width: double.infinity,
                    );
                  }
                }
              ),
            ),
            const SizedBox(height: 20),
            Text(
              '${now.month} / ${now.day} / ${now.year}',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 30),
            ),
            const SizedBox(height: 10),
            (widget.journalEntry == null)?
            Form(
              key: _entryForm,
              child: 
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      key: const Key('FT'),
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Enter a title',
                      ),
                      controller: entryControllers[0],
                      style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                      validator: (inputValue){
                        if (inputValue == null || inputValue.isEmpty) {
                          return 'Please enter a title';
                        }
                        return null;
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      key: const Key('FD'),
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Enter a description',
                      ),
                      controller: entryControllers[1],
                      maxLines: null,
                      style: const TextStyle(fontSize: 23),
                      validator: (inputValue){
                        if (inputValue == null || inputValue.isEmpty) {
                          return 'Please enter a description';
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),
            ):
            Column(children: [
              Text(
                widget.journalEntry!.title, 
                textAlign: TextAlign.center,
              ),
              Text(
                widget.journalEntry!.description,
                textAlign: TextAlign.justify,
                maxLines: null,
              ),
            ],),
            const SizedBox(height: 10)
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          children: [
            IconButton(icon: const Icon(Icons.done), key: const Key('BY'), onPressed: () {
              if (widget.journalEntry == null) {
                if (_entryForm.currentState!.validate()) {
                  var entry = JournalEntry(
                    path: widget.path!,
                    date: now,
                    title: entryControllers[0].text,
                    description: entryControllers[1].text
                  );
                  dhandler.insertEntry(entry);
                  int count = 0;
                  Navigator.popUntil(context, (_) => count++ >= 2);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Please finish writing entry...')),
                  );
                }
              } else {
                int count = 0;
                Navigator.popUntil(context, (_) => count++ >= 2);              }
            }),
            const Spacer(),
            IconButton(icon: const Icon(Icons.close), key: const Key('BN'), onPressed: () {Navigator.pushNamed(context, '/camera');}),
          ],
        ),
      ),
    );
  }
}

class JournalEntryArguments {
  const JournalEntryArguments({this.journalEntry, this.path});

  final JournalEntry? journalEntry;
  final String? path;
}