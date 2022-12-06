import 'package:flutter/material.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';
import 'package:awesome_notifications/awesome_notifications.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
      AwesomeNotifications().initialize(
        'resource://drawable/ic_launcher',
    [
        NotificationChannel(
            channelKey: 'basic',
            channelName: 'Notifikacija',
            channelDescription: 'Notifikacija za stopwatch',
            channelShowBadge: true,
            importance: NotificationImportance.High,
            )
    ]
  );

  runApp(const MyApp());
}

class NotificationController {
  final StopWatchTimer _stopWatchTimer = StopWatchTimer();
  @pragma("vm:entry-point")
  static Future<void> onActionReceivedMethod(ReceivedAction receivedAction) async {
    if(receivedAction.actionType == ActionType.KeepOnTop)
      {
        if(receivedAction.buttonKeyPressed == 'start')
          {

          }
      }
  }
}

class MyApp extends StatelessWidget {
  const MyApp ({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final StopWatchTimer _stopWatchTimer = StopWatchTimer();
  final _sati = true;

  @override
  void initState() {
    AwesomeNotifications().setListeners(
        onActionReceivedMethod: NotificationController.onActionReceivedMethod
    );

    super.initState();
  }

  @override
  void dispose() async {
    super.dispose();
    await _stopWatchTimer.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Stopwatch'),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            StreamBuilder<int>(
              stream: _stopWatchTimer.rawTime,
              initialData: _stopWatchTimer.rawTime.value,
              builder: (context, snap) {
                final value = snap.data;
                final displayTime = StopWatchTimer.getDisplayTime(value!, hours: _sati);
                return Column(
                  children: <Widget>[
                    Padding(padding: const EdgeInsets.all(8),
                      child: Text(
                      displayTime,
                      style: TextStyle(
                        fontSize: 40.0,
                        fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Padding(padding: EdgeInsets.all(8),
                      child: Text(
                        value.toString(),
                        style: TextStyle(
                          fontSize: 40.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
            SizedBox(
              height: 10.0,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green),
                    onPressed: _stopWatchTimer.onStartTimer,
                    child: const Text(
                      'Start',
                      style: TextStyle(color: Colors.white),
                    ),
                  )
                ),
                SizedBox(
                    width: 10.0
                ),
                Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red),
                      onPressed: _stopWatchTimer.onStopTimer,
                      child: const Text(
                        'Stop',
                        style: TextStyle(color: Colors.white),
                      ),
                    )
                ),
              ],
            ),
            Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue),
                  onPressed: _stopWatchTimer.onResetTimer,
                  child: const Text(
                    'Reset',
                    style: TextStyle(color: Colors.white),
                  ),
                )
            ),
            Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange),
                  onPressed: () async {
                    bool dozvoljeno = await AwesomeNotifications().isNotificationAllowed();
                    if(!dozvoljeno)
                      {
                        AwesomeNotifications().requestPermissionToSendNotifications();
                      }
                    else
                      {
                        AwesomeNotifications().createNotification(
                            content: NotificationContent(
                                id: 123,
                                channelKey: 'basic',
                                title: 'Stopwatch',
                                body: '',
                                autoDismissible: false,
                            ),

                            actionButtons: [
                              NotificationActionButton(
                                key: "start",
                                label: "Start",
                                actionType: ActionType.KeepOnTop
                              ),

                              NotificationActionButton(
                                key: "stop",
                                label: "Stop",
                                  actionType: ActionType.KeepOnTop
                              )
                            ]
                        );
                      }
                  },
                  child: const Text(
                    'Notifikacija',
                    style: TextStyle(color: Colors.white),
                  ),
                )
            ),
          ],
          )
        ),
      );
  }
}
