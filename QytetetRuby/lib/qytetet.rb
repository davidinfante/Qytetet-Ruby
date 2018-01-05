#!/bin/env ruby
# encoding: utf-8
#Proyecto: Qytetet - PDOO
#Alumno: David Infante Casas
#ETSIIT, UGR, Granada, España

require "singleton"

module ModeloQytetet
  
  class Qytetet
    include Singleton
    attr_reader :carta_actual, :jugador_actual, :jugadores, :saldo_salida, :precio_libertad
    
    @@max_jugadores = 4
    @@max_cartas = 12
    @@max_casillas = 20
    @@precio_libertad = 200
    @@saldo_salida = 1000
    
    def initialize
      @tablero = nil
      @mazo = []
      @jugadores = []
      @jugador_actual = nil
      @carta_actual = nil
      @index_mazo = 0
      inicializar_tablero
      @dado = Dado.instance
    end
    
    def self.saldo_salida
      return @@saldo_salida
    end
    
    def get_saldo_salida
      return @@saldo_salida
    end
    
    def aplicar_sorpresa
      tiene_propietario = false
      if (@carta_actual.tipo == TipoSorpresa::PAGARCOBRAR)
        @jugador_actual.modificar_saldo(@carta_actual.valor)
      elsif (@carta_actual.tipo == TipoSorpresa::IRACASILLA)
        es_carcel = @tablero.es_casilla_carcel(@carta_actual.valor)
        if (es_carcel)
          encarcelar_jugador
        else
          nueva_casilla = @tablero.obtener_casilla_numero(@carta_actual.valor)
          tiene_propietario = @jugador_actual.actualizar_posicion(nueva_casilla)
        end
      elsif (@carta_actual.tipo == TipoSorpresa::PORCASAHOTEL)
        @jugador_actual.pagar_cobrar_por_casa_y_hotel(@carta_actual.valor)
      elsif (@carta_actual.tipo == TipoSorpresa::PORJUGADOR)
        @jugadores.each do |jugador|
          if (jugador != @jugador_actual)
            jugador.modificar_saldo(@carta_actual.valor)
            @jugador_actual.modificar_saldo(-@carta_actual.valor)
          end
        end
      elsif (@carta_actual.tipo == TipoSorpresa::CONVERTIRME)
        i = 0
        while (i < @jugadores.size)
          if (@jugadores[i].eql?(@jugador_actual))
            especulador = @jugador_actual.convertirme(@carta_actual.valor)
            @jugadores[i] = especulador
            @jugador_actual = @jugadores[i]
          end
          i = i+1
        end
      end
        
      if (@carta_actual.tipo == TipoSorpresa::SALIRCARCEL)
        @jugador_actual.carta_libertad = @carta_actual
      else
        @mazo.push(@carta_actual)
      end
      @carta_actual.to_s
      return tiene_propietario
    end
    
    def cancelar_hipoteca(casilla)
      if (casilla.titulo.propietario == @jugador_actual)
        se_puede_cancelar = casilla.esta_hipotecada
        if (se_puede_cancelar)
          puedo_cancelar = @jugador_actual.puedo_pagar_hipoteca(casilla)
          if (puedo_cancelar)
            cantidad_a_pagar = casilla.cancelar_hipoteca
            @jugador_actual.modificar_saldo(-cantidad_a_pagar)
            return true
          end
        end
      end
      return false
    end
    
    def hipotecar_propiedad(casilla)
      if (casilla.soy_edificable)
        se_puede_hipotecar = !casilla.esta_hipotecada
        if (se_puede_hipotecar)
          puedo_hipotecar = @jugador_actual.puedo_hipotecar(casilla)
          if (puedo_hipotecar)
            cantidad_recibida = casilla.hipotecar
            @jugador_actual.modificar_saldo(cantidad_recibida)
            return true
          end
        end
      end
      return false
    end
    
    def comprar_titulo_propiedad
      return @jugador_actual.comprar_titulo
    end
    
    def edificar_casa(casilla)
      if (casilla.soy_edificable)
        se_puede_edificar = casilla.se_puede_edificar_casa(@jugador_actual.factor_especulador)
        if (se_puede_edificar)
          puedo_edificar = @jugador_actual.puedo_edificar_casa(casilla)
          if (puedo_edificar && @jugador_actual.tengo_saldo(casilla.titulo.precio_edificar))
            coste_edificar_casa = casilla.edificar_casa
            @jugador_actual.modificar_saldo(-coste_edificar_casa)
            return true
          end
        end
      end
      return false
    end
    
    def edificar_hotel(casilla)
      if (casilla.soy_edificable)
        se_puede_edificar = casilla.se_puede_edificar_hotel(@jugador_actual.factor_especulador)
        if (se_puede_edificar)
          puedo_edificar = @jugador_actual.puedo_edificar_hotel(casilla)
          if (puedo_edificar)
            coste_edificar_hotel = casilla.edificar_hotel
            @jugador_actual.modificar_saldo(-coste_edificar_hotel)
            return true
          end
        end
      end
      return false
    end
    
    def inicializar_juego(nombres)
      inicializar_jugadores(nombres)
      inicializar_cartas_sorpresa
      salida_jugadores
    end
    
    def intentar_salir_carcel(metodo)
      libre = false
      if (metodo == MetodoSalirCarcel::TIRANDODADO)
        valor_dado = @dado.tirar
        puts "Tiras el dado y sacas un #{valor_dado}"
        libre = valor_dado >= 5
      elsif (metodo == MetodoSalirCarcel::PAGANDOLIBERTAD)
        tengo_saldo = @jugador_actual.pagar_libertad(@@precio_libertad)
        libre = tengo_saldo
      end
        
      if (libre)
        @jugador_actual.encarcelado = false
      end
      return libre
    end
    
    def jugar
      valor_dado = @dado.tirar
      puts "Tiras el dado y sacas un #{valor_dado}"
      casilla_posicion = @jugador_actual.casilla_actual
      nueva_casilla = @tablero.obtener_nueva_casilla(casilla_posicion, valor_dado)
      tiene_propietario = @jugador_actual.actualizar_posicion(nueva_casilla)
      if (!nueva_casilla.soy_edificable)
        if (nueva_casilla.tipo == TipoCasilla::JUEZ)
          encarcelar_jugador
        elsif (nueva_casilla.tipo == TipoCasilla::SORPRESA)
          @carta_actual = @mazo.at(@index_mazo % @mazo.size)
          @index_mazo += 1
        end
      end
      return tiene_propietario
    end

    def obtener_ranking
      ranking = Hash.new
      @jugadores.each do |jug|
        capital = jug.saldo
        ranking[jug.nombre] = capital
      end
      return ranking
    end
    
    def propiedades_hipotecadas_jugador(hipotecadas)
      cas_hipo = []
        
      if (hipotecadas)
        for i in 0..@@max_casillas
          if (@tablero.obtener_casilla_numero(i).esta_hipotecada)
            cas_hipo.push(@tablero.obtener_casilla_numero(i))
          end
        end
      end
      
      if (!hipotecadas)
        for i in 0..@@max_casillas
          if (!@tablero.obtener_casilla_numero(i).esta_hipotecada)
            cas_hipo.push(@tablero.obtener_casilla_numero(i))
          end
        end
      end
        
      return cas_hipo
    end
    
    def siguiente_jugador
      no_repetir = false
      @jugadores.each_with_index do |jug, i|
        if ((jug == @jugador_actual) && (i != @jugadores.size-1) && !no_repetir)
          @jugador_actual = @jugadores.at(i+1);
          no_repetir = true
        end
        if ((jug == @jugador_actual) && (i == @jugadores.size-1) && !no_repetir)
          @jugador_actual = @jugadores.at(0);
          no_repetir = true
        end 
      end
    end

    def vender_propiedad(casilla)
      if (casilla.soy_edificable)
        puedo_vender = @jugador_actual.puedo_vender_propiedad(casilla)
        if (puedo_vender)
          @jugador_actual.vender_propiedad(casilla)
          return true
        end
      end
      return false
    end
    
    def encarcelar_jugador
      if (!@jugador_actual.tengo_carta_libertad)
        casilla_carcel = @tablero.carcel
        @jugador_actual.ir_a_carcel(casilla_carcel)
      else 
        carta = @jugador_actual.devolver_carta_libertad
        @mazo.push(carta)
      end
    end

    def inicializar_cartas_sorpresa
      @mazo << Sorpresa.new("Te conviertes en Especulador con una fianza de 3000!", 3000, TipoSorpresa::CONVERTIRME)
      @mazo << Sorpresa.new("Te conviertes en Especulador con una fianza de 5000!", 5000, TipoSorpresa::CONVERTIRME)
      @mazo << Sorpresa.new("Aquel tio que llevas 13 años sin ver te ha mandado dinero, recibes 1000 euros", 1000, TipoSorpresa::PAGARCOBRAR)
      @mazo << Sorpresa.new("Te toca pagar la matricula de la universidad de tus hijos, pagas 1500 euros", -1500, TipoSorpresa::PAGARCOBRAR)
      @mazo << Sorpresa.new("Quedas con un amigo en el parking para charlar", 13, TipoSorpresa::IRACASILLA)
      @mazo << Sorpresa.new("No llegas a fin de mes con el sueldo de dependiente del McDonalds, pasa por la salida", 0, TipoSorpresa::IRACASILLA)
      @mazo << Sorpresa.new("Se descubre que le estafaste al chino de tu barrio 1000 euros en golosinas, vas a que el Juez te juzgue", @tablero.carcel.numero_casilla, TipoSorpresa::IRACASILLA)
      @mazo << Sorpresa.new("Mucha gente de todo el mundo viene de viaje y se alojan en tus casas y hoteles, recibes 200 euros por cada hotel o casa", 200, TipoSorpresa::PORCASAHOTEL)
      @mazo << Sorpresa.new("¡Ha llegado el momento de pagar recibos! Paga 300 euros por cada hotel o casa", -300, TipoSorpresa::PORCASAHOTEL)
      @mazo << Sorpresa.new("Es tu cumpleaños y cada jugador te envia 400 euros", 400, TipoSorpresa::PORJUGADOR)
      @mazo << Sorpresa.new("Te sientes generoso, pagas 200 euros a cada jugador", -200, TipoSorpresa::PORJUGADOR)
      @mazo << Sorpresa.new("Tu abogado presenta nuevas pruebas que demuestran tu inocencia, sales de la carcel", 0, TipoSorpresa::SALIRCARCEL)
    end
    
    def inicializar_jugadores(nombres)
      if (nombres.size <= @@max_jugadores)
        nombres.each do |aux|
          @jugadores.push(Jugador.new(aux))
        end
      end
    end
    
    def inicializar_tablero
        @tablero = Tablero.new
    end

    def salida_jugadores
      @jugadores.each do |jug|
        jug.casilla_actual = @tablero.obtener_casilla_numero(0)
      end
      
      random_num = rand(0..@jugadores.size-1)
      @jugador_actual = @jugadores.at(random_num)
    end
    
    def to_s
      @tablero.to_s
      puts @mazo
    end
    
    private :salida_jugadores, :encarcelar_jugador, :inicializar_cartas_sorpresa, :inicializar_jugadores, :inicializar_tablero
  end#class Qytetet
  
end#module ModeloQytetet