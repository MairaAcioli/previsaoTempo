import 'package:flutter/material.dart';
import 'package:weather_appv2_proj/model.dart';
import 'Geo/geolocator.dart';
import 'servicegeo.dart';


void main() {
  runApp(const MyApp());
} 

class MyApp extends StatelessWidget {
   const MyApp({super.key});


@override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Wheather App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.pink),
        useMaterial3: true,
      ),
      home: const WeatherNavigation(),
    );
  }
}

class WeatherNavigation extends StatefulWidget {
  const WeatherNavigation({super.key});

  @override
  State<WeatherNavigation> createState() =>
      _WeatherNavigationState();
}

class _WeatherNavigationState
    extends State<WeatherNavigation> {
  
  int selectedIndex = 0;
  String? textChange = "";
  String textSearch = "";
  final String currently = 'Currently';
  final String today = 'Today';
  final String weekly = 'Weekly';

  late Model model;
  bool _isLoading = false;

  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);

  void _onItemTapped(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  void _errorLocation() {
     setState(() {
      textChange = """
Geolocation is not available""";
    });
  }

  void _onLocationGot(String location) {
    setState(() {
      textChange = location;
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: 0,   

      length: 3,
          body: TabBarView(children: <Widget>[
            Center(
                child: Text("Currently\n$textChange"),
              ),
              Center(
                child: Text("Today\n$textChange"),
              ),
              Center(
                child: Text("Weekly\n$textChange"),
              ),
          ]
          ),
           bottomNavigationBar: TabBar(
              tabs: [
                Tab(
                  icon: const Icon(Icons.add_a_photo),
                  text: currently,
                ),
                Tab(
                  icon: const Icon(Icons.map),
                  text: today,
                ),
                Tab(
                  icon: const Icon(Icons.add_location),
                  text: weekly,    
          ),
        ],
        onTap: _onItemTapped,
           ),
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.pink,
            actions: [
              IconButton(
              icon: const Icon(Icons.near_me),
              color: Colors.white,
              onPressed: () {
                  GeolocatorPosition geolocatorPosition = GeolocatorPosition(onLocationGot: _onLocationGot, errorLocation: _errorLocation);
                  geolocatorPosition.getCurrentPosition();
              },
            ),
            ], 
            leading: 
              IconButton(
              icon: const Icon(Icons.search),
              color: Colors.white,
              onPressed: () {
                setState(() {
                  textChange = textSearch;
                });
              },
            ),
           
            title: Container(
          padding: const EdgeInsets.all(25),
          child: Column(
            children: [
              Row(
                children: [
                  Flexible(
                    flex: 1,
                    child: TextField(
                      cursorColor: Colors.grey,
                      onChanged: (value)  {
                  setState(()  {
                    textSearch = value;
                    model = model;
                    print(model);
                  });
                },
                onSubmitted: (value) {
                  setState(() {
                    textChange = value;
                    fetchData();
                  });
                },
                      decoration: InputDecoration(
                        fillColor: Colors.white,
                        filled: true,
                        
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide.none
                        ),
                        hintText: 'Search',
                        hintStyle: const TextStyle(
                          color: Colors.grey,
                          fontSize: 18
                        ),

                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
          ),
         ), 
          );  
   }

  Future<void> fetchData() async {
    // Chama a função assíncrona para buscar os dados
   setState(() {
      _isLoading = true;
    });

    Model model = await _fetchModel();

    setState(() {
      model = model;
      _isLoading = false;
    });
  }

  Future<Model> _fetchModel() async {
    // Implemente a função para buscar os dados]
    await Future.delayed(const Duration(seconds: 2));
    ServiceGeo serviceGeo = ServiceGeo(searchCity: textChange ?? "");
                    model = await serviceGeo.fetchModel();
                    return model;
  }
}


