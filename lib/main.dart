import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const WeatherApp());
}

class WeatherApp extends StatelessWidget {
  const WeatherApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      home: const WeatherScreen(),
    );
  }
}

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  // 🔑 Paste your OpenWeatherMap API Key here
  final String apiKey = "1327457b09f7db62fe512f6207b68536";

  String cityName = "Fetching Location...";
  final TextEditingController _cityController = TextEditingController();

  double? temp;
  int? humidity;
  double? windSpeed;
  String description = "";
  bool isLoading = true;
  String errorMessage = "";
  List<dynamic> forecastList = [];

  @override
  void initState() {
    super.initState();
    _getCurrentLocationAndWeather();
  }

  // Dynamic background colors based on weather condition
  List<Color> _getThemeColors() {
    String mainCondition = description.toLowerCase();

    if (mainCondition.contains('rain') || mainCondition.contains('drizzle')) {
      return [Colors.blueGrey.shade900, Colors.blueGrey.shade600];
    } else if (mainCondition.contains('cloud')) {
      return [Colors.blueGrey.shade800, Colors.grey.shade700];
    } else if (mainCondition.contains('clear') || mainCondition.contains('sun')) {
      return [Colors.orange.shade800, Colors.deepOrange.shade400];
    } else if (mainCondition.contains('snow')) {
      return [Colors.lightBlue.shade300, Colors.blue.shade600];
    } else if (mainCondition.contains('thunderstorm')) {
      return [Colors.deepPurple.shade900, Colors.indigo.shade700];
    }

    return [const Color(0xFF1F1C2C), const Color(0xFF928DAB)];
  }

  // Get current GPS location
  Future<void> _getCurrentLocationAndWeather() async {
    setState(() {
      isLoading = true;
      errorMessage = "";
    });

    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        setState(() {
          errorMessage = "Please enable GPS/Location Services on your device.";
          isLoading = false;
        });
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          setState(() {
            errorMessage = "Location permission denied.";
            isLoading = false;
          });
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        setState(() {
          errorMessage = "Location permission is permanently denied. Allow from Settings.";
          isLoading = false;
        });
        return;
      }

      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      await fetchWeatherByCoordinates(position.latitude, position.longitude);
    } catch (e) {
      setState(() {
        errorMessage = "Error getting location: $e";
        isLoading = false;
      });
    }
  }

  // Fetch weather using coordinates
  Future<void> fetchWeatherByCoordinates(double lat, double lon) async {
    final url = Uri.parse(
        'https://api.openweathermap.org/data/2.5/weather?lat=$lat&lon=$lon&units=metric&appid=$apiKey');
    await _getWeatherData(url);
  }

  // Fetch weather using city name
  Future<void> fetchWeatherByCity(String city) async {
    setState(() {
      isLoading = true;
      errorMessage = "";
    });
    final url = Uri.parse(
        'https://api.openweathermap.org/data/2.5/weather?q=$city&units=metric&appid=$apiKey');
    await _getWeatherData(url);
  }

  // Fetch 5-Day Forecast
  Future<void> fetch5DayForecast(String city) async {
    final url = Uri.parse(
        'https://api.openweathermap.org/data/2.5/forecast?q=$city&units=metric&appid=$apiKey');

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          forecastList = (data['list'] as List)
              .where((item) => item['dt_txt'].contains('12:00:00'))
              .toList();
        });
      }
    } catch (e) {
      debugPrint("Error fetching forecast: $e");
    }
  }

  // Parse Weather Data
  Future<void> _getWeatherData(Uri url) async {
    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          temp = data['main']['temp'].toDouble();
          humidity = data['main']['humidity'];
          windSpeed = data['wind']['speed'].toDouble();
          description = data['weather'][0]['description'];
          cityName = data['name'];
          isLoading = false;
        });
        fetch5DayForecast(cityName);
      } else {
        setState(() {
          errorMessage = "City not found or data unavailable.";
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = "Please check your internet connection.";
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text('Live Weather App'),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.my_location),
            onPressed: _getCurrentLocationAndWeather,
          )
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: _getThemeColors(),
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                // Search Input
                TextField(
                  controller: _cityController,
                  decoration: InputDecoration(
                    hintText: "Enter city name...",
                    filled: true,
                    fillColor: Colors.black26,
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.search),
                      onPressed: () {
                        if (_cityController.text.isNotEmpty) {
                          fetchWeatherByCity(_cityController.text);
                        }
                      },
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Main Content
                if (isLoading)
                  const Expanded(
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircularProgressIndicator(),
                          SizedBox(height: 15),
                          Text("Fetching location and weather data..."),
                        ],
                      ),
                    ),
                  )
                else if (errorMessage.isNotEmpty)
                  Expanded(
                    child: Center(
                      child: Text(
                        errorMessage,
                        textAlign: TextAlign.center,
                        style: const TextStyle(color: Colors.redAccent, fontSize: 18),
                      ),
                    ),
                  )
                else ...[
                    Text(
                      cityName,
                      style: const TextStyle(
                          fontSize: 32, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      "${temp?.toStringAsFixed(1)} °C",
                      style: const TextStyle(
                          fontSize: 50, fontWeight: FontWeight.w300),
                    ),
                    Text(
                      description.toUpperCase(),
                      style: const TextStyle(fontSize: 16, color: Colors.white70),
                    ),
                    const SizedBox(height: 20),

                    // Cards Row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildInfoCard("Humidity", "$humidity%", Icons.water_drop),
                        _buildInfoCard("Wind Speed", "$windSpeed m/s", Icons.air),
                      ],
                    ),

                    const SizedBox(height: 20),
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "5-Day Forecast",
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(height: 10),

                    // Forecast Horizontal List
                    SizedBox(
                      height: 110,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: forecastList.length,
                        itemBuilder: (context, index) {
                          final item = forecastList[index];
                          final date = item['dt_txt'].split(' ')[0];
                          final forecastTemp = item['main']['temp'].toStringAsFixed(0);
                          final forecastDesc = item['weather'][0]['main'];

                          return Card(
                            color: Colors.white10,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15)),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16.0, vertical: 8.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(date, style: const TextStyle(fontSize: 12)),
                                  const SizedBox(height: 4),
                                  Text("$forecastTemp °C",
                                      style: const TextStyle(
                                          fontSize: 16, fontWeight: FontWeight.bold)),
                                  const SizedBox(height: 4),
                                  Text(forecastDesc,
                                      style: const TextStyle(
                                          fontSize: 12, color: Colors.white70)),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ]
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoCard(String title, String value, IconData icon) {
    return Card(
      color: Colors.white10,
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 15.0),
        child: Column(
          children: [
            Icon(icon, size: 30, color: Colors.lightBlueAccent),
            const SizedBox(height: 8),
            Text(title, style: const TextStyle(fontSize: 14, color: Colors.white70)),
            const SizedBox(height: 4),
            Text(
              value,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}