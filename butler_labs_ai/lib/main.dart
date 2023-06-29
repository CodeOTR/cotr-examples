import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          ElevatedButton(
            onPressed: () async {

              ImagePicker picker = ImagePicker();

              XFile? pickedImage = await picker.pickImage(source: ImageSource.gallery, imageQuality: 50);

              if(pickedImage == null) return;

              image.value = pickedImage;

              // https://docs.butlerlabs.ai/reference/extract-document
              String butlerApiKey = const String.fromEnvironment('BUTLER_API_KEY');
              String queueId = const String.fromEnvironment('QUEUE_ID');

              MultipartRequest request = MultipartRequest('POST', Uri.parse('https://app.butlerlabs.ai/api/queues/$queueId/documents'));

              request.headers.addAll({
                HttpHeaders.acceptHeader: '*/*',
                HttpHeaders.authorizationHeader: 'Bearer $butlerApiKey',
                HttpHeaders.contentTypeHeader: 'multipart/form-data',
              });

              Uint8List bytes = await pickedImage.readAsBytes();

              request.files.add(await MultipartFile.fromPath(
                'file',
                pickedImage.path,
                contentType: MediaType('image', 'jpeg')
              ));

              StreamedResponse response = await request.send();

              debugPrint('Response: ${response.statusCode}');
              debugPrint('Response: ${response.reasonPhrase}');
              debugPrint('Response: ${response.contentLength}');
              debugPrint('Response: ${response.request}');
              debugPrint('Response: ${response.stream}');

              debugPrint('Response: ${response.toString()}');

              response.stream.transform(utf8.decoder).listen((value) {
                debugPrint('Response stream: $value');
              });
            },
            child: const Text('Upload Image'),
          )
        ],
      ),
    );
  }
}
