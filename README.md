# LearnTrack
Your AI-powered, all-in-one study companion.

Tired of going down rabbitholes of endless YouTube videos and random blog posts, just to learn something new? LearnTrack cuts through the chaos, giving you a clear path so you can **actually** finish what you start.

## What makes LearnTrack different?
- **Smart Learning Paths** - LearnTrack's AI-generated learning paths tell you exactly **what to study** and in **what order**. No more wondering "where do I start?" or getting lost in tutorial hell. Everything you need to know is provided in links directly in the app.
- **Built-In Pomodoro Timer** - We built the tried-and-true Pomodoro technique right in the app so you don't have to juggle multiple timers and lose your focus.
- **Simple Progress Tracking** - Mark what you learn each day and watch your streak grow. It's satisfying to see your consistency build up over time, and it actually helps you retain your knowledge.

Whether you're learning to code, studying for exams, or diving into a new unit, LearnTrack eliminates your distractions and helps you stick to your plan. 

Try it out and your future self will thank you.

## Curious about our tech-stack?
LearnTrack is in Flutter with Flask + GeminiAPI backend and MySQL database.

## Demo
https://github.com/user-attachments/assets/9076af96-a5db-4cb2-b2f4-d2d80d5a3f21

## Getting Started
A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

## Prerequisites

- Python 3.8 or higher
- Flutter SDK
- MySQL Server
- Git

## Setup

1. Navigate to the backend directory:
   ```bash
   cd backend
   ```

2. Create and activate a virtual environment:
   ```bash
   python -m venv venv
   source venv/bin/activate  # On Windows: venv\Scripts\activate
   ```

3. Install dependencies:
   ```bash
   pip install -r requirements.txt
   ```

4. Set up the database:
   - Create a MySQL database
   - Import the schema:
     ```bash
     mysql -u your_username -p your_database_name < schema.sql
     ```

5. Configure the application:
   - Update `config.py` with your database credentials and other settings

6. Run the Flask application:
   ```bash
   python app.py
   ```
   
The backend server will start on `http://localhost:5000`

7. Run the Flutter application:
   ```bash
   flutter run
   ```
