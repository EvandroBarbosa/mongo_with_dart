# Simple API Rest in Dart

Está é uma API simples em dart com o banco de dados mongoDB, onde são usados os metodos Http


* GET /people
* POST /people

Aqui foi usado os queryParams ou invés de routeParams
* Put /people?id=id 
* DELETE /people?id=id
* PATCH /people?id=id

Para executar o projeto é necessário ter o SDK do [dart](https://dart.dev/get-dart) e o [mongoDB](https://www.mongodb.com/) instalado.

Após esta tudo ok a e é só acessar o diretório do projeto via terminal e executar o comando

```
 pub get
```
para baixar as dependências necessárias depois execute o comando 
```
dart bin/new_app.dart
```
para subir o servidor a e é so acessar http://localhost:3000, e para acessar usando os metodos Http
é necessário uma ferramenta como o [isomnia](https://insomnia.rest/) ou [postman](https://www.postman.com/) para as requisições.

