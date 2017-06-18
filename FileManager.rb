class FileManager
    
    def initialize(file_name)
        @filename = file_name
        @name = file_name.split("/")[1]
    end 
    
    def readF()
        File.open(@filename, 'r') 
    end 
    
    def writeF(content)
        f =File.open("OutputFiles/salida_"+@name, 'w'){ |f|
            f.puts content
        }
    end
    
    def readLine(line, kmonths)
        arrayLine = Array.new
        (0..kmonths-1).each do |i|
        arrayLine << line.split(" ")[i].strip.to_i
        end
        arrayLine
    end
    
    def loadInputFiles()
        Dir["InputFiles/*.txt"]
    end

end
