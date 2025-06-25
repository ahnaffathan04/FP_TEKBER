// lib/submit_complaint_page.dart
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SubmitComplaintPage extends StatefulWidget {
  const SubmitComplaintPage({super.key});

  @override
  State<SubmitComplaintPage> createState() => _SubmitComplaintPageState();
}

class _SubmitComplaintPageState extends State<SubmitComplaintPage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _detailController = TextEditingController();
  final TextEditingController _fileLinkController = TextEditingController();

  String? _selectedCategory;

  final List<String> _problemCategories = [
    'Refund',
    'Delivery Issue',
    'Product Damage',
    'Wrong Item',
    'Other',
  ];

  final String _purchaseId = "25769c6cd34d4bfeba98e0ee856f3e7a";

  final SupabaseClient supabase = Supabase.instance.client;

  void _submitComplaint() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      final String? fileUrl = _fileLinkController.text.trim().isEmpty
          ? null
          : _fileLinkController.text.trim();

      try {
        await supabase.from('problem_table').insert({
          //purchase id nanti tolong diganti pake state management, jadi pas di klik komplain, purchase id nya dikirim ke page ini
          'purchase_id': _purchaseId,
          'email': _emailController.text,
          'problem_category': _selectedCategory,
          'detail': _detailController.text,
          'file': fileUrl,
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Complaint submitted successfully!')),
        );

        // Reset form
        _emailController.clear();
        _detailController.clear();
        _fileLinkController.clear();
        setState(() {
          _selectedCategory = null;
        });
      } on PostgrestException catch (e) {
        print('Supabase Insert Error: ${e.message}');
        print('Error code: ${e.code}');
        print('Error details: ${e.details}');
        print('Error hint: ${e.hint}');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error submitting complaint: ${e.message}')),
        );
      } catch (e) {
        print('General Error: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('An unexpected error occurred.')),
        );
      }
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _detailController.dispose();
    _fileLinkController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Submit Complaint'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                'Purchase ID: $_purchaseId',
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  hintText: 'Enter your email address',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.email),
                ),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email';
                  }
                  if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                    return 'Please enter a valid email address';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _selectedCategory,
                decoration: const InputDecoration(
                  labelText: 'Problem Category',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.category),
                ),
                hint: const Text('Select a category'),
                items: _problemCategories.map((String category) {
                  return DropdownMenuItem<String>(
                    value: category,
                    child: Text(category),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedCategory = newValue;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select a problem category';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _detailController,
                decoration: const InputDecoration(
                  labelText: 'Detail',
                  hintText: 'Describe your problem in detail',
                  alignLabelWithHint: true,
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.description),
                ),
                maxLines: 5,
                keyboardType: TextInputType.multiline,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter problem details';
                  }
                  if (value.length < 10) {
                    return 'Detail must be at least 10 characters long';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _fileLinkController,
                decoration: const InputDecoration(
                  labelText: 'Attachment Link (Optional)',
                  hintText: 'e.g., https://example.com/image.jpg',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.link),
                ),
                keyboardType: TextInputType.url,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submitComplaint,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  minimumSize: const Size.fromHeight(50),
                ),
                child: const Text(
                  'Submit Complaint',
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
