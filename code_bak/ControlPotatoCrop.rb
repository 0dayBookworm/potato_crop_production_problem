require_relative "PotatoCrop.rb"
require_relative "Node.rb"
require_relative "BranchAndBound.rb"

class ControlPotatoCrop
    def initialize(months, temperatures, precipitations, minDemands, maxDemands, produtionCycle, valPackage)
        @potato_crop = PotatoCrop.new(months, temperatures, precipitations, minDemands,
                                    maxDemands, produtionCycle, valPackage)
        @potato_crop.initObjFunC
        @potato_crop.initRestrictions
    end
    
    def solve 
        solution, solution_evaluation = @potato_crop.lp_relaxation
        p "lp_relaxation"
        p solution, solution_evaluation
        node = Node.new(solution, solution_evaluation)
        branch = BranchAndBound.new(@potato_crop)
        resultNode = branch.doBranchAndBound(node,0)
        p 'Result node'
        p resultNode
        return resultNode
    end

end