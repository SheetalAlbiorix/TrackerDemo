import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Google Maps Demo',
      home: MapSample(),
    );
  }
}

class MapSample extends StatefulWidget {
  @override
  State<MapSample> createState() => MapSampleState();
}

Position _currentPosition;
Position destinationCoordinates =
    Position(latitude: 23.006939, longitude: 72.535984);
Set<Marker> markers = {};

class MapSampleState extends State<MapSample> {
  GoogleMapController _controller;

  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  Marker destinationMarker = Marker(
    markerId: MarkerId('$destinationCoordinates'),
    position: LatLng(
      destinationCoordinates.latitude,
      destinationCoordinates.longitude,
    ),
    infoWindow: InfoWindow(
      title: 'Destination',
      snippet: destinationCoordinates.latitude.toString(),
    ),
    icon: BitmapDescriptor.defaultMarker,
  );

  _getCurrentLocation() async {
    await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
        .then((Position position) async {
      setState(() {
        // Store the position in the variable
        _currentPosition = position;

        print('CURRENT POS: $_currentPosition');

        // For moving the camera to current location
        _controller.animateCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(
              target: LatLng(position.latitude, position.longitude),
              zoom: 18.0,
            ),
          ),
        );
      });

      Geolocator.getPositionStream(desiredAccuracy: LocationAccuracy.high)
          .listen((Position position) {
        _currentPosition = position;
        setState(() {
          _createPolylines(_currentPosition, destinationCoordinates);
        });
      });
    }).catchError((e) {
      print(e);
    });

    markers.add(destinationMarker);
    _createPolylines(_currentPosition, destinationCoordinates);
  }

  PolylinePoints polylinePoints;
  List<LatLng> polylineCoordinates = [];
  Map<PolylineId, Polyline> polylines = {};

  _createPolylines(Position start, Position destination) async {
    // Initializing PolylinePoints
    polylinePoints = PolylinePoints();
    polylineCoordinates = List();
    //polylines.clear();

    // Generating the list of coordinates to be used for
    // drawing the polylines
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      'AIzaSyDtf4T8D3xDAleBOO2OC6UVF8UTdMZ9nZA', // Google Maps API Key
      PointLatLng(start.latitude, start.longitude),
      PointLatLng(destination.latitude, destination.longitude),
    );

    // Adding the coordinates to the list
    if (result.points.isNotEmpty) {
      result.points.forEach((PointLatLng point) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      });
    }

    // Defining an ID
    PolylineId id = PolylineId('poly');

    // Initializing Polyline
    Polyline polyline = Polyline(
      polylineId: id,
      color: Colors.red,
      points: polylineCoordinates,
      width: 5,
    );

    // Adding the polyline to the map
    polylines[id] = polyline;
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: GoogleMap(
        initialCameraPosition: _kGooglePlex,
        myLocationEnabled: true,
        myLocationButtonEnabled: false,
        mapType: MapType.normal,
        zoomGesturesEnabled: true,
        zoomControlsEnabled: false,
        onMapCreated: (GoogleMapController controller) {
          _controller = controller;
        },
        markers: markers != null ? Set<Marker>.from(markers) : null,
        polylines: Set<Polyline>.of(polylines.values),
      ),
    );
  }
}
