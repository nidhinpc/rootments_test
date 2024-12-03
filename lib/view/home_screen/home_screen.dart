import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:rootments_test/controller/home_screen_controller.dart';
import 'package:rootments_test/view/login_screen/login_screen.dart';

class HomeScreen extends StatefulWidget {
  final String employeeId;
  final String email;

  const HomeScreen({Key? key, required this.employeeId, required this.email})
      : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback(
      (timeStamp) async {
        await context
            .read<HomeScreenController>()
            .getData(employeeId: widget.employeeId, email: widget.email);
      },
    );
    super.initState();
  }

  Future<void> _logout() async {
    try {
      await FirebaseAuth.instance.signOut();
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
        (route) => false,
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error during logout: ${e.toString()}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Screen'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              final shouldLogout = await showDialog<bool>(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: const Text('Confirm Logout'),
                    content: const Text('Are you sure you want to logout?'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context, false),
                        child: const Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: () => Navigator.pop(context, true),
                        child: const Text('Logout'),
                      ),
                    ],
                  );
                },
              );

              if (shouldLogout ?? false) {
                await _logout();
              }
            },
          ),
        ],
      ),
      body: Consumer<HomeScreenController>(
        builder: (context, controller, child) {
          final data = controller.dataList;

          if (data.isEmpty) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          return ListView.builder(
            itemCount: data.length,
            itemBuilder: (context, index) {
              final item = data[index];
              if (item == null) {
                return const SizedBox.shrink();
              }

              return Card(
                elevation: 4,
                margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                child: ListTile(
                  title: Text(item.data?.employeeName ?? 'No Name'),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Email: ${item.data?.emailId ?? 'N/A'}'),
                      Text('Branch: ${item.data?.branchName ?? 'N/A'}'),
                      Text('Designation: ${item.data?.designation ?? 'N/A'}'),
                      Text('locCode: ${item.data?.locCode ?? 'N/A'}'),
                    ],
                  ),
                  trailing:
                      Text('Employee ID: ${item.data?.employeeId ?? 'N/A'}'),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
