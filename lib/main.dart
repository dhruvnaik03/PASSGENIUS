
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:video_player/video_player.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'passgenius',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: RandomPasswordGenerator(),
    );
  }
}

class RandomPasswordGenerator extends StatefulWidget {
  @override
  _RandomPasswordGeneratorState createState() =>
      _RandomPasswordGeneratorState();
}

class _RandomPasswordGeneratorState extends State<RandomPasswordGenerator> {
  final TextEditingController _lengthController = TextEditingController();
  final TextEditingController _charController = TextEditingController();
  final TextEditingController _outputController = TextEditingController();
  String _password = '';
  bool _useUpperCase = false;
  bool _useLowerCase = false;
  bool _useNumbers = false;
  bool _useSpecialChars = false;

  String generatePassword(int length, String includeChar) {
    String passwordCharacters = '';
    if (_useUpperCase) passwordCharacters += 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
    if (_useLowerCase) passwordCharacters += 'abcdefghijklmnopqrstuvwxyz';
    if (_useNumbers) passwordCharacters += '0123456789';
    if (_useSpecialChars)
      passwordCharacters += '!@#%^&*()_+{}[]|\\:;<>,.?/';

    String password = '';

    // Add random characters to the password
    password += List.generate(
        length - includeChar.length,
            (index) => passwordCharacters[
        Random().nextInt(passwordCharacters.length)])
        .join();

    // Add included character(s) to the password
    password += includeChar;

    // Shuffle the password to make it more random
    List<String> passwordList = password.split('');
    passwordList.shuffle();
    return passwordList.join();
  }

  void copyToClipboard(String text) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Password copied to clipboard')),
    );
  }

  void _generatePassword() {
    if (!_useUpperCase && !_useLowerCase && !_useNumbers && !_useSpecialChars) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please select at least one checkbox')),
      );
      return;
    }

    String lengthText = _lengthController.text.trim();
    String charText = _charController.text.trim();

    int length = lengthText.isEmpty ? 12 : int.tryParse(lengthText) ?? 12;

    if (charText.length >= length) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please check your custom field')),
      );
      return;
    }

    setState(() {
      _password = generatePassword(length, charText);
      _outputController.text = _password;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Padding(
          padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 0.0),
          child: Text(
            'PASS GENIUS',
            style: TextStyle(
              fontFamily: 'FontMain7',
              fontSize: 17,
              fontWeight: FontWeight.bold,
              color: Colors.red[900],
            ),
          ),
        ),
        elevation: 10,
        backgroundColor: Color(0xFF000000),
        leading: Image.asset('assets/icons/logo.png'),
      ),
      body: Stack(
        children: [
          VideoBackground(), // Video background
          ListView(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    TextField(
                      controller: _lengthController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: 'Enter password length',
                        labelStyle: TextStyle(
                          fontFamily: 'FontMain18',
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                        filled: true,
                        fillColor: Colors.black12,
                      ),
                      style: TextStyle(color: Colors.white),
                    ),
                    SizedBox(height: 10), // Added spacing here
                    TextField(
                      controller: _charController,
                      decoration: InputDecoration(
                        labelText: 'Enter Custom Input In Password',
                        labelStyle: TextStyle(
                          fontFamily: 'FontMain18',
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                        filled: true,
                        fillColor: Colors.black12,
                      ),
                      style: TextStyle(color: Colors.white),
                    ),
                    SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Checkbox(
                              value: _useUpperCase,
                              onChanged: (value) {
                                setState(() {
                                  _useUpperCase = value!;
                                });
                              },
                              checkColor: Colors.white,
                              fillColor:
                              MaterialStateProperty.resolveWith<Color>(
                                    (Set<MaterialState> states) {
                                  if (states.contains(MaterialState.selected)) {
                                    return Colors.white;
                                  }
                                  return Colors.transparent;
                                },
                              ),
                            ),
                            Text(
                              'Uppercase',
                              style: TextStyle(color: Colors.white),
                            ),
                            Checkbox(
                              value: _useLowerCase,
                              onChanged: (value) {
                                setState(() {
                                  _useLowerCase = value!;
                                });
                              },
                              checkColor: Colors.white,
                              fillColor:
                              MaterialStateProperty.resolveWith<Color>(
                                    (Set<MaterialState> states) {
                                  if (states.contains(MaterialState.selected)) {
                                    return Colors.white;
                                  }
                                  return Colors.transparent;
                                },
                              ),
                            ),
                            Text(
                              'Lowercase',
                              style: TextStyle(color: Colors.white),
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Checkbox(
                              value: _useNumbers,
                              onChanged: (value) {
                                setState(() {
                                  _useNumbers = value!;
                                });
                              },
                              checkColor: Colors.white,
                              fillColor:
                              MaterialStateProperty.resolveWith<Color>(
                                    (Set<MaterialState> states) {
                                  if (states.contains(MaterialState.selected)) {
                                    return Colors.white;
                                  }
                                  return Colors.transparent;
                                },
                              ),
                            ),
                            Text(
                              'Numbers',
                              style: TextStyle(color: Colors.white),
                            ),
                            Checkbox(
                              value: _useSpecialChars,
                              onChanged: (value) {
                                setState(() {
                                  _useSpecialChars = value!;
                                });
                              },
                              checkColor: Colors.white,
                              fillColor:
                              MaterialStateProperty.resolveWith<Color>(
                                    (Set<MaterialState> states) {
                                  if (states.contains(MaterialState.selected)) {
                                    return Colors.white;
                                  }
                                  return Colors.transparent;
                                },
                              ),
                            ),
                            Text(
                              'Special Characters',
                              style: TextStyle(color: Colors.white),
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: _generatePassword,
                      style: ButtonStyle(
                        backgroundColor:
                        MaterialStateProperty.all<Color>(Colors.white70),
                      ),
                      child: Text(
                        'Generate Password',
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                    SizedBox(height: 20),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: _outputController,
                            readOnly: true,
                            minLines: null,
                            maxLines: null,
                            decoration: InputDecoration(
                              labelText: 'Password Output',
                              labelStyle: TextStyle(
                                fontFamily: 'FontMain18',
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                              filled: true,
                              fillColor: Colors.black12,
                              focusedBorder: OutlineInputBorder(
                                borderSide:
                                BorderSide(color: Colors.black12),
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            style: TextStyle(color: Colors.red),
                          ),
                        ),
                        SizedBox(width: 10),
                        ElevatedButton(
                          onPressed: () {
                            if (_password.isNotEmpty) {
                              copyToClipboard(_password);
                            }
                          },
                          style: ButtonStyle(
                            backgroundColor:
                            MaterialStateProperty.all<Color>(
                                Colors.white70),
                          ),
                          child: Text(
                            'Copy',
                            style: TextStyle(color: Colors.black),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class VideoBackground extends StatefulWidget {
  @override
  _VideoBackgroundState createState() => _VideoBackgroundState();
}

class _VideoBackgroundState extends State<VideoBackground> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.asset('assets/videos/background.mp4')
      ..initialize().then(
            (_) {
          _controller.play();
          _controller.setLooping(true);
          setState(() {});
        },
      );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: FittedBox(
        fit: BoxFit.cover,
        child: SizedBox(
          width: _controller.value.size.width,
          height: _controller.value.size.height,
          child: AspectRatio(
            aspectRatio: _controller.value.aspectRatio,
            child: VideoPlayer(_controller),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
