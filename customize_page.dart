import 'package:flutter/material.dart';
import 'home_page.dart';
import 'user_profile.dart';

class CustomizePage extends StatefulWidget {
  const CustomizePage({super.key});

  @override
  State<CustomizePage> createState() => _CustomizePageState();
}

class _CustomizePageState extends State<CustomizePage> {
  final _nameController = TextEditingController();
  final _courseController = TextEditingController(text: "Web Development");

  void _saveProfile() {
    if (_nameController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter your name.'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
    final profile = UserProfile(
      name: _nameController.text,
      courseTitle: _courseController.text,
    );


    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => HomePage(profile: profile), 
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Customize Your Profile'),
        automaticallyImplyLeading: false, 
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
             
              const SizedBox(height: 32),
              
              Text(
                'Welcome! Tell us about yourself.',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: 32),
              TextField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Your Name',
                  prefixIcon: Icon(Icons.person),
                ),
                keyboardType: TextInputType.name,
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _courseController,
                decoration: const InputDecoration(
                  labelText: 'Your Course',
                  prefixIcon: Icon(Icons.school),
                ),
                readOnly: true, 
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: _saveProfile,
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                ),
                child: const Text('Save and Start Learning',
                    style: TextStyle(fontSize: 18)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}