module Netcdf
  class NcVar
    property parent_id : Int32
    property id : Int32
    property name : String
    property var_type : Int32
    property ndims : Int32

    def initialize(@parent_id, @id)
      name_buffer = Bytes.new(LibNetcdf4::NC_MAX_CHAR)
      LibNetcdf4.nc_inq_var(@parent_id, @id, name_buffer, out @var_type, out @ndims, nil, nil)
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

    # Reads and returns an array of values (cf. "[Specify a Hyperslab](https://www.unidata.ucar.edu/software/netcdf/docs/programming_notes.html#specify_hyperslab)")
    # at positions and sizes given for each dimension, `readSlice(pos1, size1, pos2, size2, ...)`
    # e.g. `readSlice(2, 3, 4, 2)` gives an array of the values at position 2 for 3 steps along the
    # first dimension and position 4 for 2 steps along the second one.
    def read_slice(*args)
      if args.size != @ndims * 2
        raise Exception.new("Wrong number of arguments")
      end

      if (@var_type < LibNetcdf4::NC_BYTE || @var_type > LibNetcdf4::NC_INT64) && @var_type != LibNetcdf4::NC_STRING
        raise Exception.new("Variable type not supported yet")
      end

      pos = Array(UInt64).new(@ndims)
      size = Array(UInt64).new(@ndims)
      total_size = 1

      (0..@ndims - 1).each do |i|
        pos << args[2 * i].to_u64
        s = args[2 * i + 1].to_u64
        size << s
        total_size = total_size * s
      end

      get_val(pos, size, total_size)
    end

    # Reads and returns a single value at positions given as for `write`
    def read(*args)
      if args.size != @ndims
        raise Exception.new("Wrong number of arguments")
      end

      if (@var_type < LibNetcdf4::NC_BYTE || @var_type > LibNetcdf4::NC_INT64) && @var_type != LibNetcdf4::NC_STRING
        raise Exception.new("Variable type not supported yet")
      end

      pos = Array(UInt64).new(@ndims)
      size = Array(UInt64).new(@ndims)
      total_size = 1

      (0..@ndims - 1).each do |i|
        pos << args[i].to_u64
        size << 1.to_u64
      end

      get_val(pos, size, total_size)[0]
    end

    private def get_val(pos, size, total_size)
      case @var_type
      when LibNetcdf4::NC_BYTE, LibNetcdf4::NC_UBYTE
        sbyte_val = Bytes.new(total_size)
        LibNetcdf4.nc_get_vara_ubyte(@parent_id, @id, pos, size, sbyte_val)
        sbyte_val
      when LibNetcdf4::NC_CHAR
        char_val = Bytes.new(total_size)
        LibNetcdf4.nc_get_vara(@parent_id, @id, pos, size, char_val)
        char_val
      when LibNetcdf4::NC_SHORT
        short_val = Slice(Int16).new(total_size)
        LibNetcdf4.nc_get_vara(@parent_id, @id, pos, size, short_val)
        short_val
      when LibNetcdf4::NC_INT
        int_val = Slice(Int32).new(total_size)
        LibNetcdf4.nc_get_vara(@parent_id, @id, pos, size, int_val)
        int_val
      when LibNetcdf4::NC_DOUBLE, LibNetcdf4::NC_FLOAT
        double_val = Slice(Float64).new(total_size)
        LibNetcdf4.nc_get_vara(@parent_id, @id, pos, size, double_val)
        double_val
      when LibNetcdf4::NC_USHORT
        ushort_val = Slice(Int16).new(total_size)
        LibNetcdf4.nc_get_vara(@parent_id, @id, pos, size, ushort_val)
        ushort_val
      when LibNetcdf4::NC_UINT
        uint_val = Slice(Int32).new(total_size)
        LibNetcdf4.nc_get_vara(@parent_id, @id, pos, size, uint_val)
        uint_val
      else
        raise Exception.new("Variable type not supported yet")
      end
    end
  end
end
