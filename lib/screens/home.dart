import 'package:cargowings/screens/airCargo.dart';
import 'package:cargowings/screens/airRates.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    w(x) => MediaQuery.of(context).size.width * (x / 490);
    h(y) => MediaQuery.of(context).size.height * (y / 890);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Home',
          style: GoogleFonts.poppins(
              fontSize: h(22),
              fontWeight: FontWeight.w600,
              color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: Colors.green,
      ),
      body: Padding(
        padding: EdgeInsets.all(w(16.0)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _homeBox(
              context,
              title: 'Air Cargo',
              iconData: Icons.airplanemode_active,
              color: Colors.blue,
            ),
            SizedBox(height: h(20)),
            _homeBox(
              context,
              title: 'Shipment Cargo',
              iconData: Icons.directions_boat_filled_rounded,
              color: Colors.green,
            ),
            SizedBox(height: h(20)),
            _homeBox(
              context,
              title: 'Air Rates',
              iconData: Icons.monetization_on,
              color: Colors.orange,
            ),
          ],
        ),
      ),
    );
  }

  Widget _homeBox(BuildContext context,
      {required String title,
      required IconData iconData,
      required Color color}) {
    w(x) => MediaQuery.of(context).size.width * (x / 490);
    h(y) => MediaQuery.of(context).size.height * (y / 890);
    return GestureDetector(
      onTap: () {
        if (title == 'Air Cargo') {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => AirCargo()));
        }
        if (title == 'Shipment Cargo') {
          Fluttertoast.showToast(
            msg: 'Under Development',
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 2,
            backgroundColor: Colors.black,
            textColor: Colors.white,
            fontSize: w(18),
          );
        }
        if (title == 'Air Rates') {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => AirRates()));
        }
      },
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(h(16)),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: color, width: h(2)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(iconData, size: h(40), color: color),
            SizedBox(height: h(10)),
            Text(
              title,
              style: GoogleFonts.poppins(
                  fontSize: h(16), fontWeight: FontWeight.w600),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
