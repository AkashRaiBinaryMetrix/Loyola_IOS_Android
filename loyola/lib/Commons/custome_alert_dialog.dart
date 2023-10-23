import 'package:flutter/material.dart';

class CustomAlertDialog extends StatefulWidget {
  const CustomAlertDialog({
    Key? key,
    required this.title,
    required this.description,
  }) : super(key: key);

  final String title, description;

  @override
  _CustomAlertDialogState createState() => _CustomAlertDialogState();
}

class _CustomAlertDialogState extends State<CustomAlertDialog> {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      elevation: 0,
      backgroundColor: const Color(0xffffffff),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 15),
          Text(
            widget.title,
            style: const TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 7),
          Padding(
            padding: const EdgeInsets.only(left: 10.0,right: 10.0),
            child: Text(widget.description,textAlign: TextAlign.center,),
          ),
          const SizedBox(height: 15),
          // const Divider(
          //   height: 1,
          // ),
          // Container(
          //   width: MediaQuery.of(context).size.width,
          //   height: 50,
          //   child: InkWell(
          //     highlightColor: Colors.grey[200],
          //     onTap: () {
          //       //do somethig
          //     },
          //     child: Center(
          //       child: Text(
          //         "Continue",
          //         style: TextStyle(
          //           fontSize: 18.0,
          //           color: Theme.of(context).primaryColor,
          //           fontWeight: FontWeight.bold,
          //         ),
          //       ),
          //     ),
          //   ),
          // ),
          // Divider(
          //   height: 1,
          // ),
          // Container(
          //   width: MediaQuery.of(context).size.width,
          //   height: 50,
          //   child: InkWell(
          //     borderRadius: BorderRadius.only(
          //       bottomLeft: Radius.circular(15.0),
          //       bottomRight: Radius.circular(15.0),
          //     ),
          //     highlightColor: Colors.grey[200],
          //     onTap: () {
          //       Navigator.of(context).pop();
          //     },
          //     child: Center(
          //       child: Text(
          //         "Cancel",
          //         style: TextStyle(
          //           fontSize: 16.0,
          //           fontWeight: FontWeight.normal,
          //         ),
          //       ),
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }
}
