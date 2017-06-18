require_relative "Simplex.rb"

class PotatoCrop
    
    # Variables Globales
    $MIN_TEMP = 18
    $MAX_TEMP = 20
    $PRE_AVG = 63
    
    attr_accessor :months, :temperatures, :precipitations,
                  :min_demands, :max_demands, :production,
                  :val_package
    
    def initialize(months, temperatures, precipitations, min_demands, max_demands, production, val_package)
        @months = months
        @temperatures = temperatures
        @precipitations = precipitations
        @min_demands = min_demands
        @max_demands = max_demands
        @production = production # produccion estimada por ciclo
        @val_package = val_package # value
    end
    
    def initObjFunC()
        @objFun_c = Array.new
        
        # Ingresos y Demanda
        # Dependiendo de la demanda mínima, la demanda máxima y la producción,
        # se determinan los posibles ingresos para cada mes
        0.upto(@months-1) { |i|
            if @min_demands[i] <= @production and @production <= @max_demands[i]
                @objFun_c << @production * @val_package
            elsif @production <= @min_demands[i] - 1
                @objFun_c << @production * (@val_package / 2)
            elsif @max_demands[i]+1 <= @production
                @objFun_c << @max_demands[i] * @val_package +
                            (@production - @max_demands[i]) * (@val_package / 2)
            end
        }
        
        # En los primeros tres meses no se puede cosechar.
        0.upto(2) { |i|
            @objFun_c[i] = 0
        }
        
        # Condiciones Ambientales
        # Si se cumple alguna de estas restricciones en el mes i,
        # entonces no es posible cosechar en el mes i+3
        0.upto(@months-1) { |i|
            if i<@months-3 and (@temperatures[i]<$MIN_TEMP or @temperatures[i]>$MAX_TEMP or @precipitations[i]<$PRE_AVG)
                @objFun_c[i + 3] = 0
            end
        }
        p @objFun_c
    end
    
    def initRestrictions()
        @constraints = Array.new(@months-3)
        0.upto(@constraints.size-1) { |i|
            @constraints[i] = Array.new(@months,0)
            4.times { |j| @constraints[i][i+j] = 1 }
        }
        @independent_vector = Array.new(@months-3,1)
    end   
    
    # addRestriction Metodo encargado de añadir una restricción a la pila de restricciones.
    def addRestriction(pVarPosition, pRightSide) 
        # Añadimos la nueva restriccion.
        constraint = Array.new(@months, 0)
        if pRightSide >= 0
            constraint[pVarPosition] = 1
        else 
            constraint[pVarPosition] = -1
        end
        @constraints.push(constraint)
        # Añadimos el lado derecho.
        @independent_vector.push(pRightSide)
    end 
    
    def lp_relaxation()
        # SIMPLEX!
        solution_simplex = Simplex.new(@objFun_c, @constraints, @independent_vector)
        @solution = solution_simplex.solution
        # Evaluar solución
        @solution_evaluation = 0
        solution_simplex.solution.each_with_index { |x, i|
            @solution_evaluation+= x * @objFun_c[i]
        }
        return @solution, @solution_evaluation
    end
    
end