// import 'package:flutter/material.dart';

// class CustomTextField extends StatelessWidget {
//   final TextEditingController controller;
//   final String hintText;
//   final int maxLines;

//   const CustomTextField({
//     Key? key,
//     required this.controller,
//     required this.hintText,
//     this.maxLines = 1,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.all(3.0),
//       child: TextFormField(
//         controller: controller,
//         decoration: InputDecoration(
//           hintText: hintText,
//           border: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(15),
//               borderSide: BorderSide(
//                 color: Colors.black38,
//               )),
//         ),
//         validator: (val) {
//           if (val == null || val.isEmpty) {
//             return 'กรุณากรอก$hintText';
//           }
//         },
//         maxLines: maxLines,
//       ),
//     );
//   }
// }
