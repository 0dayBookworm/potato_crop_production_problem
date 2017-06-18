require_relative "ControlPotatoCrop.rb"
require_relative "FileManager.rb"
require 'highline/import'

def showMenu
    # Variables
    j = 1
    files_names = Array.new
    @files = Array.new
    inputs_dir = Dir["InputFiles/*.txt"]
    inputs_dir.each do |i| 
        files_names << i.split("/")[1] 
        @files << FileManager.new(i)
    end
    puts "-----------------------------------------------------------------------"
    puts "------------------------POTATO'S CROP MENU-----------------------------"
    puts "\n"
    puts "Select the file or 0 to exit: "
    files_names.each {|fn|
            puts "#{j}. #{fn}"
            j +=1
        }
    option = ask "~$: "
    puts "\n"
    if option.to_i == 0  
        exit!
    end
    option.to_i
end
    
def main
    begin
            option_selected = showMenu()
            # Carga la lógica.
            # Variables necesarias
            line_num = 1
            # Se carga el archivo seleccionado en el menú.
            file = @files[option_selected - 1]
            # Se lee el archivo.
            fileReaded = file.readF()
            # Recorrer las lineas del archivo leído.
            fileReaded.each_line { |line|
            case line_num
                when 1
                    @months = line.to_i
                when 2
                    @temperatures = file.readLine(line, @months)
                when 3
                    @precipitations = file.readLine(line, @months)
                when 4
                    @minDemands = file.readLine(line, @months)
                when 5
                    @maxDemands = file.readLine(line, @months)
                when 6
                    @produtionCycle = line.to_i
                when 7
                    @valPackage = line.to_i
            end
            line_num+=1
            }
            # Control de la lógica
            control = ControlPotatoCrop.new(@months, @temperatures, @precipitations,
                                            @minDemands, @maxDemands, @produtionCycle,
                                            @valPackage)
 
            output = control.solve()
=begin           
            #Variables escritura salida
            # Ingresos totales
            total_income = output.evaluation.to_i
            # Solución
            solution = output.solution
            # Índices equivalentes a los meses donde se cosecha en la solución.
            indexs = Array.new
            months =0
            n = solution.size
            # Se recorre la solución para determinar los indices de los meses y 
            # los meses.
            solution.each_with_index do |m,i|
                if m == 0
                elsif m==1
                    months += 1
                    indexs << i+1
                end
            end
            # Variable contenido que se escribirá en la salida.
            content = ""
            content << total_income.to_s + "\n"
            content << months.to_s + "\n"
            (0..n-1).each do |i|
                content << indexs[i].to_s + "\n"
            end
            # Se escribe la salida.
            file.writeF(content)
=end           
    rescue Interrupt
        p "error"
        
    end
end

if __FILE__ == $0

main()

end