require_relative "Simplex.rb"
#===============Begin Example 1========================================
#Nota por lo que veo solo puede con restricciones <=
#https://github.com/danlucraft/simplex
# max x +  y
#   2x +  y <= 4
#   x + 2y <= 3
#   x, y >= 0
simplex = Simplex.new(
  [1, 1],       # coefficients of objective function
  [             # matrix of inequality coefficients on the lhs ...
    [ 2,  1],
    [ 1,  2],
  ],
  [4, 3]        # .. and the rhs of the inequalities
)
#puts simplex.solution
#===============End Example1========================================

#===============Begin Example 2========================================
#http://www.ingenieriaindustrialonline.com/herramientas-para-el-ingeniero-industrial/investigaci%C3%B3n-de-operaciones/m%C3%A9todo-simplex/
# ZMAX = 20000X1 + 20000X2 + 20000X3 + 20000X4
# 2X1 + 1X2 + 1X3 + 2X4 <= 24               
# 2X1 + 2X2 + 1X3 <= 20                     
# 2X3 + 2X4 <= 20                            
# 4X4 <= 16    

simplex = Simplex.new(
  [20000, 20000, 20000, 20000],       # coefficients of objective function
  [             # matrix of inequality coefficients on the lhs ...
    [ 2, 1, 1, 2],
    [ 2, 2, 1, 0],
    [ 0, 0, 2, 2],
    [ 0, 0, 0, 4],
  ],
  [24, 20, 20, 16]        # .. and the rhs of the inequalities
)

#puts simplex.formatted_tableau
#puts simplex.solution
#===============End Example 2========================================



#===============Begin Example 3========================================
#Facility Location
#A company is thinking about building new facilities in LA and SF
#                     capital needed  expected profit
#1. factory in LA      $6M             $9M
#2. factory in SF      $3M             $5M
#3. warehouse in LA    $5M             $6M
#4. warehouse in SF    $2M             $4M

# ZMAX = 9X1 + 5X2 + 6X3 + 4X4
#6X1 + 3X2 + 5X3 + 2X4 <= 10

#build at most one of the two warehouses #X3 + X4 <= 1
#build at least one of the two factories X1 + X2 >= 1.                                        with simplex algorithm would be equivalent to -X1 -X2 <= - 1
# X4 = 2. with simplex algorithm would be equivalent to X4<=2 and -X4<=-2
simplex = Simplex.new(
  [9, 5, 6, 4],       # coefficients of objective function
  [             # matrix of inequality coefficients on the lhs ...
    [6, 3, 5, 2],
    [0, 0, 1, 1],
    [-1, -1, 0, 0],
    [0, 0, 0, 1],
    [0, 0, 0, -1],
  ],
  [10, 1, -1, 2, -2 ]        # .. and the rhs of the inequalities
  #[10, 2 , -2]
)
# puts simplex.formatted_tableau
# puts simplex.solution

#===============End Example 3========================================

#===============Begin Example 4========================================
#AQUÍ SE PRUEBA UNA RESTRICCION INSATISFACTIBLE
simplex = Simplex.new(
  [5, 8],       # coefficients of objective function
  [             # matrix of inequality coefficients on the lhs ...
    [1, 1],
    [5, 9],
    [-1, -1],
    [0, -1], # X2 >= 4 
    [-1, 0], # X1 >= 2 #=> Insatisfactible.
   
  ],
  [6, 45, 0, -4, -2]        # .. and the rhs of the inequalities
  #[10, 2 , -2]
)
puts simplex.formatted_tableau
p simplex.solution


#===============End Example 4========================================

