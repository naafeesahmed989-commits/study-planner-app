import 'package:flutter/material.dart';

const orange = Color(0xFFF57E1E);
const pink = Color(0xFFF52380);

void main() {
  runApp(const MaterialApp(debugShowCheckedModeBanner: false, home: Phase1()));
}
// STATIC: static screen with 5 fixed goal cards
class Phase1 extends StatelessWidget {
  const Phase1({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFBF7),
      // STATIC: gradient top bar
      appBar: AppBar(
        title: const Text('My Study Planner'),
        centerTitle: true,
        foregroundColor: Colors.white,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(colors: [orange, pink]),
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // STATIC: welcome banner
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              gradient: const LinearGradient(colors: [pink, orange]),
              borderRadius: BorderRadius.circular(18),
            ),
            child: const Row(
              children: [
                Icon(Icons.school, color: Colors.white, size: 34),
                SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Ready to study?\nPlan your goals and crush them!',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          // STATIC: heading
          const Text(
            'My Study Goals',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          // STATIC: 5 hard-coded goal cards
          _card('Mathematics', 5, false, orange),
          _card('Mobile App Development', 8, false, pink),
          _card('Databases', 4, false, orange),
          _card('Networking', 3, false, pink),
          _card('Operating Systems', 6, false, orange),
        ],
      ),
      // STATIC: button does nothing yet
      floatingActionButton: FloatingActionButton.extended(
        onPressed: null,
        backgroundColor: pink,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add),
        label: const Text('Add goal'),
      ),
    );
  }

  // STATIC: card widget
  Widget _card(String subject, int hours, bool done, Color iconColor) {
    return Card(
      color: done ? Colors.grey.shade200 : Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: ListTile(
        leading: Icon(
          done ? Icons.check_box : Icons.check_box_outline_blank,
          color: iconColor,
        ),
        title: Text(
          subject,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            decoration: done ? TextDecoration.lineThrough : null,
          ),
        ),
        subtitle: Text('$hours hours'),
      ),
    );
  }
}