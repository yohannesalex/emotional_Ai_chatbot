# Emotion-Aware AI Chatbot

## Overview
This project is an **Emotion-Aware AI Chatbot** that integrates **Frontend (React/Flutter), Backend (Flask), and AI Model (Gemini API)** to provide responses based on psychological parameters from **Psi Theory**. It analyzes user messages, considers emotional states, and generates responses accordingly.

## Features
- **Emotion-Aware Response Generation**: Uses **Psi Theory** parameters to tailor chatbot responses.
- **Conversation Memory**: Stores and recalls previous conversations for contextual understanding.
- **Sentiment Analysis**: Determines sadness and anger levels based on input.
- **Secure API Communication**: Uses **Flask backend** and **Gemini API** for response generation.
- **Frontend UI**: Built with **React/Flutter** to provide a user-friendly chat interface.

---

## Tech Stack
### **Frontend** (React/Flutter)
- UI for user interaction
- Sends user messages to the backend
- Displays chatbot responses

### **Backend** (Flask API)
- Handles requests from the frontend
- Processes user messages and sends them to the AI model
- Implements conversation memory using **LangChain**
- Integrates **Gemini API** for response generation

### **AI Model** (Google Gemini API)
- Generates responses based on **Psi Theory** parameters
- Analyzes conversation history for context-aware replies

---

## Installation & Setup
### **1. Clone the Repository**
```sh
git clone https://github.com/your-repo/emotion-ai-chatbot.git
cd emotion-ai-chatbot
```

### **2. Backend Setup (Flask)**
#### **Install Dependencies**
```sh
cd backend
pip install -r requirements.txt
```
#### **Set Up Environment Variables**
Create a `.env` file in the `backend/` directory:
```sh
GEMINI_API_KEY=your_api_key_here
```
#### **Run Flask Server**
```sh
python app.py
```

### **3. Frontend Setup (React/Flutter)**
#### **React Setup**
```sh
cd frontend
npm install
npm start
```
#### **Flutter Setup**
```sh
cd frontend_flutter
flutter pub get
flutter run
```

---

## API Endpoints
### **Generate Response**
- **Endpoint**: `/generate_response`
- **Method**: `POST`
- **Request Body (JSON)**:
```json
{
  "valence_level": 3,
  "arousal_level": 4,
  "selection_threshold": 5,
  "resolution_level": 6,
  "goal_directedness": 4,
  "securing_rate": 3,
  "message": "I feel stuck and unmotivated."
}
```
- **Response (JSON)**:
```json
{
  "response": "I understand that you're feeling stuck. Let's explore ways to regain motivation...",
  "sadness_level": 3,
  "anger_level": 2
}
```

---

## Project Structure
```
├── backend/        # Flask Backend
│   ├── app.py      # Main Flask App
│   ├── requirements.txt # Python Dependencies
├── frontend/  
|     |chat_ui
│        ├── lib/
│        ├── pubspec.yaml
└── README.md       # Project Documentation
```

---

## Future Improvements
- **Multi-language Support**
- **Real-time Sentiment Visualization**
- **Advanced Personality-based Responses**

---

## Contributors
- **Yohannes Alemayehu** (AI Model & Backend)
- **[Your Team]** (Frontend & Integration)

---

## License
This project is licensed under the MIT License.

