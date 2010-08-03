def cross(A, B):
    return [a+b for a in A for b in B]

row = 'ABCD'
col = '1234'

print  cross(row,col)
