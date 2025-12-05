import 'package:flutter/material.dart';

class MessageFieldBox extends StatefulWidget {
  final ValueChanged<String> onValue;
  final bool enabled;
  final FocusNode? focusNode;

  const MessageFieldBox({
    super.key,
    required this.onValue,
    this.enabled = true,
    this.focusNode,
  });

  @override
  State<MessageFieldBox> createState() => _MessageFieldBoxState();
}

class _MessageFieldBoxState extends State<MessageFieldBox> {
  final TextEditingController textController = TextEditingController();
  late FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _focusNode = widget.focusNode ?? FocusNode();
    _focusNode.addListener(_onFocusChange);
  }

  void _onFocusChange() {
    if (_focusNode.hasFocus) {
      Future.delayed(const Duration(milliseconds: 100), () {
        if (mounted) {
          Scrollable.ensureVisible(
            _focusNode.context ?? context,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
          );
        }
      });
    }
  }

  @override
  void dispose() {
    textController.dispose();
    _focusNode.removeListener(_onFocusChange);
    if (widget.focusNode == null) {
      _focusNode.dispose();
    }
    super.dispose();
  }

  void _sendMessage() {
  final textValue = textController.text.trim();
  if (textValue.isNotEmpty && widget.enabled) {
    widget.onValue(textValue);
    textController.clear();
    Future.delayed(const Duration(milliseconds: 100), () {
      if (mounted) {
        _focusNode.requestFocus();
      }
    });
  }
}

  @override
  Widget build(BuildContext context) {
    final outlineInputBorder = OutlineInputBorder(
      borderSide: BorderSide(
        color: widget.enabled 
            ? const Color.fromARGB(255, 217, 3, 3)
            : Colors.grey[400]!, 
      ),
      borderRadius: BorderRadius.circular(30),
      gapPadding: 0,
    );

    final inputDecoration = InputDecoration(
      hintText: widget.enabled 
          ? 'Habla con tu mascota...' 
          : 'Esperando respuesta...', 
      hintStyle: TextStyle(
        color: widget.enabled ? Colors.grey[600] : Colors.grey[400],
        fontSize: 16,
      ),
      enabledBorder: outlineInputBorder,
      disabledBorder: outlineInputBorder, 
      focusedBorder: outlineInputBorder.copyWith(
        borderSide: const BorderSide(
          color: Color.fromARGB(255, 217, 3, 3),
          width: 2,
        ),
      ),
      filled: true,
      fillColor: widget.enabled ? Colors.grey[50] : Colors.grey[100],
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      suffixIcon: Container(
        margin: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: widget.enabled ? Colors.red : Colors.grey[400], 
          shape: BoxShape.circle,
        ),
        child: widget.enabled
            ? IconButton(
                icon: const Icon(
                  Icons.send,
                  color: Color.fromARGB(255, 247, 245, 245),
                  size: 22,
                ),
                onPressed: _sendMessage,
              )
            : const Padding(
                padding: EdgeInsets.all(12),
                child: SizedBox(
                  width: 22,
                  height: 22,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.white,
                  ),
                ),
              ),
      ),
      prefixIcon: Icon(
        Icons.pets,
        color: widget.enabled 
            ? const Color.fromARGB(255, 217, 3, 3)
            : Colors.grey[400],
        size: 24,
      ),
    );

    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(25),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextFormField(
        onTapOutside: (event) {
          FocusScope.of(context).unfocus();
        },
        focusNode: _focusNode,
        controller: textController,
        enabled: widget.enabled, 
        decoration: inputDecoration,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        textCapitalization: TextCapitalization.sentences,
        maxLines: 3,
        minLines: 1,
        onFieldSubmitted: (value) {
          if (!widget.enabled) return; 
          _sendMessage();
        },
      ),
    );
  }
}