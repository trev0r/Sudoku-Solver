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
    col = []
    a.each do |item|
        col << item[x] unless item.class == Array
    end
    col
end
def getRow(a,x)
    row = a[x]
    row.each do |val|
        row.delete(val) if val.class == Array
    end
    row
end
def getBox(a,x)
    box = []
    startRow = 3*(x/3)
    startCol = 3*(x%3)

    a[startRow..startRow+2].each do |row|
        box << row[startCol..startCol+2]
    end
    box
end
def sudokuPrint(a)
    for j in 1..9 do
        row = a[j-1]     
        for k in 1..9 do
            print row[k-1]
            print " " if row[k-1].nil?
            print " | " if (k%3 == 0 && k != 9)
        end
        puts
        if j%3 == 0 && j != 9
            15.times { print "-" }
            puts
        end
    end
end
#Reads in a sudoku file and converts it into a 9x9 matrix of values. Unknown values (represented by 0 in the file) are
#replaced with arrays ranging from 1..9 to represent all possible values.
a = []
q = Array.new
9.times { a << [] }
File.open("easy", "r") do |infile|
    row = 0
    while(line = infile.gets)
        column = 0
        line.each_char(){ |x|
            a[row][column] = x.to_i
             if a[row][column] ==0
                 a[row][column] = nil
                 q << (1..).to_a
             end
            column+=1 
        }
        row+=1
    end
end
sudokuPrint(a)

for row in 1..9 do
    for col in 1..9 do

    end
end
