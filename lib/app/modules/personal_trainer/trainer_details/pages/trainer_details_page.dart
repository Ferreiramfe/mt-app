import 'package:flutter/material.dart';
import 'package:mt_app/shared/models/user_model.dart';

class TrainerDetailsPage extends StatefulWidget {
  UserModel user;

  TrainerDetailsPage({Key key, this.user}) : super(key: key);

  @override
  State<TrainerDetailsPage> createState() => _TrainerDetailsPageState();
}

class _TrainerDetailsPageState extends State<TrainerDetailsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Personal Trainer')),
      body: Padding(
        padding: const EdgeInsets.only(top: 32.0, right: 16.0, left: 16.0),
        child: Column(
          children: [
            Center(
              child: CircleAvatar(
                backgroundColor: Colors.amber,
                radius: 100,
              ),
            ),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(widget.user.name),
                    Text(widget.user.email)
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
