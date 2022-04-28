part of masamune;

class NotFoundPage extends PageScopedWidget {
  const NotFoundPage();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.app?.title.localize() ?? "Title"),
      ),
      body: const Center(child: Text("404 Not Found")),
    );
  }
}
