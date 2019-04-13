import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class DataList extends StatefulWidget {
  final List dataList;

  const DataList({Key key, @required this.dataList}) : super(key: key);

  @override
  _DataListState createState() => _DataListState();
}

class _DataListState extends State<DataList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("List of elements"),
        centerTitle: true,
      ),
      body: _buildBody(),
            
          );
        }
      
  Widget _buildBody() {
    return ListView.builder(
      itemCount: widget.dataList.length,
      itemBuilder: (BuildContext context, int index) {
        return ListTile(
          title: Text(widget.dataList[index]),
          trailing: IconButton(
            icon: Icon(Icons.content_copy),
            onPressed: () {
              Clipboard.setData(ClipboardData(
                text: widget.dataList[index]
              ));
              
              Scaffold.of(context).showSnackBar(SnackBar(content: Text('"${widget.dataList[index]}" copied!')));

              
            },
          ),
        );
      },
    );
  }
}