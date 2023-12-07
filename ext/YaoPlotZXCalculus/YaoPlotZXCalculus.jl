module YaoPlotZXCalculus

import YaoPlots

using ZXCalculus.ZXW: ZXWDiagram, nv, X, Z, D, H, W, Input, Output
using ZXCalculus.Utils: PiUnit, Factor
using ZXCalculus.ZX: ZXDiagram, SpiderType


using MLStyle, Karnak, NetworkLayout, Colors, CairoMakie

function YaoPlots.vizcircuit(zxd::ZXDiagram; kwargs...)
    # verbose = get(kwargs, :verbose, false)
    # graph_width = get(kwargs, :graphwidth, 10)
    # graph_height= get(kwargs, :graphheight, 10)
    # density = get(kwargs, :density, 2.0)
    # iterations = get(kwargs, :iterations, 100)
    # g = zxd.mg
    # vertexlabels = Vector{String}(undef, nv(zxd.mg))
    # vertexfillcolors = Vector{RGB}(undef, nv(zxd.mg))

    # green = RGB(0, 1, 0)
    # red = RGB(1, 0, 0)
    # yellow = RGB(1, 1, 0)
    # black = RGB(0, 0, 0)
    # white = RGB(1, 1, 1)
    # for (idx, v) in zxd.st
    #     if v == SpiderType.X
    #         curcolor = red
    #     elseif v == SpiderType.Z
    #         curcolor = green
    #     elseif v == SpiderType.H
    #         curcolor = yellow
    #     else
    #         curcolor = white
    #     end

    #     if verbose
    #         vertexlabels[idx] = string(v)[15:end]
    #     else
    #         if curcolor == white
    #             vertexlabels[idx] = string(v)[15:end]
    #         else
    #             vertexlabels[idx] = string(v)[15:15]
    #         end
    #     end
    #     vertexfillcolors[idx] = curcolor
    # end
    # initialpos, pin = Dict(), Dict()
    # height_step = graph_height / (length(zxd.inputs))
    # for (idx, input) in enumerate(zxd.inputs)
    #     initialpos[input] = (-graph_width/2, height_step * idx)
    #     pin[input] = (true, true)
    # end

    # for (idx, output) in enumerate(zxwd.outputs)
    #     initialpos[output] = (graph_width/2, height_step * idx)
    #     pin[output] = (true, true)
    # end

    # layout = Spring(; initialpos = initialpos, pin = pin, C=density, iterations=iterations)
    # @drawsvg begin
    #     background("black")
    #     sethue("blue")
    #     fontsize(8)
    #     drawgraph(
    #         g,
    #         layout = layout,
    #         vertexlabels = vertexlabels,
    #         vertexfillcolors = vertexfillcolors,
    #         vertexlabelrotations = 0.4,
    #         vertexlabeltextcolors = distinguishable_colors(20)
    #     )
    # end 600 400
    println("TODO")
end

function YaoPlots.vizcircuit(zxwd::ZXWDiagram; kwargs...)
    verbose = get(kwargs, :verbose, false)
    graph_width = get(kwargs, :graphwidth, 10)
    graph_height= get(kwargs, :graphheight, 10)
    density = get(kwargs, :density, 2.0)
    iterations = get(kwargs, :iterations, 100)
    circ_size = get(kwargs, :circsize, 10)
    bgcolor = get(kwargs, :bgcolor, "black")
    linewidth = get(kwargs, :linewidth, 3)
    spfontsize = get(kwargs, :fontsize, 8)
    vrot = get(kwargs, :vrot, 0.4)
    plotsize = get(kwargs, :plotsize, (200, 100))

    g = zxwd.mg
    vertexlabels = Vector{String}(undef, nv(zxwd.mg))
    vertexfillcolors = Vector{RGB}(undef, nv(zxwd.mg))
    vtxshapes = Vector{Symbol}(undef, nv(zxwd.mg))

    green = RGB(0, 1, 0)
    red = RGB(1, 0, 0)
    yellow = RGB(1, 1, 0)
    black = RGB(0, 0, 0)
    white = RGB(1, 1, 1)
    for (idx, v) in zxwd.st
        vertexfillcolors[idx] = @match v begin
            X(_) => red
            Z(_) => green
            D => yellow
            H => yellow
            W => black
            _ => white
        end

        vertexlabels[idx] = @match v begin
            X(p) => @match p begin
                PiUnit(val,_) => "X($val * π)"
                Factor(val,_) => "X($val)"
                _ => "X"
            end
            Z(p) => @match p begin
                PiUnit(val,_) => "Z($val * π)"
                Factor(val,_) => "Z($val)"
                _ => "X"
            end
            D => "D"
            H => "H"
            W => "W"
            Input(q) => "In($q)"
            Output(q) => "Out($q)"
            _ => "Unknown"
        end

        vtxshapes[idx] = @match v begin
            X(_) => :circle
            Z(_) => :circle
            D => :triangle
            H => :square
            W => :triangle
            _ => :circle
        end

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

    layout = Spring(; initialpos = initialpos, pin = pin, C=density, iterations=iterations)
    @drawsvg begin
        background(bgcolor)
        sethue("blue")
        fontsize(spfontsize)
        drawgraph(
            g,
            layout = layout,
            edgestrokeweights = linewidth,
            edgestrokecolors = colorant"grey",
            vertexshapesizes = circ_size,
            vertexstrokecolors = colorant"grey",
            vertexshapes = vtxshapes,
            vertexlabels = vertexlabels,
            vertexfillcolors = vertexfillcolors,

            vertexlabelrotations = vrot,
            vertexlabeltextcolors = colorant"blue"
        )
    end plotsize[1] plotsize[2]
end

end
