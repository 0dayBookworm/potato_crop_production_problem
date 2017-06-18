require_relative "Node.rb"
require_relative "PotatoCrop.rb"

class BranchAndBound
    
    def initialize(pCrop)
        @crop = pCrop
    end
    
    def doBranchAndBound(pNode, pLevel)
        # Validacion de profundidad del arbol.
        if pLevel > @crop.months
            return pNode
        end
        # Creamos el nodo izquierdo.
        leftCrop = @crop
        leftVal = pNode.solution[pLevel].floor
        leftCrop.addRestriction(pLevel, leftVal)
        leftSol = leftCrop.lp_relaxation
        lef_node = Node.new(leftSol[0], leftSol[1])
        # Creamos el nodo derecho.
        rightCrop = @crop
        rightVal = pNode.solution[pLevel].ceil 
        rightCrop.addRestriction(pLevel, -rightVal) 
        rightSol = rightCrop.lp_relaxation
        right_node = Node.new(rightSol[0], rightSol[1]) 
        # Verificamos opciones de ramificacion.
        if lef_node.evaluation >= right_node.evaluation and lef_node.evaluation != pNode.evaluation
            return doBranchAndBound(lef_node, pLevel+1)
        elsif lef_node.evaluation < right_node.evaluation and right_node.evaluation != pNode.evaluation
            return doBranchAndBound(right_node, pLevel+1)
        else 
            return pNode
        end
    end
end
