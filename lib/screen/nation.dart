import 'dart:async';

import 'package:booking_extra/model/Nation.dart';
import 'package:flutter/material.dart';

class ChooseNationScreen extends StatefulWidget {
  final BuildContext context;

  const ChooseNationScreen(this.context);
  @override
  ChooseNationScreenState createState() => ChooseNationScreenState();
}

class ChooseNationScreenState extends State<ChooseNationScreen> {
  TextEditingController editingController = TextEditingController();
  final chooseNationBloc = new ChooseNationScreenBloc();
  List<Nation> listNations;
  double headerHeight = 110;

  Widget _header(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    return ClipRRect(
      child: Container(
          height: headerHeight,
          width: width,
          color: Colors.green,
          child: Stack(
            alignment: Alignment.center,
            children: <Widget>[
              Positioned(
                  top: 20,
                  left: 0,
                  child: Container(
                      width: width,
                      child: Stack(
                        children: <Widget>[
                          IconButton(
                            icon: Icon(
                              Icons.keyboard_arrow_left,
                              color: Colors.white,
                              size: 40,
                            ),
                            onPressed: (){
                              Navigator.pop(widget.context);
                            },
                          ),
                          Align(
                              alignment: Alignment.center,
                              heightFactor: 2.2,
                              child: Text(
                                'Chọn quốc tịch',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.w500),
                              ))
                        ],
                      ))),
              Positioned(
                bottom: 5,
                child: Container(
                  height: 35,
                  width: width*0.9,
                  decoration: BoxDecoration(color: Colors.grey.shade200,
                    border: Border.all(
                      color: Colors.black,
                      width: 1.5,
                    ),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: TextField(
                    onChanged: (value) {
                      chooseNationBloc.filterRoute(value, listNations);
                    },
                    controller: editingController,
                    decoration: InputDecoration(prefixIcon: Icon(Icons.search),hintStyle: TextStyle(color: Colors.grey),),
                    style: TextStyle(fontSize: 14),
                  ),
                ),
              )
            ],
          )),
    );
  }

  Widget _buildRow(Nation nation) {
    return ListTile(
      title: Text(
        nation.name,
        style: TextStyle(fontSize: 20),
      ),
      leading: Text(nation.id.toString()),
      onTap: () {
        Navigator.pop(widget.context, nation);
      },
    );
  }

  @override
  void initState() {
    listNations=Nation.nationList();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        backgroundColor: Colors.grey.shade200,
        body:  Container(
          child: Column(
            children: <Widget>[
              _header(context),
              Expanded(
                child: StreamBuilder(
                  stream: chooseNationBloc.chooseNationSteam,
                  builder: (context, snapshot) {
                    if(snapshot.hasData){
                      return ListView.builder(
                        shrinkWrap: true,
                        itemCount: snapshot.data.length,
                        itemBuilder: (context, index) {
                          return _buildRow(snapshot.data[index]);
                        },
                      );
                    }else{
                      return ListView.separated(
                        separatorBuilder: (context, index) => Divider(
                          color: Colors.grey.shade500,
                        ),
                        shrinkWrap: true,
                        itemCount: listNations.length,
                        itemBuilder: (context, index) {
                          return _buildRow(listNations[index]);
                        },
                      );
                    }
                  },
                ),
              ),
            ],
          ),
        ));
  }
}

class ChooseNationScreenBloc{
  final _chooseNationController = new StreamController();
  Stream get chooseNationSteam => _chooseNationController.stream;
  filterRoute(String value,List<Nation> defaultList) async{
    if(value.isNotEmpty){
      List<Nation> dummyListData = List<Nation>();
      defaultList.forEach((item) {
        if (item.name.toLowerCase().contains(value)) {
          dummyListData.add(item);
        }
      });
      _chooseNationController.sink.add(dummyListData);
    }else{
      _chooseNationController.sink.add(defaultList);
    }
  }
  dispose(){
    _chooseNationController.close();
  }
}