import 'package:flutter/material.dart';

class EditableHeader extends StatefulWidget {
  final void Function(String text)? onSubmit;
  final String initialText;

  const EditableHeader({Key? key, this.onSubmit, required this.initialText})
      : super(key: key);

  @override
  State<EditableHeader> createState() => _EditableHeaderState();
}

class _EditableHeaderState extends State<EditableHeader> {
  final _titleFocusNode = FocusNode();
  bool _editing = false;
  String _text = "";

  @override
  void initState() {
    _text = widget.initialText;
    super.initState();
  }

  @override
  void didUpdateWidget(EditableHeader oldWidget) {
    setState(() {
      _text = widget.initialText;
    });
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
                    style: Theme.of(context).textTheme.headline5,
                    initialValue: _text,
                    onChanged: (text) {
                      setState(() {
                        _text = text;
                      });
                    },
                  ),
                ),
                IconButton(
                    onPressed: () {
                      setState(() {
                        widget.onSubmit?.call(_text);
                        _editing = false;
                      });
                    },
                    icon: const Icon(Icons.done))
              ],
            ),
          )
        : Row(
            children: [
              InkWell(
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Material(
                      type: MaterialType.transparency,
                      child: Text(_text,
                          style: Theme.of(context).textTheme.headline1),
                    ),
                  ),
                  onTap: () {
                    setState(() {
                      _editing = true;
                    });
                    _titleFocusNode.requestFocus();
                  }),
            ],
          );
  }
}
