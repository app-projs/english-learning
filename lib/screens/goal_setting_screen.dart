import 'package:flutter/material.dart';
import '../services/storage_service.dart';
import 'level_assessment_screen.dart';

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
            InkWell(
              onTap: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const LevelAssessmentScreen(),
                  ),
                );
                _loadWordbook();
              },
              borderRadius: BorderRadius.circular(12),
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.psychology, color: Colors.white, size: 28),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            '不确定词汇水平？点击进行【水平诊断测评】',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                            ),
                          ),
                          SizedBox(height: 2),
                          Text(
                            '5道题精准评估词汇与语法量，自动推荐词库',
                            style: TextStyle(color: Colors.white70, fontSize: 11),
                          ),
                        ],
                      ),
                    ),
                    const Icon(Icons.arrow_forward_ios, color: Colors.white, size: 14),
                  ],
                ),
              ),
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
            const SizedBox(height: 28),

            const Text(
              '🎯 阶段性目标解锁路线图：',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 6),
            Text(
              '完成上一阶段词汇与句型累积，即可自动解锁下一阶段专属词库与高级特权',
              style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
            ),
            const SizedBox(height: 14),

            // 阶段 1
            _StagedGoalCard(
              stageName: '第一阶段：突破日常起步',
              targetText: '累计完成 50 词 + 10 句型',
              recommendedWordbook: '日常基础',
              isUnlocked: true,
              isCurrent: _wordGoal <= 100,
              onSelectWordbook: () => setState(() => _selectedWordbook = '日常基础'),
            ),
            const SizedBox(height: 10),

            // 阶段 2
            _StagedGoalCard(
              stageName: '第二阶段：四六级与职场进阶',
              targetText: '累计完成 200 词 + 50 句型',
              recommendedWordbook: '四级核心',
              isUnlocked: true,
              isCurrent: _wordGoal > 100 && _wordGoal <= 300,
              onSelectWordbook: () => setState(() => _selectedWordbook = '四级核心'),
            ),
            const SizedBox(height: 10),

            // 阶段 3
            _StagedGoalCard(
              stageName: '第三阶段：考研学术与雅思精读',
              targetText: '累计完成 500 词 + 150 句型',
              recommendedWordbook: '考研必刷',
              isUnlocked: _wordGoal >= 300,
              isCurrent: _wordGoal > 300 && _wordGoal <= 500,
              onSelectWordbook: () => setState(() => _selectedWordbook = '考研必刷'),
            ),
            const SizedBox(height: 10),

            // 阶段 4
            _StagedGoalCard(
              stageName: '第四阶段：自由地道巅峰对话',
              targetText: '累计完成 1000 词 + 300 句型',
              recommendedWordbook: '雅思冲刺',
              isUnlocked: _wordGoal >= 800,
              isCurrent: _wordGoal > 500,
              onSelectWordbook: () => setState(() => _selectedWordbook = '雅思冲刺'),
            ),

            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}

class _StagedGoalCard extends StatelessWidget {
  final String stageName;
  final String targetText;
  final String recommendedWordbook;
  final bool isUnlocked;
  final bool isCurrent;
  final VoidCallback onSelectWordbook;

  const _StagedGoalCard({
    required this.stageName,
    required this.targetText,
    required this.recommendedWordbook,
    required this.isUnlocked,
    required this.isCurrent,
    required this.onSelectWordbook,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isUnlocked
            ? (isCurrent ? Colors.blue.shade50 : (isDark ? const Color(0xFF1E293B) : Colors.white))
            : (isDark ? const Color(0xFF0F172A) : Colors.grey.shade100),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isCurrent
              ? Colors.blue
              : (isUnlocked ? (isDark ? Colors.white10 : Colors.grey.shade300) : Colors.grey.shade300),
          width: isCurrent ? 2 : 1,
        ),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 20,
            backgroundColor: isUnlocked
                ? (isCurrent ? Colors.blue : Colors.green.shade100)
                : Colors.grey.shade300,
            child: Icon(
              isUnlocked ? (isCurrent ? Icons.flag_rounded : Icons.check) : Icons.lock_outline_rounded,
              color: isUnlocked ? (isCurrent ? Colors.white : Colors.green.shade800) : Colors.grey.shade600,
              size: 20,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  stageName,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: isUnlocked ? null : Colors.grey,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  targetText,
                  style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                ),
              ],
            ),
          ),
          if (isUnlocked)
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: isCurrent ? Colors.blue : Colors.grey.shade200,
                foregroundColor: isCurrent ? Colors.white : Colors.black87,
                elevation: 0,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              ),
              onPressed: onSelectWordbook,
              child: Text(isCurrent ? '当前阶段' : '选择$recommendedWordbook'),
            )
          else
            const Text('🔒 待解锁', style: TextStyle(fontSize: 12, color: Colors.grey)),
        ],
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
