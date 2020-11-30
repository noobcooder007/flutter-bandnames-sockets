import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:pie_chart/pie_chart.dart';

import 'package:band_names/services/socket_service.dart';
import 'package:band_names/models/Band.dart';

class HomePage extends StatefulWidget {
  static const IDPAGE = "HOME";

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Band> _bands = [];
  @override
  void initState() {
    final socketService = Provider.of<SocketService>(context, listen: false);
    socketService.socket.on('active-bands', _handleActiveBands);
    super.initState();
  }

  void _handleActiveBands(dynamic payload) {
    this._bands = (payload as List).map((band) => Band.fromMap(band)).toList();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final socketService = Provider.of<SocketService>(context);

    return Scaffold(
      appBar: AppBar(
          title: Text(
            'BandNames',
            style: TextStyle(color: Colors.black87),
          ),
          backgroundColor: Colors.white,
          elevation: 1,
          actions: [
            Container(
              margin: EdgeInsets.only(right: 10.0),
              child: socketService.serverStatus == ServerStatus.Online
                  ? Icon(Icons.check_circle_outline, color: Colors.green)
                  : Icon(Icons.error_outline, color: Colors.red),
            )
          ]),
      body: Column(
        children: [
          (_bands.length > 0) ? _showGraph() : Container(),
          Expanded(
            child: ListView.builder(
                itemBuilder: (context, index) => _bandTile(_bands[index]),
                itemCount: _bands.length),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        elevation: 1,
        onPressed: addNewBand,
      ),
    );
  }

  Widget _bandTile(Band band) {
    final socketService = Provider.of<SocketService>(context, listen: false);
    return Dismissible(
      key: Key(band.id),
      direction: DismissDirection.startToEnd,
      onDismissed: (_) => Provider.of<SocketService>(context, listen: false)
          .socket
          .emit('delete-band', {'id': band.id}),
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
        trailing: Text('${band.votes}', style: TextStyle(fontSize: 20.0)),
        onTap: () => socketService.socket.emit('vote-band', {'id': band.id}),
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
    if (name.length > 1)
      Provider.of<SocketService>(context, listen: false)
          .socket
          .emit('add-band', {'name': name});

    Navigator.pop(context);
  }

  Widget _showGraph() {
    Map<String, double> dataMap = Map();
    // dataMap.putIfAbsent('Flutter', () => 5);
    _bands.forEach((band) {
      dataMap.putIfAbsent(band.name, () => band.votes.toDouble());
    });
    return Container(width: double.infinity, height: 200, child: PieChart(dataMap: dataMap));
  }
}
