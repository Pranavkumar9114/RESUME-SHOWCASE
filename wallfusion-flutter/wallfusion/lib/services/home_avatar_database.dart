import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wallfusion/pages/login.dart';
import 'package:wallfusion/services/google_signin.dart';

class HomeAvatarDatabase extends StatelessWidget {
  const HomeAvatarDatabase({super.key});

  Future<void> _signOut(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    // ignore: prefer_const_declarations
    final signOutLimit = 2;
    final currentDate = DateTime.now()
        .toIso8601String()
        .split('T')[0]; // Get the current date in YYYY-MM-DD format

    // Get stored data from SharedPreferences
    final lastSignOutDate = prefs.getString('lastSignOutDate');
    final signOutCount = prefs.getInt('signOutCount') ?? 0;

    if (lastSignOutDate == currentDate && signOutCount >= signOutLimit) {
      // Show error message
      showDialog(
        // ignore: use_build_context_synchronously
        context: context,
        builder: (context) {
return AlertDialog(
  title: Text(
    'Limit Reached',
    style: TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.bold,
      color: Theme.of(context).brightness == Brightness.dark
          ? Colors.white
          : Colors.black,
    ),
  ),
  content: Text(
    'You have exceeded the maximum number of sign-outs for today. Please try again tomorrow.',
    textAlign: TextAlign.justify,
    style: TextStyle(
      fontSize: 13,
      color: Theme.of(context).brightness == Brightness.dark
          ? Colors.white70
          : Colors.black87,
    ),
  ),
  actions: [
    TextButton(
      onPressed: () => Navigator.pop(context),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        decoration: BoxDecoration(
          color: Colors.blueAccent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: const Text(
          'OK',
          style: TextStyle(
            color: Colors.white,
            fontSize: 13,
          ),
        ),
      ),
    ),
  ],
);

        },
      );
    } else {
      try {
        // Sign out user
        await AuthService().signOut();

        // Update sign-out count and date
        if (lastSignOutDate != currentDate) {
          // Reset count if date has changed
          await prefs.setString('lastSignOutDate', currentDate);
          await prefs.setInt('signOutCount', 1);
        } else {
          // Increment count for the current date
          await prefs.setInt('signOutCount', signOutCount + 1);
        }

        Navigator.pushReplacement(
          // ignore: use_build_context_synchronously
          context,
          MaterialPageRoute(builder: (context) => const Login()),
        );
      } catch (e) {
        // Handle sign-out error if needed
        // ignore: avoid_print
        print('Error signing out: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;
    List<String> emailList =
        user != null ? [user.email ?? 'No email'] : ['No email found'];

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Builder(
        builder: (context) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Active Account',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),
                Column(
                  children: emailList.map((email) {
                    return ListTile(
                      leading: CircleAvatar(
                        backgroundImage: user?.photoURL != null
                            ? NetworkImage(user!.photoURL!)
                            : null,
                        child: user?.photoURL == null
                            ? Text(
                                email.isNotEmpty ? email[0].toUpperCase() : '?',
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                              )
                            : null,
                      ),
                      title: Text(email, style: const TextStyle(fontSize: 10)),
                      onTap: () {
                        Navigator.pop(context, email);
                      },
                    );
                  }).toList(),
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () => _signOut(context),
                  child: const Text('Sign Out'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}








// import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:wallfusion/pages/login.dart';
// //import 'package:wallfusion/pages/signup.dart';
// import 'package:wallfusion/services/google_signin.dart';

// class HomeAvatarDatabase extends StatelessWidget {
//   const HomeAvatarDatabase({super.key});

//   @override
//   Widget build(BuildContext context) {
//     User? user = FirebaseAuth.instance.currentUser;
//     List<String> emailList = user != null ? [user.email ?? 'No email'] : ['No email found'];

//     return Dialog(
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(16),
//       ),
//       child: Builder( // Use Builder to get a context that is within the Scaffold's hierarchy
//         builder: (context) {
//           return Padding(
//             padding: const EdgeInsets.all(16.0),
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 const Text(
//                   'Active Account',
//                   style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//                 ),
//                 const SizedBox(height: 20),
//                 Column(
//                   children: emailList.map((email) {
//                     return ListTile(
//                       leading: CircleAvatar(
//                         backgroundImage: user?.photoURL != null ? NetworkImage(user!.photoURL!) : null,
//                         child: user?.photoURL == null
//                             ? Text(
//                                 email.isNotEmpty ? email[0].toUpperCase() : '?',
//                                 style: const TextStyle(fontWeight: FontWeight.bold),
//                               )
//                             : null,
//                       ),
//                       title: Text(email, style: const TextStyle(fontSize: 10)),
//                       onTap: () {
//                         Navigator.pop(context, email);
//                       },
//                     );
//                   }).toList(),
//                 ),
//                 // const SizedBox(height: 20),
//                 // ElevatedButton(
//                 //   onPressed: () {
//                 //     Navigator.push(
//                 //       context,
//                 //       MaterialPageRoute(builder: (context) => const Signup()),
//                 //     );
//                 //   },
//                 //   child: const Text('Change Email'),
//                 // ),
//                 const SizedBox(height: 10),
//                 ElevatedButton(
//                   onPressed: () async {
//                       try {
//                       //await FirebaseAuth.instance.signOut();
//                       await AuthService().signOut();
//                       Navigator.pushReplacement(
//                         // ignore: use_build_context_synchronously
//                         context,
//                         MaterialPageRoute(builder: (context) => const Login()),
//                       );
//                     } catch (e) {
//                       // ignore: avoid_print
//                       print('Error signing out: $e');
//                       // Handle sign-out error if needed
//                     }
//                   },
//                   child: const Text('Sign Out'),
//                 ),
//               ],
//             ),
//           );
//         },
//       ),
//     );
//   }
// }
