import 'package:flutter/material.dart';

void main() {
  runApp(MoodTrackerApp());
}

class MoodTrackerApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'MoodTracker',
      theme: ThemeData(primarySwatch: Colors.teal),
      home: MoodTrackerHomePage(),
    );
  }
}

class Mood{
  final String name;
  final IconData icon;
  final Color color;

  Mood(this.name,this.icon,this.color);

}
class MoodEntry{
  final Mood mood;
  final DateTime date;
  final String note;

  MoodEntry({required this.mood,required this.date,required this.note});
}

class MoodTrackerHomePage   extends StatefulWidget {
  const MoodTrackerHomePage({super.key});


  @override
  _MoodTrackerHomePageState createState() =>
      _MoodTrackerHomePageState();

}

class _MoodTrackerHomePageState extends State <MoodTrackerHomePage>{
  final List <MoodEntry> _moodLog=[];

  //define moods for two rows

  final List<Mood>_moodsRow1=[
    Mood('Happy',Icons.sentiment_very_satisfied,Colors.yellow),
    Mood('Sad',Icons.sentiment_dissatisfied,Colors.blue),
    Mood('Angry',Icons.sentiment_very_dissatisfied,Colors.red),
  ];

  final List<Mood>_moodsRow2=[
    Mood('Excited',Icons.sentiment_satisfied_alt,Colors.orange),
    Mood('Calm',Icons.self_improvement,Colors.green),
    Mood('Tired',Icons.bedtime,Colors.purple),
  ];

  //Add a MoodEntry

  void _addMood(Mood mood,String note){
    setState(() {
      _moodLog.add(MoodEntry(mood: mood, date: DateTime.now(), note: note));
    });
  }

//Get the most frequent mood
  Mood _getMostFrequentMood() {
    if (_moodLog.isEmpty) return
      Mood('None', Icons.sentiment_neutral, Colors.grey);

    final moodCounts = <String, int>{};
    for (var entry in _moodLog) {
      moodCounts[entry.mood.name] = (moodCounts[entry.mood.name] ?? 0) + 1;
    }
    final mostFrequent = moodCounts.entries.reduce((a, b) =>
    a.value > b.value ? a : b);

    return
      [..._moodsRow1, ..._moodsRow2].firstWhere((mood) =>
      mood.name == mostFrequent.key);
  }
  //Show a dialog to long a mood
  void _showMoodDialog(Mood mood){
    final TextEditingController _noteController =TextEditingController();

    showDialog(
        context: context,
        builder: (context){
          return AlertDialog(title: const Text("Add Mood",
              style: TextStyle(fontWeight: FontWeight.bold)),
            content: Column(mainAxisSize: MainAxisSize.min,
              children: [
                Text("Selected Mood: ${mood.name}"),
                const SizedBox(height: 10),
                TextField(
                  controller: _noteController,
                  decoration: const InputDecoration(
                    labelText: "Why do you feel this way?",border: OutlineInputBorder(),
                  ),
                ),
              ],
            ),
          actions: [TextButton(
            onPressed: () =>Navigator.pop(context),
            child: const Text("cancel",style: TextStyle(color: Colors.red)),
          ),
          ElevatedButton(
              onPressed: (){
                _addMood(mood, _noteController.text);
                Navigator.pop(context);
              },
              child: const Text("Add Mood"),
            )
           ],
          );
        },
    );
  }

  @override
  Widget build(BuildContext context)
  {
    return Scaffold(
      appBar: AppBar(
        title: const Text("MoodTracker")),
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(colors:[Colors.teal.shade300,
            Colors.teal.shade900],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,)
          ),
        ),
    );

  }


}





