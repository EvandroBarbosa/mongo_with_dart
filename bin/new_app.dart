import 'package:mongo_dart/mongo_dart.dart';

void main(List<String> arguments) async {
  Db db = new Db('mongodb://localhost:27017/test');

  await db.open();

  // Access a collection
  var coll = db.collection('people');

  // Read people
  var people = await coll.find().toList();
  print(people);

  var people1 = await coll.find(where.limit(5)).toList();
  print(people1);

  //Search for a person in the database
  var person = await coll.find(where.eq('first_name', 'Bruna'));
  print(person);

  var person1 = await coll.findOne(where.match('first_name', 'B'));
  print(person1);

  var person2 = await coll
      // .findOne(where.match('first_name', 'B').and(where.gt('id', 6)));
      // .findOne(where.match('first_name', 'B').gt('id', 6));
      .findOne(where.jsQuery('''
      return this.first_name.startsWith('B') && this.id > 6;
  '''));
  print(person2);

  // Create person

  await coll.save({
    'id': 12,
    'first_name': 'Evandro',
    'last_name': 'Barbosa',
    'email': 'evandro@gmail.com',
    'gender': 'Male'
  });

  print('Saved new person');

  // Update person
  await coll.update(await coll.findOne(where.eq('id', 1)), {
    r'$set': {'gender': 'Female'}
  });

  print('Updated person');
  print(await coll.findOne(where.eq('id', 8)));

  // Delete person
  await coll.remove(await coll.findOne(where.eq('id', 8)));

  print('Delete pernso  ${await coll.findOne(where.eq('id', 8))}');

  await db.close();
}
