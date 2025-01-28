from flask import Flask, request, jsonify
from flask_cors import CORS
from langchain.memory import ConversationBufferMemory
import google.generativeai as genai
import os
from dotenv import load_dotenv

# Load environment variables
load_dotenv()

# Initialize Flask app
app = Flask(__name__)
CORS(app)  # Enable CORS for all routes

# Configure Gemini API
gemini_api_key = os.getenv("GEMINI_API_KEY")
if not gemini_api_key:
    raise ValueError("GEMINI_API_KEY is not set in the environment variables!")

genai.configure(api_key=gemini_api_key)
model = genai.GenerativeModel("gemini-1.5-flash")

# Initialize LangChain memory
memory = ConversationBufferMemory()

# Function to calculate sadness and anger levels with conversation context
def calculate_emotion_levels(valence_level, arousal_level, selection_threshold, resolution_level, conversation_history):
    """
    Calculate sadness and anger levels based on Psi Theory parameters and conversation context.
    
    Args:
        valence_level (int): Valence level (0-7).
        arousal_level (int): Arousal level (0-7).
        selection_threshold (int): Selection threshold (0-7).
        resolution_level (int): Resolution level (0-7).
        conversation_history (str): The conversation history as a string.
    
    Returns:
        tuple: (sadness_level, anger_level) on a scale of 1-5.
    """
    sadness_level = 1  # Default to low sadness
    anger_level = 1  # Default to low anger

    # Base calculations based on Psi Theory parameters
    if valence_level < 4:  # Negative valence
        sadness_level += 1
        if arousal_level < 4:  # Low arousal
            sadness_level += 1
        if resolution_level < 4:  # Low resolution
            sadness_level += 1

    if valence_level < 4:  # Negative valence
        if arousal_level > 5:  # High arousal
            anger_level += 2
        if selection_threshold > 5:  # High selection threshold
            anger_level += 1
        if resolution_level < 4:  # Low resolution
            anger_level += 1

    # Incorporate conversation context
    if "fail" in conversation_history.lower() or "can't" in conversation_history.lower():
        sadness_level += 1  # Increase sadness if failure is mentioned
    if "success" in conversation_history.lower() or "achieved" in conversation_history.lower():
        sadness_level -= 1  # Decrease sadness if success is mentioned

    if "obstacle" in conversation_history.lower() or "conflict" in conversation_history.lower():
        anger_level += 1  # Increase anger if obstacles are mentioned
    if "calm" in conversation_history.lower() or "resolved" in conversation_history.lower():
        anger_level -= 1  # Decrease anger if resolution is mentioned

    # Ensure levels are within 1-5 range
    sadness_level = min(max(sadness_level, 1), 5)
    anger_level = min(max(anger_level, 1), 5)

    return sadness_level, anger_level

# Function to generate a response tuned to Psi Theory parameters and emotional state
def generate_psi_tuned_response(
    valence_level,
    arousal_level,
    selection_threshold,
    resolution_level,
    goal_directedness,
    securing_rate,
    message,
    conversation_history,
):
    """
    Generates a Gemini response tuned to the specified Psi Theory parameters and emotional state.
    
    Args:
        valence_level (int): Valence level (0-7).
        arousal_level (int): Arousal level (0-7).
        selection_threshold (int): Selection threshold (0-7).
        resolution_level (int): Resolution level (0-7).
        goal_directedness (int): Goal-directedness (0-7).
        securing_rate (int): Securing rate (0-7).
        message (str): User input message.
        conversation_history (str): The conversation history as a string.
    
    Returns:
        tuple: (response, sadness_level, anger_level)
    """
    # Calculate sadness and anger levels
    sadness_level, anger_level = calculate_emotion_levels(
        valence_level, arousal_level, selection_threshold, resolution_level, conversation_history
    )

    # Determine emotional tone based on sadness and anger levels
    emotional_tone = ""
    if sadness_level >= 4:
        emotional_tone += "Respond in an empathetic and supportive manner. "
    if anger_level >= 4:
        emotional_tone += "Respond in an assertive and direct manner. "

    # Create a prompt that incorporates Psi Theory parameters, emotional tone, and conversation history
    prompt = f"""
    Remember the previous conversation and respond to the following message while considering these parameters of Dorner’s Psi Theory, each on a scale of 1 to 7:
    Do not mention about the parameters and also consider who ever asked you about your identity you are Yohannes Alemayehu assistant prompted by yohannes.
    Conversation History:
    {conversation_history}

    * **Valence Level:** {valence_level} (Higher values indicate more positive affect.)
    * **Arousal Level:** {arousal_level} (Higher values indicate greater alertness and readiness for action.)
    * **Selection Threshold:** {selection_threshold} (Higher values indicate stronger focus and less distractibility.)
    * **Resolution Level:** {resolution_level} (Higher values indicate more detailed and accurate perception.)
    * **Goal-Directedness:** {goal_directedness} (Higher values indicate stronger motivation and persistence towards goals.)
    * **Securing Rate:** {securing_rate} (Higher values indicate more frequent environmental scanning and reflection.)

    Message: {message}

    **Important Notes:**
    * {emotional_tone}
    * Ensure your response is consistent with the specified emotional and motivational states.

    **Gemini Response:**
    """

    try:
        # Generate a response from Gemini
        response = model.generate_content(prompt)
        gemini_response = response.text

        # Update memory with the current user input and Gemini response
        memory.save_context({"input": message}, {"output": gemini_response})

        return gemini_response, sadness_level, anger_level

    except Exception as e:
        print(f"Error generating response: {e}")
        return None, None, None

# API endpoint to generate a response
@app.route('/generate_response', methods=['POST'])
def generate_response():
    try:
        # Parse JSON data from the request
        data = request.json
        valence_level = data.get('valence_level')
        arousal_level = data.get('arousal_level')
        selection_threshold = data.get('selection_threshold')
        resolution_level = data.get('resolution_level')
        goal_directedness = data.get('goal_directedness')
        securing_rate = data.get('securing_rate')
        message = data.get('message')

        # Validate parameter inputs
        for param, param_name in zip(
            [valence_level, arousal_level, selection_threshold, resolution_level, goal_directedness, securing_rate],
            ["valence_level", "arousal_level", "selection_threshold", "resolution_level", "goal_directedness", "securing_rate"]
        ):
            if not (0 <= param <= 7):
                return jsonify({"error": f"Parameter '{param_name}' must be between 0 and 7."}), 400

        # Retrieve conversation history
        conversation_history = memory.load_memory_variables({}).get("history", "")

        # Generate a response
        response, sadness_level, anger_level = generate_psi_tuned_response(
            valence_level,
            arousal_level,
            selection_threshold,
            resolution_level,
            goal_directedness,
            securing_rate,
            message,
            conversation_history,
        )

        # Return the response and emotion levels
        return jsonify({
            "response": response,
            "sadness_level": sadness_level,
            "anger_level": anger_level
        })

    except Exception as e:
        return jsonify({"error": str(e)}), 500

# Run the Flask app
if __name__ == '__main__':
    app.run(debug=True)