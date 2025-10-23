# Qualife - Comprehensive Wellness Tracking Application

<p align="center">
  <img src="health_app_fyp/assets/LOGO1.png" alt="Qualife Logo" width="200"/>
</p>


<p align="center">
  <strong>A cross-platform wellness companion that empowers users to track, analyze, and improve their quality of life through data-driven insights.</strong>
</p>

<p align="center">
  <a href="https://flutter.dev"><img src="https://img.shields.io/badge/Flutter-3.16+-blue?logo=flutter&logoColor=white" alt="Flutter"/></a>
  <a href="https://firebase.google.com"><img src="https://img.shields.io/badge/Firebase-Firestore%20%26%20Auth-orange?logo=firebase&logoColor=white" alt="Firebase"/></a>
  <img src="https://img.shields.io/badge/Platforms-Android%20|%20iOS%20|%20Web%20|%20macOS-success" alt="Platforms"/>
  <img src="https://img.shields.io/badge/Dart-3.0+-0175C2?logo=dart" alt="Dart"/>
</p>

---

## 📋 Table of Contents
- [Overview](#overview)
- [Key Features](#key-features)
- [Screenshots](#screenshots)
- [Technical Architecture](#technical-architecture)
- [Tech Stack](#tech-stack)
- [Core Functionality](#core-functionality)
- [Data Flow & Privacy](#data-flow--privacy)
- [Installation](#installation)
- [Project Highlights](#project-highlights)
- [Future Enhancements](#future-enhancements)

---

## 🎯 Overview

**Qualife** is a comprehensive wellness tracking application developed as a Final Year Project, designed to help users monitor and improve their overall quality of life through holistic health tracking. The application combines modern UI/UX design principles with robust data analytics to provide users with actionable insights into their sleep patterns, mood trends, nutritional intake, and physical health metrics.

### Problem Statement
Many individuals struggle to maintain awareness of their overall wellness due to fragmented tracking tools and lack of integrated data visualization. Qualife addresses this by providing a unified platform that consolidates multiple health metrics into a single, intuitive interface.

### Solution
A cross-platform mobile and web application that:
- **Tracks** daily wellness metrics (sleep, mood, nutrition, weight, BMI)
- **Analyzes** historical data with interactive charts and visualizations
- **Provides** personalized insights based on user patterns
- **Secures** sensitive health data with Firebase Authentication and Cloud Firestore
- **Delivers** a consistent experience across Android, iOS, Web, and macOS platforms

---

## ✨ Key Features

### 1. **Multi-Metric Health Tracking**
- **Sleep Monitoring**: Log bedtime/wake time with date selection and duration calculation
- **Mood Tracking**: Daily emotional state logging with visual mood icons and activity tagging
- **Nutrition Tracking**: Calorie lookup and food logging via OpenFoodFacts API integration
- **Weight & BMI Tracking**: Body metrics tracking with historical trend analysis
- **Daily Check-In**: Quick wellness surveys for streamlined data entry

### 2. **Advanced Data Visualization**
- **Interactive Charts**: Zoomable, pannable charts using Syncfusion Flutter Charts
- **Trend Analysis**: Visualize patterns across days, weeks, and months
- **BMI Graphs**: Track body mass index changes over time
- **Mood Pie Charts**: Analyze emotional distribution and activity correlations
- **Weight Graphs**: Monitor weight fluctuations with customizable date ranges

### 3. **Smart Calculations**
- **BMR Calculator**: Basal Metabolic Rate estimation based on age, gender, height, weight
- **BMI Calculator**: Real-time body mass index calculation with health category indicators
- **Calorie Tracking**: Automated daily calorie summation from logged foods

### 4. **Modern UI/UX Design**
- **Glassmorphic** Navigation: Beautiful frosted-glass effect bottom navigation
- **Neumorphic Cards**: Soft UI design language for card components
- **Gradient Backgrounds**: Eye-catching gradient color schemes throughout the app
- **Responsive Design**: Adaptive layouts for phones, tablets, and desktop platforms
- **Dark Theme Support**: Cohesive dark mode implementation

### 5. **Secure Authentication & Data Management**
- **Firebase Authentication**: Email/password authentication with secure session management
- **Cloud Firestore**: Real-time NoSQL database for health data storage
- **User Data Isolation**: Firestore security rules ensure users can only access their own data
- **Offline Support**: Local caching for improved performance and offline access

---

## 📸 Screenshots

> **📝 Note:** Screenshots will appear here once you complete the manual screenshot process.  
> Follow the instructions in [`health_app_fyp/MANUAL_SCREENSHOT_GUIDE.md`](health_app_fyp/MANUAL_SCREENSHOT_GUIDE.md) or run `./health_app_fyp/take_screenshots_manually.sh` to capture them.

### Authentication & Onboarding
<table>
  <tr>
    <td align="center">
      <img src="health_app_fyp/screenshots/1_login_screen.png" width="250" alt="Login Screen"/><br/>
      <sub><b>Login Screen</b></sub><br/>
      <sub>Secure authentication with Firebase</sub>
    </td>
    <td align="center">
      <img src="health_app_fyp/screenshots/2_home_dashboard.png" width="250" alt="Home Dashboard"/><br/>
      <sub><b>Home Dashboard</b></sub><br/>
      <sub>Central hub for all wellness features</sub>
    </td>
  </tr>
</table>

### Health Tracking
<table>
  <tr>
    <td align="center">
      <img src="health_app_fyp/screenshots/3_bmi_calculator.png" width="250" alt="BMI Calculator"/><br/>
      <sub><b>BMI Calculator</b></sub><br/>
      <sub>Interactive BMI calculation with gender/age/height/weight inputs</sub>
    </td>
    <td align="center">
      <img src="health_app_fyp/screenshots/4_daily_checkin.png" width="250" alt="Daily Check-In"/><br/>
      <sub><b>Daily Check-In</b></sub><br/>
      <sub>Quick wellness survey for daily metrics</sub>
    </td>
    <td align="center">
      <img src="health_app_fyp/screenshots/5_mood_tracker.png" width="250" alt="Mood Tracker"/><br/>
      <sub><b>Mood Tracker</b></sub><br/>
      <sub>Emotional state logging with activity tagging</sub>
    </td>
  </tr>
</table>

### Nutrition & Analytics
<table>
  <tr>
    <td align="center">
      <img src="health_app_fyp/screenshots/6_food_tracker.png" width="250" alt="Food Tracker"/><br/>
      <sub><b>Food Tracker</b></sub><br/>
      <sub>Calorie lookup via OpenFoodFacts API</sub>
    </td>
    <td align="center">
      <img src="health_app_fyp/screenshots/7_analytics_dashboard.png" width="250" alt="Analytics Dashboard"/><br/>
      <sub><b>Analytics Dashboard</b></sub><br/>
      <sub>Comprehensive data visualization hub</sub>
    </td>
  </tr>
</table>

### Data Visualization
<table>
  <tr>x
    <td align="center">
      <img src="health_app_fyp/screenshots/8_bmi_graph.png" width="250" alt="BMI Graph"/><br/>
      <sub><b>BMI Trends</b></sub><br/>
      <sub>Interactive BMI graph with date filtering</sub>
    </td>
    <td align="center">
      <img src="health_app_fyp/screenshots/9_mood_pie_chart.png" width="250" alt="Mood Pie Chart"/><br/>
      <sub><b>Mood Distribution</b></sub><br/>
      <sub>Pie chart showing mood patterns</sub>
    </td>
  </tr>
</table>

---

## 🏗️ Technical Architecture

### Architecture Overview
```
┌─────────────────────────────────────────────────────────┐
│                    Presentation Layer                    │
│  (Flutter Widgets, GetX State Management, App Theme)   │
└─────────────────┬───────────────────────────────────────┘
                  │
┌─────────────────▼───────────────────────────────────────┐
│                     Business Logic                       │
│     (Controllers, Services, Data Models, Helpers)       │
└─────────────────┬───────────────────────────────────────┘
                  │
┌─────────────────▼───────────────────────────────────────┐
│                      Data Layer                          │
│   Firebase Auth │ Cloud Firestore │ OpenFoodFacts API  │
└──────────────────────────────────────────────────────────┘
```

### Key Architectural Decisions
1. **State Management**: GetX for reactive state management and dependency injection
2. **Navigation**: GetX routing with named routes for deep linking support
3. **Theme Management**: Centralized `AppTheme` class for consistent styling
4. **Data Models**: Immutable model classes with `toMap()` and `fromMap()` serialization
5. **Error Handling**: Try-catch blocks with user-friendly error messages
6. **Code Organization**: Feature-based folder structure for scalability

---

## 🛠️ Tech Stack

### Frontend
- **Flutter 3.16+**: Cross-platform UI framework
- **Dart 3.0+**: Modern, type-safe programming language
- **GetX**: State management, dependency injection, and routing
- **Syncfusion Flutter Charts**: Professional charting library for data visualization

### Backend & Services
- **Firebase Authentication**: User authentication and session management
- **Cloud Firestore**: NoSQL database for real-time data storage
- **Firebase Security Rules**: Server-side data access control
- **OpenFoodFacts API**: Nutrition database integration for food lookup

### Analytics & Monitoring
- **Datadog Flutter Plugin**: Application performance monitoring and RUM (Real User Monitoring)
- **Firebase Analytics**: User behavior tracking and insights

### Additional Libraries
- **fl_chart**: Additional charting capabilities
- **shared_preferences**: Local data persistence
- **intl**: Internationalization and date formatting
- **http**: API communication
- **sqflite**: Local SQLite database (optional offline storage)

### Development Tools
- **Android Studio / VS Code**: Primary IDEs
- **Flutter DevTools**: Performance profiling and debugging
- **Git**: Version control
- **Firebase Console**: Backend management

---

## ⚙️ Core Functionality

### 1. User Authentication Flow
```dart
User opens app → Splash Screen → Check auth state
  ├─ Logged in → Navigate to Home Dashboard
  └─ Not logged in → Navigate to Login Screen
       ├─ Login with email/password → Verify credentials → Home Dashboard
       └─ First time? → Register account → Initial onboarding
```

### 2. Data Entry & Storage
- **Sleep Entry**: User selects bed/wake times → Calculate duration → Store in Firestore (`/users/{uid}/sleep`)
- **Mood Entry**: User selects mood + activities → Tag with timestamp → Store in Firestore (`/users/{uid}/moods`)
- **Food Entry**: User searches OpenFoodFacts → Select food → Log calories → Store in Firestore (`/users/{uid}/foods`)
- **Weight Entry**: User inputs weight → Calculate BMI → Store in Firestore (`/users/{uid}/weights`)

### 3. Data Retrieval & Visualization
1. **Query Firestore** for user's historical data (filtered by date range)
2. **Transform data** into chart-compatible format
3. **Render charts** using Syncfusion/fl_chart
4. **Enable interactions** (zoom, pan, date filtering)

### 4. BMR/BMI Calculations
- **BMI Formula**: `weight(kg) / (height(m))²`
- **BMR Formula (Mifflin-St Jeor)**:
  - Men: `10 × weight(kg) + 6.25 × height(cm) - 5 × age + 5`
  - Women: `10 × weight(kg) + 6.25 × height(cm) - 5 × age - 161`

---

## 🔒 Data Flow & Privacy

### Security Measures
1. **Firebase Authentication**: Secure email/password authentication with hashed credentials
2. **Firestore Security Rules**: User-scoped data access
   ```javascript
   match /users/{userId} {
     allow read, write: if request.auth != null && request.auth.uid == userId;
   }
   ```
3. **HTTPS Encryption**: All API calls use HTTPS for data in transit
4. **Local Storage**: Sensitive tokens stored securely using Flutter Secure Storage

### Data Privacy
- **User Data Ownership**: Users have full control over their data
- **Data Deletion**: Users can delete their account and all associated data
- **No Third-Party Sharing**: Health data is never shared with external parties
- **GDPR Compliant**: Data handling follows privacy best practices

---

## 📦 Installation

### Prerequisites
- Flutter SDK 3.16 or higher
- Dart SDK 3.0 or higher
- Android Studio / Xcode (for mobile builds)
- Firebase project with Authentication and Firestore enabled

### Setup Instructions

1. **Clone the repository**
   ```bash
   git clone https://github.com/c-mongan/Qualife.git
   cd Qualife/health_app_fyp
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Configure Firebase**
   - Create a Firebase project at [console.firebase.google.com](https://console.firebase.google.com)
   - Enable Firebase Authentication (Email/Password provider)
   - Enable Cloud Firestore database
   - Download `google-services.json` (Android) and `GoogleService-Info.plist` (iOS)
   - Place configuration files in appropriate directories:
     - Android: `android/app/google-services.json`
     - iOS: `ios/Runner/GoogleService-Info.plist`
   - Run FlutterFire CLI to generate `firebase_options.dart`:
     ```bash
     flutterfire configure
     ```

4. **Run the app**
   ```bash
   # Android/iOS
   flutter run

   # Web
   flutter run -d chrome

   # macOS
   flutter run -d macos
   ```

5. **Build for production**
   ```bash
   # Android APK
   flutter build apk --release

   # iOS (requires macOS + Xcode)
   flutter build ios --release

   # Web
   flutter build web

   # macOS
   flutter build macos
   ```

---

## 🏆 Project Highlights

### Technical Achievements
- ✅ **Cross-Platform**: Single codebase runs on 4 platforms (Android, iOS, Web, macOS)
- ✅ **Modern UI**: Implements glassmorphism, neumorphism, and gradient design trends
- ✅ **Real-Time Data**: Cloud Firestore integration for live data synchronization
- ✅ **API Integration**: Successfully integrated OpenFoodFacts API for nutrition data
- ✅ **Data Visualization**: Advanced charting with zoom, pan, and date filtering
- ✅ **State Management**: GetX for reactive, scalable state handling
- ✅ **Security**: Firebase Authentication + Firestore security rules
- ✅ **Code Quality**: Modular architecture with clear separation of concerns
- ✅ **Performance**: Optimized queries and local caching for smooth UX

### Design Highlights
- 🎨 **Cohesive Theme**: Centralized `AppTheme` class ensures design consistency
- 🎨 **Custom Components**: Reusable widgets (ModernCard, NeumorphicButton, HeaderSection)
- 🎨 **Responsive Layouts**: Adapts to different screen sizes and orientations
- 🎨 **Visual Feedback**: Loading states, error messages, and success notifications
- 🎨 **Accessibility**: High contrast ratios and readable font sizes

### Learning Outcomes
- Mastered Flutter framework and Dart language
- Implemented Firebase backend services (Auth, Firestore)
- Learned API integration patterns
- Applied state management principles
- Developed cross-platform mobile/web applications
- Practiced Git version control and agile development

---

## 🚀 Future Enhancements

### Planned Features
- [ ] **Social Features**: Share achievements and compete with friends
- [ ] **AI Insights**: Machine learning-based wellness recommendations
- [ ] **Wearable Integration**: Sync with Fitbit, Apple Health, Google Fit
- [ ] **Reminders & Notifications**: Push notifications for daily check-ins
- [ ] **Export Data**: CSV/PDF export for personal records
- [ ] **Multi-Language Support**: Internationalization (i18n)
- [ ] **Dark/Light Theme Toggle**: User-selectable color schemes
- [ ] **Water Intake Tracking**: Hydration monitoring
- [ ] **Medication Reminders**: Prescription tracking and alerts
- [ ] **Doctor Sharing**: Securely share health data with healthcare providers

### Technical Improvements
- [ ] **Unit & Integration Tests**: Comprehensive test coverage
- [ ] **CI/CD Pipeline**: Automated builds and deployments
- [ ] **Offline Mode**: Full offline functionality with sync
- [ ] **Performance Optimization**: Lazy loading and pagination
- [ ] **Accessibility**: Screen reader support and WCAG compliance
- [ ] **Analytics Dashboard**: Admin panel for usage insights

---

## 👨‍💻 Developer

**Conor Mongan**  
[GitHub](https://github.com/c-mongan) | [Email](mailto:monganconor1@gmail.com)

---



## 🙏 Acknowledgments

- **Flutter Team**: For the amazing cross-platform framework
- **Firebase Team**: For robust backend services
- **OpenFoodFacts**: For open-source nutrition data
- **Syncfusion**: For professional Flutter chart components
- **GetX Community**: For excellent state management library

---

<p align="center">
  <sub>Built with ❤️ using Flutter</sub>
</p>
