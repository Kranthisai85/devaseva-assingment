import 'dart:async';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Devaseva Campaigns',
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late Future<http.Response> _responseFuture;

  @override
  void initState() {
    super.initState();
    _responseFuture = http.get(Uri.parse(
        'https://testapi.devaseva.com/api/campaigns/getFeaturedCampaigns/'));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Devaseva Campaigns'),
      ),
      body: FutureBuilder(
        future: _responseFuture,
        builder: (BuildContext context, AsyncSnapshot<http.Response> response) {
          if (!response.hasData) {
            return const Center(
              child: Text('Loading...'),
            );
          } else if (response.data?.statusCode != 200) {
            return const Center(
              child: Text('Error loading data'),
            );
          } else {
            List<dynamic> json = jsonDecode(response.data!.body);
            return MyExpansionTileList(json);
          }
        },
      ),
    );
  }
}

class MyExpansionTileList extends StatelessWidget {
  final List<dynamic> campaignList;

  const MyExpansionTileList(this.campaignList, {Key? key}) : super(key: key);

  List<Widget> _getChildren() {
    List<Widget> children = [];
    for (var element in campaignList) {
      children.add(
        MyExpansionTile(element['id'], element['name']),
      );
    }
    return children;
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: _getChildren(),
    );
  }
}

class MyExpansionTile extends StatefulWidget {
  final int campaignId;
  final String campaignName;
  const MyExpansionTile(this.campaignId, this.campaignName, {Key? key})
      : super(key: key);
  @override
  State createState() => MyExpansionTileState();
}

class MyExpansionTileState extends State<MyExpansionTile>
    with SingleTickerProviderStateMixin {
  late PageStorageKey _key;
  late Future<http.Response> _responseFuture;
  late Animation<double> _iconTurns;
  late AnimationController _controller;
  static final Animatable<double> _easeOutTween =
      CurveTween(curve: Curves.easeOut);
  static final Animatable<double> _easeInTween =
      CurveTween(curve: Curves.easeIn);
  static final Animatable<double> _halfTween =
      Tween<double>(begin: 0.0, end: 0.5);

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
        duration: const Duration(milliseconds: 200), vsync: this);
    _iconTurns = _controller.drive(_halfTween.chain(_easeInTween));

    _responseFuture = http.get(Uri.parse(
        'https://testapi.devaseva.com/api/campaigns/GetAllSevas/${widget.campaignId}'));
  }

  @override
  Widget build(BuildContext context) {
    _key = PageStorageKey('${widget.campaignId}');
    return ExpansionTile(
      key: _key,
      title: Text(widget.campaignName),
      // trailing: const SizedBox.shrink(),
      // // leading: const Icon(Icons.keyboard_arrow_right_outlined),
      // leading: RotationTransition(
      //   turns: _iconTurns,
      //   child: const Icon(Icons.expand_more),
      // ),
      children: <Widget>[
        FutureBuilder(
          future: _responseFuture,
          builder:
              (BuildContext context, AsyncSnapshot<http.Response> response) {
            if (!response.hasData) {
              return const Center(
                child: Text('Loading...'),
              );
            } else if (response.data?.statusCode != 200) {
              return const Center(
                child: Text('Error loading data'),
              );
            } else {
              List<dynamic> json = jsonDecode(response.data!.body);
              List<Widget> reasonList = [];
              for (var element in json) {
                reasonList.add(Column(
                  children: [
                    ListTile(
                      dense: false,
                      title: Padding(
                        padding: const EdgeInsets.only(left: 35.0),
                        child: Text(element['name'],
                            style: const TextStyle(fontSize: 14)),
                      ),
                    ),
                  ],
                ));
              }
              return Column(children: reasonList);
            }
          },
        )
      ],
    );
  }
}


















// import 'dart:convert';
// import 'package:devaseva/model.dart';
// import 'package:devaseva/sevaPage.dart';
// import 'package:dio/dio.dart';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;

// void main() async {
//   runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({Key? key}) : super(key: key);

//   // This widget is the root of your application.
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       // title: 'Flutter Demo',
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//       ),
//       home: const MyHomePage(),
//     );
//   }
// }

// class MyHomePage extends StatefulWidget {
//   const MyHomePage({Key? key}) : super(key: key);

//   @override
//   State<MyHomePage> createState() => _MyHomePageState();
// }

// class _MyHomePageState extends State<MyHomePage> {
//   List campaigns = [];
//   List sevas = [];
//   List<Widget> sevaWidgets = [];

//   sevasList(int campaignId) async {
//     var response = await http.get(Uri.parse(
//         'https://testapi.devaseva.com/api/campaigns/GetAllSevas/$campaignId'));
//     if (response.statusCode == 200) {
//       sevas.clear();
//       setState(() {
//         sevas.addAll(json.decode(response.body));
//       });
//     }
//     for (int i = 0; i < sevas.length; i++) {
//       sevaWidgets.add(Text(sevas[i]['name']));
//     }
//     print("No of sevaWidgets created in campaign are : " +
//         sevaWidgets.length.toString());
//     return sevaWidgets;
//   }

//   // void getSevaAPI(int campaignId, int index) async {
//   //   // print("campaignId: $campaignId");
//   //   var response = await http.get(Uri.parse(
//   //       'https://testapi.devaseva.com/api/campaigns/GetAllSevas/$campaignId'));
//   //   if (response.statusCode == 200) {
//   //     sevas.clear();
//   //     setState(() {
//   //       sevas.addAll(json.decode(response.body));
//   //     });
//   //   }
//   //   print("No of sevaLists in campaign $campaignId are : ${sevas.length}");
//   // }

//   void getCampaigns() async {
//     try {
//       var response = await Dio().get(
//           'https://testapi.devaseva.com/api/campaigns/getFeaturedCampaigns');
//       setState(() {
//         campaigns = response.data;
//       });
//       // for (int i = 0; i < campaigns.length; i++) {
//       //   getSevaAPI(campaigns[i]['id'], i);
//       //   // print("Campaign Id : ${campaigns[i]['id']}");
//       // }
//       print("No of campaigns are : ${campaigns.length}");
//     } catch (e) {
//       print(e);
//     }
//   }

//   @override
//   void initState() {
//     super.initState();
//     getCampaigns();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Devaseva Campaigns"),
//         centerTitle: true,
//       ),
//       // body: ListView(
//       //   children: basicTiles.map(buildTile).toList(),
//       // )
//       body: ListView.builder(
//           itemCount: campaigns.length,
//           itemBuilder: (context, index) {
//             return ExpansionTile(
//                 title: Text(campaigns[index]['name']),
//                 children: sevasList(campaigns[index]['id']) as List<Widget>
//                 // sevas.isNotEmpty
//                 //     ? sevasList(campaigns[index]['id'])
//                 //     : [const CircularProgressIndicator()],
//                 );
//           }),
//     );
//   }

//   // Widget buildTile(BasicTile tile, {double leftPadding = 10}) {
//   //   if (tile.titles.isEmpty) {
//   //     return ListTile(
//   //       contentPadding: EdgeInsets.only(left: leftPadding + 20),
//   //       title: Text(tile.title),
//   //       // onTap: () => Navigator.push(
//   //       //   context,
//   //       //   MaterialPageRoute(builder: ((context) => DetailsPage(tile: tile))),
//   //       // ),
//   //     );
//   //   } else {
//   //     return ExpansionTile(
//   //         tilePadding: EdgeInsets.only(left: leftPadding),
//   //         title: Text(tile.title),
//   //         trailing: const SizedBox.shrink(),
//   //         leading: const Icon(Icons.keyboard_arrow_right_outlined),
//   //         children: tile.titles
//   //             .map((tile) => buildTile(tile, leftPadding: 46 + leftPadding))
//   //             .toList());
//   //   }
//   // }
// }
