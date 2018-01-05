#!/bin/env ruby
# encoding: utf-8
#Proyecto: Qytetet - PDOO
#Alumno: David Infante Casas
#ETSIIT, UGR, Granada, España

module ModeloQytetet
  
  class Sorpresa
    attr_reader :texto, :valor, :tipo
    
    def initialize(t, v, tp)
      @texto = t
      @valor = v
      @tipo = tp
    end
    
    def to_s
      "Sorpresa(#{@texto}, tipo: #{@tipo}, valor: #{@valor})"
    end
    
  end#class Sorpresa
  
end#module ModeloQytetet