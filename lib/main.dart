// import 'dart:async';
// import 'dart:io';
// import 'dart:ui';

// import 'package:firebase_core/firebase_core.dart';
// import 'package:states_app/firebase_options.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:states_app/app.dart';

// import 'package:flutter_dotenv/flutter_dotenv.dart';
// import 'package:states_app/core/global/theme/theme_service.dart';
// import 'package:states_app/core/preferences/user_preferences.dart';
// import 'package:states_app/core/services/env_service.dart';
// import 'package:get/get.dart';
// import 'package:get_storage/get_storage.dart';

// class MyHttpOverrides extends HttpOverrides {
//   @override
//   HttpClient createHttpClient(SecurityContext? context) {
//     return super.createHttpClient(context)
//       ..badCertificateCallback =
//           (X509Certificate cert, String host, int port) => true;
//   }
// }

// Future<void> main() async {
//   runZonedGuarded(() async {
//     WidgetsFlutterBinding.ensureInitialized();
//     await Firebase.initializeApp(
//       options: DefaultFirebaseOptions.currentPlatform,
//     );
//     // FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
//     await GetStorage.init();

//     AppSession.init();
//     // await NotificationService.init();
//     await EnvService.ensureEnvFilesExist();
//     final activePath = await EnvService.activeEnvPath();
//     final envString = await File(activePath).readAsString();
//     dotenv.loadFromString(envString: envString, isOptional: true);

//     // =======

//     // Load GPT_API from gpt.env file
//     try {
//       final gptEnvString = await rootBundle.loadString('environments/.env');
//       dotenv.loadFromString(envString: gptEnvString, isOptional: true);
//     } catch (e) {
//       debugPrint('Error loading gpt.env: $e');
//     }

//     // HttpOverrides.global = MyHttpOverrides();
//     SystemChrome.setPreferredOrientations([
//       DeviceOrientation.portraitUp,
//       DeviceOrientation.portraitDown,
//     ]);
//     // 1. Enable Edge-to-Edge mode
//     // SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);

//     // 2. Set the navigation bar color to transparent
//     SystemChrome.setSystemUIOverlayStyle(
//       const SystemUiOverlayStyle(
//         // systemNavigationBarColor: Colors.transparent, // Make it transparent
//         systemNavigationBarColor: Colors.black, // Make it transparent
//         systemNavigationBarContrastEnforced:
//             true, // Remove the translucent "scrim" on Android 10+
//         systemNavigationBarIconBrightness:
//             Brightness.dark, // Adjust icon color (dark/light)
//       ),
//     );
//     FlutterError.onError = (FlutterErrorDetails details) {
//       FlutterError.dumpErrorToConsole(details);
//     };
//     PlatformDispatcher.instance.onError = (error, stack) {
//       return true;
//     };

//     // Initialize ThemeService
//     Get.put(ThemeService());

//     runApp(App());
//   }, (Object error, StackTrace stack) {});
// }


/////Chat AI
import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:states_app/test.dart';

// import 'deepseek_service.dart';



void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: VoiceChatScreen(),
    );
  }
}

class VoiceChatScreen extends StatefulWidget {
  const VoiceChatScreen({super.key});

  @override
  State<VoiceChatScreen> createState() => _VoiceChatScreenState();
}

class _VoiceChatScreenState extends State<VoiceChatScreen> {
  final SpeechToText speechToText = SpeechToText();
  final FlutterTts flutterTts = FlutterTts();
  final DeepSeekService deepSeekService = DeepSeekService();

  final TextEditingController messageController =
      TextEditingController();

  bool isListening = false;
  bool isLoading = false;

  List<Map<String, String>> messages = [];

  @override
  void initState() {
    super.initState();
    initTts();
  }

  Future<void> initTts() async {
    await flutterTts.setLanguage("en-US");
    await flutterTts.setSpeechRate(0.5);
  }

  Future<void> startListening() async {
    bool available = await speechToText.initialize();

    if (!available) return;

    setState(() {
      isListening = true;
    });

    speechToText.listen(
      onResult: (result) {
        messageController.text = result.recognizedWords;
      },
    );
  }

  Future<void> stopListening() async {
    await speechToText.stop();

    setState(() {
      isListening = false;
    });

    if (messageController.text.trim().isNotEmpty) {
      sendMessage(messageController.text.trim());
    }
  }

  Future<void> sendMessage(String text) async {
    if (text.isEmpty) return;

    setState(() {
      messages.add({
        "role": "user",
        "message": text,
      });
      isLoading = true;
    });

    messageController.clear();

    try {
      final response =
          await deepSeekService.sendMessage(text);

      setState(() {
        messages.add({
          "role": "assistant",
          "message": response,
        });
      });

      await flutterTts.speak(response);
    } catch (e) {
      setState(() {
        messages.add({
          "role": "assistant",
          "message": "Error: $e",
        });
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Widget buildMessageBubble(Map<String, String> chat) {
    bool isUser = chat["role"] == "user";

    return Align(
      alignment:
          isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 4,
        ),
        padding: const EdgeInsets.all(12),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * .75,
        ),
        decoration: BoxDecoration(
          color: isUser
              ? Colors.blue
              : Colors.grey.shade300,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Text(
          chat["message"] ?? "",
          style: TextStyle(
            color: isUser ? Colors.white : Colors.black,
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    flutterTts.stop();
    speechToText.stop();
    messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("DeepSeek Voice Chat"),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: messages.isEmpty
                ? const Center(
                    child: Text(
                      "Start chatting with AI",
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.only(top: 10),
                    itemCount: messages.length,
                    itemBuilder: (context, index) {
                      return buildMessageBubble(
                        messages[index],
                      );
                    },
                  ),
          ),

          if (isLoading)
            const Padding(
              padding: EdgeInsets.all(10),
              child: Row(
                children: [
                  SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                    ),
                  ),
                  SizedBox(width: 10),
                  Text("AI is thinking..."),
                ],
              ),
            ),

          SafeArea(
            child: Container(
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: messageController,
                      textInputAction: TextInputAction.send,
                      onSubmitted: (value) {
                        sendMessage(value.trim());
                      },
                      decoration: InputDecoration(
                        hintText: "Type a message...",
                        border: OutlineInputBorder(
                          borderRadius:
                              BorderRadius.circular(25),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(width: 8),

                  IconButton(
                    onPressed: () {
                      sendMessage(
                        messageController.text.trim(),
                      );
                    },
                    icon: const Icon(Icons.send),
                  ),

                  IconButton(
                    onPressed: () {
                      if (isListening) {
                        stopListening();
                      } else {
                        startListening();
                      }
                    },
                    icon: Icon(
                      isListening
                          ? Icons.stop_circle
                          : Icons.mic,
                      color: isListening
                          ? Colors.red
                          : Colors.blue,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}///