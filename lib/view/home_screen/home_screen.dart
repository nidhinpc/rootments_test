import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rootments_test/controller/home_screen_controller.dart';

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
    super.initState();
    // Fetch data when the screen initializes
    Future.microtask(
        () => Provider.of<HomeScreenController>(context, listen: false).getData(
              employeeId: widget.employeeId,
              email: widget.email,
            ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Screen'),
        centerTitle: true,
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
                      Text('locCode : ${item.data?.locCode ?? 'N/A'}'),
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
