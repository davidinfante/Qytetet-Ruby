#!/bin/env ruby
# encoding: utf-8
#Proyecto: Qytetet - PDOO
#Alumno: David Infante Casas
#ETSIIT, UGR, Granada, España

module ModeloQytetet
  
  class Jugador
    attr_accessor :encarcelado, :nombre, :carta_libertad, :casilla_actual, :saldo
    attr_reader :propiedades, :factor_especulador
    
    def initialize(nom)
      @encarcelado = false
      @nombre = nom
      @saldo = 7500
      @casilla_actual = nil
      @propiedades = []
      @carta_libertad = nil
      @factor_especulador = 1
    end
    
    def copy_constructor(other)
      @encarcelado = other.encarcelado
      @nombre = other.nombre
      @saldo = other.saldo
      @casilla_actual = other.casilla_actual
      @propiedades = other.propiedades
      @carta_libertad = other.carta_libertad
      @factor_especulador = other.factor_especulador
    end
    
    def get_propiedades(opcion)
      props = []
      case opcion                                    
        when 1
          @propiedades.each do |tit|
            if (tit.casilla.num_casas < 4*@factor_especulador)
              props.push(tit.nombre)
            end
          end
        when 2
          @propiedades.each do |tit|
            if (tit.casilla.num_hoteles < 4*@factor_especulador)
              props.push(tit.nombre)
            end
          end
        when 3
          @propiedades.each do |tit|
            props.push(tit.nombre)
          end
        when 4
          props_not_hipo = obtener_propiedades_hipotecadas(false)
          props_not_hipo.each do |tit|
            props.push(tit.nombre)
          end
        when 5
          props_hipo = obtener_propiedades_hipotecadas(true)
          props_hipo.each do |tit|
            props.push(tit.nombre)
          end
        end
        return props
    end
    
    def search_casilla(nombre)
      ret = nil
      @propiedades.each do |tit|
        if (tit.nombre == nombre)
          ret = tit.casilla
        end
      end
      return ret
    end
    
    def bancarrota
      return @saldo < 0
    end
                                
    def tengo_propiedades
      return !@propiedades.empty?
    end

    def actualizar_posicion(casilla)
      if (casilla.numero_casilla < @casilla_actual.numero_casilla)
        modificar_saldo(Qytetet.saldo_salida)
      end
      @casilla_actual = casilla
      if (casilla.soy_edificable)
        if (casilla.tengo_propietario)
          @encarcelado = casilla.propietario_encarcelado
          if (!@encarcelado)
            coste_alquiler = casilla.cobrar_alquiler
            modificar_saldo(-coste_alquiler)
          end
        end
        return true
      elsif (casilla.tipo == TipoCasilla::IMPUESTO)
        coste = casilla.coste
        pagar_impuestos(coste)
        return true
      elsif (casilla.tipo == TipoCasilla::PARKING)
        return true
      elsif (casilla.tipo == TipoCasilla::CARCEL)
        return true
      elsif (casilla.tipo == TipoCasilla::SALIDA)
        return true
      elsif (casilla.tipo == TipoCasilla::JUEZ)
        return true
      elsif (casilla.tipo == TipoCasilla::SORPRESA)
        return true
      end
      return false
    end

    def comprar_titulo
      if (@casilla_actual.soy_edificable)
        tengo_propietario = @casilla_actual.tengo_propietario
        if (!tengo_propietario)
          coste_compra = @casilla_actual.coste
          if (tengo_saldo(coste_compra))
            titulo = @casilla_actual.asignar_propietario(self)
            @propiedades.push(titulo)
            modificar_saldo(-coste_compra)
            return true
          end
        end
      end
      return false
    end

    def devolver_carta_libertad
      libertad_copy = @carta_libertad
      @carta_libertad = nil
      return libertad_copy
    end

    def ir_a_carcel(casilla)
      @casilla_actual = casilla
      @encarcelado = true
    end

    def modificar_saldo(cantidad)
      @saldo += cantidad
    end

    def obtener_capital
      capital = @saldo
      @propiedades.each do |t|
        if (t.casilla.num_casas > 0)
          capital += (t.casilla.num_casas * t.casilla.precio_edificar)
        end
        if (t.casilla.num_hoteles > 0)
          capital += (t.casilla.num_hoteles * t.casilla.precio_edificar)
        end
        if (t.hipotecada)
          capital -= t.hipoteca_base
        end
      end
      return capital
    end

    def obtener_propiedades_hipotecadas(hipotecada)
      titulos = []
      if (hipotecada)
        @propiedades.each do |pro|
          if (pro.hipotecada)
            titulos.push(pro)
          end
        end
      end
      
      if (!hipotecada)
        @propiedades.each do |pro|
          if (!pro.hipotecada)
            titulos.push(pro)
          end
        end
      end
      
      return titulos
    end

    def pagar_cobrar_por_casa_y_hotel(cantidad)
      numero_total = cuantas_casas_hoteles_tengo
      modificar_saldo(numero_total * cantidad)
    end

    def pagar_libertad(cantidad)
      tengo_saldo = tengo_saldo(cantidad)
      if (tengo_saldo)
        modificar_saldo(-cantidad)
        return true
      end
      return false
    end

    def puedo_edificar_casa(casilla)
      es_mia = es_de_mi_propiedad(casilla)
      tengo_saldo = false
      if (es_mia)
        coste_edificar_casa = casilla.titulo.precio_edificar
        tengo_saldo = tengo_saldo(coste_edificar_casa)
      end
      return tengo_saldo
    end

    def puedo_edificar_hotel(casilla)
      es_mia = es_de_mi_propiedad(casilla)
      tengo_saldo = false
      if (es_mia)
        coste_edificar_hotel = casilla.titulo.precio_edificar
        tengo_saldo = tengo_saldo(coste_edificar_hotel)
      end
      return tengo_saldo
    end

    def puedo_hipotecar(casilla)
      return es_de_mi_propiedad(casilla)
    end

    def puedo_pagar_hipoteca(casilla)
      return (@saldo >= (casilla.calcular_valor_hipoteca + (casilla.calcular_valor_hipoteca * 0.1)))
    end

    def puedo_vender_propiedad(casilla)
      return (es_de_mi_propiedad(casilla) && !casilla.esta_hipotecada)
    end

    def tengo_carta_libertad
      return @carta_libertad != nil
    end

    def vender_propiedad(casilla)
      precio_venta = casilla.vender_titulo
      modificar_saldo(precio_venta)
      eliminar_de_mis_propiedades(casilla)
    end

    def cuantas_casas_hoteles_tengo
      numero_total = 0
      @propiedades.each do |pro|
        numero_total += pro.casilla.num_casas
        numero_total += pro.casilla.num_hoteles
      end
        
      return numero_total
    end

    def eliminar_de_mis_propiedades(casilla)
      @propiedades.each_with_index do |pro, i|
        if (casilla.titulo == pro)
          @propiedades.delete_at(i)
        end
      end
    end

    def es_de_mi_propiedad(casilla)
      @propiedades.each do |pro|
        if (casilla.titulo == pro)
          return true      
        end
      end
      
      return false
    end

    def tengo_saldo(cantidad)
      return @saldo >= cantidad
    end
    
    def to_s
      puts "Jugador{#{@nombre}, factor_especulador: #{@factor_especulador}, encarcelado: #{@encarcelado}, saldo: #{@saldo}, carta_libertad: #{@carta_libertad}, casilla_actual: #{@casilla_actual}\npropiedades: "
      if (!@propiedades.empty?)
        @propiedades.each do |aux|
          aux.to_s
        end
      end
    end
    
    def pagar_impuestos(cantidad)
      modificar_saldo(-cantidad)
    end
    
    def convertirme(fianza)
      especulador = Especulador.new(self, fianza)
      return especulador
    end
    
    private :cuantas_casas_hoteles_tengo, :es_de_mi_propiedad, :eliminar_de_mis_propiedades
    protected :copy_constructor, :pagar_impuestos
  end#class Jugador
  
end#ModeloQytetet
