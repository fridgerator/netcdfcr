module NetCDF
  class Attribute
    property parent_id : Int32
    property id : Int32
    property name : String
    property attribute_type : Int32

    def initialize(@name, @parent_id, @id)
      attribute_type = uninitialized Int32
      NetCDF.call_netcdf { LibNetcdf4.nc_inq_atttype(@parent_id, @id, @name, pointerof(attribute_type)) }
      @attribute_type = attribute_type
    end

    def initialize(@name, @parent_id, @id, @attribute_type)
    end

    def value
      if (@attribute_type < LibNetcdf4::NC_BYTE || @attribute_type > LibNetcdf4::NC_INT64) && @attribute_type != LibNetcdf4::NC_STRING
        raise Exception.new("Variable type not supported yet")
      end

      length = uninitialized UInt64
      NetCDF.call_netcdf { LibNetcdf4.nc_inq_attlen(@parent_id, @id, @name, pointerof(length)) }

      case @attribute_type
      when LibNetcdf4::NC_BYTE, LibNetcdf4::NC_UBYTE
        bytes_val = Bytes.new(length)
        NetCDF.call_netcdf { LibNetcdf4.nc_get_att(@parent_id, @id, @name, bytes_val) }
        length == 1 ? bytes_val[0] : bytes_val
      when LibNetcdf4::NC_SHORT, LibNetcdf4::NC_USHORT
        short_val = Slice(Int16).new(length)
        NetCDF.call_netcdf { LibNetcdf4.nc_get_att(@parent_id, @id, @name, short_val) }
        length == 1 ? short_val[0] : short_val
      when LibNetcdf4::NC_INT, LibNetcdf4::NC_UINT
        int_val = Slice(Int32).new(length)
        NetCDF.call_netcdf { LibNetcdf4.nc_get_att(@parent_id, @id, @name, int_val) }
        length == 1 ? int_val[0] : int_val
      when LibNetcdf4::NC_FLOAT, LibNetcdf4::NC_DOUBLE
        double_val = Slice(Float64).new(length)
        NetCDF.call_netcdf { LibNetcdf4.nc_get_att(@parent_id, @id, @name, double_val) }
        length == 1 ? double_val[0] : double_val
      when LibNetcdf4::NC_INT64
        i64_val = Slice(Int64).new(length)
        NetCDF.call_netcdf { LibNetcdf4.nc_get_att(@parent_id, @id, @name, i64_val) }
        length == 1 ? i64_val[0] : i64_val
      when LibNetcdf4::NC_UINT64
        ui64_val = Slice(UInt64).new(length)
        NetCDF.call_netcdf { LibNetcdf4.nc_get_att(@parent_id, @id, @name, ui64_val) }
        length == 1 ? ui64_val[0] : ui64_val
      when LibNetcdf4::NC_STRING, LibNetcdf4::NC_CHAR
        buffer = Bytes.new(length)
        NetCDF.call_netcdf { LibNetcdf4.nc_get_att(@parent_id, @id, @name, buffer) }
        String.new(buffer)
      else
        raise Exception.new("Variable type not supported yet")
      end
    end

    def set_value(val)
      if (@attribute_type < LibNetcdf4::NC_BYTE || @attribute_type > LibNetcdf4::NC_UINT) && @attribute_type != LibNetcdf4::NC_STRING
        raise Exception.new("Variable type not supported yet")
      end

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
        v = val
        NetCDF.call_netcdf { LibNetcdf4.nc_put_att_text(@parent_id, @id, name, val.size, v.to_unsafe) }
      end
    end
  end
end
