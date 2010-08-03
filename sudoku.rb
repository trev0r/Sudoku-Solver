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
    squares.zip(grid){|s,d|
        return false if digits.include?(d) && !assign(values,s,d) }
        return values
end

def assign(values,s,d)
    #Eliminate all the other values (except d) from values[s], propogate
    return values  if values[s].all?{|d2| eliminate(values,s,d2) if d2 != d}
    return false
end

def eliminate(values, s, d)
    #Eliminate d from values[s]; propogate when value or places <= 2
    return values if !values[s].include?(d) #Already eliminated
    values[s].delete(d2)
    if values[s].empty? #Contradiction: removed last value
        return false 
    elsif values[s].length == 1
        #only one value left, remove from peers
        d2 = values[2].first
        return false if !peers[s].all?{|s2| elimiante(values,s2,d2)}
    end
    ## check the places where d appears in the units of s
    units[s].each{|u|
        dplaces = u.inject([]){|result,element| result << elemement if values[s].include?(d)}
        return false if dplaces.empty?
        if(dplaces.length == 1)
            #d can only be in one place in the unit, assign there
            return false if !assign(values,dplaces.first, d)
        end
    }      
    return values
end



def printboard(values)
    width = 1+squares.max{|a,b| values[a].length <=> values[b].length}.length
    line = "\n"+3.times.inject([]){|result| result << "-"*3*width}.join("+")   
    rows.each{|r|
        col.each{|c|
                print values[r+c].center(width)+ ("36".include?(c) ? "|":"") + ("CF".include?(r) ? "line" : '')
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
