module NetCDF
  class Attribute
    property ncid : Int32
    property parent_id : Int32
    property id : Int32
    property name : String
    property attribute_type : Int32
    property length : UInt64

    def initialize(@name, @ncid, @parent_id, @id)
      attribute_type = uninitialized Int32
      length = uninitialized UInt64
      NetCDF.call_netcdf { LibNetcdf4.nc_inq_att(@ncid, @parent_id, @name, pointerof(attribute_type), pointerof(length)) }
      @attribute_type = attribute_type
      @length = length
    end

    def initialize(@name, @ncid, @parent_id, @id, @attribute_type)
      @length = UInt64.new(0)
    end

    def value
      if (@attribute_type < LibNetcdf4::NC_BYTE || @attribute_type > LibNetcdf4::NC_INT64) && @attribute_type != LibNetcdf4::NC_STRING
        raise Exception.new("Variable type not supported yet")
      end

      case @attribute_type
      when LibNetcdf4::NC_BYTE, LibNetcdf4::NC_UBYTE
        bytes_val = Bytes.new(@length)
        NetCDF.call_netcdf { LibNetcdf4.nc_get_att(@parent_id, @id, nil, bytes_val) }
        @length == 1 ? bytes_val[0] : bytes_val
      when LibNetcdf4::NC_SHORT
        short_val = Slice(Int16).new(@length)
        NetCDF.call_netcdf { LibNetcdf4.nc_get_att(@parent_id, @id, nil, short_val) }
        @length == 1 ? short_val[0] : short_val
      when LibNetcdf4::NC_INT
        int_val = Slice(Int32).new(@length)
        NetCDF.call_netcdf { LibNetcdf4.nc_get_att(@parent_id, @id, nil, int_val) }
        @length == 1 ? int_val[0] : int_val
      when LibNetcdf4::NC_FLOAT, LibNetcdf4::NC_DOUBLE
        double_val = Slice(Float64).new(@length)
        NetCDF.call_netcdf { LibNetcdf4.nc_get_att(@parent_id, @id, nil, double_val) }
        @length == 1 ? double_val[0] : double_val
      when LibNetcdf4::NC_USHORT
        ushort_val = Slice(Int16).new(@length)
        NetCDF.call_netcdf { LibNetcdf4.nc_get_att(@parent_id, @id, nil, ushort_val) }
        @length == 1 ? ushort_val[0] : ushort_val
      when LibNetcdf4::NC_UINT
        uint_val = Slice(Int32).new(@length)
        NetCDF.call_netcdf { LibNetcdf4.nc_get_att(@parent_id, @id, nil, uint_val) }
        @length == 1 ? uint_val[0] : uint_val
      when LibNetcdf4::NC_INT64
        i64_val = Slice(Int64).new(@length)
        NetCDF.call_netcdf { LibNetcdf4.nc_get_att(@parent_id, @id, nil, i64_val) }
        @length == 1 ? i64_val[0] : i64_val
      when LibNetcdf4::NC_UINT64
        ui64_val = Slice(UInt64).new(@length)
        NetCDF.call_netcdf { LibNetcdf4.nc_get_att(@parent_id, @id, nil, ui64_val) }
        @length == 1 ? ui64_val[0] : ui64_val
      when LibNetcdf4::NC_STRING, LibNetcdf4::NC_CHAR
        buffer = Bytes.new(@length)
        NetCDF.call_netcdf { LibNetcdf4.nc_get_att(@ncid, @parent_id, @name, buffer) }
        String.new(buffer)
      else
        raise Exception.new("Variable type not supported yet")
      end
    end

    def set_value(val)
      if (@attribute_type < LibNetcdf4::NC_BYTE || @attribute_type > LibNetcdf4::NC_UINT) && @attribute_type != LibNetcdf4::NC_STRING
        raise Exception.new("Variable type not supported yet")
      end

      # nc_put_att(ncid : LibC::Int, varid : LibC::Int, name : LibC::Char*, xtype : NcType, len : LibC::SizeT, op : Void*)
      # nc_put_att_text(ncid : LibC::Int, varid : LibC::Int, name : LibC::Char*, len : LibC::SizeT, op : LibC::Char*)
      if val.is_a?(UInt32)
        v = val
        NetCDF.call_netcdf { LibNetcdf4.nc_put_att(@parent_id, @id, name, LibNetcdf4::NC_UINT, 1, pointerof(v)) }
      elsif val.is_a?(Int32)
        v = val
        NetCDF.call_netcdf { LibNetcdf4.nc_put_att(@parent_id, @id, name, LibNetcdf4::NC_INT, 1, pointerof(v)) }
      elsif val.is_a?(Float64)
        v = val
        NetCDF.call_netcdf { LibNetcdf4.nc_put_att(@parent_id, @id, name, LibNetcdf4::NC_DOUBLE, 1, pointerof(v)) }
      else
        NetCDF.call_netcdf { LibNetcdf4.nc_put_att_text(@parent_id, @id, name, val.length, value) }
      end
    end
  end
end
