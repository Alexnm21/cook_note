import 'package:flutter/material.dart';

import '../../config/router/router.dart';
import '../../config/theme/styles/base_radius.dart';
import '../../config/theme/styles/base_spaces.dart';
import '../../config/theme/styles/base_text_style.dart';
import '../../core/enums/enums.dart';

class SingleSelectionProfileDialog<T> extends StatelessWidget {
  final String title;
  final List<T> list;
  final Function(T) onSelected;
  const SingleSelectionProfileDialog({
    super.key,
    required this.title,
    required this.list,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
          padding: paddings.all.s16,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(BaseRadius.s),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(title, style: baseTextStyle.h2),
              spacings.y.s10,
              ConstrainedBox(
                constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(context).size.height * 0.5,
                ),
                child: ListView.separated(
                  shrinkWrap: true,
                  itemCount: list.length,
                  separatorBuilder: (context, index) =>
                      const Divider(height: 1),
                  itemBuilder: (context, index) => ListTile(
                    title: Text(getText(list[index])),
                    onTap: () {
                      onSelected(list[index]);
                      router.pop();
                    },
                  ),
                ),
              ),
            ],
          )),
    );
  }

  String getText(T item) {
    return switch (item) {
      Gender() => item.text,
      Goal() => item.text,
      Macros() => item.text,
      ActivityLevel() => item.text,
      _ => '',
    };
  }
}
