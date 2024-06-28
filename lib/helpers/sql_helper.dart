import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi_web/sqflite_ffi_web.dart';

class SqlHelper {
  Database? db;

  Future<void> init() async {
    try {
      if (kIsWeb) {
        //web
        var factory = databaseFactoryFfiWeb;
        db = await factory.openDatabase('pos.db');
      } else {
        db = await openDatabase(
          'pos.db',
          version: 1,
          onCreate: (db, version) {
            print('database created successfully');
          },
        );
      }
    } catch (e) {
      print('Error in creating database: $e');
    }
  }

  Future<void> registerForeignKeys() async {
    await db!.rawQuery("PRAGMA foreign_keys = ON");
    var result = await db!.rawQuery("PRAGMA foreign_keys");
    print('foreign keys result: $result');
  }

//future =>await
  Future<bool> createTables() async {
    await registerForeignKeys();
    try {
      var batch = db!.batch();
      //creating categories table
      batch.execute("""
        Create table if not exists categories(
          id integer primary key, 
          name text not null,
          description text not null
          ) 
          """);
      // creating exchange table
      batch.execute("""
        Create table if not exists exchange(
          id integer primary key,
          fromCurrencyName text not null,
          fromCurrency real,
          toCurrencyName text not null,
          toCurrency real ,
          rate real
          ) 
          """);
    

      //creating products table
      batch.execute("""
        Create table if not exists products(
          id integer primary key,
          name text not null,
          description text not null,
          price double not null,
          stock integer not null,
          isAvailable boolean not null,
          image text,
          categoryId integer not null,
          foreign key(categoryId) references categories(id)
          on delete restrict
          ) 
          """);

      //creating clients table
      batch.execute("""
        Create table if not exists clients(
          id integer primary key,
          name text not null,
          email text,
          phone text,
          address text
          ) 
          """);
// creating table  orders
      batch.execute("""
        Create table if not exists orders(
          id integer primary key,
          label text ,
          totalPrice real,
          discount real ,
          clientId integer not null ,
          foreign key(clientId) references clients(id)
          on delete restrict 

          ) 
          """);
// creating table orderProductItems
      batch.execute("""
Create table if not exists orderProductItems (
orderId integer ,
productCount integer ,
productId integer ,
foreign key(productId) references products(id)
    on delete restrict
)
""");

      var result = await batch.commit();
      print('results $result');
      return true;
    } catch (e) {
      print('Error in creating table: $e');
      return false;
    }
  }

  query(String tableName,
      {required String where,
      required List<int> whereArgs,
      required int limit}) {}

  getSingleRow(String s, int i) {}

  execute(String s, Map<String, dynamic> map) {}

  insert(String s, Map<String, Object> map) {}
}
