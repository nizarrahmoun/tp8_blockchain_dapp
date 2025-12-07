import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'contract_linking.dart';

class HelloUI extends StatelessWidget {
  final TextEditingController yourNameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var contractLink = Provider.of<ContractLinking>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text("Hello World Dapp"),
        centerTitle: true,
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Center(
          child: contractLink.isLoading
              ? CircularProgressIndicator()
              : SingleChildScrollView(
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Hello ",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 30),
                          ),
                          Text(
                            contractLink.deployedName,
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 30,
                                color: Colors.tealAccent),
                          ),
                        ],
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 30),
                        child: TextFormField(
                          controller: yourNameController,
                          decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: "Your Name",
                              hintText: "What is your name?",
                              icon: Icon(Icons.drive_file_rename_outline)),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 30),
                        child: ElevatedButton(
                          child: Text('Set Name', style: TextStyle(fontSize: 20)),
                          style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                          onPressed: () {
                            if (yourNameController.text.isNotEmpty) {
                              contractLink.setName(yourNameController.text);
                              yourNameController.clear();
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ),
        ),
      ),
    );
  }
}
