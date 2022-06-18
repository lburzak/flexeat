import 'package:flutter/material.dart';

class EditableHeader extends StatefulWidget {
  final void Function(String text)? onSubmit;
  final String initialText;
  final TextStyle? style;

  const EditableHeader(
      {Key? key, this.onSubmit, required this.initialText, this.style})
      : super(key: key);

  @override
  State<EditableHeader> createState() => _EditableHeaderState();
}

class _EditableHeaderState extends State<EditableHeader> {
  final _titleFocusNode = FocusNode();
  final _controller = TextEditingController();
  bool _editing = false;

  @override
  void initState() {
    _controller.text = widget.initialText;
    super.initState();
  }

  @override
  void didUpdateWidget(EditableHeader oldWidget) {
    _controller.text = widget.initialText;
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return _editing
        ? Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 5),
            child: Row(
              children: [
                Expanded(
                  child: TextFormField(
                    focusNode: _titleFocusNode,
                    style:
                        widget.style ?? Theme.of(context).textTheme.headline1,
                    controller: _controller,
                  ),
                ),
                IconButton(
                    onPressed: () {
                      setState(() {
                        widget.onSubmit?.call(_controller.text);
                        _editing = false;
                      });
                    },
                    icon: const Icon(Icons.done))
              ],
            ),
          )
        : Row(
            children: [
              Flexible(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: InkWell(
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Text(_controller.text,
                            style: widget.style ??
                                Theme.of(context).textTheme.headline1),
                      ),
                      onTap: () {
                        setState(() {
                          _editing = true;
                        });
                        _titleFocusNode.requestFocus();
                        _controller.selection = TextSelection(
                            baseOffset: 0,
                            extentOffset: _controller.text.length);
                      }),
                ),
              ),
            ],
          );
  }
}
