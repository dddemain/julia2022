using HorizonSideRobots
include("1.jl")

function n6(robot)
    side = checkside(robot)
    inst = shuttle!(robot,side)
    move!(robot,side)
    along!(robot,inv(inst[1]),div(inst[2]+1,2))
end

function checkside(robot)
    for side in (Nord,Ost,Sud,West)
        if isborder(robot,side)
            return side
            break
        end
    end
end

function shuttle!(robot,side)
    i = 0
    s = next(side)
    while true
        i += 1
        s = inv(s)
        along!(robot,s,i)
        if !isborder(robot,side)
            break
        end
    end
    return (s,i)
end

