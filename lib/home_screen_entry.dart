//import 'dart:html';

import 'package:flutter/material.dart';
import 'package:overexpose_journal/data_storage_handler.dart';
import 'package:overexpose_journal/journal_entry.dart';
import 'package:transparent_image/transparent_image.dart';

typedef onNavigateEntryScreenCallback = Function(JournalEntry journalEntry);

class HomeEntryItem extends StatelessWidget {
  HomeEntryItem({super.key, required this.item, required this.onNavigateEntryScreen});
  final JournalEntry item;
  final DataHandler dataHandler = DataHandler.instance;
  final DateTime now = DateTime.now();
  final onNavigateEntryScreenCallback onNavigateEntryScreen;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        onNavigateEntryScreen(item);
      },
      child: Ink(
        height: 100,
        width: MediaQuery.of(context).size.width,
        child: Row(children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: AspectRatio(
              aspectRatio: 1,
              child: FutureBuilder(
                  future: dataHandler.getImage(item.path),
                  builder: (context, AsyncSnapshot<FileImage> snapshot) {
                    if (snapshot.hasData) {
                      return Container(
                        decoration: BoxDecoration( 
                          image: DecorationImage( 
                            image: snapshot.data!,
                            fit: BoxFit.cover
                          )),
                      );
                    } else {
                      return Image(image: MemoryImage(kTransparentImage));
                    }
                  }),
            ),
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(7.0),
                  child: Text(
                    '${now.month} / ${now.day} / ${now.year}',
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 30),
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(7.0),
                  child: Text(
                    item.title,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 30),
                    ),
                ),
              )
            ]),
          )
        ]),
      ),
    );
  }
}
