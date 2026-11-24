import 'package:flutter/material.dart';
const orange = Color(0xFFF57E1E);
const pink = Color(0xFFF52380);
void main() => runApp(
  const MaterialApp(debugShowCheckedModeBanner: false, home: Phase2()),
);
// STATIC: stateful screen
class Phase2 extends StatefulWidget {
  const Phase2({super.key});
  @override
  State<Phase2> createState() => _Phase2State();
}
class _Phase2State extends State<Phase2> {
  // LOGIC: list of 5 goal maps
  var goals = [
    {'subject': 'Mathematics', 'hours': 5, 'done': false},
    {'subject': 'Mobile App Development', 'hours': 8, 'done': false},
    {'subject': 'Databases', 'hours': 4, 'done': false},
    {'subject': 'Networking', 'hours': 3, 'done': false},
    {'subject': 'Operating Systems', 'hours': 6, 'done': false},
  ];
  // LOGIC: subject names for new goals
  var subjects = [
    'Data Structures',
    'Software Testing',
    'Artificial Intelligence',
    'Computer Security',
    'Web Engineering',
  ];
  // LOGIC: add a subject goal
  void addGoal() => setState(() {
    goals.add({
      'subject': subjects[goals.length % subjects.length],
      'hours': 3,
      'done': false,
    });
  });
  // LOGIC: toggle done
  void toggleGoal(int i) => setState(() {
    goals[i]['done'] = !(goals[i]['done'] as bool);
  });
  // LOGIC: remove goal
  void deleteGoal(int i) => setState(() => goals.removeAt(i));
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
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // STATIC: welcome banner
          Container(
            margin: const EdgeInsets.all(16),
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
          // STATIC: heading
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              'My Study Goals',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 8),
          // CONNECTION: connects goals list and logic to ListView.builder
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: goals.length,
              itemBuilder: (context, i) {
                var g = goals[i];
                var done = g['done'] as bool;
                // STATIC: goal card
                return Card(
                  color: done ? Colors.grey.shade200 : Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: ListTile(
                    onTap: () => toggleGoal(i),
                    leading: Checkbox(
                      value: done,
                      activeColor: i.isEven ? orange : pink,
                      onChanged: (_) => toggleGoal(i),
                    ),
                    title: Text(
                      g['subject'] as String,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        decoration: done ? TextDecoration.lineThrough : null,
                      ),
                    ),
                    subtitle: Text('${g['hours']} hours'),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete_outline, color: pink),
                      onPressed: () => deleteGoal(i),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      // CONNECTION: connects button to addGoal
      floatingActionButton: FloatingActionButton.extended(
        onPressed: addGoal,
        backgroundColor: pink,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add),
        label: const Text('Add goal'),
      ),
    );
  }
}