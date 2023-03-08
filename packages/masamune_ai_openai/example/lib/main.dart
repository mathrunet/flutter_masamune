// Dart imports:
import 'dart:io';

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:masamune_ai_openai/masamune_ai_openai.dart';

final List<MasamuneAdapter> masamuneAdapters = [
  OpenAIMasamuneAdapter(
    apiKey: "APIKEY",
  ),
];

void main() {
  runMasamuneApp(
    masamuneAdapters: masamuneAdapters,
    () => MasamuneApp(
      home: const OpenAIPage(),
      title: "Flutter Demo",
      masamuneAdapters: masamuneAdapters,
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
  final OpenAIChat _chat = OpenAIChat();
  final OpenAIMedia _media = OpenAIMedia();
  final TextEditingController _controller = TextEditingController();
  @override
  void initState() {
    super.initState();
    _chat.addListener(_handledOnUpdate);
  }

  void _handledOnUpdate() {
    setState(() {});
  }

  @override
  void dispose() {
    super.dispose();
    _chat.removeListener(_handledOnUpdate);
    _chat.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("App Demo"),
        actions: [
          Text(_chat.usageToken.toString()),
        ],
      ),
      body: ListView(children: [
        ..._chat.value
            .mapListenable(
              (e) {
                if (e.future != null) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                return ListTile(
                  title: Text(e.value),
                  subtitle: Text(e.role.name),
                );
              },
            )
            .insertEvery(const Divider(), 1)
            .toList(),
      ]),
      bottomSheet: Container(
        color: Theme.of(context).colorScheme.surface,
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
                  await _chat.send(value!);
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
                await _chat.send(value);
              },
              icon: const Icon(Icons.send),
            ),
            IconButton(
              onPressed: () async {
                final value = _controller.text;
                if (value.isEmpty) {
                  return;
                }
                _controller.text = "";
                final res =
                    await _media.create(value, count: 4).showIndicator(context);
                // ignore: use_build_context_synchronously
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => GalleryPage(
                      images: res ?? [],
                    ),
                  ),
                );
              },
              icon: const Icon(Icons.image),
            )
          ],
        ),
      ),
    );
  }
}

class GalleryPage extends StatelessWidget {
  const GalleryPage({
    super.key,
    required this.images,
  });

  final List<OpenAIMediaImg> images;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Gallery"),
      ),
      body: GridBuilder.count(
        source: images,
        crossAxisCount: 2,
        builder: (context, image, index) {
          if (image.future != null) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          return InkWell(
            onTap: () async {
              final res = await image.download().showIndicator(context);
              // ignore: use_build_context_synchronously
              Modal.alert(
                context,
                submitText: "Close",
                title: "Success",
                text: res.toString(),
              );
            },
            child: Ink.image(image: image.image!),
          );
        },
      ),
    );
  }
}
