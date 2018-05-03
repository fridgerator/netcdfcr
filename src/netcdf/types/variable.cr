module NetCDF
  class Variable
    property parent_id : Int32
    property id : Int32
    property name : String
    property var_type : Int32
    property ndims : Int32

    def initialize(@parent_id, @id)
      name_buffer = Bytes.new(LibNetcdf4::NC_MAX_CHAR)
      var_type = uninitialized Int32
      ndims = uninitialized Int32
      NetCDF.call_netcdf { LibNetcdf4.nc_inq_var(@parent_id, @id, name_buffer, pointerof(var_type), pointerof(ndims), nil, nil) }
      @var_type = var_type
      @ndims = ndims
      @name = String.new(name_buffer).gsub("\u0000", "").gsub("\u0001", "")
    end

    def attributes
      num_attributes = uninitialized Int32
      NetCDF.call_netcdf { LibNetcdf4.nc_inq_varnatts(@parent_id, @id, pointerof(num_attributes)) }

      (0..num_attributes - 1).map do |i|
        name_buffer = Bytes.new(LibNetcdf4::NC_MAX_NAME)
        NetCDF.call_netcdf { LibNetcdf4.nc_inq_attname(@parent_id, @id, i, name_buffer) }
        name = String.new(name_buffer).gsub("\u0000", "")
        Attribute.new(name, @parent_id, @id)
      end
    end

    def add_attribute(name, type_str, value)
      var_type = NetCDF.get_type(type_str)

      attribute = Attribute.new(name, @parent_id, @id, var_type)
      attribute.set_value(value)
      attribute
    end

    # Endianness: "little", "big", or "native"
    def endianness
      v = uninitialized Int32
      NetCDF.call_netcdf { LibNetcdf4.nc_inq_var_endian(@parent_id, @id, pointerof(v)) }
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
      v = uninitialized Int32
      NetCDF.call_netcdf { LibNetcdf4.nc_inq_var_fletcher32(@parent_id, @id, pointerof(v)) }
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
      v = uninitialized Int32
      NetCDF.call_netcdf { LibNetcdf4.nc_inq_var_chunking(@parent_id, @id, pointerof(v), nil) }
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
      sizes = Slice(UInt64).new(@ndims)
      NetCDF.call_netcdf { LibNetcdf4.nc_inq_var_chunking(@parent_id, @id, nil, sizes) }
      sizes.to_a.map(&.to_i)
    end

    # Boolean switch for fill mode
    def fill_mode
      v = uninitialized Int32
      NetCDF.call_netcdf { LibNetcdf4.nc_inq_var_fill(@parent_id, @id, pointerof(v), nil) }
      v == 1
    end

    # Fill value
    def fill_value
      case @var_type
      when LibNetcdf4::NC_BYTE
        byte_val = uninitialized UInt32
        NetCDF.call_netcdf { LibNetcdf4.nc_inq_var_fill(@parent_id, @id, nil, pointerof(byte_val)) }
        byte_val
      when LibNetcdf4::NC_CHAR
        char_val = uninitialized Char
        NetCDF.call_netcdf { LibNetcdf4.nc_inq_var_fill(@parent_id, @id, nil, pointerof(char_val)) }
        char_val
      when LibNetcdf4::NC_SHORT
        short_val = uninitialized UInt16
        NetCDF.call_netcdf { LibNetcdf4.nc_inq_var_fill(@parent_id, @id, nil, pointerof(short_val)) }
        short_val
      when LibNetcdf4::NC_INT
        int_val = uninitialized Int32
        NetCDF.call_netcdf { LibNetcdf4.nc_inq_var_fill(@parent_id, @id, nil, pointerof(int_val)) }
        int_val
      when LibNetcdf4::NC_FLOAT
        float_val = uninitialized Float32
        NetCDF.call_netcdf { LibNetcdf4.nc_inq_var_fill(@parent_id, @id, nil, pointerof(float_val)) }
        float_val
      when LibNetcdf4::NC_DOUBLE
        double_val = uninitialized Float64
        NetCDF.call_netcdf { LibNetcdf4.nc_inq_var_fill(@parent_id, @id, nil, pointerof(double_val)) }
        double_val
      when LibNetcdf4::NC_UBYTE
        ubyte_val = uninitialized UInt8
        NetCDF.call_netcdf { LibNetcdf4.nc_inq_var_fill(@parent_id, @id, nil, pointerof(ubyte_val)) }
        ubyte_val
      when LibNetcdf4::NC_USHORT
        ushort_val = uninitialized UInt16
        NetCDF.call_netcdf { LibNetcdf4.nc_inq_var_fill(@parent_id, @id, nil, pointerof(ushort_val)) }
        ushort_val
      when LibNetcdf4::NC_UINT
        uint_val = uninitialized UInt32
        NetCDF.call_netcdf { LibNetcdf4.nc_inq_var_fill(@parent_id, @id, nil, pointerof(uint_val)) }
        uint_val
      else
        raise Exception.new("Variable type not supported yet")
      end
    end

    # Boolean switch for shuffle
    def compression_shuffle
      v = uninitialized Int32
      NetCDF.call_netcdf { LibNetcdf4.nc_inq_var_deflate(@parent_id, @id, pointerof(v), nil, nil) }
      v == 1
    end

    # Boolean switch for compression
    def compression_deflate
      v = uninitialized Int32
      NetCDF.call_netcdf { LibNetcdf4.nc_inq_var_deflate(@parent_id, @id, nil, pointerof(v), nil) }
      v == 1
    end

    # Compression level (1-9)
    def compression_level
      v = uninitialized Int32
      NetCDF.call_netcdf { LibNetcdf4.nc_inq_var_deflate(@parent_id, @id, nil, nil, pointerof(v)) }
      v
    end

    # Reads and returns an array of values (cf. "[Specify a Hyperslab](https://www.unidata.ucar.edu/software/netcdf/docs/programming_notes.html#specify_hyperslab)")
    # at positions and sizes given for each dimension, `readSlice(pos1, size1, pos2, size2, ...)`
    # e.g. `readSlice(2, 3, 4, 2)` gives an array of the values at position 2 for 3 steps along the
    # first dimension and position 4 for 2 steps along the second one.
    def read_slice(*args)
      if args.size != @ndims * 2
        raise Exception.new("Arguments does not match number of dimension")
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

      get_val(pos, size, total_size).to_a
    end

    # Reads and returns a single value at positions given as for `write`
    def read(*args)
      if args.size != @ndims
        raise Exception.new("Arguments does not match number of dimension")
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

    # Write a value at positions given
    # `write(2, 3, "a")` writes "a" at position 2 along the first dimension and position 3 along the second one
    def write(*args)
      if args.size != @ndims + 1
        raise Exception.new("Arguments does not match number of dimension")
      end

      pos = Array(UInt64).new(@ndims)
      size = Array(UInt64).new(@ndims)

      (0..@ndims - 1).each do |i|
        pos << args[i].to_u64
        size << 1.to_u64
      end

      case @var_type
      when LibNetcdf4::NC_BYTE, LibNetcdf4::NC_UBYTE, LibNetcdf4::NC_CHAR
        byte_val = UInt8.new(args[ndims])
        NetCDF.call_netcdf { LibNetcdf4.nc_put_vara(@parent_id, @id, pos, size, pointerof(byte_val)) }
      when LibNetcdf4::NC_SHORT, LibNetcdf4::NC_USHORT
        short_val = Int16.new(args[ndims])
        NetCDF.call_netcdf { LibNetcdf4.nc_put_vara(@parent_id, @id, pos, size, pointerof(short_val)) }
      when LibNetcdf4::NC_INT, LibNetcdf4::NC_UINT
        int_val = Int32.new(args[ndims])
        NetCDF.call_netcdf { LibNetcdf4.nc_put_vara(@parent_id, @id, pos, size, pointerof(int_val)) }
      when LibNetcdf4::NC_DOUBLE, LibNetcdf4::NC_FLOAT
        double_val = Float64.new(args[ndims])
        NetCDF.call_netcdf { LibNetcdf4.nc_put_vara(@parent_id, @id, pos, size, pointerof(double_val)) }
      else
        raise Exception.new("Variable type not supported yet")
      end
    end

    # Write values from an array (array must be of same type) at positions and sizes given for each dimension
    # `writeSlice(2, 3, 4, 2, [0, 1, 2, 3, 4, 5])` writes the array at position 2 for 3 steps along the first dimension and position 4 for 2 step along the second one
    def write_slice(*args)
      if args.size != 2 * @ndims + 1
        raise Exception.new("Arguments does not match number of dimension")
      end

      pos = Array(UInt64).new(@ndims)
      size = Array(UInt64).new(@ndims)
      total_size = 1

      (0..@ndims - 1).each do |i|
        pos << args[2 * i].as(Int32).to_u64
        s = args[2 * i + 1].as(Int32).to_u64
        size << s
        total_size = total_size * s
      end

      val = args[2 * @ndims].as(Array)

      if val.size != total_size
        raise Exception.new("Wrong size of array")
      end

      correct_type = true
      case @var_type
      when LibNetcdf4::NC_BYTE, LibNetcdf4::NC_UBYTE, LibNetcdf4::NC_CHAR
        correct_type = false unless val.is_a?(Array(UInt8))
      when LibNetcdf4::NC_SHORT, LibNetcdf4::NC_USHORT
        correct_type = false unless val.is_a?(Array(Int16))
      when LibNetcdf4::NC_INT, LibNetcdf4::NC_UINT
        correct_type = false unless val.is_a?(Array(Int32))
      when LibNetcdf4::NC_DOUBLE, LibNetcdf4::NC_FLOAT
        correct_type = false unless val.is_a?(Array(Float64))
      end

      unless correct_type
        raise Exception.new("Wrong array type")
      end

      NetCDF.call_netcdf { LibNetcdf4.nc_put_vara(@parent_id, @id, pos, size, val.to_unsafe) }
    end

    private def get_val(pos, size, total_size)
      case @var_type
      when LibNetcdf4::NC_BYTE, LibNetcdf4::NC_UBYTE, LibNetcdf4::NC_CHAR
        sbyte_val = Bytes.new(total_size)
        NetCDF.call_netcdf { LibNetcdf4.nc_get_vara_ubyte(@parent_id, @id, pos, size, sbyte_val) }
        sbyte_val
      when LibNetcdf4::NC_SHORT, LibNetcdf4::NC_USHORT
        short_val = Slice(Int16).new(total_size)
        NetCDF.call_netcdf { LibNetcdf4.nc_get_vara(@parent_id, @id, pos, size, short_val) }
        short_val
      when LibNetcdf4::NC_INT, LibNetcdf4::NC_UINT
        int_val = Slice(Int32).new(total_size)
        NetCDF.call_netcdf { LibNetcdf4.nc_get_vara(@parent_id, @id, pos, size, int_val) }
        int_val
      when LibNetcdf4::NC_DOUBLE, LibNetcdf4::NC_FLOAT
        double_val = Slice(Float64).new(total_size)
        NetCDF.call_netcdf { LibNetcdf4.nc_get_vara(@parent_id, @id, pos, size, double_val) }
        double_val
      else
        raise Exception.new("Variable type not supported yet")
      end
    end
  end
end
