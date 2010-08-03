def cross(a,b)
    a.collect{|x|  b.collect{|y|  x+y }}
end
puts cross(["A","B","C","D"],["1","2","3","4"])
