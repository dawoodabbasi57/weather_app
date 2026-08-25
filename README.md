# 🌦️ Live Weather App

A modern and responsive **Flutter Weather Application** that provides real-time weather information based on the user's location or searched city. The application displays current weather conditions, humidity, wind speed, and a 5-day weather forecast with a dynamic background that changes according to the current weather conditions.

---

## 📱 Screenshots

The application provides a clean and modern user interface with dynamically changing backgrounds based on weather conditions.

| Sunny / Clear Weather     | Cloudy / Rainy Weather    |
| ------------------------- | ------------------------- |
| ☀️ Warm orange background | ☁️ Dark cloudy background |

---

## ✨ Features

### 🌍 Live Weather Information

Get real-time weather information for any searched location.

The app displays:

* Current temperature
* Weather condition
* City or location name
* Humidity percentage
* Wind speed
* 5-day weather forecast

---

### 📍 Live GPS Location

The application uses **GPS technology** to detect the user's current location and fetch weather information automatically.

Users can quickly check the current weather without manually entering their location.

---

### 🔎 City Search

Users can search for weather information by entering the name of a city or location.

For example:

```text
Islamabad
Lahore
Karachi
London
New York
```

---

### 🌡️ Real-Time Temperature

The application displays the current temperature in **Celsius (°C)**.

Example:

```text
35.1 °C
```

---

### 💧 Humidity Information

Users can view the current humidity percentage of the selected location.

Example:

```text
Humidity: 57%
```

---

### 💨 Live Wind Speed

The app provides live wind speed information for the selected location.

Example:

```text
Wind Speed: 1.77 m/s
```

---

### 📅 5-Day Weather Forecast

The application provides a weather forecast for the upcoming **5 days**.

Each forecast card displays:

* Date
* Expected temperature
* Weather condition

Example:

```text
2026-08-25
35 °C
Clear
```

---

### 🎨 Dynamic Weather Background

One of the main features of this application is its **dynamic background color system**.

The background automatically changes according to the current weather conditions.

Examples:

| Weather Condition | Background Style |
| ----------------- | ---------------- |
| ☀️ Clear / Sunny  | Warm Orange      |
| ☁️ Cloudy         | Dark Grey / Blue |
| 🌧️ Rainy         | Cool Dark Theme  |
| 🌫️ Mist / Fog    | Soft Grey        |
| ❄️ Snow           | Light Cool Theme |

This creates a more interactive and visually appealing user experience.

---

### 📱 Responsive User Interface

The application is designed with a clean and user-friendly interface that works smoothly on Android devices.

Key UI elements include:

* Modern weather dashboard
* Search bar
* GPS location button
* Large temperature display
* Weather condition display
* Humidity card
* Wind speed card
* Horizontally scrollable 5-day forecast

---

## 🛠️ Technologies Used

This project is developed using:

* **Flutter**
* **Dart**
* **Weather API**
* **GPS / Location Services**
* **REST API**
* **Geolocation**

---

## 📂 Project Structure

```text
lib/
│
├── main.dart
│
├── models/
│   └── weather_model.dart
│
├── services/
│   ├── weather_service.dart
│   └── location_service.dart
│
├── screens/
│   └── weather_screen.dart
│
├── widgets/
│   ├── weather_card.dart
│   ├── forecast_card.dart
│   └── search_bar.dart
│
└── utils/
    └── weather_background.dart
```

---

## 🚀 How to Run the Project

### 1. Clone the Repository

```bash
git clone YOUR_REPOSITORY_URL
```

### 2. Open the Project

```bash
cd live_weather_app
```

### 3. Install Dependencies

```bash
flutter pub get
```

### 4. Run the Application

```bash
flutter run
```

---

## 📋 Requirements

Make sure you have the following installed:

* Flutter SDK
* Dart SDK
* Android Studio or VS Code
* Android Emulator or Physical Android Device

You may also need to configure:

* Weather API Key
* Internet Permission
* Location Permission

---

## 🔐 Required Permissions

The application may require the following permissions:

```xml
<uses-permission android:name="android.permission.INTERNET"/>

<uses-permission android:name="android.permission.ACCESS_FINE_LOCATION"/>

<uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION"/>
```

---

## 🎯 Future Improvements

The following features can be added in future versions:

* 🌙 Dark mode
* ⭐ Save favorite cities
* 🔔 Severe weather alerts
* 🗺️ Weather map
* 📊 Hourly weather forecast
* 🌅 Sunrise and sunset information
* 🌧️ Rain probability
* 🧭 Wind direction
* 🔄 Pull to refresh weather data

---

## 📸 Application Preview

The application interface includes:

* **Live Weather App header**
* **GPS Location Button**
* **City Search**
* **Current City Name**
* **Live Temperature**
* **Current Weather Condition**
* **Humidity**
* **Live Wind Speed**
* **5-Day Forecast**
* **Dynamic Background Based on Weather**

---

## 👨‍💻 Developer

Developed with ❤️ using **Flutter & Dart**.

### Project: Live Weather App

A simple, modern, and interactive weather application that helps users check **real-time weather information, live location weather, humidity, wind speed, and a 5-day forecast** with a beautiful dynamic interface.

---

## ⭐ Support

If you like this project, consider giving the repository a **star ⭐** on GitHub!

---

**Made with ❤️ using Flutter**
