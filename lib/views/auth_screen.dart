// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:google_sign_in/google_sign_in.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:zartek/views/menu_screen.dart';

// class LoginScreen extends StatelessWidget {
//   const LoginScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: SafeArea(
//         child: Column(
//           children: [
//             const Spacer(),

//             Center(
//               child: Image.asset(
//                 'assets/firebase.jpg',
//                 height: 200,
//               ),
//             ),

//             const Spacer(),

//             // 🔵 GOOGLE LOGIN
//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 24),
//               child: SizedBox(
//                 width: double.infinity,
//                 height: 52,
//                 child: ElevatedButton.icon(
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: const Color(0xFF4285F4),
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(30),
//                     ),
//                   ),
//                   icon: const Icon(
//                     Icons.g_mobiledata,
//                     size: 32,
//                     color: Colors.white,
//                   ),
//                   label: const Text(
//                     "Google",
//                     style: TextStyle(
//                       fontSize: 16,
//                       fontWeight: FontWeight.bold,
//                       color: Colors.white,
//                     ),
//                   ),

//                   // ✅ CORRECT onPressed
//                   onPressed: () async {
//                     final user =
//                         await GoogleAuthService().signInWithGoogle();

//                     if (user != null) {
//                       final prefs =
//                           await SharedPreferences.getInstance();
//                       await prefs.setBool('isLoggedIn', true);

//                       Navigator.pushReplacement(
//                         context,
//                         MaterialPageRoute(
//                           builder: (_) => const MenuScreen(),
//                         ),
//                       );
//                     }
//                   },
//                 ),
//               ),
//             ),

//             const SizedBox(height: 16),

//             // 🟢 PHONE BUTTON (future)
//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 24),
//               child: SizedBox(
//                 width: double.infinity,
//                 height: 52,
//                 child: ElevatedButton.icon(
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: Colors.green.shade500,
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(30),
//                     ),
//                   ),
//                   icon: const Icon(Icons.phone, color: Colors.white),
//                   label: const Text(
//                     "Phone",
//                     style: TextStyle(
//                       fontSize: 16,
//                       fontWeight: FontWeight.bold,
//                       color: Colors.white,
//                     ),
//                   ),
//                   onPressed: () {},
//                 ),
//               ),
//             ),

//             const SizedBox(height: 40),
//           ],
//         ),
//       ),
//     );
//   }
// }



// class GoogleAuthService {
//   final FirebaseAuth _auth = FirebaseAuth.instance;
//   final GoogleSignIn _googleSignIn = GoogleSignIn();

//   Future<User?> signInWithGoogle() async {
//     try {
//       final GoogleSignInAccount? googleUser =
//           await _googleSignIn.signIn();

//       if (googleUser == null) return null;

//       final GoogleSignInAuthentication googleAuth =
//           await googleUser.authentication;

//       final credential = GoogleAuthProvider.credential(
//         idToken: googleAuth.idToken,
//       );

//       final UserCredential userCredential =
//           await _auth.signInWithCredential(credential);

//       return userCredential.user;
//     } catch (e) {
//       debugPrint("Google Sign-In Error: $e");
//       return null;
//     }
//   }

//   Future<void> signOut() async {
//     await _googleSignIn.signOut();
//     await _auth.signOut();
//   }
// }
