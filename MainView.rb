#require_relative "ControlPotatoCrop.rb"
require_relative "PotatoCrop.rb"
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
    option_selected = showMenu()
    line_num = 1
    # Se carga el archivo seleccionado en el menú.
    begin
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

        @potato_crop = PotatoCrop.new(@months, @temperatures, @precipitations,
                                        @minDemands, @maxDemands, @produtionCycle,
                                        @valPackage)
        solution, solution_evaluation = @potato_crop.lp_relaxation
    
        # SE ESCRIBE LA SALIDA
        
        # Índices equivalentes a los meses donde se cosecha
        indices = Array.new
        number_months = 0
        # Se recorre la solución para determinar los indices de los meses
        solution.each_with_index do |m,i|
            if m==1
                number_months += 1
                indices << i+1
            end
        end
        # Variable contenido que se escribirá en la salida.
        content = ""
        content << solution_evaluation.round.to_s + "\n"
        content << number_months.to_s #+ "\n"
        indices.each do |m|
            content << "\n" + m.to_s
        end
        # Se escribe la salida.
        puts content
        file.writeF(content)
    rescue Exception => msg  
        puts msg
    end
end

if __FILE__ == $0
    begin
        while true
            main()
        end
    rescue Interrupt
        puts "\nHas finalizado presionando Ctrl-c"
    end
end