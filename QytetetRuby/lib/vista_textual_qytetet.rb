#!/bin/env ruby
# encoding: utf-8
#Proyecto: Qytetet - PDOO
#Alumno: David Infante Casas
#ETSIIT, UGR, Granada, España

require_relative "qytetet"
require_relative "jugador"
require_relative "casilla"
require_relative "sorpresa"

module InterfazTextualQytetet
  
  class VistaTextualQytetet
    include ModeloQytetet
    def seleccion_menu(menu)
      begin #Hasta que se hace una seleccionn valida
        valido= true
        for m in menu #se muestran las opciones del menu�
          mostrar( "#{m[0]}" + " : " + "#{m[1]}")
        end
        mostrar( "\nElige un numero de opcion: ")
        captura = gets.chomp
        valido=comprobar_opcion(captura, 0, menu.length-1) #metodo para comprobar la eleccion correcta
        if (! valido) then
          mostrar( "\n\n ERROR !!! \n\n Seleccion erronea. Intentalo de nuevo.\n\n")
        end
      end while (!valido)
      Integer(captura)
    end

    def comprobar_opcion(captura,min,max)
      # metodo para comprobar si la opcion introducida es correcta, usado por seleccion_menu
      valido=true
      begin
        opcion = Integer(captura)
        if (opcion<min || opcion>max) #No es un entero entre los validos
          valido = false
          mostrar('el numero debe estar entre min y max')
        end
        rescue Exception => e  #No se ha introducido un entero
          valido = false
          mostrar('debes introducir un numero')
      end 
      valido
    end

    def menu_gestion_inmobiliaria
      puts "\nElige la gestion inmobiliaria que deseas hacer"
      menuGI=[[0, 'Siguiente Jugador'], [1, 'Edificar casa'], [2, 'Edificar Hotel'], [3, 'Vender propiedad'],[4, 'Hipotecar Propiedad'], [5, 'Cancelar Hipoteca']]
      salida=seleccion_menu(menuGI)
      #mostrar( 'has elegido')
      #mostrar(salida)
      return salida
    end

    def menu_salir_carcel
      #puts "\nElige el metodo para salir de la carcel"
      #menuSC=[[0, 'Tirando el dado'], [1, 'Pagando mi libertad']]
      #salida=self.seleccion_menu(menuSC)
      #mostrar( 'has elegido')
      #mostrar(salida)
      #salida
      metodo = 0
      valido = false
      puts "Estas encarcelado."
      puts "\nElige una opcion:"
      puts "\t(1) - Pagar libertad."
      puts "\t(2) - Tirar dado."
      
      loop do
        lectura = gets.chomp
        if (comprobar_opcion(lectura, 1, 2))
          metodo = Integer(lectura)
          valido = true
        else puts "\nError de entrada inténtalo de nuevo.\n"
        end
        break if (valido)
      end
        
      return metodo
    end

    def elegir_quiero_comprar(casilla)
      metodo = 0
      valido = false
      puts "Has caido en la casilla:"
      puts casilla.to_s
      puts "Elige una opcion:"
      puts "\t(1) - Adquirir propiedad."
      puts "\t(2) - No adquirir."
        
      loop do
        lectura = gets.chomp
        if (comprobar_opcion(lectura, 1, 2))
          metodo = Integer(lectura)
          valido = true
        else
          puts "Error de entrada intentalo de nuevo."
        end
        break if (valido)
      end
        
      if (metodo == 1)
        return true
      else
        return false
      end
    end

    def menu_elegir_propiedad(listaPropiedades) # numero y nombre de propiedades            
      menuEP = Array.new
      numero_opcion=0
      for prop in listaPropiedades
        menuEP<<[numero_opcion, prop] # opcion de menu, numero y nombre de propiedad
        numero_opcion=numero_opcion+1
      end
      menuEP<<[numero_opcion, "Cancelar"]
      numero_opcion += 1
      #puts menuEP.inspect
      salida=seleccion_menu(menuEP) # M�todo para controlar la elecci�n correcta en el men� 
      salida
    end  

    def obtener_nombre_jugadores
      nombres=Array.new
      valido = true
      begin
        self.mostrar("Escribe el numero de jugadores: (de 2 a 4):")
        lectura = gets.chomp #lectura de teclado
        valido=comprobar_opcion(lectura, 2, 4) #m�todo para comprobar la elecci�n correcta
      end while(!valido)

      for i in 1..Integer(lectura)  #pide nombre de jugadores y los mete en un array
        mostrar('Jugador:  '+ i.to_s)
        nombre=gets.chomp
        nombres<<nombre
      end
      nombres
    end

    def mostrar(texto)  #metodo para mostrar el string que recibe como argumento
      puts texto
    end
    
    def pause
      puts "\nPulsa intro para continuar...: \n"
      gets.chomp
    end
    
    def end_turn_line
      puts "\n******************************************************\n\n"
    end
    
    def has_salido_carcel(salgo_carcel)
        if (salgo_carcel)
          puts "Has salido de la carcel."
        else
          puts "No has podido salir de la carcel."
        end
    end

    def informacion_casilla(casilla, jugador)
      case casilla.tipo
        when TipoCasilla::SALIDA
          puts "\nSALIDA : Has pasado por la salida se te suman 1000 euros."
        when TipoCasilla::CALLE
          puts "\nCALLE : "
          if (casilla.tengo_propietario)
            puts "Caes sobre la "
            puts casilla.to_s
          end
        when TipoCasilla::SORPRESA
          puts "\nSORPRESA : Coges una carta del mazo."
        when TipoCasilla::JUEZ
          puts "\nJUEZ : "
        when TipoCasilla::CARCEL
          puts "\nCARCEL : Has caido en la carcel."
          if (jugador.encarcelado)
            puts "El juez te manda a la carcel"
          else
            puts "Solo estas de visita"
          end
        when TipoCasilla::IMPUESTO
          puts "\nIMPUESTO : Caes en la casilla impuesto, te toca pagar."
        when TipoCasilla::PARKING
          puts "\nPARKING : Estas en el parking, disfruta de tu descanso."
      end
    end
    
    def informacion_sorpresa(sorpresa)
      puts "Obtienes la carta: "
      puts sorpresa.to_s
    end
    
    def informacion_jugador(jugador)
      puts "\nResumen del jugador: "
      puts jugador.to_s
    end
    
    def saldo_jugador(jugador)
      puts "Resumen del jugador: "
      puts jugador.nombre
      puts "saldo: "
      puts jugador.saldo
    end
    
    def puedo_construir(opcion, puedo)
      #opcion: 1 casas, 2 hoteles, 3 vender, 4 hipotecar, 5 cancelar hipoteca
      if(opcion == 1 && puedo)
        puts "\nCasa edificada"
      elsif(opcion == 1 && !puedo)
        puts "\nCasa no edificada, no hay saldo suficiente"
      elsif(opcion == 2 && puedo)
        puts "\nHotel edificado"
      elsif(opcion == 2 && !puedo)
        puts "\nHotel no edificado, no hay saldo suficiente"
      elsif(opcion == 3 && puedo)
        puts "\nPropiedad vendida"
      elsif(opcion == 3 && !puedo)
        puts "\nPropiedad no vendida, esta hipotecada?"
      elsif(opcion == 4 && puedo)
        puts "\nPropiedad hipotecada"
      elsif(opcion == 4 && !puedo)
        puts "\nERROR Propiedad no hipotecada"
      elsif(opcion == 5 && puedo)
        puts "\nHipoteca cancelada"
      elsif(opcion == 5 && !puedo)
        puts "\nHipoteca no cancelada, no hay saldo suficiente"
      end
    end
    
    def inicio_turno(jugador)
      puts "Es el turno de: " + jugador.nombre
      puts "con saldo: "
      puts jugador.saldo
      puts "que esta en la casilla: "
      puts jugador.casilla_actual
      if (jugador.encarcelado)
        puts "Y esta encarcelado.\n\n"
      else
        puts "Y no esta encarcelado.\n\n"
      end
    end
    
    def fin_del_juego(ranking, juego)
      puts "Has caido en bancarrota, fin del juego."
      puts "\nRANKING:\n"
      juego.jugadores.each do |j|
        puts j.nombre + " con saldo: "
        puts ranking[j.nombre]
      end
    end
    
    private :comprobar_opcion, :seleccion_menu

  end#class VistaTextualQytetet
  
end#module InterfazTextualQytetet
