#!/bin/env ruby
# encoding: utf-8
#Proyecto: Qytetet - PDOO
#Alumno: David Infante Casas
#ETSIIT, UGR, Granada, España

require_relative "qytetet"
require_relative "casilla"
require_relative "calle"
require_relative "jugador"
require_relative "especulador"
require_relative "metodo_salir_carcel"

module InterfazTextualQytetet
  
  class ControladorQytetet
    include ModeloQytetet
    
    def initialize
      @juego = Qytetet.instance
      @vista = VistaTextualQytetet.new
    end
    
    def inicializacion_juego
      @juego.inicializar_juego(@vista.obtener_nombre_jugadores)
      @jugador_actual = @juego.jugador_actual
      puts @jugador_actual.casilla_actual
      @casilla = @jugador_actual.casilla_actual
      
      @juego.to_s
      @vista.pause
    end
    
    def main
      inicializacion_juego
      desarrollo_juego
    end
    
    def desarrollo_juego
      end_game = false
      while(!end_game)
        @vista.end_turn_line
        turno = turno_jugador
        if (turno)
          end_game = true
        end
        @vista.informacion_jugador(@jugador_actual)
        if (!end_game)
          cambiar_turno
        end
        if (!end_game)
          @vista.pause
        end
      end
      fin_del_juego
    end
    
    #****************************************************
    
    def turno_jugador #2
      @vista.inicio_turno(@jugador_actual)
      end_game = movimiento
      gestion_inmobiliaria
      return end_game
    end
    
    def movimiento #2.1
      libre = movimiento_si_carcel
      end_game = false
      if (libre)
        end_game = movimiento_no_carcel
      end
      return end_game#true->fin false->continua
    end
    
    def gestion_inmobiliaria #2.2
      if (!@jugador_actual.encarcelado && !@jugador_actual.bancarrota && @jugador_actual.tengo_propiedades)
        props = []
        casilla_elegida = nil

        loop do
          opcion = @vista.menu_gestion_inmobiliaria
          case opcion
            when 1
              props = @jugador_actual.get_propiedades(1)
              propiedad_elegida = @vista.menu_elegir_propiedad(props)
              if (propiedad_elegida != props.size)
                casilla_elegida = @jugador_actual.search_casilla(props.at(propiedad_elegida))
                @vista.puedo_construir(1, @juego.edificar_casa(casilla_elegida))
              end
            when 2
              props = @jugador_actual.get_propiedades(2)
              propiedad_elegida = @vista.menu_elegir_propiedad(props)
              if (propiedad_elegida != props.size)
                casilla_elegida = @jugador_actual.search_casilla(props.at(propiedad_elegida))
                @vista.puedo_construir(2, @juego.edificar_hotel(casilla_elegida))
              end
            when 3
              props = @jugador_actual.get_propiedades(3)
              propiedad_elegida = @vista.menu_elegir_propiedad(props)
              if (propiedad_elegida != props.size)
                casilla_elegida = @jugador_actual.search_casilla(props.at(propiedad_elegida))
                @vista.puedo_construir(3, @juego.vender_propiedad(casilla_elegida))
              end
            when 4
              props = @jugador_actual.get_propiedades(4)
              propiedad_elegida = @vista.menu_elegir_propiedad(props)
              if (propiedad_elegida != props.size)
                casilla_elegida = @jugador_actual.search_casilla(props.at(propiedad_elegida))
                @vista.puedo_construir(4, @juego.hipotecar_propiedad(casilla_elegida))
              end
            when 5
              props = @jugador_actual.get_propiedades(5)
              propiedad_elegida = @vista.menu_elegir_propiedad(props)
              if (propiedad_elegida != props.size)
                casilla_elegida = @jugador_actual.search_casilla(props.at(propiedad_elegida))
                @vista.puedo_construir(5, @juego.cancelar_hipoteca(casilla_elegida))
              end
          end
          @vista.saldo_jugador(@jugador_actual)
          break if (opcion == 0)
        end
      end
    end
    
    def movimiento_si_carcel #2.1.A
      if (@jugador_actual.encarcelado)
        opcion = @vista.menu_salir_carcel
        if (opcion == 1)
          salgo_carcel = @juego.intentar_salir_carcel(MetodoSalirCarcel::PAGANDOLIBERTAD)
        else
          salgo_carcel = @juego.intentar_salir_carcel(MetodoSalirCarcel::TIRANDODADO)
        end
        @vista.has_salido_carcel(salgo_carcel)
        return salgo_carcel#Si he salido o no true->si, false->no
      end
      return true#No estaba en la cárcel
    end
    
    def movimiento_no_carcel #2.1.B
      if (!@jugador_actual.encarcelado)
        if (@juego.jugar)
          @casilla = @jugador_actual.casilla_actual
          @vista.informacion_casilla(@casilla, @jugador_actual)
          if (@casilla.tipo == TipoCasilla::SORPRESA)
            @vista.informacion_sorpresa(@juego.carta_actual)
            @juego.aplicar_sorpresa
            if (@juego.carta_actual.tipo == TipoSorpresa::CONVERTIRME)
              @jugador_actual = @juego.jugador_actual
            end
          end
          if (@casilla.tipo == TipoCasilla::CALLE && !@casilla.tengo_propietario && @jugador_actual.tengo_saldo(@casilla.coste))
            if (@vista.elegir_quiero_comprar(@casilla))
              @jugador_actual.comprar_titulo
            end
          end
          if (@jugador_actual.bancarrota)
            return true#Se acaba el juego
          end
        end
      end
      return false#Continua el juego
    end
    
    
    def cambiar_turno #3
      @juego.siguiente_jugador
      @jugador_actual = @juego.jugador_actual
    end
    
    def fin_del_juego #4
      @vista.end_turn_line
      ranking = @juego.obtener_ranking
      @vista.fin_del_juego(ranking, @juego)
      @vista.pause
      exit(0)
    end
    
    #****************************************************
    
    def elegir_propiedad(propiedades) # lista de propiedades a elegir
      @vista.mostrar("\tCasilla\tTitulo")
      listaPropiedades= Array.new
      for prop in propiedades  # crea una lista de strings con numeros y nombres de propiedades
        propString= prop.numero_casilla.to_s+' '+prop.titulo.nombre
        listaPropiedades<<propString
      end
      seleccion=@vista.menu_elegir_propiedad(listaPropiedades)  # elige de esa lista del menu
      propiedades.at(seleccion)
    end
    
  end#class ControladorQytetet
end#module InterfazTextualQytetet