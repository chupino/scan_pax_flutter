import 'package:flutter/material.dart';
import 'package:get/get.dart';


class SimpleHeader extends StatelessWidget {
  const SimpleHeader({
    required this.title,
    required this.height,
    Key? key,
    required this.size,
    this.onTap
  }) : super(key: key);

  final Size size;
  final title;
  final double height;
  final Function()? onTap;


  @override
  Widget build(BuildContext context) {
    int countThisNotification = 1;
    return Container(
      height: height,
      width: size.width,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Colors.black, Color.fromARGB(255, 18, 38, 84)],
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
      ),
      child: Row(
        
        children: [
              Container(

        child: IconButton(
          onPressed: onTap,
          icon: Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
            size: 40,
          ),
        ),
      ),
              Flexible(
                

                  child: Text(
                      title!,
                      style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'Poppins',
                        fontSize: size.height*0.038,
                        fontWeight: FontWeight.w600,
                        overflow: TextOverflow.visible
                      ),
                    ),
                
              ),
        ],
      ),
    );
  }
}