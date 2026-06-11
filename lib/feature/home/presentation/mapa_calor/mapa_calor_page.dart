import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:ferova_clinic_flutter/feature/home/domain/posta.dart';

const _kNavy = Color(0xFF1A3A5C);
const _kBlue = Color(0xFF0D6EA8);
const _kRed = Color(0xFFE53935);
const _kOrange = Color(0xFFFFA726);
const _kGreen = Color(0xFF4CAF50);

Color _statusColor(PostaStatus s) {
  switch (s) {
    case PostaStatus.critico:
      return _kRed;
    case PostaStatus.moderado:
      return _kOrange;
    case PostaStatus.bajo:
      return _kGreen;
  }
}

// ─── Página Mapa de Calor ─────────────────────────────────────────────────────
class MapaCalorPage extends StatefulWidget {
  final List<Posta> postas;
  const MapaCalorPage({super.key, required this.postas});

  @override
  State<MapaCalorPage> createState() => _MapaCalorPageState();
}

class _MapaCalorPageState extends State<MapaCalorPage> {
  PostaStatus? _filtroActivo;
  late final MapController _mapController;

  @override
  void initState() {
    super.initState();
    _mapController = MapController();
  }

  List<Posta> get _postasFiltradas {
    if (_filtroActivo == null) return widget.postas;
    return widget.postas.where((p) => p.status == _filtroActivo).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _MapaControlBar(
          filtroActivo: _filtroActivo,
          onFiltroChanged: (f) => setState(() => _filtroActivo = f),
        ),
        Expanded(
          child: _MapaBody(
            postas: _postasFiltradas,
            mapController: _mapController,
          ),
        ),
      ],
    );
  }
}

// ─── Barra de leyenda + filtros ───────────────────────────────────────────────
class _MapaControlBar extends StatelessWidget {
  final PostaStatus? filtroActivo;
  final ValueChanged<PostaStatus?> onFiltroChanged;

  const _MapaControlBar({
    required this.filtroActivo,
    required this.onFiltroChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _MapaLeyenda(),
          const SizedBox(height: 10),
          _MapaFiltros(
            filtroActivo: filtroActivo,
            onFiltroChanged: onFiltroChanged,
          ),
        ],
      ),
    );
  }
}

class _MapaLeyenda extends StatelessWidget {
  const _MapaLeyenda();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: const [
        _LeyendaItem(color: _kRed, label: 'Crítico'),
        SizedBox(width: 20),
        _LeyendaItem(color: _kOrange, label: 'Moderado'),
        SizedBox(width: 20),
        _LeyendaItem(color: _kGreen, label: 'Bien'),
      ],
    );
  }
}

class _LeyendaItem extends StatelessWidget {
  final Color color;
  final String label;
  const _LeyendaItem({required this.color, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 5),
        Text(label, style: const TextStyle(fontSize: 13, color: _kNavy)),
      ],
    );
  }
}

class _MapaFiltros extends StatelessWidget {
  final PostaStatus? filtroActivo;
  final ValueChanged<PostaStatus?> onFiltroChanged;

  const _MapaFiltros({
    required this.filtroActivo,
    required this.onFiltroChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          _FiltroChip(
            label: 'Todas',
            isActive: filtroActivo == null,
            activeColor: _kBlue,
            onTap: () => onFiltroChanged(null),
          ),
          const SizedBox(width: 8),
          _FiltroChip(
            label: 'Crítico',
            isActive: filtroActivo == PostaStatus.critico,
            activeColor: _kRed,
            dotColor: _kRed,
            onTap: () => onFiltroChanged(PostaStatus.critico),
          ),
          const SizedBox(width: 8),
          _FiltroChip(
            label: 'Moderado',
            isActive: filtroActivo == PostaStatus.moderado,
            activeColor: _kOrange,
            dotColor: _kOrange,
            onTap: () => onFiltroChanged(PostaStatus.moderado),
          ),
          const SizedBox(width: 8),
          _FiltroChip(
            label: 'Bien',
            isActive: filtroActivo == PostaStatus.bajo,
            activeColor: _kGreen,
            dotColor: _kGreen,
            onTap: () => onFiltroChanged(PostaStatus.bajo),
          ),
        ],
      ),
    );
  }
}

class _FiltroChip extends StatelessWidget {
  final String label;
  final bool isActive;
  final Color activeColor;
  final Color? dotColor;
  final VoidCallback onTap;

  const _FiltroChip({
    required this.label,
    required this.isActive,
    required this.activeColor,
    this.dotColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
        decoration: BoxDecoration(
          color: isActive ? activeColor : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isActive ? activeColor : const Color(0xFFD0D9E4),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (!isActive && dotColor != null) ...[
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(color: dotColor, shape: BoxShape.circle),
              ),
              const SizedBox(width: 5),
            ],
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: isActive ? Colors.white : const Color(0xFF6B7D8F),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Cuerpo del mapa ──────────────────────────────────────────────────────────
class _MapaBody extends StatelessWidget {
  final List<Posta> postas;
  final MapController mapController;

  const _MapaBody({required this.postas, required this.mapController});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        FlutterMap(
          mapController: mapController,
          options: const MapOptions(
            initialCenter: LatLng(-12.095, -77.055),
            initialZoom: 12.5,
          ),
          children: [
            TileLayer(
              urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
              userAgentPackageName: 'com.ferova.clinic',
            ),
            CircleLayer(
              circles: postas
                  .map(
                    (p) => CircleMarker(
                      point: LatLng(p.latitude, p.longitude),
                      radius: 1500,
                      useRadiusInMeter: true,
                      color: _statusColor(p.status).withValues(alpha: 0.25),
                      borderColor: _statusColor(p.status).withValues(alpha: 0.7),
                      borderStrokeWidth: 2,
                    ),
                  )
                  .toList(),
            ),
            MarkerLayer(
              markers: postas
                  .map(
                    (p) => Marker(
                      point: LatLng(p.latitude, p.longitude),
                      width: 140,
                      height: 50,
                      alignment: Alignment.bottomCenter,
                      child: _PostaMapMarker(posta: p),
                    ),
                  )
                  .toList(),
            ),
          ],
        ),
        Positioned(
          bottom: 16,
          left: 16,
          child: _ZoomControls(mapController: mapController),
        ),
        if (postas.isEmpty) const _EmptyFiltroMessage(),
      ],
    );
  }
}

// ─── Marcador en el mapa ──────────────────────────────────────────────────────
class _PostaMapMarker extends StatelessWidget {
  final Posta posta;
  const _PostaMapMarker({required this.posta});

  @override
  Widget build(BuildContext context) {
    final color = _statusColor(posta.status);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _PostaLabel(name: posta.shortName, color: color),
        const SizedBox(height: 3),
        Container(
          width: 14,
          height: 14,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: color.withValues(alpha: 0.5),
                blurRadius: 6,
                spreadRadius: 1,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _PostaLabel extends StatelessWidget {
  final String name;
  final Color color;
  const _PostaLabel({required this.name, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.15),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Text(
        name,
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w700,
          color: color,
        ),
      ),
    );
  }
}

// ─── Controles de zoom ────────────────────────────────────────────────────────
class _ZoomControls extends StatelessWidget {
  final MapController mapController;
  const _ZoomControls({required this.mapController});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.15),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _ZoomButton(
            icon: Icons.add_rounded,
            onTap: () => mapController.move(
              mapController.camera.center,
              mapController.camera.zoom + 1,
            ),
          ),
          const Divider(height: 1, thickness: 1, color: Color(0xFFE0E0E0)),
          _ZoomButton(
            icon: Icons.remove_rounded,
            onTap: () => mapController.move(
              mapController.camera.center,
              mapController.camera.zoom - 1,
            ),
          ),
        ],
      ),
    );
  }
}

class _ZoomButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  const _ZoomButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: 36,
        height: 36,
        child: Icon(icon, size: 20, color: _kNavy),
      ),
    );
  }
}

// ─── Mensaje filtro vacío ─────────────────────────────────────────────────────
class _EmptyFiltroMessage extends StatelessWidget {
  const _EmptyFiltroMessage();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.92),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 8,
            ),
          ],
        ),
        child: const Text(
          'No hay postas con este filtro',
          style: TextStyle(fontSize: 14, color: _kNavy),
        ),
      ),
    );
  }
}
