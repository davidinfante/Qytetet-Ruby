#!/bin/env ruby
# encoding: utf-8
#Proyecto: Qytetet - PDOO
#Alumno: David Infante Casas
#ETSIIT, UGR, Granada, España

module ModeloQytetet
  
  class Casilla
    attr_accessor :numero_casilla, :coste, :tipo
    
    def initialize(numero_casilla, tipo)
      if (tipo == TipoCasilla::IMPUESTO)
        @coste = 1000
      else
        @coste = 0
      end
      @numero_casilla = numero_casilla
      @tipo = tipo
    end
    
    def soy_edificable
      return @tipo == TipoCasilla::CALLE
    end
    
    def to_s
      "Casilla{#{@numero_casilla}, tipo: #{@tipo}}"
    end
    
  end#class Casilla
  
end#module ModeloQytetet
