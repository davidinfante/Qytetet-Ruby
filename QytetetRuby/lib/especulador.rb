#!/bin/env ruby
# encoding: utf-8
#Proyecto: Qytetet - PDOO
#Alumno: David Infante Casas
#ETSIIT, UGR, Granada, España

module ModeloQytetet
  
  class Especulador < Jugador

    def initialize(other, fianza)
      copy_constructor(other)
      @factor_especulador = 2
      @fianza = fianza
    end
    
    def pagar_impuestos(cantidad)
      modificar_saldo(-cantidad/2)
    end
    
    def ir_a_carcel(casilla)
      if (!pagar_fianza(@fianza))
        @casilla_actual = casilla
        @encarcelado = true 
      end
    end
    
    def convertirme(fianza)
      return self
    end
    
    def pagar_fianza(cantidad)
      salir_carcel = (@saldo >= cantidad)
      if (salir_carcel)
        modificar_saldo(-cantidad)
      end
      return salir_carcel
    end
    
    def to_s
      puts "Especulador{#{@nombre}, factor_especulador: #{@factor_especulador}, fianza: #{@fianza}, encarcelado: #{@encarcelado}, saldo: #{@saldo}, carta_libertad: #{@carta_libertad}, casilla_actual: #{@casilla_actual}\npropiedades: "
      if (!@propiedades.empty?)
        @propiedades.each do |aux|
          aux.to_s
        end
      end
    end
    
    protected :pagar_impuestos
    private :pagar_fianza
  end#class Especulador
  
end#module ModeloQytetet
