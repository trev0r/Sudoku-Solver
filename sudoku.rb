# Reads in a Sudoku puzzle and splits out the answer
class Entry 
    attr_reader :row, :col,  :value
    @possibleValues
    def initialize(r, c)
        row = r
        col = c
        possibleVals = (1..9).to_a
        value = nil
    end

    def remove(x)
        @possibleValues.remove(x)
        @value = @possibleValues[0] if @possibleValues.length == 1
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


def check(entry, knownvalues)
    knownvalues.each do |val|
        entry.remove(val)
    end
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
                q << Entry.new(row,column) 
            end
            column+=1 
        }
        row+=1
    end
end
sudokuPrint(a)
puts q.length
while (q.length  > 0)
    entry = q.first
    puts "#{entry.row},#{entry.col}"
    row = getRow(a,entry.row)
    check(entry, row)
    col = getCol(a,entry.col)
    check(entry, col)
    box = getBox(a,entry.box)
    check(entry, box)
    unless entry.value.nil?
        a[entry.row][entry.col] = entry.value 
    else
        q << entry
    end

    sudokuPrint(a)
end
