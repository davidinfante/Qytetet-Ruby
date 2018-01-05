#!/bin/env ruby
# encoding: utf-8
#Proyecto: Qytetet - PDOO
#Alumno: David Infante Casas
#ETSIIT, UGR, Granada, España

require "singleton"

module ModeloQytetet
  
  class Dado
    include Singleton
    
    def initialize
    end
    
    def tirar
      return 1 + rand(6)
    end
    
    def to_s
      puts tirar
    end
    
  end#class Dado
  
end#module ModeloQytetet
