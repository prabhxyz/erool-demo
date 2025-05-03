# Erool - TikTok-style Educational Platform

Erool is a social learning platform that delivers educational content in short, engaging snippets. It combines the addictive nature of short-form content with the benefits of micro-learning to create an engaging educational experience.

## Features

- **Short-Form Educational Content**: Bite-sized learning snippets (15-60 seconds)
- **Topic-Based Learning**: Follow specific academic subjects
- **Social Features**: Like, comment, and share content
- **Gamification**: Streaks, badges, and leaderboards
- **Personalized Feed**: ML-based recommendations
- **Creator Portal**: Verified educators can publish content
- **Ad-Supported**: Free access with optional premium features

## Technical Stack

### Backend
- Node.js with Express
- MongoDB for data storage
- JWT for authentication
- RESTful API

### Frontend
- Flutter for cross-platform development
- Provider for state management
- Google AdMob for monetization

## Project Structure

```
erool/
├── backend/              # Node.js backend
│   ├── src/
│   │   ├── models/      # Database models
│   │   ├── routes/      # API routes
│   │   └── middleware/  # Custom middleware
│   ├── package.json
│   └── Dockerfile
├── mobile_app/          # Flutter frontend
│   ├── lib/
│   │   ├── models/      # Data models
│   │   ├── providers/   # State management
│   │   ├── screens/     # UI screens
│   │   └── widgets/     # Reusable components
│   └── pubspec.yaml
└── scripts/             # Utility scripts
    ├── scrape_content.py
    └── requirements.txt
```

## Getting Started

### Backend Setup

1. Install dependencies:
   ```bash
   cd backend
   npm install
   ```

2. Create a `.env` file:
   ```
   PORT=5000
   MONGODB_URI=mongodb://localhost:27017/erool
   JWT_SECRET=your_secret_key
   ```

3. Start the server:
   ```bash
   npm run dev
   ```

### Frontend Setup

1. Install Flutter dependencies:
   ```bash
   cd mobile_app
   flutter pub get
   ```

2. Create a `.env` file:
   ```
   API_URL=http://localhost:5000
   ADMOB_APP_ID=your_admob_app_id
   ```

3. Run the app:
   ```bash
   flutter run
   ```

### Content Scraping

1. Install Python dependencies:
   ```bash
   cd scripts
   pip install -r requirements.txt
   ```

2. Run the scraper:
   ```bash
   python scrape_content.py
   ```

## Deployment

### Backend

1. Build the Docker image:
   ```bash
   docker-compose build
   ```

2. Start the services:
   ```bash
   docker-compose up -d
   ```

### Frontend

1. Build for Android:
   ```bash
   flutter build apk --release
   ```

2. Build for iOS:
   ```bash
   flutter build ios --release
   ```

3. Build for web:
   ```bash
   flutter build web --release
   ```

## Contributing

1. Fork the repository
2. Create a feature branch
3. Commit your changes
4. Push to the branch
5. Create a Pull Request

## License

This project is licensed under the MIT License - see the LICENSE file for details. 