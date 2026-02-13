import 'package:flutter/material.dart';

class GoalSettingScreen extends StatefulWidget {
  final Map<String, int> currentGoals;
  final Function(Map<String, int>) onGoalsSaved;

  const GoalSettingScreen({
    super.key,
    required this.currentGoals,
    required this.onGoalsSaved,
  });

  @override
  State<GoalSettingScreen> createState() => _GoalSettingScreenState();
}

class _GoalSettingScreenState extends State<GoalSettingScreen> {
  late int _wordGoal;
  late int _sentenceGoal;
  late int _dialogueGoal;
  late int _dailyMinutes;

  final Map<String, List<int>> _presets = {
    '轻松': [100, 50, 10, 15],
    '适中': [300, 100, 25, 30],
    '挑战': [500, 200, 50, 60],
    '极限': [1000, 500, 100, 120],
  };

  @override
  void initState() {
    super.initState();
    _wordGoal = widget.currentGoals['words'] ?? 500;
    _sentenceGoal = widget.currentGoals['sentences'] ?? 200;
    _dialogueGoal = widget.currentGoals['dialogues'] ?? 50;
    _dailyMinutes = widget.currentGoals['dailyMinutes'] ?? 30;
  }

  void _applyPreset(String preset) {
    setState(() {
      _wordGoal = _presets[preset]![0];
      _sentenceGoal = _presets[preset]![1];
      _dialogueGoal = _presets[preset]![2];
      _dailyMinutes = _presets[preset]![3];
    });
  }

  void _saveGoals() {
    widget.onGoalsSaved({
      'words': _wordGoal,
      'sentences': _sentenceGoal,
      'dialogues': _dialogueGoal,
      'dailyMinutes': _dailyMinutes,
    });
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('学习目标'),
        actions: [
          TextButton(
            onPressed: _saveGoals,
            child: const Text('保存', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '快速设置',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Row(
              children: _presets.keys.map((preset) {
                return Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: OutlinedButton(
                      onPressed: () => _applyPreset(preset),
                      child: Text(preset),
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 24),
            const Text(
              '自定义目标',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            _GoalSlider(
              icon: Icons.translate,
              label: '单词目标',
              value: _wordGoal,
              min: 50,
              max: 2000,
              unit: '个',
              onChanged: (value) => setState(() => _wordGoal = value),
            ),
            const SizedBox(height: 16),
            _GoalSlider(
              icon: Icons.format_quote,
              label: '句子目标',
              value: _sentenceGoal,
              min: 20,
              max: 500,
              unit: '个',
              onChanged: (value) => setState(() => _sentenceGoal = value),
            ),
            const SizedBox(height: 16),
            _GoalSlider(
              icon: Icons.chat,
              label: '对话目标',
              value: _dialogueGoal,
              min: 5,
              max: 200,
              unit: '个',
              onChanged: (value) => setState(() => _dialogueGoal = value),
            ),
            const SizedBox(height: 16),
            _GoalSlider(
              icon: Icons.timer,
              label: '每日学习时间',
              value: _dailyMinutes,
              min: 10,
              max: 180,
              unit: '分钟',
              onChanged: (value) => setState(() => _dailyMinutes = value),
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _saveGoals,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text('保存设置'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _GoalSlider extends StatelessWidget {
  final IconData icon;
  final String label;
  final int value;
  final int min;
  final int max;
  final String unit;
  final ValueChanged<int> onChanged;

  const _GoalSlider({
    required this.icon,
    required this.label,
    required this.value,
    required this.min,
    required this.max,
    required this.unit,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: Theme.of(context).colorScheme.primary),
                const SizedBox(width: 8),
                Text(
                  label,
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.w500),
                ),
                const Spacer(),
                Text(
                  '$value $unit',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Slider(
              value: value.toDouble(),
              min: min.toDouble(),
              max: max.toDouble(),
              divisions: (max - min) ~/ 10,
              onChanged: (v) => onChanged(v.round()),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('$min $unit',
                    style:
                        TextStyle(color: Colors.grey.shade600, fontSize: 12)),
                Text('$max $unit',
                    style:
                        TextStyle(color: Colors.grey.shade600, fontSize: 12)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
