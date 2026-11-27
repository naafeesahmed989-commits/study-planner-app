import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'firebase_options.dart';


//STATIC: colors used
const Color pantoneOrange = Color(0xFFF57E1E);
const Color neonPink = Color(0xFFF52380);
const LinearGradient pinkGradient = LinearGradient(
  colors: [neonPink, neonPink],
);
const LinearGradient orangGradient = LinearGradient(
  colors: [pantoneOrange, pantoneOrange],
);
const LinearGradient mixGradien = LinearGradient(
  colors: [pantoneOrange, neonPink],
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
);

AppBar gradienAppBar (String title){
  return AppBar(
    title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontFamily: 'georgia' ),),
    backgroundColor: Colors.transparent,
    foregroundColor: Colors.white,
    flexibleSpace: Container(
      decoration: const BoxDecoration(gradient: mixGradien),
    ),
  );
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
   @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My Study Planner',
      debugShowCheckedModeBanner: false,
      home: const HomePage(),
      theme: ThemeData(
        colorScheme: ColorScheme.light(
          primary: pantoneOrange,
          secondary: neonPink,
        ),
      ),
    );
  }
}
// hhome screen
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // LOGIC: the goals, a list of maps with three keys
  List<Map<String, dynamic>> goals = [];

final CollectionReference goalsCollection =
    FirebaseFirestore.instance.collection('goals');
    @override
void initState() {
  super.initState();
  loadGoals();
}

Future<void> loadGoals() async {
  final snapshot = await goalsCollection.get();

  if (!mounted) return;

  setState(() {
    goals = snapshot.docs.map((doc) {
      return {
        ...doc.data() as Map<String, dynamic>,
        'id': doc.id,
      };
    }).toList();
  });
}
  // LOGIC: open the second screen and wait for the result
 Future<void> addGoal() async {
  final result = await Navigator.push<Map<String, dynamic>>(
    context,
    MaterialPageRoute(builder: (context) => const AddGoalScreen()),
  );

  if (result == null) return;
  if (!mounted) return;

  final doc = await goalsCollection.add(result);

  if (!mounted) return;

  setState(() {
    goals.add({
      ...result,
      'id': doc.id,
    });
  });
}
  // LOGIC: flip done between true and false
  Future<void> toggleGoal(int index) async {
  String id = goals[index]['id'];
  bool done = !goals[index]['done'];

  await goalsCollection.doc(id).update({
    'done': done,
  });

  if (!mounted) return;

  setState(() {
    goals[index]['done'] = done;
  });
}
// LOGIC: delete a goal from Firestore and the list
Future<void> deleteGoal(int index) async {
  String id = goals[index]['id'];

  await goalsCollection.doc(id).delete();

  if (!mounted) return;

  setState(() {
    goals.removeAt(index);
  });
}
  // LOGIC: sum of all hours using fold
  int get totalHours {
    return goals.fold<int>(0, (sum, goal) => sum + (goal['hours'] as int));
  }

  // LOGIC: completed goals function using where
  int get completeGoals {
    return goals.where((goal) => goal['done'] == true).length;
  }

  // LOGIC: goals not finished yet
  int get remaininGoals {
    return goals.length - completeGoals;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // STATIC: AppBar
      appBar: gradienAppBar('My Study Planner'),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // STATIC + CONNECTION: three circles, numbers from the getters
            Row(
              children: [
                StatCircle(value: '$totalHours', label: 'Total hours', gradient: orangGradient),
                StatCircle(value: '$completeGoals', label: 'Completed', gradient: mixGradien),
                StatCircle(value: '$remaininGoals', label: 'Remaining', gradient: pinkGradient)
              ],
            ),
            // STATIC: Heading
            const Text(
              'My Study Goals',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: pantoneOrange,
                fontFamily: 'georgia',
              ),
            ),
            const SizedBox(height: 12),

            // CONNECTIOn: one card for each goal map or message if no goal
            Expanded(
              child: goals.isEmpty? const Center(
                child: Text('No study goals yet. Start by adding your first goal!',textAlign: TextAlign.center,),
              )  : ListView.builder(
                itemCount: goals.length,
                itemBuilder: (context, index) {
                  Map<String, dynamic> goal = goals[index];
                  bool done = goal['done'];
                  return Card(
                    color: done ? Colors.orange.shade100 : Colors.white,
                    child: ListTile(
                      onTap: () => toggleGoal(index),
                      leading: Checkbox(
                        value: done,
                        activeColor: neonPink,
                        onChanged: (_) => toggleGoal(index),
                      ),
                      title: Text(
                        goal['subject'],
                        style: TextStyle(
                          decoration: done ? TextDecoration.lineThrough : null,
                        ),
                      ),
                      subtitle: Text('${goal['hours']} hours'),
                      trailing: IconButton(
                        onPressed: () => deleteGoal(index),
                        icon: const Icon(Icons.delete_outline, color: neonPink),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      // STATIC + CONNECTION: the button opens the second screen
      floatingActionButton: FloatingActionButton(
        onPressed: addGoal,
        backgroundColor: pantoneOrange,
        foregroundColor: Colors.white,
        child: const Icon(Icons.add),
      ),
    );
  }
}
// STATIC: one stat circle 
class StatCircle extends StatelessWidget {
  final String value;
  final String label;
  final Gradient gradient;

  const StatCircle({
    super.key,
    required this.value,
    required this.label,
    required this.gradient,
  });
  @override
  Widget build(BuildContext context) {
    return Expanded(child: Padding(padding: const EdgeInsets.symmetric(horizontal: 6), child: AspectRatio(aspectRatio: 1, child: Container(decoration: BoxDecoration(shape: BoxShape.circle, gradient: gradient,),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(value, style: const TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold,),),
        Text(label, textAlign: TextAlign.center, style: const TextStyle(color: Colors.white),),
      ],
    )
    ),),),);
  }
}
// STATIC: the second screen, stateful
class AddGoalScreen extends StatefulWidget {
  const AddGoalScreen({super.key});

  @override
  State<AddGoalScreen> createState() => _AddGoalScreenState();
}
class _AddGoalScreenState extends State<AddGoalScreen> {
  // LOGIC: read what the user types, and hold the error message
  final TextEditingController subjectController = TextEditingController();
  final TextEditingController hoursController = TextEditingController();
  String? subjectError;
  String? hoursError;
  @override
  void dispose() {
    subjectController.dispose();
    hoursController.dispose();
    super.dispose();
  }
  // LOGIC: check the input, then send the goal back
  void save() {
    String subject = subjectController.text.trim();
    int? hours = int.tryParse(hoursController.text.trim());
    bool subjectOk = subject.isNotEmpty;
    bool hoursOk = hours != null && hours > 0;

    setState(() {
      subjectError = subjectOk ? null : 'Please enter a subject';
      hoursError = hoursOk ? null : 'Please enter whole hours above 0';
    });
    if(!subjectOk || !hoursOk) return; 
    // CONNECTION: return the new goal to the home screen
    Navigator.pop(context, {
      'subject': subject, 'hours': hours,'done': false,
    });
  }
  // STATIC: the form
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: gradienAppBar('Add Goal'),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: subjectController,
              decoration: InputDecoration(
                labelText: 'Subject',
                errorText: subjectError,
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: hoursController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Hours',
                errorText: hoursError,
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: save,
                style: ElevatedButton.styleFrom(
                  backgroundColor: pantoneOrange,
                  foregroundColor: Colors.white,
                ),
                child: const Text('Save'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}