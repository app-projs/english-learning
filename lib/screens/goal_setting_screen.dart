import 'package:flutter/material.dart';
import '../services/storage_service.dart';

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
  String _selectedWordbook = '四级核心';
  final List<String> _wordbooks = ['四级核心', '六级高频', '考研必刷', '雅思冲刺', '日常基础'];

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
    _loadWordbook();
  }

  void _loadWordbook() async {
    final storage = await StorageService.getInstance();
    if (!mounted) return;
    setState(() {
      _selectedWordbook = storage.getTargetWordbook();
    });
  }

  void _applyPreset(String preset) {
    setState(() {
      _wordGoal = _presets[preset]![0];
      _sentenceGoal = _presets[preset]![1];
      _dialogueGoal = _presets[preset]![2];
      _dailyMinutes = _presets[preset]![3];
    });
  }

  void _saveGoals() async {
    final storage = await StorageService.getInstance();
    await storage.saveTargetWordbook(_selectedWordbook);

    widget.onGoalsSaved({
      'words': _wordGoal,
      'sentences': _sentenceGoal,
      'dialogues': _dialogueGoal,
      'dailyMinutes': _dailyMinutes,
    });
    if (!mounted) return;
    Navigator.pop(context, _selectedWordbook);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('学习目标与目标词库'),
        actions: [
          TextButton(
            onPressed: _saveGoals,
            child: const Text('保存', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Target Wordbook Selection
            const Text(
              '📖 当前学习目标词库',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              '在设置中选定目标词库后，后续单词与句子练习将自动为你匹配该词库难度。',
              style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _wordbooks.map((wb) {
                final isSelected = wb == _selectedWordbook;
                return ChoiceChip(
                  label: Text(wb, style: TextStyle(fontWeight: isSelected ? FontWeight.bold : FontWeight.normal)),
                  selected: isSelected,
                  selectedColor: Colors.deepOrange.shade100,
                  onSelected: (selected) {
                    if (selected) {
                      setState(() {
                        _selectedWordbook = wb;
                      });
                    }
                  },
                );
              }).toList(),
            ),

            const SizedBox(height: 24),
            const Divider(),
            const SizedBox(height: 12),

            const Text(
              '⚡️ 快速强度设置',
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
              '自定义每日目标数量',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            _GoalSlider(
              icon: Icons.translate,
              title: '单词复习目标',
              value: _wordGoal,
              min: 50,
              max: 2000,
              divisions: 39,
              unit: '词',
              onChanged: (v) => setState(() => _wordGoal = v.toInt()),
            ),
            const SizedBox(height: 16),
            _GoalSlider(
              icon: Icons.format_quote,
              title: '句子练习目标',
              value: _sentenceGoal,
              min: 20,
              max: 1000,
              divisions: 49,
              unit: '句',
              onChanged: (v) => setState(() => _sentenceGoal = v.toInt()),
            ),
            const SizedBox(height: 16),
            _GoalSlider(
              icon: Icons.chat,
              title: '对话练习目标',
              value: _dialogueGoal,
              min: 5,
              max: 200,
              divisions: 39,
              unit: '句',
              onChanged: (v) => setState(() => _dialogueGoal = v.toInt()),
            ),
            const SizedBox(height: 16),
            _GoalSlider(
              icon: Icons.timer,
              title: '每日学习时长',
              value: _dailyMinutes,
              min: 5,
              max: 180,
              divisions: 35,
              unit: '分钟',
              onChanged: (v) => setState(() => _dailyMinutes = v.toInt()),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}

class _GoalSlider extends StatelessWidget {
  final IconData icon;
  final String title;
  final int value;
  final double min;
  final double max;
  final int divisions;
  final String unit;
  final ValueChanged<double> onChanged;

  const _GoalSlider({
    required this.icon,
    required this.title,
    required this.value,
    required this.min,
    required this.max,
    required this.divisions,
    required this.unit,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                Icon(icon, color: Theme.of(context).primaryColor),
                const SizedBox(width: 8),
                Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
                const Spacer(),
                Text('$value $unit', style: TextStyle(color: Theme.of(context).primaryColor, fontWeight: FontWeight.bold)),
              ],
            ),
            Slider(
              value: value.toDouble().clamp(min, max),
              min: min,
              max: max,
              divisions: divisions,
              onChanged: onChanged,
            ),
          ],
        ),
      ),
    );
  }
}
