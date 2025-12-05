import 'package:flutter/material.dart';
import 'package:yes_no_app/presentation/widgets/bienestar/semaforo_widget.dart';
import 'package:yes_no_app/config/helpers/bienestar_service.dart'; 
import 'package:yes_no_app/presentation/widgets/bienestar/grafica_emocional_widget.dart';
import 'package:yes_no_app/infrastructure/models/bienestar_model.dart';
import 'package:yes_no_app/config/helpers/secure_storage_service.dart';
import 'package:yes_no_app/presentation/widgets/bienestar/crisis_modal_helper.dart';
import 'package:yes_no_app/presentation/widgets/bienestar/control_widget.dart';

class BienestarEmocionalScreen extends StatefulWidget {
  const BienestarEmocionalScreen({super.key});

  @override
  State<BienestarEmocionalScreen> createState() => _BienestarEmocionalScreenState();
}

class _BienestarEmocionalScreenState extends State<BienestarEmocionalScreen> {
  EstadoSemaforo? _estadoActual;
  bool _cargando = true;
  bool _cargandoSemaforo = true;
  bool _cargandoGrafica = true;
  bool _modalMostrado = false; 
  final bienestarService = BienestarService();
  List<DatoGrafica>? _datosSemanales;

  DateTime? _fechaInscripcion;
  DateTime _fechaInicioSemanaActual = DateTime.now();
  bool _navegandoEntreSemanas = false;

 
  @override
  void initState() {
    super.initState();
    _fechaInicioSemanaActual = _obtenerInicioSemana(DateTime.now());
    _cargarFechaInscripcion();
    _cargarTodo();
  }


  Future<void> _cargarFechaInscripcion() async {
      _fechaInscripcion = await SecureStorageService.getFechaInscripcion();
  }

  // Obtener inicio de semana
  DateTime _obtenerInicioSemana(DateTime fecha) {
    return fecha.subtract(Duration(days: fecha.weekday - 1));
  }

 
  // Navegar a semana anterior
  void _semanaAnterior() {
    if (!_puedeIrAnterior()) return;
    final nuevaFecha = _fechaInicioSemanaActual.subtract(const Duration(days: 7));
    _cargarDatosSemanalesPorFecha(nuevaFecha); 
  }

  //Navegar a semana siguiente
   void _semanaSiguiente() {
    if (!_puedeIrSiguiente()) return;
    final nuevaFecha = _fechaInicioSemanaActual.add(const Duration(days: 7));
    _cargarDatosSemanalesPorFecha(nuevaFecha); 
  }

  bool _puedeIrAnterior() {
    if (_fechaInscripcion == null) return false;
    final inicioSemanaInscripcion = _obtenerInicioSemana(_fechaInscripcion!);
    final inicioSemanaAnterior = _fechaInicioSemanaActual.subtract(const Duration(days: 7));
    return !inicioSemanaAnterior.isBefore(inicioSemanaInscripcion);
  }

  bool _puedeIrSiguiente() {
    
    final inicioSemanaActual = _obtenerInicioSemana(DateTime.now());
    final inicioSemanaSiguiente = _fechaInicioSemanaActual.add(const Duration(days: 7));
    return inicioSemanaSiguiente.isBefore(inicioSemanaActual);
  }

  // Navegar a la semana actual
   void _irAHoy() {
    final hoy = _obtenerInicioSemana(DateTime.now());
    _cargarDatosSemanalesPorFecha(hoy); 
  }


  Future<void> _cargarDatosSemanalesPorFecha(DateTime fechaInicio) async {
    try {
      setState(() {
        _navegandoEntreSemanas = true;
        _cargandoGrafica = true;
      });

      final token = await _obtenerToken();
      if (token != null) {
        final fechaFin = fechaInicio.add(const Duration(days: 6));
        
        final startDate = '${fechaInicio.year}-${fechaInicio.month.toString().padLeft(2, '0')}-${fechaInicio.day.toString().padLeft(2, '0')}';
        final endDate = '${fechaFin.year}-${fechaFin.month.toString().padLeft(2, '0')}-${fechaFin.day.toString().padLeft(2, '0')}';
        
        final weekData = await bienestarService.obtenerNivelesSemanales(
          token: token,
          startDate: startDate,
          endDate: endDate,
        );
        
        setState(() {
          _datosSemanales = weekData.toDatosGrafica();
          _fechaInicioSemanaActual = fechaInicio;
          _cargandoGrafica = false;
          _navegandoEntreSemanas = false;
          _actualizarEstadoCarga();
        });
      } else {
        setState(() {
          _cargandoGrafica = false;
          _navegandoEntreSemanas = false;
          _actualizarEstadoCarga();
        });
      }
    } catch (e) {
      setState(() {
        _cargandoGrafica = false;
        _navegandoEntreSemanas = false;
        _actualizarEstadoCarga();
      });
    }
  }

  Future<void> _cargarTodo() async {
    setState(() {
      _cargando = true;
      _cargandoSemaforo = true;
      _cargandoGrafica = true;
      _modalMostrado = false; 
    });
    
    await Future.wait([
      _cargarEstadoEmocional(),
      _cargarDatosSemanales(),
    ]);
  }
  
  Future<void> _cargarDatosSemanales() async {
    try {
      final token = await _obtenerToken();
      if (token != null) {
        final now = DateTime.now();
        final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
        final endOfWeek = startOfWeek.add(Duration(days: 6));
        
        final startDate = '${startOfWeek.year}-${startOfWeek.month.toString().padLeft(2, '0')}-${startOfWeek.day.toString().padLeft(2, '0')}';
        final endDate = '${endOfWeek.year}-${endOfWeek.month.toString().padLeft(2, '0')}-${endOfWeek.day.toString().padLeft(2, '0')}';
        
        final weekData = await bienestarService.obtenerNivelesSemanales(
          token: token,
          startDate: startDate,
          endDate: endDate,
        );
        
        setState(() {
          _datosSemanales = weekData.toDatosGrafica();
          _cargandoGrafica = false;
          _actualizarEstadoCarga();
        });
        
      } else {
        setState(() {
          _cargandoGrafica = false;
          _actualizarEstadoCarga();
        });
      }
    } catch (e) {
      setState(() {
        _cargandoGrafica = false;
        _actualizarEstadoCarga();
      });
    }
  }

  Future<void> _cargarEstadoEmocional() async {
    try {
      final token = await _obtenerToken();
      if (token != null) {
        final estado = await bienestarService.obtenerEstadoSemaforoSeguro(token);

        setState(() {
          //Para pruebas
          // _estadoActual = EstadoSemaforo.rojo;
          
          //Producción
          _estadoActual = estado ?? EstadoSemaforo.verde;
          
          _cargandoSemaforo = false;
          _actualizarEstadoCarga();
        });

        // Mostrar modal si está en crisis 
        if (mounted && _estadoActual == EstadoSemaforo.rojo && !_modalMostrado) {
          _modalMostrado = true;
          Future.delayed(const Duration(milliseconds: 300), () {
            if (mounted) {
              CrisisModalHelper.showCrisisModal(context);
            }
          });
        }

      } else {
        setState(() {
          _estadoActual = EstadoSemaforo.verde; 
          _cargandoSemaforo = false;
          _actualizarEstadoCarga();
        });
      }
    } catch (e) {
     
      setState(() {
        _estadoActual = EstadoSemaforo.verde; 
        _cargandoSemaforo = false;
        _actualizarEstadoCarga();
      });
    }
  }

  void _actualizarEstadoCarga() {
    if (!_cargandoSemaforo && !_cargandoGrafica) {
      setState(() {
        _cargando = false;
      });
    }
  }

  Future<String?> _obtenerToken() async {
    try {
      return await SecureStorageService.getToken();
    } catch (e) {
 
      return null;
    }
  }
 
  @override
Widget build(BuildContext context) {

  return Scaffold(
    backgroundColor: Colors.white,
    appBar: _buildAppBar(context),
    body: _buildBody(context),
    floatingActionButton: FloatingActionButton(
      mini: true,
      backgroundColor: const Color(0xFFF35449),
      onPressed: () {
        _cargarTodo();
      },
      child: const Icon(Icons.refresh, color: Colors.white),
    ),
    floatingActionButtonLocation: FloatingActionButtonLocation.endDocked, 
  );
}

  // App bar
  PreferredSizeWidget _buildAppBar(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isTablet = screenWidth > 600;
    final isLandscape = MediaQuery.of(context).orientation == Orientation.landscape;

    final toolbarHeight = isLandscape ? 100.0 : (isTablet ? 160.0 : 140.0);
    final iconSize = isTablet ? 22.0 : (isLandscape ? 18.0 : 20.0);

    return AppBar(
      backgroundColor: const Color(0xFFF35449),
      elevation: 2,
      shadowColor: Colors.black.withValues(alpha: 0.3),
      toolbarHeight: toolbarHeight,
      automaticallyImplyLeading: false,
      titleSpacing: 0,
      leading: IconButton(
        icon: Icon(
          Icons.arrow_back_ios_new_rounded,
          color: Colors.white,
          size: isTablet ? 24.0 : (isLandscape ? 18.0 : 20.0),
        ),
        onPressed: () => Navigator.pop(context),
      ),
      title: _buildAppBarContent(context),
      centerTitle: true,
      actions: [
        // Botón SOS 
        if (_estadoActual == EstadoSemaforo.rojo && !_cargando)
          Container(
            margin: EdgeInsets.only(right: isTablet ? 12.0 : 8.0),
            child: IconButton(
              icon: Container(
                padding: EdgeInsets.all(isTablet ? 12.0 : 10.0),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.3),
                    width: 2,
                  ),
                ),
                child: Icon(
                  Icons.error,
                  color: Colors.white,
                  size: iconSize,
                ),
              ),
              tooltip: 'Ver recursos de apoyo',
              onPressed: () {
                CrisisModalHelper.showCrisisModal(context);
              },
            ),
          ),
      ],
    );
  }


Widget _buildAppBarContent(BuildContext context) {
  final screenWidth = MediaQuery.of(context).size.width;
  final isTablet = screenWidth > 600;
  final isLandscape = MediaQuery.of(context).orientation == Orientation.landscape;

  final avatarSize = isLandscape ? 65.0 : (isTablet ? 75.0 : 65.0);
  final titleFontSize = isTablet ? 25.0 : (isLandscape ? 21.0 : 23.0);
  final subtitleFontSize = isTablet ? 20.0 : (isLandscape ? 16.0 : 18.0);
  final spacing = isTablet ? 12.0 : (isLandscape ? 8.0 : 10.0);
  final borderWidth = isTablet ? 3.0 : 2.0;
  final iconSize = isTablet ? 50.0 : (isLandscape ? 30.0 : 40.0);

  return Row(
    mainAxisAlignment: MainAxisAlignment.start,
    crossAxisAlignment: CrossAxisAlignment.center,
    mainAxisSize: MainAxisSize.min,
    children: [
      Container(
        width: avatarSize,  
        height: avatarSize, 
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.2),
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white, width: borderWidth),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.2),
              blurRadius: isTablet ? 8 : 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Padding(
          padding: EdgeInsets.all(isTablet ? 6 : 4), 
          child: ClipOval(
            child: Image.asset(
              'assets/images/mascota.png',
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(
                color: Colors.white.withValues(alpha: 0.1),
                child: Icon(
                  Icons.emoji_emotions,
                  color: Colors.white,
                  size: iconSize, 
                ),
              ),
            ),
          ),
        ),
      ),
      SizedBox(width: spacing), 
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Tu bienestar',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: titleFontSize, 
              color: Colors.white,
              height: 1.1,
            ),
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
          ),
          SizedBox(height: isLandscape ? 1 : 2),
          Text(
            'importa 💖',
            style: TextStyle(
              fontWeight: FontWeight.w400,
              fontSize: subtitleFontSize,
              color: Colors.white.withValues(alpha: 0.95),
            ),
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
          ),
        ],
      ),
    ],
  );
}

// Cuerpo principal
Widget _buildBody(BuildContext context) {
  final screenWidth = MediaQuery.of(context).size.width;
  final isTablet = screenWidth > 600;
  final isLandscape = MediaQuery.of(context).orientation == Orientation.landscape;

  final maxWidth = isTablet ? 800.0 : screenWidth;
  final padding = isTablet ? 24.0 : (isLandscape ? 12.0 : 20.0);
  final spacing = isTablet ? 24.0 : (isLandscape ? 16.0 : 20.0);

  return Center(
    child: ConstrainedBox(
      constraints: BoxConstraints(maxWidth: maxWidth),
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: EdgeInsets.all(padding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (_cargando)
                Center(
                  child: Padding(
                    padding: const EdgeInsets.all(40),
                    child: Column(
                      children: [
                        const CircularProgressIndicator(
                          color: Color(0xFFF35449),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Analizando tu estado emocional...',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              else ...[
                // Semaforo
                _buildSectionTitle(
                  icon: Icons.traffic,
                  title: 'Estado Emocional Actual',
                  isTablet: isTablet,
                  isLandscape: isLandscape,
                ),
                SizedBox(height: spacing * 0.5),
                SemaforoWidget(
                  estadoActual: _estadoActual ?? EstadoSemaforo.verde,
                  showAnimation: true,
                ),
                
                SizedBox(height: spacing * 0.5),

                // Gráfica con navegación
                _buildSectionTitle(
                  icon: Icons.show_chart,
                  title: 'Evolución Semanal',
                  isTablet: isTablet,
                  isLandscape: isLandscape,
                ),
                SizedBox(height: spacing * 0.5),
                
                // Controles de navegación
                NavigationControlsWidget(
                  fechaInicioSemana: _fechaInicioSemanaActual,
                  puedeAnterior: _puedeIrAnterior(),
                  puedeSiguiente: _puedeIrSiguiente(),
                  cargando: _navegandoEntreSemanas,
                  onAnterior: _semanaAnterior,
                  onSiguiente: _semanaSiguiente,
                  onHoy: _irAHoy,
                ),
                
                SizedBox(height: 8),
                
                // Tu gráfica actual
                if (_navegandoEntreSemanas)
                  SizedBox(
                    height: 200,
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircularProgressIndicator(
                            color: Color(0xFFF35449),
                          ),
                          SizedBox(height: 16),
                          Text(
                            'Cargando semana...',
                            style: TextStyle(
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                else
                  GraficaEmocionalWidget(datos: _datosSemanales),
                
                SizedBox(height: spacing),
              ],
              SizedBox(height: isTablet ? 24 : 16),
            ],
          ),
        ),
      ),
    ),
  );
}


  Widget _buildSectionTitle({
    required IconData icon,
    required String title,
    required bool isTablet,
    required bool isLandscape,
  }) {
    final fontSize = isTablet ? 20.0 : (isLandscape ? 16.0 : 18.0);
    final iconSize = isTablet ? 24.0 : (isLandscape ? 18.0 : 20.0);

    return Row(
      children: [
        Icon(
          icon,
          color: const Color(0xFFF35449),
          size: iconSize,
        ),
        const SizedBox(width: 8),
        Text(
          title,
          style: TextStyle(
            fontSize: fontSize,
            fontWeight: FontWeight.bold,
            color: Colors.grey[800],
          ),
        ),
      ],
    );
  }
}

