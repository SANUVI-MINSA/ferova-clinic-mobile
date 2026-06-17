import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';

class MapLocationStep extends StatefulWidget {
  final double? initialLatitude;
  final double? initialLongitude;
  final ValueChanged<LatLng> onLocationChanged;

  const MapLocationStep({
    super.key,
    this.initialLatitude,
    this.initialLongitude,
    required this.onLocationChanged,
  });

  @override
  State<MapLocationStep> createState() => _MapLocationStepState();
}

class _MapLocationStepState extends State<MapLocationStep> {
  final MapController _mapController = MapController();
  LatLng _selectedLocation = const LatLng(-12.0464, -77.0428);
  bool _isLoadingLocation = true;
  bool _isLoadingAddress = false;
  String? _errorMessage;
  String? _streetReference;
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    if (widget.initialLatitude != null && widget.initialLongitude != null) {
      _selectedLocation = LatLng(
        widget.initialLatitude!,
        widget.initialLongitude!,
      );
      _isLoadingLocation = false;
      _getAddressFromCoordinates(_selectedLocation);
    } else {
      _determinePosition();
    }
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }

  Future<void> _determinePosition() async {
    setState(() => _isLoadingLocation = true);
    try {
      final bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        setState(() {
          _errorMessage = 'Activa el servicio de ubicación de tu dispositivo.';
          _isLoadingLocation = false;
        });
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          setState(() {
            _errorMessage = 'Permiso de ubicación denegado.';
            _isLoadingLocation = false;
          });
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        setState(() {
          _errorMessage =
              'Permiso denegado permanentemente. Habilítalo desde ajustes.';
          _isLoadingLocation = false;
        });
        return;
      }

      final Position position = await Geolocator.getCurrentPosition();
      final LatLng newLocation = LatLng(position.latitude, position.longitude);
      setState(() {
        _selectedLocation = newLocation;
        _isLoadingLocation = false;
      });
      widget.onLocationChanged(newLocation);
      _getAddressFromCoordinates(newLocation);

      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          _mapController.move(_selectedLocation, 16);
        }
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'No se pudo obtener tu ubicación. $e';
        _isLoadingLocation = false;
      });
    }
  }

  Future<void> _getAddressFromCoordinates(LatLng location) async {
    setState(() => _isLoadingAddress = true);
    try {
      final List<Placemark> placemarks = await placemarkFromCoordinates(
        location.latitude,
        location.longitude,
      );

      if (placemarks.isNotEmpty) {
        final Placemark place = placemarks.first;
        final String street = [
          place.street,
          place.subLocality,
        ].where((part) => part != null && part.isNotEmpty).join(', ');

        setState(() {
          _streetReference = street.isNotEmpty
              ? street
              : 'Dirección no disponible';
          _isLoadingAddress = false;
        });
      } else {
        setState(() {
          _streetReference = 'Dirección no disponible';
          _isLoadingAddress = false;
        });
      }
    } catch (e) {
      setState(() {
        _streetReference = 'No se pudo obtener la dirección';
        _isLoadingAddress = false;
      });
    }
  }

  void _onMapMoved(LatLng newLocation) {
    setState(() => _selectedLocation = newLocation);
    widget.onLocationChanged(newLocation);

    // Debounce — espera que el usuario deje de mover el mapa antes de consultar
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 700), () {
      _getAddressFromCoordinates(newLocation);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Elige la ubicación de la posta',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color(0xFF1A1A2E),
          ),
        ),
        const SizedBox(height: 4),
        const Text(
          'Arrastra el mapa para mover el marcador',
          style: TextStyle(fontSize: 13, color: Color(0xFF6B7D8F)),
        ),
        const SizedBox(height: 16),

        // Mapa
        SizedBox(
          height: 400,
          child: _isLoadingLocation
              ? const Center(
                  child: CircularProgressIndicator(color: Color(0xFF003178)),
                )
              : ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Stack(
                    children: [
                      FlutterMap(
                        mapController: _mapController,
                        options: MapOptions(
                          initialCenter: _selectedLocation,
                          initialZoom: 16,
                          onPositionChanged: (camera, hasGesture) {
                            if (hasGesture) {
                              _onMapMoved(camera.center);
                            }
                          },
                        ),
                        children: [
                          TileLayer(
                            urlTemplate:
                                'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                            userAgentPackageName: 'com.ferova.clinic',
                          ),
                        ],
                      ),
                      const Center(
                        child: Padding(
                          padding: EdgeInsets.only(bottom: 40),
                          child: Icon(
                            Icons.location_pin,
                            color: Color(0xFF003178),
                            size: 48,
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 16,
                        right: 16,
                        child: FloatingActionButton(
                          mini: true,
                          backgroundColor: Colors.white,
                          onPressed: _determinePosition,
                          child: const Icon(
                            Icons.my_location,
                            color: Color(0xFF003178),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
        ),

        const SizedBox(height: 16),

        if (_errorMessage != null)
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Text(
              _errorMessage!,
              style: const TextStyle(color: Colors.redAccent, fontSize: 13),
              textAlign: TextAlign.center,
            ),
          ),

        // Referencia de calle + coordenadas como dato secundario
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            color: const Color(0xFFF8FAFC),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: const Color(0xFFE2E8F0)),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(
                Icons.place_outlined,
                color: Color(0xFF6B7D8F),
                size: 18,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _isLoadingAddress
                        ? const Text(
                            'Buscando dirección...',
                            style: TextStyle(
                              fontSize: 14,
                              color: Color(0xFF9EAFC0),
                            ),
                          )
                        : Text(
                            _streetReference ?? 'Sin referencia',
                            style: const TextStyle(
                              fontSize: 14,
                              color: Color(0xFF1A1A2E),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                    const SizedBox(height: 4),
                    Text(
                      'Lat: ${_selectedLocation.latitude.toStringAsFixed(4)}, '
                      'Lng: ${_selectedLocation.longitude.toStringAsFixed(4)}',
                      style: const TextStyle(
                        fontSize: 11,
                        color: Color(0xFF9EAFC0),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
