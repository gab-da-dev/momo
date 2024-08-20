import 'package:flutter/material.dart';

class LabeledCheckbox extends StatelessWidget {
  LabeledCheckbox({
    super.key,
    required this.label,
    required this.padding,
    required this.value,
    required this.onChanged,
    this.price=0,
  });

  final String label;
  final EdgeInsets padding;
  final bool value;
  final ValueChanged<bool> onChanged;
  double price;

  @override
  Widget build(BuildContext context) {
    return 
      InkWell(
      onTap: () {
        onChanged(!value);
      },
      child: Padding(
        padding: padding,
        child: Row(
          children: <Widget>[
            Checkbox(
              activeColor: Colors.grey,
              value: value,
              onChanged: (bool? newValue) {
                onChanged(newValue!);
              },
            ),
            Expanded(child: Text(label)),
            if(price != 0)
            Text('R ${price.toStringAsFixed(2)}')
          ],
        ),
      ),
    );
  }
}