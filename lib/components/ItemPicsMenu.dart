
import 'dart:typed_data';

import 'package:flutter/material.dart';


class ItemPicMenu extends StatelessWidget {
  const ItemPicMenu({
    Key? key,
    required this.title,
    this.imagen,
    required this.icon,
    required this.onTap,
    required this.color,
  }) : super(key: key);

  final String title;
  final Uint8List? imagen;
  final IconData icon;
  final Color color;
  final Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          color: color
        ),
        margin: EdgeInsets.only(bottom: 10),
        child: Row(
          children: [
            Icon(icon,color: Colors.blue,),
            SizedBox(
              width: 10,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(fontFamily: 'Poppins', color: Colors.white,fontWeight: FontWeight.bold,fontSize: 15),
                ),

                imagen!=null?Container(
                  margin: EdgeInsets.only(top: 10,bottom: 10),
                  height: 80,
                  width: 120,
                  child: Image.memory(imagen!,fit: BoxFit.contain,)
                ):Text(
                    "Toma una foto",
                    style: TextStyle(fontFamily: 'Poppins', color: Colors.white,fontSize: 10),
                  ),
              ],
            ),
            Expanded(child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 15),
                  child: Icon(Icons.photo_camera,color: Colors.white,),
                ),
              ],
            ))
          ],
        ),
      ),
    );
  }
}
