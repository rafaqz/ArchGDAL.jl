using Documenter, ArchGDAL

# make sure you have run the tests before such that the test files are present
makedocs(
    modules = [ArchGDAL],
    format = Documenter.HTML(;
        prettyurls = get(ENV, "CI", "false") == "true",
        canonical = "https://yeesian.com/ArchGDAL.jl",
        assets = String[],
    ),
    sitename = "ArchGDAL.jl",
    workdir = joinpath(@__DIR__, "..", "test"),
    strict = true,
    pages = [
        "index.md",
        "ArchGDAL Quickstart Guide" => "quickstart.md",
        "GDAL Datasets" => "datasets.md",
        "Feature Data" => "features.md",
        "Raster Data" => "rasters.md",
        "Working with Images" => "images.md",
        "Tables Interface" => "tables.md",
        "Geometric Operations" => "geometries.md",
        "Spatial Projections" => "projections.md",
        # "Working with Spatialite" => "spatialite.md",
        "Interactive versus Scoped Objects" => "memory.md",
        "Design Considerations" => "considerations.md",
        "API Reference" => "reference.md",
    ],
)

deploydocs(; repo = "github.com/yeesian/ArchGDAL.jl.git")
