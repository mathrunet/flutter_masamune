// Dart imports:

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:masamune/masamune.dart';
import 'package:masamune_ai_openai/masamune_ai_openai.dart';

const assistantId = "AssistantID";

final List<MasamuneAdapter> masamuneAdapters = [
  const OpenAIMasamuneAdapter(
    apiKey: "sk-APIKey",
  ),
];

void main() {
  runMasamuneApp(
    masamuneAdapters: masamuneAdapters,
    (ref) => MasamuneApp(
      home: const OpenAIPage(),
      title: "Flutter Demo",
      masamuneAdapters: ref.adapters,
      theme: AppThemeData(
        primary: Colors.blue,
      ),
    ),
  );
}

class OpenAIPage extends StatefulWidget {
  const OpenAIPage({super.key});

  @override
  State<StatefulWidget> createState() => OpenAIPagePageState();
}

class OpenAIPagePageState extends State<OpenAIPage> {
  final OpenAIAssistantDocument _assistant =
      OpenAIAssistantDocument(assistantId);
  late final OpenAIThread _thread = OpenAIThread(assistant: _assistant);
  final TextEditingController _controller = TextEditingController();
  @override
  void initState() {
    super.initState();
    _assistant.addListener(_handledOnUpdate);
    _thread.addListener(_handledOnUpdate);
    _init();
  }

  Future<void> _init() async {
    await _thread.connect(initialMessages: [
      OpenAIMessage.fromUser(content: "こんにちは。本日はどうされましたか？"),
    ]);
  }

  void _handledOnUpdate() {
    setState(() {});
  }

  @override
  void dispose() {
    super.dispose();
    _thread.disconnect();
    _assistant.removeListener(_handledOnUpdate);
    _thread.removeListener(_handledOnUpdate);
    _assistant.dispose();
    _thread.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("App Demo"),
      ),
      body: ListView(children: [
        ..._thread.value?.mapListenable(
              (e) {
                if (e.status == OpenAIMessageStatus.queued) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                return ListTile(
                  title: Text(e.value.text),
                  subtitle: Text(e.role?.name ?? ""),
                );
              },
            ).insertEvery(const Divider(), 1) ??
            [],
      ]),
      bottomNavigationBar: Container(
        color: Theme.of(context).colorScheme.surface,
        child: SafeArea(
          top: false,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: FormTextField(
                  controller: _controller,
                  onSubmitted: (value) async {
                    if (value.isEmpty) {
                      return;
                    }
                    _controller.text = "";
                    await _thread.send(
                      message: OpenAIMessage.fromUser(content: value!),
                    );
                  },
                ),
              ),
              IconButton(
                onPressed: () async {
                  final value = _controller.text;
                  if (value.isEmpty) {
                    return;
                  }
                  _controller.text = "";
                  await _thread.send(
                    message: OpenAIMessage.fromUser(content: value),
                  );
                },
                icon: const Icon(Icons.send),
              ),
              // IconButton(
              //   onPressed: () async {
              //     final value = _controller.text;
              //     if (value.isEmpty) {
              //       return;
              //     }
              //     _controller.text = "";
              //     final res =
              //         await _media.create(value, count: 4).showIndicator(context);
              //     // ignore: use_build_context_synchronously
              //     Navigator.of(context).push(
              //       MaterialPageRoute(
              //         builder: (context) => GalleryPage(
              //           images: res ?? [],
              //         ),
              //       ),
              //     );
              //   },
              //   icon: const Icon(Icons.image),
              // )
            ],
          ),
        ),
      ),
    );
  }
}

// class GalleryPage extends StatelessWidget {
//   const GalleryPage({
//     super.key,
//     required this.images,
//   });

//   final List<OpenAIMediaImg> images;

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Gallery"),
//       ),
//       body: GridBuilder.count(
//         source: images,
//         crossAxisCount: 2,
//         builder: (context, image, index) {
//           if (image.future != null) {
//             return const Center(
//               child: CircularProgressIndicator(),
//             );
//           }
//           return InkWell(
//             onTap: () async {
//               final res = await image.download().showIndicator(context);
//               // ignore: use_build_context_synchronously
//               Modal.alert(
//                 context,
//                 submitText: "Close",
//                 title: "Success",
//                 text: res.toString(),
//               );
//             },
//             child: Ink.image(image: image.image!),
//           );
//         },
//       ),
//     );
//   }
// }
