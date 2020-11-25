import 'package:flutter/material.dart';

import 'package:band_names/models/Band.dart';

class HomePage extends StatefulWidget {
  static const IDPAGE = "HOME";

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Band> _bands = [
    Band(id: '1', name: 'Metallica', votes: '5'),
    Band(id: '2', name: 'Queen', votes: '1'),
    Band(id: '2', name: 'Heroes del Silencio', votes: '2'),
    Band(id: '2', name: 'Bon Jovi', votes: '5'),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'BandNames',
          style: TextStyle(color: Colors.black87),
        ),
        backgroundColor: Colors.white,
      ),
      body: ListView.builder(
          itemBuilder: (context, index) => _bandTile(_bands[index]),
          itemCount: _bands.length),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        elevation: 1,
        onPressed: addNewBand,
      ),
    );
  }

  Widget _bandTile(Band band) {
    return Dismissible(
      key: Key(band.id),
      direction: DismissDirection.startToEnd,
      onDismissed: (direction) {
        
      },
      background: Container(
        color: Colors.red,
        child: Align(
            alignment: Alignment.centerLeft,
            child: Padding(
                padding: EdgeInsets.all(10.0),
                child: Text(
                  'Delete Band',
                  style: TextStyle(color: Colors.white),
                ))),
      ),
      child: ListTile(
        leading: CircleAvatar(
          child: Text(band.name.substring(0, 2)),
          backgroundColor: Colors.blue[100],
        ),
        title: Text(band.name),
        trailing: Text(band.votes, style: TextStyle(fontSize: 20.0)),
        onTap: () {
          print(band.name);
        },
      ),
    );
  }

  addNewBand() {
    final TextEditingController _bandNameEditingController =
        TextEditingController();
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Add new band:'),
            content: TextField(controller: _bandNameEditingController),
            actions: [
              MaterialButton(
                  onPressed: () {
                    addBandToList(_bandNameEditingController.text);
                  },
                  child: Text('Add'),
                  elevation: 5,
                  textColor: Colors.blue),
            ],
          );
        });
  }

  addBandToList(String name) {
    if (name.length > 1) {
      setState(() {
        _bands.add(Band(id: DateTime.now().toString(), name: name, votes: '0'));
      });
    }
    Navigator.pop(context);
  }
}
