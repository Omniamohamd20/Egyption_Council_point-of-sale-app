import 'package:easy_pos/helpers/sql_helper.dart';
import 'package:easy_pos/models/client.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class ClientsDropDown extends StatefulWidget {
  final int? selectedValue;
  final void Function(int?)? onChanged;
  const ClientsDropDown(
      {super.key, this.selectedValue, this.onChanged});

  @override
  State<ClientsDropDown> createState() => _ClientsDropDownState();
}

class _ClientsDropDownState extends State<ClientsDropDown> {
  List<ClientData>? clients;
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

  @override
  Widget build(BuildContext context) {
    return   clients == null
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : (clients?.isEmpty ?? false)
            ? const Center(
                child: Text('No user Found'),
              )
            : Container(
              width: 300,
              height: 50,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    border: Border.all(color: Color.fromARGB(209, 255, 255, 255))),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  child: DropdownButton(
                      underline: const SizedBox(),
                      isExpanded: true,
                      hint: const Text(
                        'Select Client',
                        style:  TextStyle(
  color: Colors.black
  ,fontSize: 16,
  fontWeight: FontWeight.w400)
                      ),
                      value: widget.selectedValue,
                      items: [
                        for (var client in clients!)
                          DropdownMenuItem(
                            value: client.id,
                            child: Text(client.name ?? 'No Name'),
                          ),
                      ],
                      onChanged: widget.onChanged),
                ),
              );
  }
}
