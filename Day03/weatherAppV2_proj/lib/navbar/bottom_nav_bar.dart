import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:geolocator/geolocator.dart';
import 'package:weatherappv2_proj/model/location_model.dart';
import 'package:weatherappv2_proj/navbar/tabs/currently_tab.dart';
import 'package:weatherappv2_proj/navbar/tabs/today_tab.dart';
import 'package:weatherappv2_proj/navbar/tabs/weekly_tab.dart';
import 'package:weatherappv2_proj/services/city_service.dart';
import 'package:weatherappv2_proj/services/location_service.dart';

class BottonNavBar extends StatefulWidget {
  const BottonNavBar({super.key});

  @override
  _BottonNavBarState createState() => _BottonNavBarState();
}

class _BottonNavBarState extends State<BottonNavBar>
    with SingleTickerProviderStateMixin {
  final TextEditingController _searchController = TextEditingController();
  late TabController _tabController;
  List<LocationModel> _citySuggestions = [];
  final FocusNode _focusNode = FocusNode();
  LocationModel? location;
  bool focus = false;
  bool isPermissionGranted = false;
  bool displayError = false;
  bool notFoundLocation = false;

  final LocationService _locationService = LocationService();

  Future<void> _getCurrentLocation() async {
    if (isPermissionGranted) {
      Position? currentPosition = await _locationService.getCurrentLocation();
      setCurrentLocation(LocationModel(
        latitude: currentPosition.latitude,
        longitude: currentPosition.longitude,
        name: 'São Paulo',
        admin1: 'São Paulo',
        country: 'Brazil',
      ));
    } else {
      setState(() {
        notFoundLocation = false;
        displayError = true;
      });
    }
  }

  Future<void> _getUserPermission() async {
    try {
      isPermissionGranted = await _locationService.requestPermission();
      await _getCurrentLocation();
    } catch (e) {
      print('error $e');
    }
  }

  Future<List<LocationModel>> _fetchCitySuggestions(String query) async {
    return await CityService.fetchCitySuggestions(query);
  }

  @override
  void initState() {
    super.initState();
    _getUserPermission();
    _focusNode.addListener(() {
      if (_focusNode.hasFocus) {
        setState(() {
          focus = true;
        });
      } else {
        setState(() {
          focus = false;
        });
      }
    });
    _tabController = TabController(length: 3, vsync: this);
  }

  void _showAlertDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: const Text('City name that does not exist'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  Widget listViewCities(BuildContext context) {
    return TypeAheadField(
      animationStart: 0,
      animationDuration: Duration.zero,
      textFieldConfiguration: TextFieldConfiguration(
          autofocus: true,
          style: const TextStyle(fontSize: 15, color: Colors.white),
          decoration: const InputDecoration(
            hintText: 'Search location',
            labelText: 'Search location',
            labelStyle: TextStyle(color: Colors.white)
          ),
          controller: _searchController,
          onSubmitted: (String text) {
            if (_citySuggestions.isEmpty) {
              setState(() {
                notFoundLocation = true;
              });
            } else {
              _searchController.text = _citySuggestions[0].toListFormat();
              // _searchController.text = _citySuggestions[0].name!;
              setCurrentLocation(_citySuggestions[0]);
            }
          }),
      suggestionsBoxDecoration:
          const SuggestionsBoxDecoration(color: Colors.white),
      suggestionsCallback: (pattern) async {
        if (pattern.isNotEmpty) {
          _citySuggestions = await _fetchCitySuggestions(pattern);
        } else {
          _citySuggestions = [];
        }

        return _citySuggestions;
      },
      itemBuilder: (context, location) {
        return Container(
          decoration: BoxDecoration(
            border: Border.all(
              color: Colors.grey,
              width: 1.0,
            ),
          ),
          padding: const EdgeInsets.all(10),
          child: Text.rich(
            TextSpan(
              children: [
                const WidgetSpan(
                  child: Padding(
                    padding: EdgeInsets.only(right: 10),
                    child: Icon(
                      Icons.location_city,
                      color: Colors.black,
                    ),
                  ),
                ),
                TextSpan(
                  text: location.name ?? 'N/A',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                TextSpan(text: ' ${location.admin1 ?? 'N/A'}'),
                TextSpan(text: ', ${location.country ?? 'N/A'}'),
              ],
            ),
          ),
        );
      },
      onSuggestionSelected: (LocationModel location) {
        _searchController.text = location.toListFormat();
        setCurrentLocation(location);
      },
    );
  }

  Future<void> setCurrentLocation(LocationModel? suggestion) async {
    if (suggestion != null) {
      suggestion = await _locationService.getLocationInfo(suggestion);
      setState(() {
        location = suggestion;
        displayError = false;
      });
      setState(() {
        notFoundLocation = false;
      });
    } else {
      setState(() {
        displayError = true;
      });
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var children2 = [
      if (notFoundLocation)
        errorMsg(
            'An issue occurred while processing your request. Check the city you entered and the connection, then try again.'),
      if (location == null && !displayError && !notFoundLocation)
        emptyMsg()
      else if (!displayError && !notFoundLocation)
        CurrentlyTab(location: location)
      else if (!notFoundLocation)
        errorMsg(
            'Geolocation is not available, please enable in your App setting'),
      if (notFoundLocation)
        errorMsg(
            'An issue occurred while processing your request. Check the city you entered and the connection, then try again.'),
      if (location == null && !displayError && !notFoundLocation)
        emptyMsg()
      else if (!displayError && !notFoundLocation)
        TodayTab(location: location)
      else if (!notFoundLocation)
        errorMsg(
            'Geolocation is not available, please enable in your App setting'),
      if (notFoundLocation)
        errorMsg(
            'An issue occurred while processing your request. Check the city you entered and the connection, then try again.'),
      if (location == null && !displayError)
        emptyMsg()
      else if (!displayError && !notFoundLocation)
        WeeklyTab(location: location)
      else if (!notFoundLocation)
        errorMsg(
            'Geolocation is not available, please enable in your App setting'),
    ];
    return Scaffold(
      appBar: AppBar(
        leading: const Icon(
          Icons.search,
          color: Colors.white60,
        ),
        title: Padding(
          padding: const EdgeInsets.all(8.0),
          child: listViewCities(context),
        ),
        backgroundColor: Colors.grey[700],
        actions: [
          IconButton(
            icon: const Icon(Icons.location_pin),
            color: Colors.white,
            onPressed: () {
              _getCurrentLocation();
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          Opacity(
            opacity: 0.7,
            child: Image.asset(
              'assets/default_background.jpeg',
              fit: BoxFit.cover,
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
            ),
          ),
          TabBarView(
            controller: _tabController,
            children: children2,
          ),
        ],
      ),
      bottomNavigationBar: Container(
        color: Colors.grey[700],
        child: TabBar(
          dividerColor: Colors.black54,
          indicatorColor: Colors.black54,
          labelColor: Colors.black54,
          unselectedLabelColor: Colors.white60,
          unselectedLabelStyle: const TextStyle(
            color: Colors.white60,
          ),
          controller: _tabController,
          tabs: const [
            Tab(
              icon: Icon(Icons.access_time),
              text: 'Currently',
            ),
            Tab(icon: Icon(Icons.today), text: 'Today'),
            Tab(icon: Icon(Icons.calendar_today), text: 'Weekly'),
          ],
        ),
      ),
    );
  }

  Center errorMsg(String msg) {
    return Center(
      child: Text(
        msg,
        textAlign: TextAlign.center,
        style: const TextStyle(
          color: Colors.red,
          fontSize: 20,
        ),
      ),
    );
  }

  Center emptyMsg() {
    return const Center(
      child: Text(
        '...',
        textAlign: TextAlign.center,
        style: TextStyle(
          color: Colors.blue,
          fontSize: 20,
        ),
      ),
    );
  }
}
