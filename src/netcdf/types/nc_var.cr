module Netcdf
  class NcVar
    property parent_id : Int32
    property id : Int32
    property name : String
    property var_type : Int32
    property ndims : Int32

    def initialize(@parent_id, @id)
      var_type = Int32.new(0)
      LibNetcdf4.nc_inq_var(@parent_id, @id, nil, pointerof(var_type), out ndims, nil, nil)
      @var_type = var_type
      @ndims = ndims

      name_buffer = Bytes.new(LibNetcdf4::NC_MAX_CHAR)
      LibNetcdf4.nc_inq_varname(@parent_id, @id, name_buffer)
      @name = String.new(name_buffer).gsub("\u0000", "").gsub("\u0001", "")
    end

    def attributes
      LibNetcdf4.nc_inq_varnatts(@parent_id, @id, out num_attributes)

      (0..num_attributes - 1).map do |i|
        name_buffer = Bytes.new(LibNetcdf4::NC_MAX_NAME)
        LibNetcdf4.nc_inq_attname(@parent_id, @id, i, name_buffer)
        name = String.new(name_buffer).gsub("\u0000", "")
        NcAtt.new(name, @parent_id, @id, i)
      end
    end

    # Endianness: "little", "big", or "native"
    def endianness
      LibNetcdf4.nc_inq_var_endian(@parent_id, @id, out v)
      case v
      when LibNetcdf4::NC_ENDIAN_LITTLE
        "little"
      when LibNetcdf4::NC_ENDIAN_BIG
        "big"
      when LibNetcdf4::NC_ENDIAN_NATIVE
        "native"
      else
        "unknown"
      end
    end

    # Checksum mode: "none" or "fletcher32"
    def checksum_mode
      LibNetcdf4.nc_inq_var_fletcher32(@parent_id, @id, out v)
      case v
      when LibNetcdf4::NC_NOCHECKSUM
        "none"
      when LibNetcdf4::NC_FLETCHER32
        "fletcher32"
      else
        "unknown"
      end
    end

    # Chunk mode: "contiguous", or "chunked"
    def chunk_mode
      LibNetcdf4.nc_inq_var_chunking(@parent_id, @id, out v, nil)
      case v
      when LibNetcdf4::NC_CONTIGUOUS
        "contiguous"
      when LibNetcdf4::NC_CHUNKED
        "chunked"
      else
        "unknown"
      end
    end

    # Array of chunk sizes, one size per dimension
    def chunk_sizes
      sizes = Array(UInt64).new(@ndims)
      LibNetcdf4.nc_inq_var_chunking(@parent_id, @id, nil, sizes.to_unsafe)
      sizes
    end

    # Boolean swith for fill mode
    def fill_mode
      LibNetcdf4.nc_inq_var_fill(@parent_id, @id, out v, nil)
      v == 1
    end

    # Fill value
    def fill_value
      case @var_type
      when LibNetcdf4::NC_BYTE
        v = UInt32.new(0)
        LibNetcdf4.nc_inq_var_fill(@parent_id, @id, nil, pointerof(v))
        v
      when LibNetcdf4::NC_CHAR
        v = '0'
        LibNetcdf4.nc_inq_var_fill(@parent_id, @id, nil, pointerof(v))
        v
      when LibNetcdf4::NC_SHORT
        v = UInt16.new(0)
        LibNetcdf4.nc_inq_var_fill(@parent_id, @id, nil, pointerof(v))
        v
      when LibNetcdf4::NC_INT
        v = Int32.new(0)
        LibNetcdf4.nc_inq_var_fill(@parent_id, @id, nil, pointerof(v))
        v
      when LibNetcdf4::NC_FLOAT
        v = Float32.new(0)
        LibNetcdf4.nc_inq_var_fill(@parent_id, @id, nil, pointerof(v))
        v
      when LibNetcdf4::NC_DOUBLE
        v = Float64.new(0)
        LibNetcdf4.nc_inq_var_fill(@parent_id, @id, nil, pointerof(v))
        v
      when LibNetcdf4::NC_UBYTE
        v = UInt8.new(0)
        LibNetcdf4.nc_inq_var_fill(@parent_id, @id, nil, pointerof(v))
        v
      when LibNetcdf4::NC_USHORT
        v = UInt16.new(0)
        LibNetcdf4.nc_inq_var_fill(@parent_id, @id, nil, pointerof(v))
        v
      when LibNetcdf4::NC_UINT
        v = UInt32.new(0)
        LibNetcdf4.nc_inq_var_fill(@parent_id, @id, nil, pointerof(v))
        v
      else
        raise Exception.new("Variable type not supported yet")
      end
    end

    # Boolean switch for shuffle
    # fun nc_inq_var_deflate(ncid : LibC::Int, varid : LibC::Int, shufflep : LibC::Int*, deflatep : LibC::Int*, deflate_levelp : LibC::Int*) : LibC::Int
    def compression_shuffle
      LibNetcdf4.nc_inq_var_deflate(@parent_id, @id, out v, nil, nil)
      v == 1
    end

    # Boolean switch for compression
    def compression_deflate
      LibNetcdf4.nc_inq_var_deflate(@parent_id, @id, nil, out v, nil)
      v == 1
    end

    # Compression level (1-9)
    def compression_level
      LibNetcdf4.nc_inq_var_deflate(@parent_id, @id, nil, nil, out v)
      v
    end
  end
end
