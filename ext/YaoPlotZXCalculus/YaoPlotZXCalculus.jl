module YaoPlotZXCalculus

import YaoPlots

using ZXCalculus.ZXW: ZXWDiagram, nv, X, Z, D, H, W
using ZXCalculus.ZX: ZXDiagram, SpiderType


using MLStyle, Karnak, NetworkLayout, Colors, CairoMakie

function YaoPlots.vizcircuit(zxd::ZXDiagram; kwargs...)
    verbose = get(kwargs, :verbose, false)
    graph_width = get(kwargs, :graphwidth, 10)
    graph_height= get(kwargs, :graphheight, 10)
    density = get(kwargs, :density, 2.0)
    iterations = get(kwargs, :iterations, 100)
    g = zxd.mg
    vertexlabels = Vector{String}(undef, nv(zxd.mg))
    vertexfillcolors = Vector{RGB}(undef, nv(zxd.mg))

    green = RGB(0, 1, 0)
    red = RGB(1, 0, 0)
    yellow = RGB(1, 1, 0)
    black = RGB(0, 0, 0)
    white = RGB(1, 1, 1)
    for (idx, v) in zxd.st
        if v == SpiderType.X
            curcolor = red
        elseif v == SpiderType.Z
            curcolor = green
        elseif v == SpiderType.H
            curcolor = yellow
        else
            curcolor = whie
        end

        if verbose
            vertexlabels[idx] = string(v)[15:end]
        else
            if curcolor == white
                vertexlabels[idx] = string(v)[15:end]
            else
                vertexlabels[idx] = string(v)[15:15]
            end
        end
        vertexfillcolors[idx] = curcolor
    end
    initialpos, pin = Dict(), Dict()
    height_step = graph_height / (length(zxd.inputs))
    for (idx, input) in enumerate(zxd.inputs)
        initialpos[input] = (-graph_width/2, height_step * idx)
        pin[input] = (true, true)
    end

    for (idx, output) in enumerate(zxwd.outputs)
        initialpos[output] = (graph_width/2, height_step * idx)
        pin[output] = (true, true)
    end

    layout = Spring(; initialpos = initialpos, pin = pin, C=density, iterations=iterations)
    @drawsvg begin
        background("black")
        sethue("blue")
        fontsize(8)
        drawgraph(
            g,
            layout = layout,
            vertexlabels = vertexlabels,
            vertexfillcolors = vertexfillcolors,
            vertexlabelrotations = 0.4,
            vertexlabeltextcolors = distinguishable_colors(20)
        )
    end 600 400
end

function YaoPlots.vizcircuit(zxwd::ZXWDiagram; kwargs...)
    verbose = get(kwargs, :verbose, false)
    graph_width = get(kwargs, :graphwidth, 10)
    graph_height= get(kwargs, :graphheight, 10)
    density = get(kwargs, :density, 2.0)
    iterations = get(kwargs, :iterations, 100)
    g = zxwd.mg
    vertexlabels = Vector{String}(undef, nv(zxwd.mg))
    vertexfillcolors = Vector{RGB}(undef, nv(zxwd.mg))

    green = RGB(0, 1, 0)
    red = RGB(1, 0, 0)
    yellow = RGB(1, 1, 0)
    black = RGB(0, 0, 0)
    white = RGB(1, 1, 1)
    for (idx, v) in zxwd.st
        curcolor = @match v begin
            X(_) => red
            Z(_) => green
            D => yellow
            H => yellow
            W => black
            _ => white
        end
        if verbose
            vertexlabels[idx] = string(v)[15:end]
        else
            if curcolor == white
                vertexlabels[idx] = string(v)[15:end]
            else
                vertexlabels[idx] = string(v)[15:15]
            end
        end
        vertexfillcolors[idx] = curcolor
    end
    initialpos, pin = Dict(), Dict()
    height_step = graph_height / (length(zxwd.inputs))
    for (idx, input) in enumerate(zxwd.inputs)
        initialpos[input] = (-graph_width/2, height_step * idx)
        pin[input] = (true, true)
    end

    for (idx, output) in enumerate(zxwd.outputs)
        initialpos[output] = (graph_width/2, height_step * idx)
        pin[output] = (true, true)
    end

    # layout = SFDP(; initialpos = initialpos, pin = pin)
    layout = Spring(; initialpos = initialpos, pin = pin, C=density, iterations=iterations)
    @drawsvg begin
        background("black")
        sethue("blue")
        fontsize(8)
        drawgraph(
            g,
            layout = layout,
            vertexlabels = vertexlabels,
            vertexfillcolors = vertexfillcolors,
            vertexlabelrotations = 0.4,
            vertexlabeltextcolors = distinguishable_colors(20)
        )
    end 600 400
end

end
