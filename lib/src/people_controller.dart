import 'dart:io';

import 'package:http_server/http_server.dart';
import 'package:mongo_dart/mongo_dart.dart';

class PeopleController {
  PeopleController(this._requestBody, Db db)
      : _request = _requestBody.request,
        _store = db.collection('people') {
    handle();
  }

  HttpRequestBody _requestBody;
  final HttpRequest _request;
  final DbCollection _store;

  handle() async {
    switch (_request.method) {
      case 'GET':
        await handleGet();
        break;
      case 'POST':
        await handlePost();
        break;
      case 'PUT':
        await handlePut();
        break;
      case 'DELETE':
        await handleDelete();
        break;
      case 'PATCH':
        await handlePatch();
        break;
      default:
        _request.response.statusCode = 405;
    }

    await _request.response.close();
  }

  handleGet() async {
    _request.response.write(await _store.find().toList());
  }

  handlePost() async {
    var newPerson = await _store.save(_requestBody.body);
    await _request.response.write(newPerson);
  }

  handlePut() async {
    var id = int.parse(_request.uri.queryParameters['id']);
    var itemToPut = await _store.findOne(where.eq('id', id));

    if (itemToPut != null) {
      await _store.update(itemToPut, _requestBody.body);
    } else {
      await _store.save(_requestBody.body);
    }
  }

  handleDelete() async {
    var id = int.parse(_request.uri.queryParameters['id']);
    var itemToDelete = await _store.findOne(where.eq('id', id));

    if (itemToDelete != null) {
      await _store.remove(itemToDelete);
      _request.response.statusCode = 204;
    } else {
      _request.response.statusCode = 404;
    }
  }

  handlePatch() async {
    var id = int.parse(_request.uri.queryParameters['id']);
    var itemToPatch = await _store.findOne(where.eq('id', id));

    _request.response
        .write(await _store.update(itemToPatch, {r'$set': _requestBody.body}));
  }
}
