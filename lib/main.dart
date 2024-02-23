import 'dart:async';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  await dotenv.load(fileName: ".env");
  runApp(const MyApp());
}

String githubAccessToken = dotenv.env['GITHUB_ACCESS_TOKEN']!;

class MyApp extends StatelessWidget {
  const MyApp({Key? key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GitHub Finder',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
      home: const SplashScreen(),
      routes: {
        '/search': (context) => const SearchScreen(),
        '/userDetails': (context) => const UserDetailsScreen(),
      },
    );
  }
}

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key});

  @override
  Widget build(BuildContext context) {
    Future.delayed(const Duration(seconds: 3), () {
      Navigator.of(context).pushReplacementNamed('/search');
    });

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children:  [
            const Text(
              'Zahid Parviz',
              style: TextStyle(fontSize: 24),
            ),
            const SizedBox(height: 20),
            Image.asset(
              'assets/spy_logo.jpeg',
              width: 100,
              height: 100,
            ),
          ],
        ),
      ),
    );
  }
}

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key});

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  String query = '';
  List users = [];
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('GitHub Finder'),
        actions: [
          Visibility(
            visible: users.isNotEmpty,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Center(
                child: Text(
                  'Users: ${users.length}',
                  style: const TextStyle(fontSize: 16),
                ),
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              onChanged: (value) {
                setState(() {
                  query = value;
                });
              },
              decoration: const InputDecoration(
                hintText: 'Search for users...',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                searchUsers();
              },
              child: const Text('Search'),
            ),
            const SizedBox(height: 16),
            if (isLoading) const CircularProgressIndicator(),
            if (users.isNotEmpty)
              Expanded(
                child: ListView.builder(
                  itemCount: users.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: ListTile(
                        leading: ClipOval(
                          child: Image.network(
                            users[index]['avatar_url'],
                            width: 50,
                            height: 50,
                            fit: BoxFit.cover,
                          ),
                        ),
                        title: Text(users[index]['login']),
                        onTap: () {
                          Navigator.pushNamed(context, '/userDetails', arguments: users[index]);
                        },
                      ),
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }

  void searchUsers() async {
    setState(() {
      isLoading = true;
      users.clear();
    });

    var headers = {
      'Authorization': githubAccessToken,
    };

    var allUsers = <dynamic>[];
    var page = 1;
    while (true) {
      var response = await http.get(
        Uri.parse(
            'https://api.github.com/search/users?q=location:$query&page=$page&per_page=500'),
        headers: headers,
      );

      //print('Response: ${response.body}'); // Debugging statement

      var data = jsonDecode(response.body);
     // print('Data: $data'); // Debugging statement

      var items = data['items'];

      if (items == null) {
        // Handle null items
        //print('Items is null');
        break;
      }

      if (items.isEmpty) break;

      allUsers.addAll(items);
      page++;
    }

    setState(() {
      users = allUsers;
      isLoading = false;
    });
  }
}

class UserDetailsScreen extends StatelessWidget {
  const UserDetailsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final dynamic user = ModalRoute.of(context)!.settings.arguments;

    return Scaffold(
      appBar: AppBar(
        title: Text(user['login']),
      ),
      body: FutureBuilder(
        future: fetchUserDetails(user['login']),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else {
            var userDetails = snapshot.data;
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: SizedBox(
                        width: 200,
                        height: 200,
                        child: CircleAvatar(
                          backgroundImage: NetworkImage(user['avatar_url']),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    _buildDetailRow('Name', userDetails?['name'] ?? 'Not available'),
                    _buildDetailRow('Email', userDetails?['email'] ?? 'Not available'),
                    _buildDetailRow('Company', userDetails?['company'] ?? 'Not available'),
                    _buildDetailRow('Location', userDetails?['location'] ?? 'Not available'),
                    _buildDetailRow('Blog', userDetails?['blog'] ?? 'Not available'),
                    _buildDetailRow('Followers', userDetails?['followers'].toString() ?? 'Not available'),
                    _buildDetailRow('Following', userDetails?['following'].toString() ?? 'Not available'),
                    _buildDetailRow('Public Repositories', userDetails?['public_repos'].toString() ?? 'Not available'),
                  ],
                ),
              ),
            );
          }
        },
      ),
    );
  }

  Future<Map<String, dynamic>> fetchUserDetails(String username) async {
    var headers = {
      'Authorization': githubAccessToken,
    };

    var response = await http.get(
      Uri.parse('https://api.github.com/users/$username'),
      headers: headers,
    );

    return jsonDecode(response.body);
  }

  Widget _buildDetailRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$title:',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }
}
