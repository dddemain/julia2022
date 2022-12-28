using HorizonSideRobots
include("1.jl")

function n5(robot)
    crd = get_crd(robot)
    markedges(robot)
    inv_get_crd(robot,movefield_stop(robot))
    inv_markedges(robot)
    goto_crd(robot,crd)
end

function movefield_stop(robot)
    s = Ost
    width = along!(robot,s,true)
    while t_move!(robot,Nord)
        s = inv(s)
        if along!(robot,s,true) < width
            return s
            break
        end
    end
end

function inv_get_crd(robot,s)
    while isborder(robot,s)
        move!(robot,Sud)
    end
    if s == West
        while t_move!(robot,s) && isborder(robot,Nord)
            continue
        end
    end
end

function inv_markedges(robot)
    for side in (Nord,Ost,Sud,West)
        while t_move!(robot,side) && isborder(robot,next(side))
            putmarker!(robot)
        end
        putmarker!(robot)
    end
end

