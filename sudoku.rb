# Reads in a Sudoku puzzle and splits out the answer
class Sudoku
    #@rows, @columns, @boxes, @queue
    def read 
    end

    def solve
    end

    def print
    end


end
def getCol(a, x)
    row = []
    a.each do |item|
        row << item[x]
    end
    row
end
def getRow(a,x)
     a[x]
end
#Reads in a sudoku file and converts it into a 9x9 matrix of values. Unknown values (represented by 0 in the file) are
#replaced with arrays ranging from 1..9 to represent all possible values.
a = []
9.times { a << [] }
File.open("easy", "r") do |infile|
    row = 0
    while(line = infile.gets)
        column = 0
        line.each_char(){ |x|
            a[row][column] = x.to_i
            a[row][column] = (1..9).to_a  if a[row][column] ==0
            column+=1 
        }
        row+=1
    end
end

