import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ferova_clinic_flutter/core/di/dependency_injection.dart';
import 'package:ferova_clinic_flutter/feature/auth/domain/user.dart';
import 'package:ferova_clinic_flutter/feature/home/domain/posta.dart';
import '../../../auth/presentation/login/login_page.dart';
import 'admin_home_state.dart';
import 'admin_home_view_model.dart';
import '../estado_postas/estado_postas_page.dart';
import '../estado_postas/estado_postas_view_model.dart';
import '../mapa_calor/mapa_calor_page.dart';

// ─── Colores compartidos ─────────────────────────────────────────────────────
const _kNavy = Color(0xFF1A3A5C);
const _kBlue = Color(0xFF0D6EA8);
const _kBg = Color(0xFFF5F7FA);
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

// ─── AppBar del Home ─────────────────────────────────────────────────────────
class _HomeAppBar extends StatelessWidget implements PreferredSizeWidget {
  const _HomeAppBar();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    final viewModel = context.read<AdminHomeViewModel>(); // ← Obtener viewModel

    return AppBar(
      backgroundColor: _kNavy,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.logout_rounded, color: Colors.white, size: 20),
        onPressed: () => _logout(context, viewModel),
      ),
      title: const Text(
        'FerovaClinic',
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
      ),
      centerTitle: true,
      actions: [
        IconButton(
          icon: const Icon(Icons.person_outline_rounded, color: Colors.white),
          onPressed: () {},
        ),
      ],
    );
  }

  void _logout(BuildContext context, AdminHomeViewModel viewModel) async {
    // Diálogo de confirmación
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Cerrar sesión'),
        content: const Text('¿Estás seguro de que quieres salir?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Salir', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirm == true) {
      // Limpiar token usando el ViewModel
      await viewModel.logout();

      // Navegar al login y limpiar todo el stack
      if (context.mounted) {
        // Opción 1: Si tienes el widget de Login disponible
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (_) => const LoginPage()), // ← Usa tu LoginPage
              (route) => false,
        );
      }
    }
  }

}

// ─── AppBar del Mapa ─────────────────────────────────────────────────────────
class _MapaAppBar extends StatelessWidget implements PreferredSizeWidget {
  const _MapaAppBar();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: _kNavy,
      elevation: 0,
      automaticallyImplyLeading: false,
      title: const Text(
        'Mapa de Calor',
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
      ),
      centerTitle: true,
    );
  }
}

// ─── AppBar de Postas ─────────────────────────────────────────────────────────
class _PostasAppBar extends StatelessWidget implements PreferredSizeWidget {
  const _PostasAppBar();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: _kNavy,
      elevation: 0,
      automaticallyImplyLeading: false,
      title: const Text(
        'Postas',
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
      ),
      centerTitle: true,
    );
  }
}

// ─── Página principal ────────────────────────────────────────────────────────
class AdminHomePage extends StatefulWidget {
  final User user;
  const AdminHomePage({super.key, required this.user});

  @override
  State<AdminHomePage> createState() => _AdminHomePageState();
}

class _AdminHomePageState extends State<AdminHomePage> {
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AdminHomeViewModel>().init(widget.user);
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AdminHomeViewModel>().state;

    return Scaffold(
      backgroundColor: _kBg,
      appBar: switch (_selectedIndex) {
        1 => const _MapaAppBar(),
        2 => const _PostasAppBar(),
        _ => const _HomeAppBar(),
      },
      body: IndexedStack(
        index: _selectedIndex,
        children: [
          _HomeTab(state: state),
          MapaCalorPage(postas: state.heatmapPostas),
          const _PostasTab(),
        ],
      ),
      bottomNavigationBar: _AdminBottomNav(
        selectedIndex: _selectedIndex,
        onTap: (i) => setState(() => _selectedIndex = i),
      ),
    );
  }
}

// ─── Bottom Navigation ───────────────────────────────────────────────────────
class _AdminBottomNav extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onTap;

  const _AdminBottomNav({required this.selectedIndex, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: selectedIndex,
      onTap: onTap,
      backgroundColor: Colors.white,
      selectedItemColor: _kBlue,
      unselectedItemColor: const Color(0xFF9EAFC0),
      selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 11),
      unselectedLabelStyle: const TextStyle(fontSize: 11),
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home_rounded),
          label: 'Inicio',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.map_rounded),
          label: 'Mapa',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.local_hospital_rounded),
          label: 'Postas',
        ),
      ],
    );
  }
}

// ─── Tab: Inicio ─────────────────────────────────────────────────────────────
class _HomeTab extends StatelessWidget {
  final AdminHomeState state;
  const _HomeTab({required this.state});

  @override
  Widget build(BuildContext context) {
    if (state.isLoading) {
      return const Center(child: CircularProgressIndicator(color: _kBlue));
    }

    return RefreshIndicator(
      color: _kBlue,
      onRefresh: () => context.read<AdminHomeViewModel>().refresh(),
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _GreetingCard(user: state.user),
            const SizedBox(height: 16),
            _StatsRow(
              postasActivas: state.summary.totalActiveFacilities,
              postasConAlerta: state.summary.totalCriticalFacilities,
            ),
            const SizedBox(height: 16),
            _AdherenciaCard(
              postas: state.topPostas,
              globalCoverage: state.summary.globalAdherenceRate,
            ),
            const SizedBox(height: 16),
            _EstadoPostasCard(
              postas: state.topPostas,
              globalAdherence: state.summary.globalAdherenceRate,
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}

// ─── Tarjeta de saludo ────────────────────────────────────────────────────────
class _GreetingCard extends StatelessWidget {
  final User? user;
  const _GreetingCard({required this.user});

  String get _greeting {
    final h = DateTime.now().hour;
    if (h < 12) return 'Buenos días';
    if (h < 18) return 'Buenas tardes';
    return 'Buenas noches';
  }

  String get _formattedDate {
    final now = DateTime.now();
    const months = [
      '', 'enero', 'febrero', 'marzo', 'abril', 'mayo', 'junio',
      'julio', 'agosto', 'septiembre', 'octubre', 'noviembre', 'diciembre',
    ];
    const weekdays = ['lunes', 'martes', 'miércoles', 'jueves', 'viernes', 'sábado', 'domingo'];
    final day = weekdays[now.weekday - 1];
    final capitalDay = day[0].toUpperCase() + day.substring(1);
    return '$capitalDay ${now.day} de ${months[now.month]} ${now.year}';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
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
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: '$_greeting, ',
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w600,
                    color: _kBlue,
                  ),
                ),
                TextSpan(
                  text: user?.name ?? '',
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w600,
                    color: _kNavy,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 4),
          RichText(
            text: const TextSpan(
              children: [
                TextSpan(
                  text: 'Coordinador ',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: _kNavy,
                  ),
                ),
                TextSpan(
                  text: 'MINSA',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: _kRed,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 4),
          Text(
            _formattedDate,
            style: const TextStyle(fontSize: 12, color: Color(0xFF9EAFC0)),
          ),
        ],
      ),
    );
  }
}

// ─── Fila de estadísticas ────────────────────────────────────────────────────
class _StatsRow extends StatelessWidget {
  final int postasActivas;
  final int postasConAlerta;

  const _StatsRow({required this.postasActivas, required this.postasConAlerta});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _StatCard(
            value: postasActivas,
            label: 'Postas Activas',
            icon: Icons.local_hospital_rounded,
            iconColor: _kRed,
            iconBg: const Color(0xFFFDEAEA),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _StatCard(
            value: postasConAlerta,
            label: 'Postas Críticas',
            icon: Icons.warning_amber_rounded,
            iconColor: _kRed,
            iconBg: const Color(0xFFFDEAEA),
          ),
        ),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  final int value;
  final String label;
  final IconData icon;
  final Color iconColor;
  final Color iconBg;

  const _StatCard({
    required this.value,
    required this.label,
    required this.icon,
    required this.iconColor,
    required this.iconBg,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
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
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(color: iconBg, borderRadius: BorderRadius.circular(10)),
            child: Icon(icon, color: iconColor, size: 22),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '$value',
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: _kNavy,
                ),
              ),
              Text(
                label,
                style: const TextStyle(fontSize: 11, color: Color(0xFF6B7D8F)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ─── Tarjeta de adherencia global ────────────────────────────────────────────
class _AdherenciaCard extends StatelessWidget {
  final List<Posta> postas;
  final double globalCoverage;

  const _AdherenciaCard({required this.postas, required this.globalCoverage});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
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
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _MiniBarChart(postas: postas),
                const SizedBox(height: 8),
                const Text(
                  'Adherencia global',
                  style: TextStyle(fontSize: 12, color: Color(0xFF6B7D8F)),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          Text(
            globalCoverage > 0
                ? '${globalCoverage.toStringAsFixed(2)}%'
                : '0',
            style: const TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.bold,
              color: _kBlue,
            ),
          ),
        ],
      ),
    );
  }
}

class _MiniBarChart extends StatelessWidget {
  final List<Posta> postas;
  const _MiniBarChart({required this.postas});

  @override
  Widget build(BuildContext context) {
    if (postas.isEmpty) {
      return const SizedBox(
        height: 60,
        child: Center(
          child: Icon(Icons.bar_chart_rounded, size: 40, color: Color(0xFFD0D9E4)),
        ),
      );
    }

    return SizedBox(
      height: 60,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: postas.map((p) => _MiniBar(posta: p)).toList(),
      ),
    );
  }
}

class _MiniBar extends StatelessWidget {
  final Posta posta;
  const _MiniBar({required this.posta});

  @override
  Widget build(BuildContext context) {
    final maxH = 50.0;
    final h = (maxH * posta.coveragePercentage / 100).clamp(4.0, maxH);

    return Padding(
      padding: const EdgeInsets.only(right: 6),
      child: Container(
        width: 20,
        height: h,
        decoration: BoxDecoration(
          color: _kBlue,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
        ),
      ),
    );
  }
}

// ─── Tarjeta Estado de Postas ─────────────────────────────────────────────────
class _EstadoPostasCard extends StatelessWidget {
  final List<Posta> postas;
  final double globalAdherence;
  const _EstadoPostasCard({required this.postas, required this.globalAdherence});

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
          _EstadoPostasHeader(postas: postas, globalAdherence: globalAdherence),
          if (postas.isEmpty)
            const _EmptyPostasState()
          else
            ...postas.map((p) => _PostaListItem(posta: p)),
          if (postas.isNotEmpty) const SizedBox(height: 8),
        ],
      ),
    );
  }
}

class _EstadoPostasHeader extends StatelessWidget {
  final List<Posta> postas;
  final double globalAdherence;
  const _EstadoPostasHeader({required this.postas, required this.globalAdherence});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 12, 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'Estado de Postas',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: _kBlue,
            ),
          ),
          if (postas.isNotEmpty)
            GestureDetector(
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => ChangeNotifierProvider(
                    create: (_) => getIt<EstadoPostasViewModel>()..load(),
                    child: EstadoPostasPage(globalAdherence: globalAdherence),
                  ),
                ),
              ),
              child: Row(
                children: const [
                  Text(
                    'Ver mas',
                    style: TextStyle(fontSize: 13, color: Color(0xFF6B7D8F)),
                  ),
                  SizedBox(width: 4),
                  Icon(Icons.arrow_forward_rounded, size: 16, color: Color(0xFF6B7D8F)),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

class _PostaListItem extends StatelessWidget {
  final Posta posta;
  const _PostaListItem({required this.posta});

  @override
  Widget build(BuildContext context) {
    final color = _statusColor(posta.status);

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
      child: Row(
        children: [
          Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  posta.name,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: _kNavy,
                  ),
                ),
                Text(
                  posta.location,
                  style: const TextStyle(fontSize: 11, color: Color(0xFF9EAFC0)),
                ),
              ],
            ),
          ),
          Text(
            '${posta.coveragePercentage.toStringAsFixed(0)}%',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}

class _EmptyPostasState extends StatelessWidget {
  const _EmptyPostasState();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 32),
      child: Center(
        child: Text(
          'No tienes postas asignadas',
          style: TextStyle(fontSize: 14, color: Colors.grey.shade400),
        ),
      ),
    );
  }
}

// ─── Tab: Postas (placeholder) ───────────────────────────────────────────────
class _PostasTab extends StatelessWidget {
  const _PostasTab();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.local_hospital_rounded, size: 64, color: Colors.grey.shade300),
          const SizedBox(height: 16),
          Text(
            'Módulo de Postas',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.grey.shade400),
          ),
          const SizedBox(height: 8),
          Text(
            'Próximamente',
            style: TextStyle(fontSize: 13, color: Colors.grey.shade400),
          ),
        ],
      ),
    );
  }
}
