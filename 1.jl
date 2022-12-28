using HorizonSideRobots
hsr = HorizonSideRobots
#######################


function along1!(robot,direct)::Nothing
    while !isborder(robot,direct)
        move!(robot,direct)
    end
end

function num_steps_along1!(robot,direct)::Int
    num_steps=0
    while !isborder(robot,direct)
        move!(robot,direct)
        num_steps +=1
    end
    return num_steps
end

##2ndmethod
function along1!(robot,direct,num_steps)::Nothing
    for _ in 1:num_steps
        move!(robot,direct)
    end
end

##newlevels
t_move!(robot,direct) = (!isborder(robot,direct) && (move!(robot,direct); return true); false)

function along!(robot,direct,ns::Bool=false,pm::Bool=false)
    num_steps = 0
    if pm putmarker!(robot) end
    while t_move!(robot,direct)
        if pm putmarker!(robot) end
        if ns num_steps += 1 end
    end
    return num_steps
end

function along!(robot,direct,given_steps::Int,pm::Bool=false)
    num_steps = zero(given_steps)
    if pm putmarker!(robot) end
    while given_steps > num_steps && t_move!(robot,direct)
        if pm putmarker!(robot) end
        num_steps += 1
    end
    return num_steps
end


##addit
next(side::HorizonSide)::HorizonSide = HorizonSide(mod(Int(side)+3,4))
inv(side::HorizonSide)::HorizonSide = HorizonSide(mod(Int(side)+2,4))
prev(side::HorizonSide)::HorizonSide = HorizonSide(mod(Int(side)+1,4))
##addit

function get_crd(robot)
    cx,cy=0,0
    while !isborder(robot,West) || !isborder(robot,Sud)
        if t_move!(robot,West) cx +=1 end
        if t_move!(robot,Sud) cy +=1 end
    end
    return (cx,cy)
end

function goto_crd(robot,crd,pos::Bool=false)
    if !pos get_crd(robot) end
    along!(robot,Ost,crd[1])
    along!(robot,Nord,crd[2])
end

##practice
function markcross(robot)
    for i in 0:3
        side = HorizonSide(i)
        steps = along!(robot,side,true,true)
        along!(robot,inv(side),steps)
    end
end

function markedges(robot)
    crd = get_crd(robot)
    for side in (Nord,Ost,Sud,West)
        along!(robot,side,false,true)
    end
    goto_crd(robot,crd)
    return nothing
end

##redef4t2
hsr.move!(robot,side::NTuple{2,HorizonSide}) = for s in side move!(robot,s) end
hsr.isborder(robot,side::NTuple{2,HorizonSide}) = isborder(robot,side[1]) || isborder(robot,side[2])
next(side::NTuple{2,HorizonSide}) = next.(side)
inv(side::NTuple{2,HorizonSide}) = inv.(side)

function markx(robot)
    for i in 0:3
        side = HorizonSide(i)
        tside = (side,next(side))
        steps = along!(robot,tside,true,true)
        along!(robot,inv(tside),steps)
    end
end

function movefield(robot,pm::Bool=false)
    crd = get_crd(robot)
    s = Nord
    along!(robot,s,false,pm)
    while t_move!(robot,Ost)
        s = inv(s)
        along!(robot,s,false,pm)
    end
    goto_crd(robot,crd)
end

function mean_tmpr(robot)
    crd = get_crd(robot)
    s = Nord
    temps = collect(alongtemp!(robot,s))
    while t_move!(robot,Ost)
        s = inv(s)
        temps .+ alongtemp!(robot,s)
    end
    goto_crd(robot,crd)
    return temps[1]/temps[2]
end
function alongtemp!(robot,side)
    t,c = 0,0
    while true
        if ismarker(robot)
            t += temperature(robot)
            c += 1
        end
        if !t_move!(robot,side)
            break
        end
    end
    return (t,c)
end

