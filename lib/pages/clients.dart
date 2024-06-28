import 'dart:ffi';

import 'package:data_table_2/data_table_2.dart';
import 'package:easy_pos/helpers/sql_helper.dart';
import 'package:easy_pos/models/client.dart';
import 'package:easy_pos/pages/clients_ops.dart';
import 'package:easy_pos/widgets/app_table.dart';
import 'package:easy_pos/widgets/bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class ClientsPage extends StatefulWidget {
  const ClientsPage({super.key});

  @override
  State<ClientsPage> createState() => _ClientsPageState();
}

class _ClientsPageState extends State<ClientsPage> {
  List<ClientData>? clients;
  bool _showWidget = false;
  int pressedCount = 0;
  @override
  void initState() {
    getClients();
    super.initState();
  }

  void getClients() async {
    try {
      var sqlHelper = GetIt.I.get<SqlHelper>();
      var data = await sqlHelper.db!.query('clients');
      if (data.isNotEmpty) {
        clients = [];
        for (var item in data) {
          clients!.add(ClientData.fromJson(item));
        }
      } else {
        clients = [];
      }
    } catch (e) {
      print('Error In get data $e');
      clients = [];
    }
    setState(() {});
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Clients'),
        actions: [
          IconButton(
              onPressed: () async {
                var result = await Navigator.push(context,
                    MaterialPageRoute(builder: (ctx) => ClientsOpsPage()));
                if (result ?? false) {
                  getClients();
                }
              },
              icon: const Icon(Icons.add))
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 20.0),
        child: Column(
          children: [
            // search,filter,sort row
            Row(mainAxisAlignment: MainAxisAlignment.start, children: [
              Container(
                width: 295,
                height: 50,
                child: TextField(
                  onChanged: (value) async {
                    var sqlHelper = GetIt.I.get<SqlHelper>();
                    var result = await sqlHelper.db!.rawQuery("""
        SELECT * FROM Clients
        WHERE name LIKE '%$value%' OR phone LIKE '%$value%' OR email LIKE '%$value%' OR address LIKE '%$value%';
          """);
                    if (result.isNotEmpty) {
                      clients = [];
                      for (var item in result) {
                        clients!.add(ClientData.fromJson(item));
                      }
                    } else {
                      clients = [];
                    }
                    setState(() {});
                    // print('values:${result}');
                 
                  },
                  decoration: const InputDecoration(
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(5.0),
                          bottomLeft: Radius.circular(5.0),
                        ),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(1)),
                      ),
                      hintText: 'search'),
                ),
              ),
              Container(
                padding: const EdgeInsets.all(2),
                width: 40,
                height: 50,
                
                              decoration: BoxDecoration(
                                 borderRadius: BorderRadius.only(
            
                    topRight: Radius.circular(5.0),
                    bottomRight: Radius.circular(5.0),
                  
                  ),
                                color: Theme.of(context).primaryColor,
                  border:   Border(  top: BorderSide(color: Colors.black, width: 1.0),
                  right: BorderSide(color: Colors.black, width: 1.0),
                  bottom: BorderSide(color: Colors.black, width: 1.0),
   
                ),
                
                ),

                // color: Theme.of(context).primaryColor,
                child: IconButton(
                  alignment: Alignment.center,
                    iconSize: 18,
                    onPressed: () {
                      setState(() {
                        pressedCount % 2 == 0
                            ? (getSortedData('name', 'ASC'), pressedCount++)
                            : (getSortedData('name', 'DESC'), pressedCount++);
                      });
                    },
                    icon: Icon(Icons.sort_by_alpha_rounded,color: Colors.white,)),
              ),
              Container(
                
                  // padding: const EdgeInsets.all(2),
                  width: 35,
                  height: 50,
                  child: IconButton(
                      iconSize: 18,
                      onPressed: () {
                        setState(() {
                          _showWidget = !_showWidget;
                        });
                      },
                      icon: Icon(
                        
                        _showWidget
                            ?  Icons.filter_alt_off_rounded
                            : Icons.filter_alt,
                            color:  Theme.of(context).primaryColor,size: 25,
                           
                      )))
            ]),
            SizedBox(
              height: 10,
            ),
            if (_showWidget)
              BottomSheetModal(
                text: 'j',
               
              ),
            const SizedBox(
              height: 10,
            ),
            Expanded(
              child: AppTable(
                  minWidth: 1200,
                  columns: const [
                    DataColumn(label: Text('Id')),
                    DataColumn(label: Text('Name')),
                    DataColumn(label: Text('Email')),
                    DataColumn(label: Text('Phone')),
                    DataColumn(label: Text('Address')),
                    DataColumn(label: Center(child: Text('Actions'))),
                  ],
                  source: ClientsSource(
                    clientsEx: clients,
                    onUpdate: (clientData) async {
                      var result = await Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (ctx) => ClientsOpsPage(
                                    clientData: clientData,
                                  )));
                      if (result ?? false) {
                        getClients();
                      }
                    },
                    onDelete: (clientData) {
                      onDeleteRow(clientData.id!);
                    },
                  )),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> getSortedData(String columnName, String sortType) async {
    var sqlHelper = GetIt.I.get<SqlHelper>();
    var data;
    if (sortType == "ASC") {
      data = await sqlHelper.db!.rawQuery("""
SELECT * FROM Clients ORDER BY $columnName ASC;
""");
    }
    if (sortType == "DESC") {
      data = await sqlHelper.db!.rawQuery("""
SELECT * FROM Clients ORDER BY $columnName DESC;
""");
    }
    if (data.isNotEmpty) {
      clients = [];
      for (var item in data) {
        clients!.add(ClientData.fromJson(item));
      }
    } else {
      clients = [];
    }
    setState(() {});
  }

  Future<void> onDeleteRow(int id) async {
    try {
      var dialogResult = await showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text('Delete client'),
              content:
                  const Text('Are you sure you want to delete this client?'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context, false);
                  },
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context, true);
                  },
                  child: const Text('Delete'),
                ),
              ],
            );
          });

      if (dialogResult ?? false) {
        var sqlHelper = GetIt.I.get<SqlHelper>();
        var result = await sqlHelper.db!.delete(
          'clients',
          where: 'id =?',
          whereArgs: [id],
        );
        if (result > 0) {
          getClients();
        }
      }
    } catch (e) {
      print('Error In delete data $e');
    }
  }
}

class ClientsSource extends DataTableSource {
  List<ClientData>? clientsEx;

  void Function(ClientData) onUpdate;
  void Function(ClientData) onDelete;
  ClientsSource(
      {required this.clientsEx,
      required this.onUpdate,
      required this.onDelete});

  @override
  DataRow? getRow(int index) {
    return DataRow2(cells: [
      DataCell(Text('${clientsEx?[index].id}')),
      DataCell(Text('${clientsEx?[index].name}')),
      DataCell(Text('${clientsEx?[index].email}')),
      DataCell(Text('${clientsEx?[index].phone}')),
      DataCell(Text('${clientsEx?[index].address}')),
      DataCell(Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(
              onPressed: () {
                onUpdate(clientsEx![index]);
              },
              icon: const Icon(Icons.edit)),
          IconButton(
              onPressed: () {
                onDelete(clientsEx![index]);
              },
              icon: const Icon(
                Icons.delete,
                color: Colors.red,
              )),
        ],
      )),
    ]);
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => clientsEx?.length ?? 0;

  @override
  int get selectedRowCount => 0;
}
