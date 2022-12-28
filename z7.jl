using HorizonSideRobots
include("1.jl")

function n7(robot)
    state=true
    side = HorizonSide(rand(0:3))
    i = 1
    while state==true
        i+=1
        side = next(side)
        for j in 1:div(i,2)
            move!(robot,side)
            if ismarker(robot)
                state=false
                break
            end
        end
    end
end

