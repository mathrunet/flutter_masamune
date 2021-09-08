part of masamune.list;

class ListTextField extends StatefulWidget {
  const ListTextField({
    required this.label,
    this.addIcon,
    this.controller,
    this.onSubmitted,
    this.submitIcon,
  });
  final String label;
  final IconData? submitIcon;
  final IconData? addIcon;
  final TextEditingController? controller;
  final void Function(String? value)? onSubmitted;

  @override
  State<StatefulWidget> createState() => _ListTextField();
}

class _ListTextField extends State<ListTextField> {
  CrossFadeState _state = CrossFadeState.showFirst;
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _state = CrossFadeState.showFirst;
    _focusNode.addListener(_handledOnFocus);
  }

  @override
  void dispose() {
    super.dispose();
    _focusNode.removeListener(_handledOnFocus);
    _focusNode.dispose();
  }

  void _handledOnFocus() {
    if (!_focusNode.hasFocus && _state == CrossFadeState.showSecond) {
      setState(() {
        _focusNode.unfocus();
        _state = CrossFadeState.showFirst;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedCrossFade(
      firstChild: ListTile(
        leading: Icon(
          widget.addIcon ?? Icons.add,
          color: context.theme.disabledColor,
        ),
        title: Text(
          widget.label,
          style: TextStyle(
            color: context.theme.disabledColor,
          ),
        ),
        onTap: () {
          setState(() {
            _state = CrossFadeState.showSecond;
            _focusNode.requestFocus();
          });
        },
      ),
      secondChild: FormItemCommentField(
        focusNode: _focusNode,
        hintText: widget.label,
        onSubmitted: widget.onSubmitted,
        submitIcon: widget.submitIcon ?? Icons.check,
        controller: widget.controller,
        padding: const EdgeInsets.only(right: 8),
      ),
      crossFadeState: _state,
      duration: const Duration(milliseconds: 500),
    );
  }
}
