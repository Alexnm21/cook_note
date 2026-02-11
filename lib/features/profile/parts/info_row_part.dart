part of '../view/profile_view.dart';

class InfoRowPart extends StatelessWidget {
  final String label;
  final String value;
  const InfoRowPart({super.key, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: paddings.bottom.s12,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style: baseTextStyle.h3.copyWith(color: Colors.grey[600])),
          Text(value, style: baseTextStyle.h3),
        ],
      ),
    );
  }
}
