import 'package:flutter/material.dart';
import '../../../core/services/storage_service.dart';
import '../../../core/services/audio_service.dart';

class NotificationSettingsScreen extends StatefulWidget {
  final Map<String, dynamic> notificationSettings;
  final Function(Map<String, dynamic>) onSettingsSaved;

  const NotificationSettingsScreen({
    super.key,
    required this.notificationSettings,
    required this.onSettingsSaved,
  });

  @override
  State<NotificationSettingsScreen> createState() =>
      _NotificationSettingsScreenState();
}

class _NotificationSettingsScreenState
    extends State<NotificationSettingsScreen> {
  late bool _dailyReminder;
  late bool _streakReminder;
  late bool _achievementNotification;
  late bool _practiceReminder;
  late String _reminderTime;
  String _currentAccent = 'US';
  double _currentSpeechRate = 1.0;

  final List<String> _timeOptions = [
    '07:00',
    '08:00',
    '09:00',
    '12:00',
    '18:00',
    '20:00',
    '21:00'
  ];

  @override
  void initState() {
    super.initState();
    _dailyReminder = widget.notificationSettings['dailyReminder'] ?? true;
    _streakReminder = widget.notificationSettings['streakReminder'] ?? true;
    _achievementNotification =
        widget.notificationSettings['achievementNotification'] ?? true;
    _practiceReminder =
        widget.notificationSettings['practiceReminder'] ?? false;
    _reminderTime = widget.notificationSettings['reminderTime'] ?? '08:00';
    _loadAudioSettings();
  }

  Future<void> _loadAudioSettings() async {
    final storage = await StorageService.getInstance();
    if (mounted) {
      setState(() {
        _currentAccent = storage.getAccent();
        _currentSpeechRate = storage.getSpeechRate();
      });
    }
  }

  void _saveSettings() {
    widget.onSettingsSaved({
      'dailyReminder': _dailyReminder,
      'streakReminder': _streakReminder,
      'achievementNotification': _achievementNotification,
      'practiceReminder': _practiceReminder,
      'reminderTime': _reminderTime,
    });
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('通知设置'),
        actions: [
          TextButton(
            onPressed: _saveSettings,
            child: const Text('保存', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
      body: ListView(
        children: [
          _buildSectionHeader('学习提醒'),
          SwitchListTile(
            title: const Text('每日学习提醒'),
            subtitle: const Text('定时提醒你保持学习习惯'),
            value: _dailyReminder,
            onChanged: (value) => setState(() => _dailyReminder = value),
          ),
          if (_dailyReminder) ...[
            ListTile(
              title: const Text('提醒时间'),
              subtitle: Text(_reminderTime),
              trailing: const Icon(Icons.chevron_right),
              onTap: _showTimePicker,
            ),
          ],
          Divider(
            height: 24,
            indent: 16,
            endIndent: 16,
            color: Theme.of(context).brightness == Brightness.dark
                ? Colors.white.withValues(alpha: 0.08)
                : Colors.black.withValues(alpha: 0.06),
          ),
          _buildSectionHeader('提醒类型'),
          SwitchListTile(
            title: const Text('连续学习提醒'),
            subtitle: const Text('提醒你保持连续学习天数'),
            value: _streakReminder,
            onChanged: (value) => setState(() => _streakReminder = value),
          ),
          SwitchListTile(
            title: const Text('练习提醒'),
            subtitle: const Text('提醒你进行单词、句子练习'),
            value: _practiceReminder,
            onChanged: (value) => setState(() => _practiceReminder = value),
          ),
          SwitchListTile(
            title: const Text('成就解锁通知'),
            subtitle: const Text('获得新成就时通知你'),
            value: _achievementNotification,
            onChanged: (value) =>
                setState(() => _achievementNotification = value),
          ),
          Divider(
            height: 24,
            indent: 16,
            endIndent: 16,
            color: Theme.of(context).brightness == Brightness.dark
                ? Colors.white.withValues(alpha: 0.08)
                : Colors.black.withValues(alpha: 0.06),
          ),
          _buildSectionHeader('语音发音与语速'),
          ListTile(
            leading: const Icon(Icons.record_voice_over_rounded, color: Colors.indigo),
            title: const Text('英语发音口音'),
            subtitle: Text(_currentAccent == 'UK' ? '🇬🇧 英式发音 (RP Standard)' : '🇺🇸 美式发音 (General American)'),
            trailing: SegmentedButton<String>(
              segments: const [
                ButtonSegment(value: 'US', label: Text('🇺🇸 美音')),
                ButtonSegment(value: 'UK', label: Text('🇬🇧 英音')),
              ],
              selected: {_currentAccent},
              onSelectionChanged: (val) async {
                final newAccent = val.first;
                setState(() => _currentAccent = newAccent);
                final storage = await StorageService.getInstance();
                await storage.saveAccent(newAccent);
                AudioService.instance.speakWord('hello', accent: newAccent);
              },
            ),
          ),
          ListTile(
            leading: const Icon(Icons.speed_rounded, color: Colors.deepOrange),
            title: const Text('全局发音语速'),
            subtitle: Text('${_currentSpeechRate.toStringAsFixed(1)}x (${_getSpeechRateLabel(_currentSpeechRate)})'),
            trailing: SegmentedButton<double>(
              segments: const [
                ButtonSegment(value: 0.8, label: Text('0.8x')),
                ButtonSegment(value: 1.0, label: Text('1.0x')),
                ButtonSegment(value: 1.2, label: Text('1.2x')),
              ],
              selected: {_currentSpeechRate},
              onSelectionChanged: (val) async {
                final newRate = val.first;
                setState(() => _currentSpeechRate = newRate);
                final storage = await StorageService.getInstance();
                await storage.saveSpeechRate(newRate);
                AudioService.instance.speakSentence('The limits of my language mean the limits of my world.', speechRate: newRate);
              },
            ),
          ),
          Divider(
            height: 24,
            indent: 16,
            endIndent: 16,
            color: Theme.of(context).brightness == Brightness.dark
                ? Colors.white.withValues(alpha: 0.08)
                : Colors.black.withValues(alpha: 0.06),
          ),
          _buildSectionHeader('学习闹钟与推送测试'),
          ListTile(
            leading: const Icon(Icons.alarm_rounded, color: Colors.amber),
            title: const Text('模拟每日定时打卡闹钟'),
            subtitle: Text('测试在 $_reminderTime 触发的极光打卡提醒卡片'),
            onTap: _triggerAlarmDialog,
          ),
          ListTile(
            leading: const Icon(Icons.notifications_active_rounded, color: Colors.blue),
            title: const Text('发送测试推送通知'),
            subtitle: const Text('模拟系统通知栏发出的打卡打卡提醒'),
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('🔔 Lumina 英语提醒: 保持连续打卡！今天的练习还在等你喔 ($reminderTime)'),
                  action: SnackBarAction(
                    label: '去打卡',
                    textColor: Colors.amber,
                    onPressed: _triggerAlarmDialog,
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  String get reminderTime => _reminderTime;

  void _triggerAlarmDialog() {
    AudioService.instance.speakSentence('Time for your daily English practice!');

    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: const BoxDecoration(
                  color: Color(0xFFFFF7ED),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.alarm_on_rounded,
                  color: Color(0xFFF97316),
                  size: 40,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                '⏰ 每日打卡时间到 ($_reminderTime)',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                '“The limits of my language mean the limits of my world.”\n今天的 4 步学习舱还在等你解锁！',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.grey,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('10分钟后提醒'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFF97316),
                        foregroundColor: Colors.white,
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                        Navigator.pop(context); // Return to home/daily tab
                      },
                      child: const Text('🚀 立即去打卡'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _getSpeechRateLabel(double rate) {
    if (rate <= 0.8) return '慢速跟读';
    if (rate >= 1.2) return '快速高阶';
    return '标准母语';
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
    );
  }

  void _showTimePicker() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('选择提醒时间'),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: _timeOptions.length,
            itemBuilder: (context, index) {
              final time = _timeOptions[index];
              return ListTile(
                title: Text(time),
                trailing: _reminderTime == time
                    ? const Icon(Icons.check, color: Colors.green)
                    : null,
                onTap: () {
                  setState(() => _reminderTime = time);
                  Navigator.pop(context);
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
