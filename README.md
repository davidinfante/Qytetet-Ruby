# Qytetet-Ruby

### Autor: David Infante Casas
### Fecha: 25/12/2017

Qytetet es una versión minimalista de Monopoly.  
Programado en Ruby and Rails y cuya interfaz es textual mediante la terminal.

### Organización de ficheros

- calle.rb: define la clase Calle y la interacción con los jugadores. Es subclase de casilla.
- casilla.rb: define la clase Casilla.
- controlador_qytetet.rb: define la clase ControladorQytetet. Es el bucle principal que desarrolla el juego.
- dado.rb: define la clase Dado.
- especulador.rb: define la clase Especulador. Es un tipo de jugador que cuenta con algunas ventajas sobre el resto de jugadores.
- jugador.rb: define la clase Jugador. Especifica los comportamientos y estadísticas de un jugador.
- metodo_salir_carcel.rb: define el enumerado MetodoSalirCarcel.
- prueba_qytetet.rb: define la clase PruebaQytetet. Incluye el "main".
- qytetet.rb: define la clase Qytetet. Controla eventos del juego.
- sorpresa.rb: define la clase Sorpresa. Se trata de la clase para las carta sorpresa.
- tablero.rb: define la clase Tablero. Inicializa el tablero del juego con sus casillas.
- tipo_casilla.rb: define el enumerado TipoCasilla.
- tipo_sorpresa.rb: define el enumerado TipoSorpresa.
- titulo_propiedad.rb: define la clase TituloPropiedad. Sirve de unión entre el jugador y la casilla a la que pertenece el título.
- vista_textual_qytetet.rb: define la clase VistaTextualQytetet. Contiene métodos para todo los mensajes que se muestran en la terminal.
