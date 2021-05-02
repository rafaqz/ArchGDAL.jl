function imread(colortable::ColorTable, dataset::AbstractDataset, indices)
    palette = getcolortable(getband(dataset, indices[1])) do ct
        paletteinterp(ct)
    end
    colortype = if palette == GPI_Gray
        ColorTypes.Gray
    elseif palette == GPI_RGB
        ColorTypes.RGBA
    else
        error("""
        $palette not yet supported. Please file an issue at
        https://github.com/yeesian/ArchGDAL.jl/issues
        """)
    end
    return imread(colortype, dataset, Tuple(indices))
end

function imread(
    colortype::Type{<:ColorTypes.Colorant},
    dataset::AbstractDataset,
    indices::NTuple{1,<:Integer},
)
    return ImageCore.PermutedDimsArray(
        ImageCore.colorview(colortype, ImageCore.normedview(read(dataset, indices[1]))),
        (2, 1),
    )
end

function imread(
    colortype::Type{<:ColorTypes.Colorant},
    dataset::AbstractDataset,
    indices::NTuple{3,<:Integer},
)
    return ImageCore.PermutedDimsArray(
        ImageCore.colorview(
            colortype,
            ImageCore.normedview(read(dataset, indices[1])),
            ImageCore.normedview(read(dataset, indices[2])),
            ImageCore.normedview(read(dataset, indices[3])),
        ),
        (2, 1),
    )
end

function imread(
    colortype::Type{<:ColorTypes.Colorant},
    dataset::Dataset,
    indices::NTuple{4,<:Integer},
)
    return ImageCore.PermutedDimsArray(
        ImageCore.colorview(
            colortype,
            ImageCore.normedview(read(dataset, indices[1])),
            ImageCore.normedview(read(dataset, indices[2])),
            ImageCore.normedview(read(dataset, indices[3])),
            ImageCore.normedview(read(dataset, indices[4])),
        ),
        (2, 1),
    )
end

function imread(dataset::AbstractDataset, indices)
    gci = unique(GDALColorInterp[getcolorinterp(getband(dataset, i)) for i in indices])
    gciorder = sort(gci)
    return if gciorder == [GCI_GrayIndex]
        imread(ColorTypes.Gray, dataset, Tuple(indices[sortperm(gci)]))
    elseif gciorder == [GCI_PaletteIndex]
        getcolortable(getband(dataset, 1)) do ct
            imread(ct, dataset, indices)
        end
    elseif gciorder == [GCI_RedBand, GCI_GreenBand, GCI_BlueBand]
        imread(ColorTypes.RGB, dataset, Tuple(indices[sortperm(gci)]))
    elseif gciorder == [GCI_RedBand, GCI_GreenBand, GCI_BlueBand, GCI_AlphaBand]
        imread(ColorTypes.RGBA, dataset, Tuple(indices[sortperm(gci)]))
    else
        error("""
        Unknown GCI: $gciorder. Please file an issue at
        https://github.com/yeesian/ArchGDAL.jl/issues
        """)
    end
end

imread(dataset::AbstractDataset) = imread(dataset, 1:nraster(dataset))

function imread(filename::String)
    return read(filename) do dataset
        imread(dataset)
    end
end