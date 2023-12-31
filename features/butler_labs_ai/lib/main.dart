import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';

import 'models/butler_result.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: const Home());
  }
}

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  ValueNotifier<XFile?> image = ValueNotifier<XFile?>(null);
  ValueNotifier<ButlerResult?> result = ValueNotifier<ButlerResult?>(null);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ValueListenableBuilder(
          valueListenable: result,
          builder: (context, val, child) {
            return ListView(
              padding: const EdgeInsets.all(16),
              children: [
                ElevatedButton(
                  onPressed: () async {
                    ImagePicker picker = ImagePicker();

                    XFile? pickedImage = await picker.pickImage(source: ImageSource.gallery);

                    if (pickedImage == null) return;

                    image.value = pickedImage;
                    debugPrint('pickedImage: ' + pickedImage.path);

                    // https://docs.butlerlabs.ai/reference/extract-document
                    String butlerApiKey = const String.fromEnvironment('BUTLER_API_KEY');
                    String queueId = const String.fromEnvironment('QUEUE_ID');

                    MultipartRequest request = MultipartRequest('POST', Uri.parse('https://app.butlerlabs.ai/api/queues/$queueId/documents'));

                    request.headers.addAll({
                      HttpHeaders.acceptHeader: '*/*',
                      HttpHeaders.authorizationHeader: 'Bearer $butlerApiKey',
                      HttpHeaders.contentTypeHeader: 'multipart/form-data',
                    });

                    if (defaultTargetPlatform == TargetPlatform.android || defaultTargetPlatform == TargetPlatform.iOS) {
                      request.files.add(
                        await MultipartFile.fromPath(
                          'file',
                          pickedImage.path,
                          contentType: MediaType('image', 'jpeg'),
                        ),
                      );
                    } else {
                      Uint8List bytes = await pickedImage.readAsBytes();

                      MultipartFile file = MultipartFile(
                        'file',
                        ByteStream.fromBytes(bytes),
                        bytes.lengthInBytes,
                        filename: pickedImage.path
                            .split('/')
                            .last,
                        contentType: MediaType('image', 'jpeg'),
                      );

                      request.files.add(file);
                    }

                    StreamedResponse response = await request.send();

                    debugPrint('Response: ${response.statusCode}');
                    debugPrint('Response: ${response.reasonPhrase}');
                    debugPrint('Response: ${response.contentLength}');
                    debugPrint('Response: ${response.request}');
                    debugPrint('Response: ${response.stream}');
                    debugPrint('Response: ${response.toString()}');

                    response.stream.transform(utf8.decoder).listen((value) {
                      ButlerResult butlerResult = ButlerResult.fromJson(jsonDecode(value));
                      result.value = butlerResult;
                      debugPrint('Response stream: $value');
                    });
                  },
                  child: const Text('Upload Image'),
                ),
                if(val != null)...[
                  ListTile(
                    title: Text('Document ID: ${val.documentId}'),
                  ),
                  ListTile(
                    title: Text('Document Status: ${val.documentStatus}'),
                  ),
                  ListTile(
                    title: Text('Document Type: ${val.documentType}'),
                  ),
                  ...val.formFields.map((field) {
                    return ListTile(
                      title: Text('Field: ${field.fieldName}'),
                      subtitle: Text('Value: ${field.value}'),
                    );
                  }).toList(),
                ]
              ],
            );
          }
      ),
    );
  }
}
