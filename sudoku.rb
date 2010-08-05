# Reads in a Sudoku puzzle and solves 
class Array
    #Redefines detect to return the first value in the block that does not evaulate to false
    def detect(ifnone = nil)
        each{ |o|
            x = yield(o)
            return x if x 
        }
        ifnone.call if ifnone
    end
end
def cross(a,b)
    a.collect{|x|  b.collect{|y|  x+y }}
end
#Throughout this program:
# => r is a row,     e.g. 'A'
# => c is a column,  e.g. '3'
# => s is a square,  e.g. 'A3'
# => d is a digit,   e.g. '9'
# => u is a unit,    e.g. ['A1,'B1','C1','D1','E1','F1','G1','H1','I1']
# => g is a grid,    e.g. 81 non-blank chars, e.g. starting with '..18..7...
# => values is a hash of possible values, e.g. {'A1'=>'123489','A2'=>'4'...} 
@rows = ('A'..'I').to_a
@cols = ('1'..'9').to_a
@digits = '123456789'

@squares = cross(@rows,@cols).flatten
@unitlist = @cols.collect{|c| cross(@rows,[c]).flatten} +
    @rows.collect{|r| cross([r],@cols).flatten} 
@rows.each_slice(3){|rs| @cols.each_slice(3){|cs| @unitlist.concat([cross(rs,cs).flatten])}}

@units = Hash[@squares.collect{|s| [s, @unitlist.select{|u| u.include?(s)}]}]
@peers = Hash[@units.keys.collect{|u| [u, @units[u].flatten.uniq!.select{|s2| s2 != s}]}]

def parse_grid(grid)
    grid = grid.inject([]){|result,element| result << element if '0.-123456789'.include?(element)}
    values = Hash[@squares.collect{|s| [s,@digits.clone]}]
    @squares.zip(grid){|s,d|
        return false if @digits.include?(d) && !assign(values,s,d) }
        return values
end

def assign(values,s,d)
    #Eliminate all the other values (except d) from values[s], propogate
    if (values[s].split(//).all?{|d2| d2 != d ? eliminate(values,s,d2) : true}) 
        return values
    else
        return false
    end
end
def eliminate(values, s, d) 
    #Eliminate d from values[s]; propogate when value or places <= 2
    return values unless values[s].include?(d) #Already eliminated

    values[s].delete!(d)
    return false if values[s].empty? #Contradiction: removed last value
    if values[s].length == 1 #only one value left, remove from peers
        d2 = values[s]
        return false unless (Array.new(@peers[s])).all?{|s2| eliminate(values,s2,d2)}
    end
    ## check the places where d appears in the units of s
    @units[s].each{|u|
        dplaces = u.inject([]){|result,element| values[element].include?(d) ? result << element : result } 
        return false if dplaces.empty?
        #d can only be in one place in the unit, assign there
        return false if dplaces.length == 1 and !assign(values,dplaces.first, d)
    }      
    return values 
end

def search(values) 
    return false unless values #already failed
    return values if @squares.all?{|s| values[s].length == 1} #solves
    s = @squares.clone.delete_if{|x| values[x].length <= 1}.min{|a,b| values[a].length <=> values[b].length}
    test = values[s].split(//).detect(lambda{ false}) {|d| search(assign(Marshal::load(Marshal::dump(values)),s,d)) }
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

File.open(ARGV.first, "r") do |infile|
    while(line = infile.gets)
        p line.chomp
        printboard(search(parse_grid(line.chomp.split(//))))
    end
end
