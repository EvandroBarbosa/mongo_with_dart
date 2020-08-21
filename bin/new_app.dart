import 'dart:io';
import 'dart:convert';
import 'package:mongo_dart/mongo_dart.dart';

void main(List<String> arguments) async {
  int port = 3000;
  var server = await HttpServer.bind('localhost', port);

  Db db = new Db('mongodb://localhost:27017/test');

  await db.open();

  // Access a collection
  DbCollection coll = db.collection('people');

  server.listen((HttpRequest req) async {
    var content = await req.cast<List<int>>().transform(Utf8Decoder()).join();
    var document = json.decode(content);
    var people = await coll.find().toList();
    switch (req.uri.path) {
      case '/':
        req.response
          ..write('Hello world')
          ..close();
        break;
      case '/people':
        // Handle GET request
        if (req.method == 'GET') {
          req.response.write(people);
        }
        // Handle POST request
        else if (req.method == 'POST') {
          await coll.save(document);
        }
        // Handle PUT request
        else if (req.method == 'PUT') {
          var id = int.parse(req.uri.queryParameters['id']);
          var itemToReplace = await coll.findOne(where.eq('id', id));

          if (itemToReplace == null) {
            await coll.save(document);
          } else {
            await coll.update(itemToReplace, document);
          }
        }
        // Handle DELETE request
        else if (req.method == 'DELETE') {
          var id = int.parse(req.uri.queryParameters['id']);
          var itemToDelete = await coll.findOne(where.eq('id', id));
          await coll.remove(itemToDelete);
          print('Item removido com sucesso');
        }
        // Handle PATCH request
        else if (req.method == 'PATCH') {
          var id = int.parse(req.uri.queryParameters['id']);
          var itemToPatch = await coll.findOne(where.eq('id', id));
          await coll.update(itemToPatch, {
            r'$set': document,
          });
        }
        await req.response.close();
        break;
      default:
        req.response
          ..statusCode = HttpStatus.notFound
          ..write('Not found 403');
        await req.response.close();
    }
  });

  print('Server linstening at http://localhost:$port');
}
