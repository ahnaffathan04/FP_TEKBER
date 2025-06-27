import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class ConcertDetailCompleted extends StatefulWidget {
  const ConcertDetailCompleted({super.key});

  @override
  State<ConcertDetailCompleted> createState() => _ConcertDetailCompletedState();
}

class _ConcertDetailCompletedState extends State<ConcertDetailCompleted> {
  double rating = 0;
  final TextEditingController feedbackController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Feedback',
          style: TextStyle(
            color: Color(0xFFC105FF),
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 8),

        // ⭐ Rating bintang
        Center(
          child: RatingBar.builder(
            initialRating: rating,
            minRating: 1,
            allowHalfRating: false,
            itemCount: 5,
            unratedColor: Colors.white24,
            itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
            itemBuilder: (context, _) =>
                const Icon(Icons.star, color: Colors.amber),
            onRatingUpdate: (value) => setState(() => rating = value),
          ),
        ),

        const SizedBox(height: 12),

        // 📝 Komentar
        TextField(
          controller: feedbackController,
          maxLines: 4,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            hintText: 'Isi komentar disini',
            hintStyle: const TextStyle(color: Colors.white54),
            filled: true,
            fillColor: const Color(0xFF1D1E2D),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
          ),
        ),

        const SizedBox(height: 12),

        // 🔘 Tombol Post
        SizedBox(
          width: double.infinity,
          height: 48,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.transparent,
              padding: EdgeInsets.zero,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 0,
            ),
            onPressed: () {
              final feedback = feedbackController.text;
              // TODO: Kirim ke backend / simpan
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                    content: Text("Feedback dikirim: ⭐$rating\n$feedback")),
              );
              feedbackController.clear();
              setState(() => rating = 0);
            },
            child: Ink(
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF00D1FF), Color(0xFF0077FF)],
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Center(
                child: Text(
                  'Post',
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
