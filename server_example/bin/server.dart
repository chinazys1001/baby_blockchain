import 'dart:convert';
import 'dart:io';

import 'package:firedart/firedart.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart';
import 'package:shelf_router/shelf_router.dart';

import 'blockchain/logic/transaction.dart';

// Configure routes.
final _router = Router()
  ..get('/', _rootHandler)
  ..get('/echo/<message>', _echoHandler)
  ..post('/post/transaction', _postTransactionHandler);

Future<Response> _postTransactionHandler(Request request) async {
  try {
    Transaction tranaction =
        Transaction.fromJson(jsonDecode(await request.readAsString()));

    tranaction.printTransaction();

    // Firestore.instance.collection("blockHistory").add({"oh wow": 21});
    return Response.ok('Accepted');
  } catch (e) {
    return Response.badRequest(body: e.toString());
  }
}

Response _rootHandler(Request request) {
  Firestore.instance.collection("blockHistory").add({"oh wow": 21});
  return Response.ok('Hello, World!\n');
}

Response _echoHandler(Request request) {
  final message = request.params['message'];
  return Response.ok('$message\n');
}

void main(List<String> args) async {
  // Use any available host or container IP (usually `0.0.0.0`).
  final ip = InternetAddress.anyIPv4;

  // Configure a pipeline that logs requests.
  final handler = Pipeline().addMiddleware(logRequests()).addHandler(_router);

  // For running in containers, we respect the PORT environment variable.
  final port = int.parse(Platform.environment['PORT'] ?? '8080');
  final server = await serve(handler, ip, port);
  print('Server listening on port ${server.port}');

  Firestore.initialize("baby-blockchain");
  print('Firebase initialized');
}
