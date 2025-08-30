// import 'package:flutter/material.dart';

// void main() => runApp(MaterialApp(home: Ui02()));

// class Ui02 extends StatefulWidget {
//   const Ui02({super.key});

//   @override
//   _Ui02State createState() => _Ui02State();
// }

// class _Ui02State extends State<Ui02> {
//   int _step = 0;

//   final _nameController = TextEditingController();
//   final _rrnController = TextEditingController();
//   final _phoneController = TextEditingController();

//   void _nextStep() {
//     setState(() {
//       if (_step < 2) _step++;
//     });
//   }

//   Widget _buildStepContent() {
//     switch (_step) {
//       case 0:
//         return Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             _stepTitle('이름'),
//             _inputField(_nameController, '이름을 입력해주세요.'),
//           ],
//         );
//       case 1:
//         return Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             _stepTitle('생년월일'),
//             Text(
//               '⚠ 이 서비스는 만 19세 이상만 이용 가능합니다.',
//               style: TextStyle(color: Colors.grey),
//             ),
//             SizedBox(height: 12),
//             _inputField(_rrnController, '주민등록번호 (예: 000101-3******)'),
//             SizedBox(height: 24),
//             _disabledField('이름', _nameController.text),
//           ],
//         );
//       case 2:
//         return Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             _stepTitle('전화번호'),
//             _inputField(_phoneController, '전화번호 (예: 010-1234-5678)'),
//             SizedBox(height: 24),
//             _disabledField('생년월일', '2000-01-01'),
//             _disabledField('이름', _nameController.text),
//           ],
//         );
//       default:
//         return SizedBox.shrink();
//     }
//   }

//   Widget _stepTitle(String keyword) {
//     return RichText(
//       text: TextSpan(
//         children: [
//           TextSpan(
//             text: keyword,
//             style: TextStyle(
//               color: Colors.greenAccent,
//               fontSize: 20,
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//           TextSpan(
//             text: '을 입력해주세요.',
//             style: TextStyle(color: Colors.white, fontSize: 20),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _inputField(TextEditingController controller, String hint) {
//     return TextField(
//       controller: controller,
//       style: TextStyle(color: Colors.white),
//       decoration: InputDecoration(
//         hintText: hint,
//         hintStyle: TextStyle(color: Colors.grey),
//         enabledBorder: UnderlineInputBorder(
//           borderSide: BorderSide(color: Colors.white),
//         ),
//         focusedBorder: UnderlineInputBorder(
//           borderSide: BorderSide(color: Colors.purpleAccent),
//         ),
//       ),
//       keyboardType: _step == 2 ? TextInputType.phone : TextInputType.text,
//     );
//   }

//   Widget _disabledField(String label, String value) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(label, style: TextStyle(color: Colors.grey)),
//         SizedBox(height: 4),
//         Text(value, style: TextStyle(color: Colors.white)),
//         Divider(color: Colors.grey),
//       ],
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.black,
//       appBar: AppBar(
//         backgroundColor: Colors.black,
//         leading: BackButton(color: Colors.white),
//         title: Text('본인 인증', style: TextStyle(color: Colors.white)),
//         centerTitle: true,
//         elevation: 0,
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(24.0),
//         child: AnimatedSwitcher(
//           duration: Duration(milliseconds: 300),
//           child: _buildStepContent(),
//           transitionBuilder:
//               (child, animation) =>
//                   FadeTransition(opacity: animation, child: child),
//         ),
//       ),
//       bottomNavigationBar: Padding(
//         padding: const EdgeInsets.all(12.0),
//         child: ElevatedButton(
//           style: ElevatedButton.styleFrom(
//             backgroundColor: Colors.purple,
//             padding: EdgeInsets.symmetric(vertical: 16),
//           ),
//           onPressed: _nextStep,
//           child: Text('확인', style: TextStyle(fontSize: 18)),
//         ),
//       ),
//     );
//   }
// }
