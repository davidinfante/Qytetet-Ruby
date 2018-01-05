#!/bin/env ruby
# encoding: utf-8
#Proyecto: Qytetet - PDOO
#Alumno: David Infante Casas
#ETSIIT, UGR, Granada, España


module ModeloQytetet
  
  class Calle < Casilla
    
    attr_accessor :num_hoteles, :num_casas, :titulo
    
    def initialize(numero_casilla, coste, titulo)
      @numero_casilla = numero_casilla
      @coste = coste
      @num_hoteles = 0
      @num_casas = 0
      @tipo = TipoCasilla::CALLE
      @titulo = titulo
    end
    
    #Constructor
    def self.construct(numero_casilla, coste, titulo)
      @aux = self.new(numero_casilla, coste, titulo)
      @aux.titulo.casilla = @aux
    end
    
    def asignar_propietario(jugador)
      @titulo.propietario = jugador
      return @titulo
    end
    
    def calcular_valor_hipoteca
      return (@titulo.hipoteca_base + (@num_casas * 0.5 * @titulo.hipoteca_base + @num_hoteles * @titulo.hipoteca_base))
    end
    
    def cancelar_hipoteca
      @titulo.hipotecada = false
      return calcular_valor_hipoteca + (calcular_valor_hipoteca * 0.1)
    end
    
    def cobrar_alquiler
      coste_alquiler_base = @titulo.alquiler_base
      coste_alquiler = coste_alquiler_base + (@num_casas*0.5 + @num_hoteles*2)
      @titulo.cobrar_alquiler(coste_alquiler)
      return coste_alquiler
    end
    
    def edificar_casa
      @num_casas += 1
      coste_edificar_casa = @titulo.precio_edificar
      return coste_edificar_casa
    end
    
    def edificar_hotel
      @num_hoteles += 1
      coste_edificar_hotel = @titulo.precio_edificar
      return coste_edificar_hotel
    end
    
    def esta_hipotecada
      return @titulo.hipotecada
    end
    
    #int get_coste_hipoteca() {}

    def get_precio_edificar
      return @titulo.precio_edificar
    end
    
    def hipotecar
      @titulo.hipotecada = true
      return calcular_valor_hipoteca
    end
    
    #int precio_total_comprar() {}
    
    def propietario_encarcelado
      return @titulo.propietario_encarcelado
    end
    
    def se_puede_edificar_casa(factor_especulador)
      return (@num_casas < (factor_especulador * 4))
    end
    
    def se_puede_edificar_hotel(factor_especulador)
      return (@num_hoteles < (factor_especulador * 4))
    end
    
    def soy_edificable
      return true
    end
    
    def tengo_propietario
      return @titulo.tengo_propietario
    end
        
    def vender_titulo
      @titulo.propietario = nil
      @num_hoteles = 0
      @num_casas = 0
      precio_compra = @coste + (@num_casas + @num_hoteles) * @titulo.precio_edificar
      return (precio_compra + @titulo.factor_revalorizacion * precio_compra)
    end
    
    #private void asignar_titulo_propiedad() {}
    
    def to_s
      if (@tipo == TipoCasilla::CALLE && !tengo_propietario)
        "Casilla{#{@numero_casilla}, coste: #{@coste}}\ncon titulo: #{@titulo}"
      elsif (@tipo == TipoCasilla::CALLE && tengo_propietario)
        "Casilla{#{@numero_casilla}, pertenece a #{@titulo.propietario.nombre} coste: #{@coste}, num_hoteles: #{@num_hoteles}, num_casas: #{@num_casas}}\ncon titulo: #{@titulo}"
      end
    end
    
  end#class Calle
  
end#module ModeloQytetet
