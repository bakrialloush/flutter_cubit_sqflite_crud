import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_db/cubit/users_cubit.dart';

import '../models/user.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sqflite'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          IconButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => const DialogContent(),
              );
            },
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: BlocBuilder<UsersCubit, UsersState>(
        builder: (_, state) {
          return ListView(
            padding: const EdgeInsets.all(10),
            children:
                state.usersCubitList.map((user) => UserRowCard(user)).toList(),
          );
        },
      ),
    );
  }
}

class UserRowCard extends StatelessWidget {
  const UserRowCard(this.user, {super.key});

  final User user;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
        alignment: Alignment.center,
        height: 60,
        child: ListTile(
          leading: const Icon(Icons.person),
          title: Text(user.userName),
          subtitle: Text(user.age.toString()),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return DialogContent(user: user);
                      },
                    );
                  },
                  icon: const Icon(Icons.edit)),
              IconButton(onPressed: () {}, icon: const Icon(Icons.delete)),
            ],
          ),
        ),
      ),
    );
  }
}

class DialogContent extends StatelessWidget {
  const DialogContent({this.user, super.key});

  final User? user;

  @override
  Widget build(BuildContext context) {
    var textName = TextEditingController();
    var textAge = TextEditingController();
    if (user != null) {
      textName.text = user!.userName;
      textAge.text = user!.age.toString();
    }
    return AlertDialog(
      title: const Text('User info'),
      content: SizedBox(
        height: 120,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            textField('User name', textName),
            const SizedBox(height: 10),
            textField('Age', textAge, TextInputType.number),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            if (textName.text.trim().isNotEmpty &&
                textAge.text.trim().isNotEmpty) {
              user == null
                  ? context.read<UsersCubit>().addUser(User(
                      textName.text, int.tryParse(textAge.text.trim()) ?? 0))
                  : log(user!.userName);
              Navigator.pop(context);
            }
          },
          child: Text(user == null ? 'Add' : 'Save changes'),
        ),
      ],
    );
  }

  TextFormField textField(
    String label,
    TextEditingController textName, [
    TextInputType? inputType,
  ]) {
    return TextFormField(
      controller: textName,
      keyboardType: inputType,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.symmetric(horizontal: 10),
        label: Text(label),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }
}