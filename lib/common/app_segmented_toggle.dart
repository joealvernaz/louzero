import 'package:flutter/cupertino.dart';

class AppSegmentedToggle extends StatefulWidget {
  const AppSegmentedToggle({
    Key? key,
    required this.itemList,
    this.width,
    required this.onChange
  }) : super(key: key);
  final List<String> itemList;
  final double? width;
  final Function onChange;

  @override
  _AppSegmentedToggleState createState() => _AppSegmentedToggleState();
}
class _AppSegmentedToggleState extends State<AppSegmentedToggle> {
  int selectedItem = 0;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.width ?? 120,
      child: CupertinoSlidingSegmentedControl(
          groupValue: selectedItem,
          backgroundColor: const Color(0xFFF1F3F5),
          children: <int, Widget>{
            for (final item in widget.itemList.asMap().entries)
              item.key: _segmentItem(item.value),
          },
          onValueChanged: (value){
            setState(() {
              selectedItem = value as int;
            });
            widget.onChange(widget.itemList[selectedItem]);
          }
      ),
    );
  }

  Widget _segmentItem(text) => Container(
    padding: const EdgeInsets.all(15),
    child: Text(text),
  );
}