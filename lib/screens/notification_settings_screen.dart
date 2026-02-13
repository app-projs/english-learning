import 'package:flutter/material.dart';

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
          const Divider(),
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
          const Divider(),
          _buildSectionHeader('推送测试'),
          ListTile(
            leading: const Icon(Icons.send),
            title: const Text('发送测试通知'),
            subtitle: const Text('点击发送一条测试通知'),
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('测试通知已发送')),
              );
            },
          ),
        ],
      ),
    );
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
