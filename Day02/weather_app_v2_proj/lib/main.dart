import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:weather_app_v2_proj/geocoding_object.dart';

import 'forecast_object.dart';
import 'weather_code.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Weather App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
            seedColor: const Color.fromARGB(255, 138, 231, 216)),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Home'),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String textoVariavel = "";
  String textoSearch = "";
  bool temPermissaoGps = false;
  bool gpsHabilitado = false;
  late LocationPermission permissao;
  late Position posicao;
  double? longitude, latitude;
  List<Geocoding_Object> listaCidades = List.empty(); ////Geocoding_Object
  Geocoding_Object? cidadeSelecionada;
  Forecast_Object? climaAtual;
  Forecast_Object? climaToday;
  Forecast_Object? climaWeek;
  final erroGeolocalizacaoDesabilitada =
      "Geolocation is not available, please enable it in your App settings.";
  final erroLocalNaoEncontrado =
      "Could not find any result for the supplied address or coordinates.";
  final erroApiFora =
      "The service connection is lost, please check your internet connection or try again later.";

  @override
  void initState() {
    validarGps();
    super.initState();
  }

  validarGps() async {
    gpsHabilitado = await Geolocator.isLocationServiceEnabled();
    if (gpsHabilitado) {
      permissao = await Geolocator.checkPermission();

      if (permissao == LocationPermission.denied) {
        permissao = await Geolocator.requestPermission();
        if (permissao == LocationPermission.denied ||
            permissao == LocationPermission.deniedForever) {
          print('Location permissions are denied');
          setState(() {
            textoVariavel = erroGeolocalizacaoDesabilitada;
            cidadeSelecionada = null;
            listaCidades = List.empty();
          });
          // await seGpsDesligadoValidarSeFoiLigado();
        } else {
          temPermissaoGps = true;
        }
      } else {
        temPermissaoGps = true;
      }

      if (temPermissaoGps) {
        setState(() {
          //refresh the UI
        });
        await getLocalizacao();
      }
    } else {
      print("GPS Service is not enabled, turn on GPS location");
      setState(() {
        textoVariavel = erroGeolocalizacaoDesabilitada;
        cidadeSelecionada = null;
        listaCidades = List.empty();
      });
      // await seGpsDesligadoValidarSeFoiLigado();
    }

    setState(() {
      //refresh the UI
    });
  }

  getLocalizacao() async {
    posicao = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    setState(() {
      //refresh UI
      longitude = posicao.longitude;
      latitude = posicao.latitude;
    });

    LocationSettings locationSettings = const LocationSettings(
      accuracy: LocationAccuracy.high, //accuracy of the location data
      distanceFilter: 100, //minimum distance (measured in meters) a
      //device must move horizontally before an update event is generated;
    );

    Geolocator.getPositionStream(locationSettings: locationSettings)
        .listen((Position position) {
      print(position.longitude); //Output: 80.24599079
      print(position.latitude); //Output: 29.6593457

      setState(() {
        //refresh UI on update
        longitude = position.longitude;
        latitude = position.latitude;
      });
    });

    await setaClimaAtual(posicao.latitude, posicao.longitude);
    await buscaPelaPosicao(posicao.latitude, posicao.longitude);
  }

  // seGpsDesligadoValidarSeFoiLigado() async {
  //   if (!gpsHabilitado || !temPermissaoGps) {
  //     await validarGps();
  //     Timer.periodic(Duration(seconds: 2),
  //         (Timer t) => seGpsDesligadoValidarSeFoiLigado());
  //   }
  // }

  Future<List<Geocoding_Object>?> buscaCidadePeloNome(String nomeCidade) async {
    final response = await http.get(Uri.parse(
        'https://geocoding-api.open-meteo.com/v1/search?name=$nomeCidade'));
    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      var results = json.decode(response.body);
      var lista = results['results'];
      List<Geocoding_Object> listaObjeto = List.empty(growable: true);
      if (lista != null) {
        for (int i = 0; i < lista.length; i++) {
          listaObjeto.add(Geocoding_Object.fromJson(lista[i]));
        }
      }
      return listaObjeto;
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      setState(() {
        textoVariavel = erroApiFora;
      });
      return null;
      //  throw Exception('Failed to load response');
    }
  }

  buscaPeloNomeCidade(String cidade) async {
    if (cidade.length > 1) {
      List<Geocoding_Object>? cidades = await buscaCidadePeloNome(cidade);
      if (cidades == null || cidades.isEmpty) {
        setState(() {
          textoVariavel = erroLocalNaoEncontrado;
          cidadeSelecionada = null;
          listaCidades = List.empty();
        });
      }
      setState(() {
        listaCidades = cidades!;
      });
    } else {
      setState(() {
        textoVariavel = cidade;
        cidadeSelecionada = null;
        listaCidades = List.empty();
      });
    }
  }

  buscaPelaPosicao(double latitude, double longitude) async {
    List<Placemark> placemarks =
        await placemarkFromCoordinates(latitude, longitude);
    //listaCidades = placemarks;
    Geocoding_Object geocodingFirst = Geocoding_Object(
        latitude: latitude,
        longitude: longitude,
        pais: placemarks.first.country.toString(),
        regiao: placemarks.first.administrativeArea.toString(),
        nome: placemarks.first.locality.toString());

    await setaClimaAtual(latitude, longitude);
    setState(() {
      //listaCidades = [geocodingFirst];
      cidadeSelecionada = geocodingFirst;
    });

    //[Placemark(locality: "nome", country: "pais", administrativeArea: "estado")];
    print("ENTREI NO BUSCA PELA POSICAO");
  }

  Future<Forecast_Object?> buscaClimaCurrentPelasCoordenadas(
      double lati, double long) async {
    final response = await http.get(Uri.parse(
        'https://api.open-meteo.com/v1/forecast?latitude=$lati&longitude=$long&current_weather=true&timezone=America/Sao_Paulo'));
    if (response.statusCode == 200) {
      var results = json.decode(response.body);
      Forecast_Object forecast = Forecast_Object.fromJson(results);
      return forecast;
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      // throw Exception('Failed to load response');
      setState(() {
        textoVariavel = erroApiFora;
      });
      return null;
    }
  }

  Future<Forecast_Object?> buscaClimaTodayPelasCoordenadas(
      double lati, double long) async {
    String hoje = DateTime.now().toString().substring(0, 10);
    final response = await http.get(Uri.parse(
        'https://api.open-meteo.com/v1/forecast?latitude=$lati&longitude=$long&hourly=weathercode,temperature_2m,windspeed_10m&timezone=America/Sao_Paulo&start_date=$hoje&end_date=$hoje'));
    if (response.statusCode == 200) {
      var results = json.decode(response.body);
      Forecast_Object forecast = Forecast_Object.fromJson(results);
      return forecast;
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      // throw Exception('Failed to load response');
      setState(() {
        textoVariavel = erroApiFora;
      });
      return null;
    }
  }

  Future<Forecast_Object?> buscaClimaWeekPelasCoordenadas(
      double lati, double long) async {
    String hoje = DateTime.now().toString().substring(0, 10);
    String aposSeisDias =
        DateTime.now().add(const Duration(days: 6)).toString().substring(0, 10);
    final response = await http.get(Uri.parse(
        'https://api.open-meteo.com/v1/forecast?latitude=$lati&longitude=$long&timezone=America/Sao_Paulo&start_date=$hoje&end_date=$aposSeisDias&daily=weathercode,temperature_2m_max,temperature_2m_min'));
    if (response.statusCode == 200) {
      var results = json.decode(response.body);
      Forecast_Object forecast = Forecast_Object.fromJson(results);
      return forecast;
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      // throw Exception('Failed to load response');
      setState(() {
        textoVariavel = erroApiFora;
      });
      return null;
    }
  }

  setaClimaAtual(double lati, double long) async {
    climaAtual = await buscaClimaCurrentPelasCoordenadas(lati, long);
    climaToday = await buscaClimaTodayPelasCoordenadas(lati, long);
    climaWeek = await buscaClimaWeekPelasCoordenadas(lati, long);
  }

  setaErroDeLocalizacaoDesabilitadaNaTela() {
    setState(() {
      textoVariavel = erroGeolocalizacaoDesabilitada;
      cidadeSelecionada = null;
      listaCidades = List.empty();
    });
  }

  Text retornaObjetoTextoFrmatado(String texto, Color corTexto) {
    return Text(
      texto,
      style: TextStyle(color: corTexto),
      textAlign: TextAlign.center,
    );
  }

  ehUmErro(String texto) {
    return texto == erroGeolocalizacaoDesabilitada ||
        texto == erroLocalNaoEncontrado ||
        texto == erroApiFora;
  }

  retornaWidgetCurrent() {
    if (cidadeSelecionada != null) {
      String weatherDesc =
          retornaWeatherDescription(climaAtual!.current_weather!.weathercode);
      return SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              cidadeSelecionada!.nome,
              textAlign: TextAlign.center,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(
              cidadeSelecionada!.regiao ?? "",
              textAlign: TextAlign.center,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(
              cidadeSelecionada!.pais ?? "",
              textAlign: TextAlign.center,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(
              "${climaAtual!.current_weather!.temperature}ºC",
              textAlign: TextAlign.center,
            ),
            Text(
              "${climaAtual!.current_weather!.windspeed} km/h",
              textAlign: TextAlign.center,
            ),
            Text(
              weatherDesc,
              textAlign: TextAlign.center,
            )
          ],
        ),
      );
    }
  }

  retornaWidgetToday() {
    List<TableRow> listaRow = List.empty(growable: true);
    if (cidadeSelecionada != null) {
      for (int i = 0; i < climaToday!.hourly!.listaTime.length; i++) {
        String weatherDesc =
            retornaWeatherDescription(climaToday!.hourly!.listaWeatherCode[i]);
        listaRow.add(TableRow(children: [
          Text(
            climaToday!.hourly!.listaTime[i].substring(11, 16),
            textAlign: TextAlign.center,
          ),
          Text(
            "${climaToday!.hourly!.listaTemperature[i]}ºC",
          ),
          Text(
            "${climaToday!.hourly!.listaWindSpeed[i]} km/h",
          ),
          Text(
            weatherDesc,
          )
        ]));
      }
      return SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              cidadeSelecionada!.nome,
              textAlign: TextAlign.center,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(
              cidadeSelecionada!.regiao ?? "",
              textAlign: TextAlign.center,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(
              cidadeSelecionada!.pais ?? "",
              textAlign: TextAlign.center,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            Table(
                border: TableBorder.all(
                    color: const Color.fromARGB(255, 192, 241, 227),
                    width: 1.5),
                children: listaRow),
          ],
        ),
      );
    }
  }

  retornaWidgetWeek() {
    List<TableRow> listaRow = List.empty(growable: true);
    if (cidadeSelecionada != null) {
      for (int i = 0; i < climaWeek!.weekly!.listaTime.length; i++) {
        String weatherDesc =
            retornaWeatherDescription(climaWeek!.weekly!.listaWeatherCode[i]);
        listaRow.add(TableRow(children: [
          Text(
            climaWeek!.weekly!.listaTime[i].substring(0, 10),
            textAlign: TextAlign.center,
          ),
          Text(
            "${climaWeek!.weekly!.listaTemperatureMin[i]}ºC",
          ),
          Text(
            "${climaWeek!.weekly!.listaTemperatureMax[i]}ºC",
          ),
          Text(
            weatherDesc,
          )
        ]));
      }
      return SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              cidadeSelecionada!.nome,
              textAlign: TextAlign.center,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(
              cidadeSelecionada!.regiao ?? "",
              textAlign: TextAlign.center,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(
              cidadeSelecionada!.pais ?? "",
              textAlign: TextAlign.center,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            Table(
                border: TableBorder.all(
                    color: const Color.fromARGB(255, 204, 238, 227),
                    width: 1.5),
                children: listaRow),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        initialIndex: 0,
        length: 3,
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Theme.of(context).colorScheme.inversePrimary,
            leading: IconButton(
              icon: const Icon(Icons.search),
              color: const Color.fromARGB(255, 178, 236, 227),
              onPressed: () async {
                if (gpsHabilitado && temPermissaoGps) {
                  textoVariavel = textoSearch;
                  await buscaPeloNomeCidade(textoVariavel);
                } else {
                  setaErroDeLocalizacaoDesabilitadaNaTela();
                }
              },
            ),
            title: Container(
              padding: const EdgeInsets.all(5),
              child: TextField(
                decoration: const InputDecoration(
                    hintText: "Search location...", border: InputBorder.none),
                onChanged: (value) async {
                  if (gpsHabilitado && temPermissaoGps) {
                    textoSearch = value;
                    textoVariavel = textoSearch;
                    await buscaPeloNomeCidade(textoSearch);
                  } else {
                    setaErroDeLocalizacaoDesabilitadaNaTela();
                  }
                },
                onSubmitted: (value) async {
                  if (gpsHabilitado && temPermissaoGps) {
                    textoVariavel = value;
                    await buscaPeloNomeCidade(textoVariavel);
                  } else {
                    setaErroDeLocalizacaoDesabilitadaNaTela();
                  }
                },
              ),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.near_me),
                color: Colors.white,
                onPressed: () async {
                  await validarGps();
                  if (gpsHabilitado && temPermissaoGps) {
                    textoVariavel = "$longitude $latitude";
                    //tem coordenadas
                    await buscaPelaPosicao(latitude!, longitude!);
                    //await setaClimaAtual(latitude!, longitude!);
                  } else {
                    setaErroDeLocalizacaoDesabilitadaNaTela();
                  }
                },
              )
            ],
          ),
          body: Container(
            child: Stack(
              children: [
                TabBarView(
                  children: <Widget>[
                    //TODO: VER O Q TEXTOVARIAVEL RETORA QDO
                    Center(
                      child: ehUmErro(textoVariavel)
                          ? retornaObjetoTextoFrmatado(
                              textoVariavel, const Color.fromARGB(255, 27, 117, 98))
                          : retornaWidgetCurrent(),
                    ),
                    Center(
                        child: ehUmErro(textoVariavel)
                            ? retornaObjetoTextoFrmatado(
                                textoVariavel, const Color.fromARGB(255, 27, 117, 98))
                            : retornaWidgetToday() //retornaObjetoTextoFrmatado(today, Colors.black),
                        ),
                    Center(
                      child: ehUmErro(textoVariavel)
                          ? retornaObjetoTextoFrmatado(
                              textoVariavel, const Color.fromARGB(255, 27, 117, 98))
                          : retornaWidgetWeek(),
                    ),
                  ],
                ),
                Expanded(
                  child: Container(
                    color: Colors.white,
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: listaCidades.length,
                      itemBuilder: (context, index) {
                        return Card(
                          // color: Theme.of(context).colorScheme.onBackground,
                          child: ListTile(
                            onTap: () async {
                              cidadeSelecionada = listaCidades[index];

                              setState(() {
                                listaCidades = List.empty(growable: true);
                              });
                            },
                            title: Text(
                              '${listaCidades[index].nome}, ${listaCidades[index].regiao}, ${listaCidades[index].pais}',
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                )
              ],
            ),
          ),
          bottomNavigationBar: const TabBar(
            tabs: <Widget>[
              Tab(
                icon: Icon(Icons.schedule),
                text: "Currently",
              ),
              Tab(
                icon: Icon(Icons.today),
                text: "Today",
              ),
              Tab(
                icon: Icon(Icons.date_range),
                text: "Weekly",
              ),
            ],
          ),
        ));
  }
}
