import 'package:flutter/material.dart';

class AddTweetView extends StatefulWidget {
  final void Function(String tweet) onClickAdd;
  const AddTweetView({Key? key, required this.onClickAdd}) : super(key: key);

  @override
  State<AddTweetView> createState() => _AddTweetViewState();
}

class _AddTweetViewState extends State<AddTweetView> {
  final _formkey = GlobalKey<FormState>();
  final tweetMessageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Card(
        elevation: 9,
        child: Form(
          key: _formkey,
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text("Add a new tweet"),
                  ),
                  Flexible(
                    child: SizedBox(
                      height: MediaQuery.of(context).size.height * 0.3,
                      child: TextFormField(
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        controller: tweetMessageController,
                        maxLines: null,
                        expands: true,
                        keyboardType: TextInputType.text,
                        maxLength: 280,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: 'Enter a tweet',
                        ),
                        validator: (value) {
                          if (value != null) {
                            if (value.isEmpty) {
                              return "Please enter some text";
                            } else if (value.length > 280) {
                              return "Maximum length should be 280 characters";
                            }
                          }
                          return null;
                        },
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: const Text('Cancel'),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ElevatedButton(
                            onPressed: () {
                              if (_formkey.currentState!.validate()) {
                                widget.onClickAdd(tweetMessageController.text);
                                Navigator.of(context).pop();
                              }
                            },
                            child: const Text('Add a tweet')),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
