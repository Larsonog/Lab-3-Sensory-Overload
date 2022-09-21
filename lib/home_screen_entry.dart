//import 'dart:html';

import 'package:flutter/material.dart';
import 'package:overexpose_journal/data_storage_handler.dart';
import 'package:overexpose_journal/journal_entry.dart';
import 'package:transparent_image/transparent_image.dart';

class HomeEntryItem extends StatelessWidget {
  HomeEntryItem({super.key, required this.item});
  final JournalEntry item;
  final DataHandler dataHandler = DataHandler.instance;
  final DateTime now = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(
          maxHeight: 200, maxWidth: MediaQuery.of(context).size.height),
      child: Row(children: [
        FutureBuilder(
            future: dataHandler.getImage(item.path),
            builder: (context, AsyncSnapshot<FileImage> snapshot) {
              if (snapshot.hasData) {
                return Image(image: snapshot.data!);
              } else {
                return Image(image: MemoryImage(kTransparentImage));
              }
            }),
        Column(children: [
          Text(
            '${now.month} / ${now.day} / ${now.year}',
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 30),
          ),
          Text(item.title)
        ])
      ]),
    );
  }
}
