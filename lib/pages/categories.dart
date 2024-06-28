import 'package:data_table_2/data_table_2.dart';
import 'package:easy_pos/helpers/sql_helper.dart';
import 'package:easy_pos/models/category_data.dart';
import 'package:easy_pos/pages/category_ops.dart';
import 'package:easy_pos/widgets/app_table.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class CategoriesPage extends StatefulWidget {
  const CategoriesPage({super.key});

  @override
  State<CategoriesPage> createState() => _CategoriesPageState();
}

class _CategoriesPageState extends State<CategoriesPage> {
  List<CategoryData>? categories;
    bool _showWidget = false;
  int pressedCount = 0;
  @override
  void initState() {
    getCategories();
    super.initState();
  }

  void getCategories() async {
    try {
      var sqlHelper = GetIt.I.get<SqlHelper>();
      var data = await sqlHelper.db!.query('categories');

      if (data.isNotEmpty) {
        categories = [];
        for (var item in data) {
          categories!.add(CategoryData.fromJson(item));
        }
      } else {
        categories = [];
      }
    } catch (e) {
      print('Error In get data $e');
      categories = [];
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Categories'),
        actions: [
          IconButton(
              onPressed: () async {
                var result = await Navigator.push(context,
                    MaterialPageRoute(builder: (ctx) => CategoriesOpsPage()));
                if (result ?? false) {
                  getCategories();
                }
              },
              icon: const Icon(Icons.add))
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
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
        SELECT * FROM Categories
        WHERE name LIKE '%$value%' OR description LIKE '%$value%';
          """);
                    if (result.isNotEmpty) {
                      categories = [];
                      for (var item in result) {
                        categories!.add(CategoryData.fromJson(item));
                      }
                    } else {
                      categories = [];
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
                  border: Border(
                    top: BorderSide(color: Colors.black, width: 1.0),
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
                    icon: Icon(
                      Icons.sort_by_alpha_rounded,
                      color: Colors.white,
                    )),
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
                            ? Icons.filter_alt_off_rounded
                            : Icons.filter_alt,
                        color: Theme.of(context).primaryColor,
                        size: 25,
                      )))
            ]),
            SizedBox(
              height: 10,
            ),
            if (_showWidget)
                     Row(
                  // mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                        width: 370,
                        height: 100,
                        decoration: BoxDecoration(
                          color: Color.fromARGB(255, 228, 227, 227),
                          borderRadius: BorderRadius.circular(1.0),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            // sort button
                            ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    minimumSize: Size(30, 25),
                                    // backgroundColor: Colors.white
                                    ),
                                onPressed: () async {
                                  setState(() {
                                  
                                  });
                                },
                                child: Text(
                                  'filter1',
                                 ),),
                            SizedBox(
                              width: 5,
                            ),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  minimumSize: Size(30, 25),
                              ),
                              onPressed: () {
                                setState(() {
                                 
                                });
                              },
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    'filter 2',
                                  ),
                                ],
                              ),
                            ),
                          ],
                        )),
                  ]),
            const SizedBox(
              height: 10,
            ),
            Expanded(
                child: AppTable(
                    columns: const [
                  DataColumn(label: Text('Id')),
                  DataColumn(label: Text('Name')),
                  DataColumn(label: Text('Description')),
                  DataColumn(label: Center(child: Text('Actions'))),
                ],
                    source: CategoriesTableSource(
                      categoriesEx: categories,
                      onUpdate: (categoryData) async {
                        var result = await Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (ctx) => CategoriesOpsPage(
                                      categoryData: categoryData,
                                    )));
                        if (result ?? false) {
                          getCategories();
                        }
                      },
                      onDelete: (categoryData) {
                        onDeleteRow(categoryData.id!);
                      },
                    ))),
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
SELECT * FROM Categories ORDER BY $columnName ASC;
""");
    }
    if (sortType == "DESC") {
      data = await sqlHelper.db!.rawQuery("""
SELECT * FROM Categories ORDER BY $columnName DESC;
""");
    }
    if (data.isNotEmpty) {
      categories = [];
      for (var item in data) {
       categories!.add(CategoryData.fromJson(item));
      }
    } else {
      categories = [];
    }
    setState(() {});
  }


  Future<void> onDeleteRow(int id) async {
    try {
      var dialogResult = await showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text('Delete Category'),
              content:
                  const Text('Are you sure you want to delete this category?'),
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
          'categories',
          where: 'id =?',
          whereArgs: [id],
        );
        if (result > 0) {
          getCategories();
        }
      }
    } catch (e) {
      print('Error In delete data $e');
    }
  }
}

class CategoriesTableSource extends DataTableSource {
  List<CategoryData>? categoriesEx;

  void Function(CategoryData) onUpdate;
  void Function(CategoryData) onDelete;
  CategoriesTableSource(
      {required this.categoriesEx,
      required this.onUpdate,
      required this.onDelete});

  @override
  DataRow? getRow(int index) {
    return DataRow2(cells: [
      DataCell(Text('${categoriesEx?[index].id}')),
      DataCell(Text('${categoriesEx?[index].name}')),
      DataCell(Text('${categoriesEx?[index].description}')),
      DataCell(Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(
              onPressed: () {
                onUpdate(categoriesEx![index]);
              },
              icon: const Icon(Icons.edit)),
          IconButton(
              onPressed: () {
                onDelete(categoriesEx![index]);
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
  int get rowCount => categoriesEx?.length ?? 0;

  @override
  int get selectedRowCount => 0;
}
