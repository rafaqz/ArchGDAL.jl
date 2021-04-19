function Base.iterate(layer::AbstractFeatureLayer, state::Int=0)
    layer.ptr == C_NULL && return nothing
    state == 0 && resetreading!(layer)
    ptr = GDAL.ogr_l_getnextfeature(layer.ptr)
    return if ptr == C_NULL
        resetreading!(layer)
        nothing
    else
        (Feature(ptr), state+1)
    end
end

Base.eltype(layer::AbstractFeatureLayer) = Feature

Base.length(layer::AbstractFeatureLayer) = nfeature(layer, true)

struct BlockIterator
    rows::Cint
    cols::Cint
    ni::Cint
    nj::Cint
    n::Cint
    xbsize::Cint
    ybsize::Cint
end

function blocks(raster::AbstractRasterBand)
    (xbsize, ybsize) = blocksize(raster)
    rows = height(raster)
    cols = width(raster)
    ni = ceil(Cint, rows / ybsize)
    nj = ceil(Cint, cols / xbsize)
    return BlockIterator(rows, cols, ni, nj, ni * nj, xbsize, ybsize)
end

function Base.iterate(obj::BlockIterator, iter::Int=0)
    iter == obj.n && return nothing
    j = floor(Int, iter / obj.ni)
    i = iter % obj.ni
    nrows = if (i + 1) * obj.ybsize < obj.rows
        obj.ybsize
    else
        obj.rows - i * obj.ybsize
    end
    ncols = if (j + 1) * obj.xbsize < obj.cols
        obj.xbsize
    else
        obj.cols - j * obj.xbsize
    end
    return (((i, j), (nrows, ncols)), iter+1)
end

struct WindowIterator
    blockiter::BlockIterator
end
Base.size(i::WindowIterator) = (i.blockiter.ni, i.blockiter.nj)
Base.length(i::WindowIterator) = i.blockiter.n
Base.IteratorSize(::Type{WindowIterator}) = Base.HasShape{2}()
Base.IteratorEltype(::Type{WindowIterator}) = Base.HasEltype()
Base.eltype(::WindowIterator) = Tuple{UnitRange{Int}, UnitRange{Int}}

windows(raster::AbstractRasterBand) = WindowIterator(blocks(raster))

function Base.iterate(obj::WindowIterator, iter::Int=0)
    handle = obj.blockiter
    next = Base.iterate(handle, iter)
    next == nothing && return nothing
    (((i, j), (nrows, ncols)), iter) = next
    return (
        ((1:ncols) .+ j * handle.xbsize, (1:nrows) .+ i * handle.ybsize),
        iter
    )
end

mutable struct BufferIterator{T <: Real}
    raster::AbstractRasterBand
    w::WindowIterator
    buffer::Array{T, 2}
end

function bufferwindows(raster::AbstractRasterBand)
    return BufferIterator(
        raster,
        windows(raster),
        Array{pixeltype(raster)}(undef, blocksize(raster)...)
    )
end

function Base.iterate(obj::BufferIterator, iter::Int=0)
    next = Base.iterate(obj.w, iter)
    next == nothing && return nothing
    ((cols, rows), iter) = next
    rasterio!(obj.raster, obj.buffer, rows, cols)
    return (obj.buffer[1:length(cols), 1:length(rows)], iter)
end
