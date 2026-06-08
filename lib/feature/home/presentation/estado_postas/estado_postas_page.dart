import 'package:flutter/material.dart';
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

// ─── Página Estado de Postas ──────────────────────────────────────────────────
class EstadoPostasPage extends StatelessWidget {
  final List<Posta> postas;
  const EstadoPostasPage({super.key, required this.postas});

  double get _globalCoverage {
    if (postas.isEmpty) return 0;
    final sum = postas.fold(0.0, (acc, p) => acc + p.coveragePercentage);
    return sum / postas.length;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        backgroundColor: _kNavy,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_rounded, color: Colors.white, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Estado de Postas',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.insert_chart_outlined_rounded, color: Colors.white),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _AdherenciaGlobalCard(globalCoverage: _globalCoverage),
            const SizedBox(height: 16),
            _DetalleEstablecimientoCard(postas: postas),
          ],
        ),
      ),
    );
  }
}

// ─── Tarjeta Adherencia Global ────────────────────────────────────────────────
class _AdherenciaGlobalCard extends StatelessWidget {
  final double globalCoverage;
  const _AdherenciaGlobalCard({required this.globalCoverage});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'ADHERENCIA GLOBAL',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF9EAFC0),
                  letterSpacing: 0.8,
                ),
              ),
              const Icon(
                Icons.insert_chart_outlined_rounded,
                color: Color(0xFF9EAFC0),
                size: 20,
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            '${globalCoverage.toStringAsFixed(2)}%',
            style: const TextStyle(
              fontSize: 42,
              fontWeight: FontWeight.bold,
              color: _kBlue,
              height: 1.1,
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Tarjeta Detalle por Establecimiento ─────────────────────────────────────
class _DetalleEstablecimientoCard extends StatelessWidget {
  final List<Posta> postas;
  const _DetalleEstablecimientoCard({required this.postas});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          _DetalleHeader(),
          const Divider(height: 1, thickness: 1, color: Color(0xFFF0F5FA)),
          ...postas.map((p) => _EstablecimientoItem(posta: p)),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}

class _DetalleHeader extends StatelessWidget {
  const _DetalleHeader();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 12, 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'Detalle por Establecimiento',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: _kNavy,
            ),
          ),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: _kBlue,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
              minimumSize: Size.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              elevation: 0,
            ),
            child: const Text('Exportar', style: TextStyle(fontSize: 13)),
          ),
        ],
      ),
    );
  }
}

class _EstablecimientoItem extends StatelessWidget {
  final Posta posta;
  const _EstablecimientoItem({required this.posta});

  @override
  Widget build(BuildContext context) {
    final color = _statusColor(posta.status);

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Row(
            children: [
              Container(
                width: 18,
                height: 18,
                decoration: BoxDecoration(color: color, shape: BoxShape.circle),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      posta.name,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: _kNavy,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      posta.location,
                      style: const TextStyle(fontSize: 12, color: Color(0xFF9EAFC0)),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Text(
                '${posta.coveragePercentage.toStringAsFixed(0)}%',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
            ],
          ),
        ),
        const Divider(height: 1, thickness: 1, color: Color(0xFFF0F5FA)),
      ],
    );
  }
}
