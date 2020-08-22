import 'package:new_app/people_channel.dart';

void main(List<String> arguments) async {
  int port = 3000;
  var server = await HttpServer.bind('localhost', port);

  Db db = new Db('mongodb://localhost:27017/test');

  await db.open();

  // Access a collection
  DbCollection coll = db.collection('people');

  server.transform(HttpBodyHandler()).listen((HttpRequestBody reqBody) async {
    // var content =
    //     await reqBody.request.cast<dart_mongoList<int>>().transform(Utf8Decoder()).join();
    // var document = json.decode(content);
    var people = await coll.find().toList();
    switch (reqBody.request.uri.path) {
      case '/':
        reqBody.request.response.write('Hello world');
        await reqBody.request.response.close();
        break;
      case '/people':
        PeopleController(reqBody, db);
        break;
      default:
        reqBody.request.response
          ..statusCode = HttpStatus.notFound
          ..write('Not found 404');
        await reqBody.request.response.close();
    }
  });

  print('Server linstening at http://localhost:$port');
}
