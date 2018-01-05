#!/bin/env ruby
# encoding: utf-8
#Proyecto: Qytetet - PDOO
#Alumno: David Infante Casas
#ETSIIT, UGR, Granada, España

module ModeloQytetet
  
  class Tablero
    attr_accessor :carcel, :casillas
    
    def initialize
      @carcel = nil
      @casillas = []
      inicializar
    end
    
    def es_casilla_carcel(numeroCasilla)
      return numeroCasilla == @carcel.numero_casilla
    end
    
    def obtener_casilla_numero(numeroCasilla)
      return @casillas.at(numeroCasilla)
    end

    def obtener_nueva_casilla(casilla, desplazamiento)
      if ((casilla.numero_casilla + desplazamiento) > 19)
        return @casillas.at((casilla.numero_casilla + desplazamiento) - @casillas.size)
      else
        return @casillas.at(casilla.numero_casilla + desplazamiento)
      end
    end
    
    def inicializar
      titulo1 = TituloPropiedad.new("Villa Raiz", 250, 0.1, 100, 500)
      titulo2 = TituloPropiedad.new("Campamento de la Resistencia", 500, 0.15, 200, 750)
      titulo3 = TituloPropiedad.new("Moga", 750, 0.2, 300, 1000)
      titulo4 = TituloPropiedad.new("Ciudad Delfino", 1000, 0.25, 400, 1250)
      titulo5 = TituloPropiedad.new("El Yermo", 1250, 0.3, 500, 1500)
      titulo6 = TituloPropiedad.new("Ventormenta", 1500, 0.35, 600, 1750)
      titulo7 = TituloPropiedad.new("Rapture", 1750, 0.4, 700, 2000)
      titulo8 = TituloPropiedad.new("Ciudad Trigal", 2000, 0.45, 800, 2250)
      titulo9 = TituloPropiedad.new("Costa del Sol", 2500, 0.55, 1000, 2750)
      titulo10 = TituloPropiedad.new("Tallon IV", 3000, 0.65, 1200, 3250)
      titulo11 = TituloPropiedad.new("Hyrule", 3500, 0.75, 1400, 3750)
      titulo12 = TituloPropiedad.new("Anor Londo", 4000, 0.85, 1600, 4250)
      
      @casillas << Casilla.new(0, TipoCasilla::SALIDA)
      @casillas << Calle.construct(1, 2500, titulo1)
      @casillas << Calle.construct(2, 3000, titulo2)
      @casillas << Casilla.new(3, TipoCasilla::SORPRESA)
      @casillas << Calle.construct(4, 3500, titulo3)
      @casillas << Calle.construct(5, 4000, titulo4)
      @casillas << Calle.construct(6, 4500, titulo5)
      @casillas << Casilla.new(7,  TipoCasilla::SORPRESA)
      @casillas << Calle.construct(8, 5000, titulo6)
      @casillas << Casilla.new(9, TipoCasilla::CARCEL)
      @casillas << Casilla.new(10, TipoCasilla::JUEZ)
      @casillas << Calle.construct(11, 5500, titulo7)
      @casillas << Calle.construct(12, 6000, titulo8)
      @casillas << Casilla.new(13, TipoCasilla::PARKING)
      @casillas << Calle.construct(14, 7000, titulo9)
      @casillas << Calle.construct(15, 8000, titulo10)
      @casillas << Casilla.new(16, TipoCasilla::IMPUESTO)
      @casillas << Calle.construct(17, 9000, titulo11)
      @casillas << Casilla.new(18, TipoCasilla::SORPRESA)
      @casillas << Calle.construct(19, 10000, titulo12)
      
      @carcel = @casillas.at(9)
    end
    
    def to_s
      for i in 0..19
        puts @casillas[i].to_s
      end
    end
    
  end#class Tablero
  
end#module ModeloQytetet
