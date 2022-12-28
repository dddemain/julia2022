using HorizonSideRobots
include("1.jl")

function n8(robot,side)
    function alongstop!(robot,side,given_steps,stop_cond)
        while !stop_cond && num_steps < given_steps && !isborder(robot,side)
            move!(robot,side)
        end
    end
    
