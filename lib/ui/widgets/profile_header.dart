import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:scroll_architecture_task/bloc/auth/auth_bloc.dart';
import 'package:scroll_architecture_task/bloc/auth/auth_event.dart';
import 'package:scroll_architecture_task/bloc/auth/auth_state.dart';

class ProfileHeader extends StatelessWidget {
  const ProfileHeader({super.key});

  String _getGreetingMessage(Map<String, dynamic>? user) {
    if (user != null) {
      final firstName = user['name']?['firstname'] ?? '';
      final lastName = user['name']?['lastname'] ?? '';

      if (firstName.isNotEmpty) {
        return "Hello, $firstName $lastName";
      }
    }
    return "Welcome";
  }

  String _getUserEmail(Map<String, dynamic>? user) {
    return user != null ? (user['email'] ?? '') : '';
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        final user = state.user;
        final greeting = _getGreetingMessage(user);
        final email = _getUserEmail(user);

        return Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.orange, Colors.deepOrange],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          padding: const EdgeInsets.fromLTRB(16, 60, 16, 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 25,
                    backgroundColor: Colors.white,
                    child: Text(
                      user != null
                          ? (user['name']?['firstname']?[0] ?? 'U').toUpperCase()
                          : 'G',
                      style: const TextStyle(
                        color: Colors.deepOrange,
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          greeting,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        if (email.isNotEmpty)
                          Text(
                            email,
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 12,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                      ],
                    ),
                  ),
                  if (user != null)
                    IconButton(
                      icon: const Icon(Icons.logout, color: Colors.white),
                      onPressed: () {
                        context.read<AuthBloc>().add(LogoutRequested());
                      },
                    ),
                ],
              ),
              const SizedBox(height: 20),
              Container(
                height: 45,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(25),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: const Row(
                  children: [
                    Icon(Icons.search, color: Colors.grey),
                    SizedBox(width: 8),
                    Text(
                      "Search products",
                      style: TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}