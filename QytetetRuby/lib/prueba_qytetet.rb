#!/bin/env ruby
# encoding: utf-8
#Proyecto: Qytetet - PDOO
#Alumno: David Infante Casas
#ETSIIT, UGR, Granada, España

require_relative "casilla"
require_relative "dado"
require_relative "jugador"
require_relative "metodo_salir_carcel"
require_relative "qytetet"
require_relative "sorpresa"
require_relative "tablero"
require_relative "tipo_casilla"
require_relative "tipo_sorpresa"
require_relative "titulo_propiedad"
require_relative "controlador_qytetet"
require_relative "vista_textual_qytetet"


module ModeloQytetet

  class PruebaQytetet
    include InterfazTextualQytetet
    #@@mazo = []
    #@@tablero = Tablero.new
    
    #Inicialización de las cartas sorpresa que van en el mazo
    #def self.inicializar_sorpresas
    #  @@mazo << Sorpresa.new("Aquel tío que llevas 13 años sin ver te ha mandado dinero, recibes 1000 euros", 1000, TipoSorpresa::PAGARCOBRAR)
    #  @@mazo << Sorpresa.new("Te toca pagar la matrícula de la universidad de tus hijos, pagas 2000 euros", -2000, TipoSorpresa::PAGARCOBRAR)
    #  @@mazo << Sorpresa.new("Se descubre que le estafaste al chino de tu barrio 1000 euros en golosinas, vas a que el Juez te juzgue", 10, TipoSorpresa::IRACASILLA)
    #  @@mazo << Sorpresa.new("No llegas a fin de mes con el sueldo de dependiente del McDonalds, pasa por la salida", 0, TipoSorpresa::IRACASILLA)
    #  @@mazo << Sorpresa.new("Vas a visitar a un amigo de la infancia a la cárcel", @@tablero.carcel.numero_casilla, TipoSorpresa::IRACASILLA)
    #  @@mazo << Sorpresa.new("Mucha gente de todo el mundo viene de viaje y se alojan en tus casas y hoteles, recibes 200 euros por cada hotel o casa", 200, TipoSorpresa::PORCASAHOTEL)
    #  @@mazo << Sorpresa.new("¡Ha llegado el momento de pagar recibos! Paga 300 euros por cada hotel o casa", -300, TipoSorpresa::PORCASAHOTEL)
    #  @@mazo << Sorpresa.new("Es tu cumpleaños y cada jugador te envía 400 euros", 400, TipoSorpresa::PORJUGADOR)
    #  @@mazo << Sorpresa.new("Te sientes generoso, pagas 200 euros a cada jugador", -200, TipoSorpresa::PORJUGADOR)
    #  @@mazo << Sorpresa.new("Tu abogado presenta nuevas pruebas que demuestran tu inocencia, sales de la cárcel", 0, TipoSorpresa::SALIRCARCEL)
    #end
    
    #Return de las cartas del mazo sorpresa con valor mayor que 0
    #def self.get_cartas_valor_mayor_0
    #  mayor_0 = []
    #  @@mazo.each do |aux|
    #    if (aux.valor > 0)
    #      mayor_0.push(aux)
    #    end
    #  end
    #  return mayor_0
    #end
    
    #Return de las cartas del mazo sorpresa con tipo IRACASILLA
    #def self.get_cartas_tipo_ir_a_casilla
    #  tipo_ira_casilla = []
    #  @@mazo.each do |aux|
    #    if (aux.tipo == TipoSorpresa::IRACASILLA)
    #      tipo_ira_casilla.push(aux)
    #    end
    #  end
    #  return tipo_ira_casilla
    #end
    
    #Return de las cartas del mazo sorpresa con tipo pasado como argumento
    #def self.get_cartas_tipo (tipo_carta)
    #  tipo_argumento = []
    #  @@mazo.each do |aux|
    #    if (aux.tipo == tipo_carta)
    #      tipo_argumento.push(aux)
    #    end
    #  end
    #  return tipo_argumento
    #end
    
    #Método main
    def self.main
      #inicializar_sorpresas
      #puts @@mazo
      
      #Probar los métodos de visualización de cartas sorpresa
      #arr = []
      #arr = get_cartas_valor_mayor_0 
      #puts arr
      #arr = get_cartas_tipo_ir_a_casilla
      #puts arr
      #arr = get_cartas_tipo(TipoSorpresa::SALIRCARCEL)
      #puts arr
      
      #Probar que el tablero está bien creado
      #@@tablero.to_s
      
      #qytetet = Qytetet.instance
      #qytetet.to_s
      
      game = ControladorQytetet.new
      game.main
    end
    
  end#class PruebaQytetet

  PruebaQytetet.main
  
end#module ModeloQytetet
