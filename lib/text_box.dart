import 'package:flutter/material.dart';

class MyTextBox extends StatelessWidget {
  final String text;
  final String sectionName;
  final void Function()? onPressed;

  const MyTextBox({
    super.key,
    required this.text,
    required this.sectionName,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 5),
      //username
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    //section name
                    Text(
                      sectionName,
                      style: TextStyle(
                        fontSize: 18,
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                    ),

                    //text
                    Text(
                      text,
                      style: TextStyle(
                        fontSize: 18,
                        color: Theme.of(context).colorScheme.secondary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),

                //edit icon
                IconButton(
                  onPressed: onPressed,
                  icon: Icon(
                    Icons.edit,
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                )
              ],
            ),
          ),

          SizedBox(height: 15),

          //line divider
          Container(
            decoration: BoxDecoration(
                border: Border(
                    bottom: BorderSide(
              color: Theme.of(context).colorScheme.secondary,
              width: 1,
            ))),
            width: 600,
          ),
        ],
      ),
    );
  }
}
