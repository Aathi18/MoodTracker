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

class Mood {
  final String name;
  final IconData icon;
  final Color color;

  Mood(this.name, this.icon, this.color);
}

class MoodEntry {
  final Mood mood;
  final DateTime date;
  final String note;

  MoodEntry({required this.mood, required this.date, required this.note});
}

class MoodTrackerHomePage extends StatefulWidget {
  const MoodTrackerHomePage({super.key});

  @override
  _MoodTrackerHomePageState createState() => _MoodTrackerHomePageState();
}

class _MoodTrackerHomePageState extends State<MoodTrackerHomePage> {
  final List<MoodEntry> _moodLog = [];

  // Define moods for two rows
  final List<Mood> _moodsRow1 = [
    Mood('Happy', Icons.sentiment_very_satisfied, Colors.yellow),
    Mood('Sad', Icons.sentiment_dissatisfied, Colors.blue),
    Mood('Angry', Icons.sentiment_very_dissatisfied, Colors.red),
  ];

  final List<Mood> _moodsRow2 = [
    Mood('Excited', Icons.sentiment_satisfied_alt, Colors.orange),
    Mood('Calm', Icons.self_improvement, Colors.green),
    Mood('Tired', Icons.bedtime, Colors.purple),
  ];

  // Add a mood entry
  void _addMood(Mood mood, String note) {
    setState(() {
      _moodLog.add(MoodEntry(mood: mood, date: DateTime.now(), note: note));
    });
  }

  // Get the most frequent mood
  Mood _getMostFrequentMood() {
    if (_moodLog.isEmpty) return Mood('None', Icons.sentiment_neutral, Colors.grey);

    final moodCounts = <String, int>{};
    for (var entry in _moodLog) {
      moodCounts[entry.mood.name] = (moodCounts[entry.mood.name] ?? 0) + 1;
    }

    final mostFrequent = moodCounts.entries.reduce((a, b) => a.value > b.value ? a : b);
    return [..._moodsRow1, ..._moodsRow2].firstWhere((mood) => mood.name == mostFrequent.key);
  }

  // Show a dialog to log a mood
  void _showMoodDialog(Mood mood) {
    final TextEditingController _noteController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add Mood', style: TextStyle(fontWeight: FontWeight.bold)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Selected Mood: ${mood.name}'),
              const SizedBox(height: 10),
              TextField(
                controller: _noteController,
                decoration: const InputDecoration(
                  labelText: 'Why do you feel this way?',
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel', style: TextStyle(color: Colors.red)),
            ),
            ElevatedButton(
              onPressed: () {
                _addMood(mood, _noteController.text);
                Navigator.pop(context);
              },
              child: const Text('Add Mood'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('MoodTracker')),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.teal.shade300, Colors.teal.shade900],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  'How are you feeling today?',
                  style: TextStyle(fontSize: 22, color: Colors.white, fontWeight: FontWeight.w600),
                ),
              ),
              // Mood Rows
              _buildMoodRow(_moodsRow1),
              _buildMoodRow(_moodsRow2),

              // Mood Log Section
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  'Mood Log',
                  style: TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
              Expanded(
                child: _moodLog.isEmpty
                    ? const Center(
                  child: Text(
                    'No mood entries yet. Tap a mood to log!',
                    style: TextStyle(fontSize: 16, color: Colors.black),
                  ),
                )
                    : ListView.builder(
                  itemCount: _moodLog.length,
                  itemBuilder: (context, index) {
                    final entry = _moodLog[index];
                    return Card(
                      color: Colors.teal.shade800,
                      margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
                      child: ListTile(
                        leading: Icon(entry.mood.icon, color: entry.mood.color),
                        title: Text(entry.mood.name, style: TextStyle(color: Colors.black)),
                        subtitle: Text(
                          '${entry.date.day}/${entry.date.month}/${entry.date.year} - ${entry.note}',
                          style: TextStyle(color: Colors.white70),
                        ),
                      ),
                    );
                  },
                ),
              ),

              // Statistics Section
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: _buildStatistics(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMoodRow(List<Mood> moods) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: moods.map((mood) {
          return GestureDetector(
            onTap: () => _showMoodDialog(mood),
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: mood.color.withOpacity(0.8),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                children: [
                  Icon(mood.icon, color: Colors.white, size: 36),
                  SizedBox(height: 8),
                  Text(mood.name, style: TextStyle(color: Colors.white)),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildStatistics() {
    final mostFrequentMood = _getMostFrequentMood();
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(mostFrequentMood.icon, color: mostFrequentMood.color),
        const SizedBox(width: 10),
        Text(
          'Most Frequent Mood: ${mostFrequentMood.name}',
          style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}
