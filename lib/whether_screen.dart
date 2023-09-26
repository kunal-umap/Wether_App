import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:wether_app/Forcastcard.dart';
import 'package:wether_app/aditional_itom.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';


class WhetherScreen extends StatefulWidget {
  const WhetherScreen({super.key});

  @override
  State<WhetherScreen> createState() => _WhetherScreenState();
}

class _WhetherScreenState extends State<WhetherScreen> {

  Future<Map<String,dynamic>> getCurrentWhether() async {
    try {
      String city = "London";
      await dotenv.load(fileName: "lib/.env");
      final res = await http.get(
          Uri.parse('https://api.openweathermap.org/data/2.5/forecast?q=$city&APPID=${dotenv.env['KEY']}')
      );
      final data = jsonDecode(res.body);

      if(data['cod'] != '200'){
        throw "An unexpeted Error Occured";
      }
   // temp = data['list'][0]['main']['temp'];
      return data;
    }catch (e) {
      throw e.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Whether App",
          style: TextStyle(
            fontWeight: FontWeight.w700,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: () {
                setState(() {});
              },
              icon: const Icon(Icons.refresh))
        ],
      ),
      body: FutureBuilder(
        future: getCurrentWhether(),
        builder: (context, snapshot) {
          if(snapshot.connectionState == ConnectionState.waiting){
            return const LinearProgressIndicator();
          }

          if(snapshot.hasError){
            return Text(snapshot.error.toString());
          }

          final data = snapshot.data!;
          final WhetherData = data['list'][0];
          final currentTemp = WhetherData['main']['temp'];
          final currSky = WhetherData['weather'][0]['main'];
          return SizedBox(
            width: double.infinity,
            child:  Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: double.infinity,
                  child: Card(
                    elevation: 10,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(
                            sigmaX: 10,
                            sigmaY: 10
                        ),
                        child:  Padding(
                          padding:const EdgeInsets.all(12),
                          child: Column(
                            children: [
                              Text(
                                '$currentTemp K',
                                style:const TextStyle(
                                  fontSize: 32,
                                  fontWeight: FontWeight.bold
                                ),
                              ),
                              const SizedBox(height: 16),
                              Icon(
                                  currSky == 'Clouds' || currSky == 'Rain' ? Icons.cloud_rounded:Icons.sunny,
                                  size: 64,
                              ),
                              const SizedBox(height: 16),
                              Text(
                                currSky,
                                style:const TextStyle(
                                  fontSize: 20
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                const Padding(
                  padding: EdgeInsets.fromLTRB(12, 2, 2, 14),
                  child: Text(
                    "Whether Forcast",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 22
                    ),
                    textAlign: TextAlign.left,
                  ),
                ),
                // SingleChildScrollView(
                //   scrollDirection: Axis.horizontal,
                //   child: Row(
                //     children: [
                //       for(int i = 0;i<10;i++)
                //         ForcastCard(
                //           time: data['list'][i+1]['dt'].toString(),
                //           value: data['list'][i+1]['main']['temp'].toString(),
                //           icon: data['list'][i+1]['weather'][0]['main'] == 'Clouds'||data['list'][i+1]['weather'][0]['main'] == 'Rain'? Icons.cloud_rounded:Icons.sunny,
                //         ),
                //     ],
                //   ),
                // ),
                SizedBox(
                  height: 128,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: 5,
                    itemBuilder: (context,index){
                      return ForcastCard(
                        time: data['list'][index+1]['dt'].toString(),
                        value: data['list'][index+1]['main']['temp'].toString(),
                        icon: data['list'][index+1]['weather'][0]['main'] == 'Clouds'||data['list'][index+1]['weather'][0]['main'] == 'Rain'? Icons.cloud_rounded:Icons.sunny,
                      );
                    }
                  ),
                ),
                const SizedBox(height: 20,),
                const Padding(
                  padding: EdgeInsets.fromLTRB(12, 2, 12, 0),
                  child: Text(
                    "Additional Information",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 22
                    ),
                    textAlign: TextAlign.left,
                  ),
                ),
                const SizedBox(height: 10,),
                Padding(
                  padding: EdgeInsets.all(11),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      AdditionalInfo(
                        icon: Icons.water_drop,
                        label: "Humidity",
                        value: WhetherData['main']['humidity'].toString(),
                      ),
                      AdditionalInfo(
                        icon: Icons.wind_power,
                        label: "Wind",
                        value: WhetherData['wind']['speed'].toString(),
                      ),
                      AdditionalInfo(
                        icon: Icons.compress_rounded,
                        label: "Pressure",
                        value: WhetherData['main']['pressure'].toString(),
                      ),
                    ],
                  ),
                )

              ],
            ),
          );
        },
      ),
    );
  }
}

