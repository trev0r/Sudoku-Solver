# Reads in a Sudoku puzzle and splits out the answer
def cross(a,b)
    a.collect{|x|  b.collect{|y|  x+y }}
end

rows = ('A'..'I').to_a
cols = ('1'..'9').to_a
digits = '123456789'

squares = cross(rows,cols).flatten
unitlist = cols.collect{|c| cross(rows,c).flatten} +
    rows.collect{|r| cross(r,cols).flatten} 
rows.each_slice(3){|rs| cols.each_slice(3){|cs| unitlist.concat([cross(rs,cs).flatten])}}

units = Hash[squares.collect{|sqr| [sqr, unitlist.select{|x| x.include?(sqr)}]}]
peers = Hash[units.keys.collect{|s| [s, units[s].flatten.uniq!.select{|x| x != s}]}]

p squares
puts
p peers['A1']

def parse_grid(grid)
    grid = grid.inject([]){|result,element| result << element if '0.-123456789'.include?(element)}
    values = Hash[squares.collect{|s| [s,digits]}]
    

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
#a = []
#q = Array.new
#box = 0
#9.times { a << [] }
#File.open("easy", "r") do |infile|
#    row = 0
#    while(line = infile.gets)
#        column = 0
#        line.each_char(){ |x|
#            a[row][column] = x.to_i
#            if a[row][column] ==0
#                a[row][column] = nil
#                q << Entry.new(row,column,box) 
#            end
#            box+=1 if column%3 == 0  && column != 0 && column < 9
#            #    puts "#{row},#{column}:#{box}"
#            column+=1 
#        }
#        box-=2 
#        row+=1
#        box+=3 if row%3 == 0 && row != 0
#    end
#end
