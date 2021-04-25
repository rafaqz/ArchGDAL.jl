const GDALColorTable      = GDAL.GDALColorTableH
const GDALCoordTransform  = GDAL.OGRCoordinateTransformationH
const GDALDataset         = GDAL.GDALDatasetH
const GDALDriver          = GDAL.GDALDriverH
const GDALFeature         = GDAL.OGRFeatureH
const GDALFeatureDefn     = GDAL.OGRFeatureDefnH
const GDALFeatureLayer    = GDAL.OGRLayerH
const GDALField           = GDAL.OGRField
const GDALFieldDefn       = GDAL.OGRFieldDefnH
const GDALGeometry        = GDAL.OGRGeometryH
const GDALGeomFieldDefn   = GDAL.OGRGeomFieldDefnH
const GDALProgressFunc    = GDAL.GDALProgressFunc
const GDALRasterAttrTable = GDAL.GDALRasterAttributeTableH
const GDALRasterBand      = GDAL.GDALRasterBandH
const GDALSpatialRef      = GDAL.OGRSpatialReferenceH
const GDALStyleManager    = GDAL.OGRStyleMgrH
const GDALStyleTable      = GDAL.OGRStyleTableH
const GDALStyleTool       = GDAL.OGRStyleToolH

const StringList          = Ptr{Cstring}

CPLErr = GDAL.CPLErr
CPLXMLNodeType = GDAL.CPLXMLNodeType
GDALDataType = GDAL.GDALDataType
GDALAsyncStatusType = GDAL.GDALAsyncStatusType
GDALAccess = GDAL.GDALAccess
GDALRWFlag = GDAL.GDALRWFlag
GDALRIOResampleAlg = GDAL.GDALRIOResampleAlg
GDALColorInterp = GDAL.GDALColorInterp
GDALPaletteInterp = GDAL.GDALPaletteInterp
GDALRATFieldType = GDAL.GDALRATFieldType
GDALRATFieldUsage = GDAL.GDALRATFieldUsage
GDALTileOrganization = GDAL.GDALTileOrganization
GDALGridAlgorithm = GDAL.GDALGridAlgorithm
OGRwkbGeometryType = GDAL.OGRwkbGeometryType
OGRwkbVariant = GDAL.OGRwkbVariant
OGRFieldSubType = GDAL.OGRFieldSubType
OGRJustification = GDAL.OGRJustification
OGRSTClassId = GDAL.OGRSTClassId
OGRSTUnitId = GDAL.OGRSTUnitId
OGRSTPenParam = GDAL.OGRSTPenParam
OGRSTBrushParam = GDAL.OGRSTBrushParam
OGRSTSymbolParam = GDAL.OGRSTSymbolParam
OGRSTLabelParam = GDAL.OGRSTLabelParam
GDALResampleAlg = GDAL.GDALResampleAlg
GWKAverageOrModeAlg = GDAL.GWKAverageOrModeAlg
OGRAxisOrientation = GDAL.OGRAxisOrientation

"return the corresponding `DataType` in julia"
const _JLTYPE = Dict{GDALDataType, DataType}(
    GDAL.GDT_Unknown    => Any,
    GDAL.GDT_Byte       => UInt8,
    GDAL.GDT_UInt16     => UInt16,
    GDAL.GDT_Int16      => Int16,
    GDAL.GDT_UInt32     => UInt32,
    GDAL.GDT_Int32      => Int32,
    GDAL.GDT_Float32    => Float32,
    GDAL.GDT_Float64    => Float64,
)

const _GDALTYPE = Dict{DataType,GDALDataType}(
    Any         => GDAL.GDT_Unknown,
    UInt8       => GDAL.GDT_Byte,
    UInt16      => GDAL.GDT_UInt16,
    Int16       => GDAL.GDT_Int16,
    UInt32      => GDAL.GDT_UInt32,
    Int32       => GDAL.GDT_Int32,
    Float32     => GDAL.GDT_Float32,
    Float64     => GDAL.GDT_Float64,
)

@enum(OGRFieldType,
    OFTInteger          = 0,
    OFTIntegerList      = 1,
    OFTReal             = 2,
    OFTRealList         = 3,
    OFTString           = 4,
    OFTStringList       = 5,
    OFTWideString       = 6,
    OFTWideStringList   = 7,
    OFTBinary           = 8,
    OFTDate             = 9,
    OFTTime             = 10,
    OFTDateTime         = 11,
    OFTInteger64        = 12,
    OFTInteger64List    = 13,
    OFTMaxType          = 14,
)

"return the corresponding `DataType` in julia"
const _FIELDTYPE = Dict{OGRFieldType, DataType}(
    OFTInteger         => Int32,
    OFTIntegerList     => Vector{Int32},
    OFTReal            => Float64,
    OFTRealList        => Vector{Float64},
    OFTString          => String,
    OFTStringList      => Vector{String},
    OFTWideString      => Nothing, # deprecated
    OFTWideStringList  => Nothing, # deprecated
    OFTBinary          => Vector{UInt8},
    OFTDate            => Dates.Date,
    OFTTime            => Dates.Time,
    OFTDateTime        => Dates.DateTime,
    OFTInteger64       => Int64,
    OFTInteger64List   => Vector{Int64},
    # OFTMaxType         => Nothing # unsupported
)

@enum(WKBGeometryType,
    wkbUnknown                  = 0,
    wkbPoint                    = 1,
    wkbLineString               = 2,
    wkbPolygon                  = 3,
    wkbMultiPoint               = 4,
    wkbMultiLineString          = 5,
    wkbMultiPolygon             = 6,
    wkbGeometryCollection       = 7,
    wkbCircularString           = 8,
    wkbCompoundCurve            = 9,
    wkbCurvePolygon             = 10,
    wkbMultiCurve               = 11,
    wkbMultiSurface             = 12,
    wkbCurve                    = 13,
    wkbSurface                  = 14,
    wkbPolyhedralSurface        = 15,
    wkbTIN                      = 16,
    wkbTriangle                 = 17,
    wkbNone                     = 18,
    wkbLinearRing               = 19,
    wkbCircularStringZ          = 20,
    wkbCompoundCurveZ           = 21,
    wkbCurvePolygonZ            = 22,
    wkbMultiCurveZ              = 23,
    wkbMultiSurfaceZ            = 24,
    wkbCurveZ                   = 25,
    wkbSurfaceZ                 = 26,
    wkbPolyhedralSurfaceZ       = 27,
    wkbTINZ                     = 28,
    wkbTriangleZ                = 29,
    wkbPointM                   = 30,
    wkbLineStringM              = 31,
    wkbPolygonM                 = 32,
    wkbMultiPointM              = 33,
    wkbMultiLineStringM         = 34,
    wkbMultiPolygonM            = 35,
    wkbGeometryCollectionM      = 36,
    wkbCircularStringM          = 37,
    wkbCompoundCurveM           = 38,
    wkbCurvePolygonM            = 39,
    wkbMultiCurveM              = 40,
    wkbMultiSurfaceM            = 41,
    wkbCurveM                   = 42,
    wkbSurfaceM                 = 43,
    wkbPolyhedralSurfaceM       = 44,
    wkbTINM                     = 45,
    wkbTriangleM                = 46,
    wkbPointZM                  = 47,
    wkbLineStringZM             = 48,
    wkbPolygonZM                = 49,
    wkbMultiPointZM             = 50,
    wkbMultiLineStringZM        = 51,
    wkbMultiPolygonZM           = 52,
    wkbGeometryCollectionZM     = 53,
    wkbCircularStringZM         = 54,
    wkbCompoundCurveZM          = 55,
    wkbCurvePolygonZM           = 56,
    wkbMultiCurveZM             = 57,
    wkbMultiSurfaceZM           = 58,
    wkbCurveZM                  = 59,
    wkbSurfaceZM                = 60,
    wkbPolyhedralSurfaceZM      = 61,
    wkbTINZM                    = 62,
    wkbTriangleZM               = 63,
    wkbPoint25D                 = 64,
    wkbLineString25D            = 65,
    wkbPolygon25D               = 66,
    wkbMultiPoint25D            = 67,
    wkbMultiLineString25D       = 68,
    wkbMultiPolygon25D          = 69,
    wkbGeometryCollection25D    = 70,
)

@enum(WKBByteOrder,
    wkbXDR = 0,
    wkbNDR = 1,
)

@enum(GDALOpenFlag,
    OF_ReadOnly             = GDAL.GDAL_OF_READONLY,                # 0x00
    OF_Update               = GDAL.GDAL_OF_UPDATE,                  # 0x01
    # OF_All                  = GDAL.GDAL_OF_ALL,                     # 0x00
    OF_Raster               = GDAL.GDAL_OF_RASTER,                  # 0x02
    OF_Vector               = GDAL.GDAL_OF_VECTOR,                  # 0x04
    OF_GNM                  = GDAL.GDAL_OF_GNM,                     # 0x08
    OF_Kind_Mask            = GDAL.GDAL_OF_KIND_MASK,               # 0x1e
    OF_Shared               = GDAL.GDAL_OF_SHARED,                  # 0x20
    OF_Verbose_Error        = GDAL.GDAL_OF_VERBOSE_ERROR,           # 0x40
    OF_Internal             = GDAL.GDAL_OF_INTERNAL,                # 0x80
    # OF_DEFAULT_BLOCK_ACCESS = GDAL.GDAL_OF_DEFAULT_BLOCK_ACCESS,    # 0
    OF_Array_Block_Access   = GDAL.GDAL_OF_ARRAY_BLOCK_ACCESS,      # 0x0100
    OF_Hashset_Block_Access = GDAL.GDAL_OF_HASHSET_BLOCK_ACCESS,    # 0x0200
    # OF_RESERVED_1           = GDAL.GDAL_OF_RESERVED_1,              # 0x0300
    OF_Block_Access_Mask    = GDAL.GDAL_OF_BLOCK_ACCESS_MASK,       # 0x0300
)
