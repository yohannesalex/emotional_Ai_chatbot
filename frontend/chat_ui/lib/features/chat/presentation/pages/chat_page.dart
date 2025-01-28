import 'package:chat_ui/features/chat/domain/entities/chat.dart';
import 'package:chat_ui/features/chat/presentation/bloc/chat_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/parameters_bloc.dart';
import '../widget/edit_parameter_widget.dart';

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final List<Map<String, dynamic>> messages = [];
  final TextEditingController _controller = TextEditingController();

  void _sendMessage(String text) {
    if (text.trim().isEmpty) return;

    // Add the user's message
    setState(() {
      messages.add({
        "sender": "user",
        "message": text.trim(),
        "isLoading": false,
      });
    });

    _controller.clear();
  }

  void _showEditDialog() {
    showDialog(
      context: context,
      builder: (context) => EditParametersDialog(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Emotional ChatBot"),
        backgroundColor: const Color.fromARGB(255, 207, 187, 241),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: _showEditDialog,
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: BlocListener<ChatBloc, ChatState>(
              listener: (context, state) {
                if (state is LoadedSingleChatState) {
                  // Replace loading indicator with AI response
                  setState(() {
                    messages.removeWhere((msg) => msg["isLoading"] == true);
                    messages.add({
                      "sender": "ai",
                      "message": state.chat.response,
                      "isLoading": false,
                      "anger": state.chat.anger, // Store anger level
                      "sadness": state.chat.sadness, // Store sadness level
                    });
                  });
                } else if (state is ErrorState) {
                  setState(() {
                    messages.removeWhere((msg) => msg["isLoading"] == true);
                    messages.add({
                      "sender": "ai",
                      "message": "Error: ${state.message}",
                      "isLoading": false
                    });
                  });
                }
              },
              child: ListView.builder(
                padding: const EdgeInsets.all(10),
                itemCount: messages.length,
                itemBuilder: (context, index) {
                  final message = messages[index];
                  final isUser = message["sender"] == "user";
                  final isLoading = message["isLoading"] == true;
                  final anger = message["anger"] ?? 0;
                  final sadness = message["sadness"] ?? 0;

                  return Align(
                    alignment:
                        isUser ? Alignment.centerRight : Alignment.centerLeft,
                    child: Container(
                      margin: const EdgeInsets.symmetric(vertical: 5),
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color:
                            isUser ? Colors.deepPurple[100] : Colors.grey[300],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: isLoading
                          ? const Text(
                              "...", // Typing animation effect
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            )
                          : Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  message["message"],
                                  style: const TextStyle(fontSize: 16),
                                ),
                                if (!isUser) ...[
                                  const SizedBox(height: 5),
                                  Row(
                                    children: [
                                      Text(
                                        "😡 Anger: $anger",
                                        style: TextStyle(color: Colors.red),
                                      ),
                                      const SizedBox(width: 10),
                                      Text(
                                        "😢 Sadness: $sadness",
                                        style: TextStyle(color: Colors.blue),
                                      ),
                                    ],
                                  ),
                                ]
                              ],
                            ),
                    ),
                  );
                },
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            color: Colors.grey[200],
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: const InputDecoration(
                      hintText: "Type a message...",
                      border: InputBorder.none,
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send, color: Colors.deepPurple),
                  onPressed: () {
                    final text = _controller.text.trim();
                    if (text.isEmpty) return;

                    // Add the user's message
                    _sendMessage(text);

                    // Add loading animation for AI response
                    setState(() {
                      messages.add({
                        "sender": "ai",
                        "message": "",
                        "isLoading": true,
                      });
                    });

                    // Get current parameters
                    final parametersState =
                        context.read<ParametersBloc>().state;
                    final valenceLevel = parametersState.parameters[0];
                    final arousalLevel = parametersState.parameters[1];
                    final selectionThreshold = parametersState.parameters[2];
                    final resolutionLevel = parametersState.parameters[3];
                    final goalDirectedness = parametersState.parameters[4];
                    final securingRate = parametersState.parameters[5];

                    // Send message event
                    context.read<ChatBloc>().add(
                          SendChatEvent(
                            ChatSendEntity(text: text),
                            valenceLevel,
                            arousalLevel,
                            selectionThreshold,
                            resolutionLevel,
                            goalDirectedness,
                            securingRate,
                          ),
                        );
                  },
                ),
              ],
            ),
          ),
          SizedBox(
            height: 5,
          )
        ],
      ),
    );
  }
}
