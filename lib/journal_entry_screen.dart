import 'dart:async';

import 'package:flutter/material.dart';
import 'package:overexpose_journal/journal_entry.dart';
import 'package:overexpose_journal/data_storage_handler.dart';
import 'package:transparent_image/transparent_image.dart';

class JournalEntryScreen extends StatefulWidget {
  const JournalEntryScreen({super.key, this.journal_entry, this.path});

  final JournalEntry? journal_entry;
  final String? path;

  @override
  State<JournalEntryScreen> createState() => _JournalEntryScreenState();
}

class _JournalEntryScreenState extends State<JournalEntryScreen> {

  @override
  Widget build(BuildContext context) {

    final DateTime now = DateTime.now();

    final DataHandler dhandler = DataHandler.instance;

    Future<FileImage> getImage() async {
      FileImage image;
      if (widget.journal_entry == null) {
        image = await dhandler.getImage(widget.path!);
      } else {
        image = await dhandler.getImage(widget.journal_entry!.path);
      }

      return image;
    }
    

    return Scaffold(
      body: SafeArea (
        child: ListView(
          children: [
            ConstrainedBox(
              constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height - 230),
              child: FutureBuilder(
                future: getImage(),
                builder: (context, AsyncSnapshot<FileImage> snapshot) {
                  if (snapshot.hasData) {
                    return Image(
                      image: snapshot.data!,
                      fit: BoxFit.cover,
                      height: double.infinity,
                      width: double.infinity,
                    );
                  } else {
                    return Image(
                      image: MemoryImage(kTransparentImage),
                      fit: BoxFit.cover,
                      height: double.infinity,
                      width: double.infinity,
                    );;
                  }
                }
              ),
            ),
            Text(
              '${now.month} / ${now.day} / ${now.year}',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 30),
            ),

          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          children: [
            IconButton(icon: const Icon(Icons.done), onPressed: () {
              if (widget.journal_entry == null) {
                var entry = JournalEntry(
                  path: widget.path!,
                  date: DateTime.now(),
                  title: '[placeholder]',
                  description: '[placeholder]'
                );
                dhandler.insertEntry(entry);
              }
              Navigator.pushNamed(context, '/home');
            }),
            const Spacer(),
            IconButton(icon: const Icon(Icons.close), onPressed: () {Navigator.pushNamed(context, '/camera');}),
          ],
        ),
      ),
    );
  }
}