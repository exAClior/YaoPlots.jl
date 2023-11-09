module YaoPlotZXCalculus

import YaoPlots

using ZXCalculus.ZXW: ZXWDiagram, nv, X, Z, D, H, W
using ZXCalculus.ZX: ZXDiagram


using MLStyle, Karnak, NetworkLayout, Colors, CairoMakie

function YaoPlots.vizcircuit(cir::ZXDiagram, kwargs...)
    println("TODO")
end

function YaoPlots.vizcircuit(zxwd::ZXWDiagram)
    g = zxwd.mg
    vertexlabels = Vector{String}(undef, nv(zxwd.mg))
    for (idx, vtx) in zxwd.st
        vertexlabels[idx] = string(vtx)[15:end]
    end
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
        vertexfillcolors[idx] = curcolor
    end
    initialpos, pin = Dict(), Dict()
    for (idx, input) in enumerate(zxwd.inputs)
        initialpos[input] = (-2, idx)
        pin[input] = (true, true)
    end

    for (idx, output) in enumerate(zxwd.outputs)
        initialpos[output] = (nv(zxwd.mg) / length(zxwd.inputs), idx)
        pin[output] = (true, true)
    end

    layout = SFDP(; initialpos = initialpos, pin = pin)
    @drawsvg begin
        background("black")
        sethue("grey40")
        fontsize(8)
        drawgraph(
            g,
            layout = layout,
            vertexlabels = vertexlabels,
            vertexfillcolors = vertexfillcolors,
        )
    end 600 400
end

end
