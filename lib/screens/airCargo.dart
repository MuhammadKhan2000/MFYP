import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class AirCargo extends StatefulWidget {
  const AirCargo({super.key});

  @override
  State<AirCargo> createState() => _AirCargoState();
}

class _AirCargoState extends State<AirCargo>
    with SingleTickerProviderStateMixin {
  TextEditingController txtNumber = TextEditingController(),
      txtcode = TextEditingController();
  bool isLoading = false;
  Map<String, dynamic> scrapedData = {};

  TabController? tabController;
  Future<void> startScraping() async {
    // Fluttertoast.showToast(
    //   msg: "Data will fetched in 5 minutes . Thank You!",
    //   toastLength: Toast.LENGTH_LONG,
    //   gravity: ToastGravity.BOTTOM,
    //   backgroundColor: Colors.black,
    //   textColor: Colors.white,
    //   fontSize: 16,
    // );
  setState(() {
    isLoading = true;
  });

  try {
    const String apiUrl = "http://192.168.236.189:5000/api/cargo/scrape";

    // Build the URL with query parameters
    final Uri url = Uri.parse(apiUrl).replace(queryParameters: {
      'number': txtNumber.text,
      'airline_code': txtcode.text,
    });

    // Send GET request
    final response = await http.get(url);

    if (response.statusCode == 200) {
        // Parse JSON data
        setState(() {
          scrapedData = json.decode(response.body);
        });
        
      } else {
        // Handle non-200 responses
        Fluttertoast.showToast(
          msg: "Wrong number or required airline code. Please try again.",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0,
        );
      }
    } catch (e) {
      // Show error toast
      Fluttertoast.showToast(
        msg: 'Error: $e',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }
  @override
  void initState() {
    // TODO: implement initState
    tabController = TabController(length: 3, vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    txtNumber.dispose();
    txtcode.dispose();
    tabController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    w(x) => MediaQuery.of(context).size.width * (x / 490);
    h(y) => MediaQuery.of(context).size.height * (y / 890);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Air Cargo",
          style: GoogleFonts.poppins(
              fontSize: h(22),
              fontWeight: FontWeight.w600,
              color: Colors.white),
        ),
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back_outlined, color: Colors.white),
        ),
        backgroundColor: Colors.green,
      ),
      body: Padding(
        padding: EdgeInsets.all(w(16.0)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: txtNumber,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Number',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.confirmation_number),
                    ),
                  ),
                ),
                SizedBox(width: w(16)),
                Expanded(
                  child: TextField(
                    controller: txtcode,
                    keyboardType: TextInputType.text,
                    decoration: const InputDecoration(
                      labelText: 'Code',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.code),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: h(20)),
            Center(
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: isLoading
                      ? null
                      : () {
                          if (txtNumber.text.isEmpty) {
                            Fluttertoast.showToast(
                              msg: 'Required: Number',
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.BOTTOM,
                              timeInSecForIosWeb: 2,
                              backgroundColor: Colors.black,
                              textColor: Colors.white,
                              fontSize: w(18),
                            );
                            return;
                          }
                          // // Check if the number starts with '501'
                          // if (!txtNumber.text.startsWith('871')) {
                          //   Fluttertoast.showToast(
                          //     msg: 'Number must start with 501',
                          //     toastLength: Toast.LENGTH_SHORT,
                          //     gravity: ToastGravity.BOTTOM,
                          //     timeInSecForIosWeb: 2,
                          //     backgroundColor: Colors.black,
                          //     textColor: Colors.white,
                          //     fontSize: w(18),
                          //   );
                          //   return;
                          // }
                          // if (txtcode.text.isEmpty) {
                          //   Fluttertoast.showToast(
                          //     msg: 'Required: Code',
                          //     toastLength: Toast.LENGTH_SHORT,
                          //     gravity: ToastGravity.BOTTOM,
                          //     timeInSecForIosWeb: 2,
                          //     backgroundColor: Colors.black,
                          //     textColor: Colors.white,
                          //     fontSize: w(18),
                          //   );
                          //   return;
                          // }
                          // if (!txtcode.text.startsWith('HNA')) {
                          //   Fluttertoast.showToast(
                          //     msg: 'for 501- the code must be SW',
                          //     toastLength: Toast.LENGTH_SHORT,
                          //     gravity: ToastGravity.BOTTOM,
                          //     timeInSecForIosWeb: 2,
                          //     backgroundColor: Colors.black,
                          //     textColor: Colors.white,
                          //     fontSize: w(18),
                          //   );
                          //   return;
                          // }
                          startScraping();
                        },
                  style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: h(16)),
                      backgroundColor: Colors.green,
                      elevation: 5),
                  child: isLoading
                      ? SizedBox(
                          height: h(20),
                          width: w(20),
                          child: const CircularProgressIndicator(
                            color: Colors.green,
                            strokeWidth: 2,
                          ),
                        )
                      : Text(
                          "Track Cargo",
                          style: GoogleFonts.poppins(
                              fontSize: w(18),
                              color: Colors.white,
                              fontWeight: FontWeight.w500),
                        ),
                ),
              ),
            ),
            SizedBox(height: h(20)),
            Expanded(
              child: scrapedData.isEmpty
                  ? Center(
                      child: Text(
                        "No results found",
                        style: GoogleFonts.poppins(
                            fontSize: h(18),
                            fontWeight: FontWeight.w600,
                            color: Colors.grey.withOpacity(0.7)),
                      ),
                    )
                  : Column(
                      children: [
                        TabBar(
                          controller: tabController,
                          isScrollable: true,
                          tabAlignment: TabAlignment.start,
                          labelStyle: GoogleFonts.poppins(
                            fontSize: h(12),
                            fontWeight: FontWeight.w500,
                          ),
                          tabs: const [
                            Tab(
                              text: "Flight Detail",
                            ),
                            Tab(text: "Milestone"),
                            Tab(text: "Shipment Detail"),
                          ],
                        ),
                        Expanded(
                          child: TabBarView(
                            controller: tabController,
                            children: [
                              (scrapedData['flight_detail'] != null &&
                              scrapedData['flight_detail'].isNotEmpty)                      
                                  ? buildFlightDetail(
                                      context, scrapedData['flight_detail'])
                                  : Center(
                                      child: Text("No data found or wrong number",
                                          style: GoogleFonts.poppins(
                                              fontSize: h(10),
                                              fontWeight: FontWeight.w600,
                                              color: Colors.grey
                                                  .withOpacity(0.7)))),
                              (scrapedData['milestone'] != null &&
                            
                              scrapedData['milestone'].isNotEmpty)
                                  ? buildMilestones(
                                      context, scrapedData['milestone'])
                                  : Center(
                                      child: Text(
                                      "No data found or wrong number",
                                      style: GoogleFonts.poppins(
                                          fontSize: h(10),
                                          fontWeight: FontWeight.w600,
                                          color: Colors.grey.withOpacity(0.7)),
                                    )),
                              (scrapedData['shipment'] != null &&
                              scrapedData['shipment'].isNotEmpty)
                                  ? buildShipmentDetail(
                                      context, scrapedData['shipment'])
                                  : Center(
                                      child: Text(
                                      "No data found or wrong number",
                                      style: GoogleFonts.poppins(
                                          fontSize: h(10),
                                          fontWeight: FontWeight.w600,
                                          color: Colors.grey.withOpacity(0.7)),
                                    )),
                            ],
                          ),
                        ),
                      ],
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

Widget buildShipmentDetail(
    BuildContext context, Map<String, dynamic> shipmentDetail) {
  w(x) => MediaQuery.of(context).size.width * (x / 490);
  h(y) => MediaQuery.of(context).size.height * (y / 890);
  return ListView(
    children: [
      Card(
        elevation: 5,
        child: ListTile(
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text.rich(TextSpan(children: [
                TextSpan(
                    text: 'Actual Weight: ',
                    style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w600,
                        fontSize: w(14),
                        color: HexColor('808080'))),
                TextSpan(
                    text: ' ${shipmentDetail['actual_weight']}',
                    style: GoogleFonts.poppins(
                        fontWeight: FontWeight.normal,
                        fontSize: w(16),
                        color: HexColor('000000'))),
              ])),
              Text.rich(TextSpan(children: [
                TextSpan(
                    text: 'Pieces: ',
                    style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w600,
                        fontSize: w(14),
                        color: HexColor('808080'))),
                TextSpan(
                    text: ' ${shipmentDetail['pieces']}',
                    style: GoogleFonts.poppins(
                        fontWeight: FontWeight.normal,
                        fontSize: w(16),
                        color: HexColor('000000'))),
              ])),
              Text.rich(TextSpan(children: [
                TextSpan(
                    text: 'Volume: ',
                    style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w600,
                        fontSize: w(14),
                        color: HexColor('808080'))),
                TextSpan(
                    text: ' ${shipmentDetail['volume']}',
                    style: GoogleFonts.poppins(
                        fontWeight: FontWeight.normal,
                        fontSize: w(16),
                        color: HexColor('000000'))),
              ])),
            ],
          ),
        ),
      ),
    ],
  );
}

Widget buildFlightDetail(BuildContext context, List<dynamic> flightDetails) {
  w(x) => MediaQuery.of(context).size.width * (x / 490);
  h(y) => MediaQuery.of(context).size.height * (y / 890);
  return ListView(
    children: flightDetails.map((flight) {
      return Card(
        elevation: 5,
        child: ListTile(
          title: Text(
            "${flight['carrier']??''} ${flight['flight_number']??''} (${flight['flight_status']??''})",
            style: GoogleFonts.poppins(
                fontWeight: FontWeight.normal,
                fontSize: w(16),
                color: HexColor('000000')),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text.rich(TextSpan(children: [
                TextSpan(
                    text: 'Departure: ',
                    style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w600,
                        fontSize: w(14),
                        color: HexColor('808080'))),
                TextSpan(
                    text: ' ${flight['departure'] ?? 'N/A'}',
                    style: GoogleFonts.poppins(
                        fontWeight: FontWeight.normal,
                        fontSize: w(16),
                        color: HexColor('000000'))),
              ])),
              Text.rich(TextSpan(children: [
                TextSpan(
                    text: 'Arrival: ',
                    style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w600,
                        fontSize: w(14),
                        color: HexColor('808080'))),
                TextSpan(
                    text: ' ${flight['arrival'] ?? 'N/A'}',
                    style: GoogleFonts.poppins(
                        fontWeight: FontWeight.normal,
                        fontSize: w(16),
                        color: HexColor('000000'))),
              ])),
              Text.rich(TextSpan(children: [
                TextSpan(
                    text: 'Date: ',
                    style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w600,
                        fontSize: w(14),
                        color: HexColor('808080'))),
                TextSpan(
                    text: ' ${flight['flight_date'] ?? 'N/A'}',
                    style: GoogleFonts.poppins(
                        fontWeight: FontWeight.normal,
                        fontSize: w(16),
                        color: HexColor('000000'))),
              ])),
            ],
          ),
        ),
      );
    }).toList(),
  );
}

Widget buildMilestones(BuildContext context, List<dynamic> milestones) {
  w(x) => MediaQuery.of(context).size.width * (x / 490);
  h(y) => MediaQuery.of(context).size.height * (y / 890);
  return ListView(
    children: milestones.map((milestone) {
      return Card(
        elevation: 5,
        child: ListTile(
          title: Text(
            "${milestone['status']??''} - ${milestone['location']??''}",
            style: GoogleFonts.poppins(
                fontWeight: FontWeight.normal,
                fontSize: w(16),
                color: HexColor('000000')),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text.rich(TextSpan(children: [
                TextSpan(
                    text: 'Date: ',
                    style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w600,
                        fontSize: w(14),
                        color: HexColor('808080'))),
                TextSpan(
                    text: ' ${milestone['date'] ?? 'N/A'}',
                    style: GoogleFonts.poppins(
                        fontWeight: FontWeight.normal,
                        fontSize: w(16),
                        color: HexColor('000000'))),
              ])),
              Text.rich(TextSpan(children: [
                TextSpan(
                    text: 'Description: ',
                    style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w600,
                        fontSize: w(14),
                        color: HexColor('808080'))),
                TextSpan(             
                    text: ' ${milestone['description'] ?? 'N/A'}',
                    style: GoogleFonts.poppins(
                        fontWeight: FontWeight.normal,
                        fontSize: w(16),
                        color: HexColor('000000'))),
              ])),
            ],
          ),
        ),
      );
    }).toList(),
  );
}
