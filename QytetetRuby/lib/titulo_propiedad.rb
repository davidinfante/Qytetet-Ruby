#!/bin/env ruby
# encoding: utf-8
#Proyecto: Qytetet - PDOO
#Alumno: David Infante Casas
#ETSIIT, UGR, Granada, España

module ModeloQytetet
  
  class TituloPropiedad
    attr_accessor :hipotecada, :casilla, :propietario, :precio_edificar, :nombre, :alquiler_base, :factor_revalorizacion, :hipoteca_base
    
    def initialize(n, aB, fR, hB, pE)
      @nombre = n
      @hipotecada = false
      @alquiler_base = aB
      @factor_revalorizacion = fR
      @hipoteca_base = hB
      @precio_edificar = pE
      @casilla = nil
      @propietario = nil
    end

    def cobrar_alquiler(coste)
      @propietario.modificar_saldo(coste)
    end
    
    def propietario_encarcelado
      return @propietario.encarcelado
    end

    def tengo_propietario
      return @propietario != nil
    end
    
    def to_s
      if (tengo_propietario) 
        "TituloPropiedad{#{@nombre}, hipotecada: #{@hipotecada}, alquiler_base: #{@alquiler_base}, factor_revalorizacion: #{@factor_revalorizacion}, hipoteca_base: #{@hipoteca_base}, precio_edificar: #{@precio_edificar}, num_casas #{@casilla.num_casas}, num_hoteles #{@casilla.num_hoteles}}"
      else
        "TituloPropiedad{#{@nombre}, alquiler_base: #{@alquiler_base}, factor_revalorizacion: #{@factor_revalorizacion}, hipoteca_base: #{@hipoteca_base}, precio_edificar: #{@precio_edificar}}"
      end
    end
    
  end#class TituloPropiedad
  
end#module ModeloQytetet
