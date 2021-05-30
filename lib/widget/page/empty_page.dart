part of masamune;

class EmptyPage extends PageHookWidget {
  const EmptyPage({this.showAppBar = false, this.label});
  final String? label;
  final bool showAppBar;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: showAppBar ? AppBar() : null,
      body: Center(child: Text(label ?? "")),
    );
  }
}
