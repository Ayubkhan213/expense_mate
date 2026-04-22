import 'dart:io';
import 'package:spendio/features/profile/presentation/bloc/notification/notification_bloc.dart';
import 'package:spendio/features/profile/presentation/bloc/notification/notification_event.dart';
import 'package:spendio/features/profile/presentation/bloc/notification/notification_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

class DailyNotificationFace extends StatelessWidget {
  const DailyNotificationFace({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => NotificationBloc()..add(LoadNotificationSettings()),
      child: const _DailyNotificationView(),
    );
  }
}

class _DailyNotificationView extends StatelessWidget {
  const _DailyNotificationView();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<NotificationBloc, NotificationState>(
      listener: (context, state) {
        if (state.errorMessage != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.errorMessage!),
              backgroundColor: Colors.red,
            ),
          );
        }
        if (state.successMessage != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.successMessage!),
              backgroundColor: Colors.green,
            ),
          );
        }
      },
      builder: (context, state) {
        final theme = Theme.of(context);

        return Scaffold(
          appBar: AppBar(
            title: const Text('Daily Notification'),
            actions: [
              if (state.isEnabled)
                IconButton(
                  icon: const Icon(Icons.delete_outline),
                  onPressed: () {
                    context.read<NotificationBloc>().add(CancelNotification());
                  },
                  tooltip: 'Cancel Notification',
                ),
            ],
          ),
          body: state.status == NotificationStatus.loading
              ? const Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Status Card
                      _StatusCard(
                        isEnabled: state.isEnabled,
                        hour: state.hour,
                        minute: state.minute,
                      ),
                      const SizedBox(height: 24),

                      // Time Picker
                      _TimePicker(
                        hour: state.hour,
                        minute: state.minute,
                        onTimeChanged: (hour, minute) {
                          context.read<NotificationBloc>().add(
                            UpdateTime(hour, minute),
                          );
                        },
                      ),
                      const SizedBox(height: 16),

                      // Title Input
                      _TitleInput(
                        initialValue: state.title,
                        onChanged: (value) {
                          context.read<NotificationBloc>().add(
                            UpdateTitle(value),
                          );
                        },
                      ),
                      const SizedBox(height: 16),

                      // Body Input
                      _BodyInput(
                        initialValue: state.body,
                        onChanged: (value) {
                          context.read<NotificationBloc>().add(
                            UpdateBody(value),
                          );
                        },
                      ),
                      const SizedBox(height: 16),

                      // Image Section
                      _ImageSection(
                        imagePath: state.imagePath,
                        onImageChanged: (path) {
                          context.read<NotificationBloc>().add(
                            UpdateImage(path),
                          );
                        },
                      ),
                      const SizedBox(height: 24),

                      // Test Button
                      OutlinedButton.icon(
                        onPressed: () {
                          context.read<NotificationBloc>().add(
                            SendTestNotification(),
                          );
                        },
                        icon: const Icon(Icons.notifications_active),
                        label: const Text('Send Test Notification'),
                        style: OutlinedButton.styleFrom(
                          minimumSize: const Size(double.infinity, 50),
                        ),
                      ),
                      const SizedBox(height: 12),

                      // Schedule Button
                      // Add Schedule to List Button (REPLACE Schedule Button)
                      ElevatedButton.icon(
                        onPressed: () {
                          context.read<NotificationBloc>().add(
                            const AddScheduleToList(),
                          );
                        },
                        icon: const Icon(Icons.add),
                        label: const Text('Add to Schedule List'),
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size(double.infinity, 50),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Schedule List
                      if (state.schedules.isNotEmpty) ...[
                        Card(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(16),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.schedule,
                                      color: theme.primaryColor,
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      'Scheduled Notifications (${state.schedules.length})',
                                      style: theme.textTheme.titleMedium
                                          ?.copyWith(
                                            fontWeight: FontWeight.bold,
                                          ),
                                    ),
                                  ],
                                ),
                              ),
                              const Divider(height: 1),
                              ListView.separated(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: state.schedules.length,
                                separatorBuilder: (_, __) =>
                                    const Divider(height: 1),
                                itemBuilder: (context, index) {
                                  final schedule = state.schedules[index];
                                  final timeStr =
                                      '${schedule.hour.toString().padLeft(2, '0')}:${schedule.minute.toString().padLeft(2, '0')}';
                                  return ListTile(
                                    leading: CircleAvatar(
                                      backgroundColor: theme.primaryColor
                                          .withOpacity(0.1),
                                      child: Text(
                                        '${index + 1}',
                                        style: TextStyle(
                                          color: theme.primaryColor,
                                        ),
                                      ),
                                    ),
                                    title: Text(schedule.title),
                                    subtitle: Text(
                                      '$timeStr - ${schedule.body}',
                                    ),
                                    trailing: IconButton(
                                      icon: const Icon(
                                        Icons.delete,
                                        color: Colors.red,
                                      ),
                                      onPressed: () {
                                        context.read<NotificationBloc>().add(
                                          RemoveScheduleFromList(schedule.id),
                                        );
                                      },
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Save All Button
                        ElevatedButton.icon(
                          onPressed: () {
                            context.read<NotificationBloc>().add(
                              const SaveAllSchedules(),
                            );
                          },
                          icon: const Icon(Icons.save),
                          label: const Text('Save All Schedules'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            minimumSize: const Size(double.infinity, 50),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),
                      ],
                      // ElevatedButton.icon(
                      //   onPressed: () {
                      //     context.read<NotificationBloc>().add(
                      //       ScheduleNotification(),
                      //     );
                      //   },
                      //   icon: const Icon(Icons.alarm_add),
                      //   label: Text(
                      //     state.isEnabled
                      //         ? 'Update Daily Notification'
                      //         : 'Schedule Daily Notification',
                      //   ),
                      //   style: ElevatedButton.styleFrom(
                      //     minimumSize: const Size(double.infinity, 50),
                      //     shape: RoundedRectangleBorder(
                      //       borderRadius: BorderRadius.circular(12),
                      //     ),
                      //   ),
                      // ),
                      const SizedBox(height: 24),

                      // Info Card
                      const _InfoCard(),
                    ],
                  ),
                ),
        );
      },
    );
  }
}

class _StatusCard extends StatelessWidget {
  final bool isEnabled;
  final int hour;
  final int minute;

  const _StatusCard({
    required this.isEnabled,
    required this.hour,
    required this.minute,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final timeStr =
        '${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}';

    return Card(
      color: isEnabled
          ? Colors.green.withOpacity(0.1)
          : Colors.grey.withOpacity(0.1),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Icon(
              isEnabled ? Icons.notifications_active : Icons.notifications_off,
              color: isEnabled ? Colors.green : Colors.grey,
              size: 32,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    isEnabled ? 'Notification Active' : 'No Notification Set',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: isEnabled ? Colors.green : Colors.grey,
                    ),
                  ),
                  if (isEnabled)
                    Text('Daily at $timeStr', style: theme.textTheme.bodySmall),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TimePicker extends StatelessWidget {
  final int hour;
  final int minute;
  final Function(int hour, int minute) onTimeChanged;

  const _TimePicker({
    required this.hour,
    required this.minute,
    required this.onTimeChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final timeStr =
        '${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}';

    return Card(
      child: ListTile(
        leading: Icon(Icons.access_time, color: theme.primaryColor),
        title: const Text('Notification Time'),
        subtitle: Text(timeStr),
        trailing: const Icon(Icons.chevron_right),
        onTap: () async {
          final time = await showTimePicker(
            context: context,
            initialTime: TimeOfDay(hour: hour, minute: minute),
          );
          if (time != null) {
            onTimeChanged(time.hour, time.minute);
          }
        },
      ),
    );
  }
}

class _TitleInput extends StatefulWidget {
  final String initialValue;
  final Function(String) onChanged;

  const _TitleInput({required this.initialValue, required this.onChanged});

  @override
  State<_TitleInput> createState() => _TitleInputState();
}

class _TitleInputState extends State<_TitleInput> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialValue);
  }

  @override
  void didUpdateWidget(_TitleInput oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initialValue != widget.initialValue) {
      _controller.text = widget.initialValue;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _controller,
      onChanged: widget.onChanged,
      decoration: InputDecoration(
        labelText: 'Notification Title',
        hintText: 'Enter notification title',
        prefixIcon: const Icon(Icons.title),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
      maxLength: 50,
    );
  }
}

class _BodyInput extends StatefulWidget {
  final String initialValue;
  final Function(String) onChanged;

  const _BodyInput({required this.initialValue, required this.onChanged});

  @override
  State<_BodyInput> createState() => _BodyInputState();
}

class _BodyInputState extends State<_BodyInput> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialValue);
  }

  @override
  void didUpdateWidget(_BodyInput oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initialValue != widget.initialValue) {
      _controller.text = widget.initialValue;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _controller,
      onChanged: widget.onChanged,
      decoration: InputDecoration(
        labelText: 'Notification Message',
        hintText: 'Enter notification message',
        prefixIcon: const Icon(Icons.message),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
      maxLines: 3,
      maxLength: 200,
    );
  }
}

class _ImageSection extends StatelessWidget {
  final String? imagePath;
  final Function(String?) onImageChanged;

  const _ImageSection({required this.imagePath, required this.onImageChanged});

  Future<void> _pickImage(BuildContext context) async {
    try {
      final picker = ImagePicker();
      final XFile? image = await picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 85,
      );

      if (image != null) {
        onImageChanged(image.path);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error picking image: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.image, color: theme.primaryColor),
                const SizedBox(width: 8),
                Text(
                  'Notification Image (Optional)',
                  style: theme.textTheme.titleMedium,
                ),
              ],
            ),
            const SizedBox(height: 12),
            if (imagePath != null) ...[
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.file(
                  File(imagePath!),
                  height: 200,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () => _pickImage(context),
                      icon: const Icon(Icons.edit),
                      label: const Text('Change Image'),
                    ),
                  ),
                  const SizedBox(width: 8),
                  OutlinedButton.icon(
                    onPressed: () => onImageChanged(null),
                    icon: const Icon(Icons.delete),
                    label: const Text('Remove'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.red,
                    ),
                  ),
                ],
              ),
            ] else
              OutlinedButton.icon(
                onPressed: () => _pickImage(context),
                icon: const Icon(Icons.add_photo_alternate),
                label: const Text('Add Image'),
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  const _InfoCard();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      color: Colors.blue.withOpacity(0.1),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.info_outline, color: Colors.blue),
                const SizedBox(width: 8),
                Text(
                  'How it works',
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              '• Notification will repeat daily at the selected time\n'
              '• Works even when the app is closed\n'
              '• Images are displayed in expanded notification\n'
              '• Large images are automatically resized',
              style: theme.textTheme.bodySmall,
            ),
          ],
        ),
      ),
    );
  }
}
