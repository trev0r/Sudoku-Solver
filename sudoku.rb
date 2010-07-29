# Reads in a Sudoku puzzle and splits out the answer
class Entry 
    attr_reader :row, :col, :box,  :value
    @possibleValues
    def initialize(r, c, b)
        @row = r
        @col = c
        @box = b
        @possibleValues = (1..9).to_a
        @value = nil
    end

    def delete(x)
        @possibleValues.delete(x)
        puts "#{@row},#{@col} (#{x}): #{@possibleValues}"
        @value = @possibleValues[0] if @possibleValues.length == 1
    end
    def testPrint
        puts "#{@row},#{@col}"
    end

end
def getCol(a, x)
    col = []
    a.each do |item|
        col.push(item[x]) unless item[x].class == Array
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

    a[startRow,3].each do |row|
        for i in startCol..startCol+2 do
            box.push(row[i])
        end
        # print "boxrow #{row}\n"
        # box.push(row[startCol,3])
    end
    box
end



def check(entry, knownvalues)
    knownvalues.each do |val|
        entry.delete(val) unless val.nil?
    end
end

def sudokuPrint(a)
    for j in 1..9 do
        row = a[j-1]     
        for k in 1..9 do
            if row[k-1].nil?
                print " "
            else
                print row[k-1]
            end
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
box = 0
9.times { a << [] }
File.open("easy", "r") do |infile|
    row = 0
    while(line = infile.gets)
        column = 0
        line.each_char(){ |x|
            a[row][column] = x.to_i
            if a[row][column] ==0
                a[row][column] = nil
                q << Entry.new(row,column,box) 
            end
            box+=1 if column%3 == 0  && column != 0 && column < 9
            #    puts "#{row},#{column}:#{box}"
            column+=1 
        }
        box-=2 
        row+=1
        box+=3 if row%3 == 0 && row != 0
    end
end
sudokuPrint(a)
puts
while (q.length  > 0)
    entry = q.shift
    row = getRow(a,entry.row)
    check(entry, row)
    print "Row: #{row}"
    puts
    col = getCol(a,entry.col)
    check(entry, col)
    print "Col: #{col}"
    puts
    box = getBox(a,entry.box)
    check(entry, box)
    print "Box: #{box}"
    puts
    unless entry.value.nil?
        a[entry.row][entry.col] = entry.value 
    else
        q.push(entry)# << entry
    end

    sudokuPrint(a)
    puts
end
