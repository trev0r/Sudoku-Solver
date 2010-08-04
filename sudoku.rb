# Reads in a Sudoku puzzle and splits out the answer
def cross(a,b)
    a.collect{|x|  b.collect{|y|  x+y }}
end

@rows = ('A'..'I').to_a
@cols = ('1'..'9').to_a
@digits = '123456789'

@squares = cross(@rows,@cols).flatten
@unitlist = @cols.collect{|c| cross(@rows,[c]).flatten} +
    @rows.collect{|r| cross([r],@cols).flatten} 
@rows.each_slice(3){|rs| @cols.each_slice(3){|cs| @unitlist.concat([cross(rs,cs).flatten])}}

@units = Hash[@squares.collect{|sqr| [sqr, @unitlist.select{|x| x.include?(sqr)}]}]
@peers = Hash[@units.keys.collect{|s| [s, @units[s].flatten.uniq!.select{|x| x != s}]}]

grid = "
003020600
900305001
001806400
008102900
700000008
006708200
002609500
800203009
005010300".gsub(/\n/,"").split(//)
grid = "4.....8.5.3..........7......2.....6.....8.4......1.......6.3.7.5..2.....1.4......".split(//)
def parse_grid(grid)
    grid = grid.inject([]){|result,element| result << element if '0.-123456789'.include?(element)}
    values = Hash[@squares.collect{|s| [s,@digits.clone]}]
    @squares.zip(grid){|s,d|
        return false if @digits.include?(d) && !assign(values,s,d) }
        return values
end

def assign(values,s,d)
    #Eliminate all the other values (except d) from values[s], propogate
    #puts "Eliminating all values except: #{d} from #{s}"
    if (values[s].split(//).all?{|d2| d2 != d ? eliminate(values,s,d2) : true}) 
        return values
    else
        return false
    end
end
def eliminate(values, s, d) 
    #Eliminate d from values[s]; propogate when value or places <= 2
    return values unless values[s].include?(d) #Already eliminated
    # puts "Eliminating #{d} from #{values[s].inspect} in #{s}"
    values[s].delete!(d)
    #printboard(values)
    if values[s].empty? #Contradiction: removed last value
        return false 
    elsif values[s].length == 1
        #only one value left, remove from peers
        d2 = values[s]
        return false unless (Array.new(@peers[s])).all?{|s2| eliminate(values,s2,d2)}
    end
    ## check the places where d appears in the units of s
    @units[s].each{|u|
        dplaces = u.inject([]){|result,element| values[element].include?(d) ? result << element : result } 
        return false if dplaces.empty?
        if(dplaces.length == 1) #d can only be in one place in the unit, assign there
            return false if !assign(values,dplaces.first, d)
        end
    }      
    return values

end

def printboard(values)
    width = 1+values[@squares.max{|a,b| values[a].length <=> values[b].length}].length
    line = "\n"+3.times.inject([]){|result,x| result << "-"*3*width}.join("+")   
    @rows.each{|r|
        @cols.each{|c|
            print values[r+c].center(width)+ ("36".include?(c) ? "|":"")        
        }
        puts ("CF".include?(r) ? line : '') 
    }
    puts
end

def search(values) 
    return false unless values #already failed
    return values if @squares.all?{|s| values[s].length == 1} #solves
    s = @squares.clone.delete_if{|x| values[x].length <= 1}.min{|a,b| values[a].length <=> values[b].length}
    test = values[s].split(//).collect{|d|
        x = search(assign(Marshal::load(Marshal::dump(values)),s,d)) 
    }
    test = test.select{|t| t != false}.first
    test.nil? ? false : test 
end
printboard(search(parse_grid(grid)))
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
