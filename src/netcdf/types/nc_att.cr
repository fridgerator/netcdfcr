module Netcdf
  class NcAtt
    property ncid : Int32
    property parent_id : Int32
    property id : Int32
    property name : String
    property att_type : Int32
    property att_len : UInt64

    def initialize(@name, @ncid, @parent_id, @id)
      LibNetcdf4.nc_inq_att(@ncid, @parent_id, @name, out @att_type, out @att_len)
    end

    def value
      if (@att_type < LibNetcdf4::NC_BYTE || @att_type > LibNetcdf4::NC_INT64) && @att_type != LibNetcdf4::NC_STRING
        raise Exception.new("Variable type not supported yet")
      end

      case @att_type
      when LibNetcdf4::NC_BYTE, LibNetcdf4::NC_UBYTE
        bytes_val = Bytes.new(@att_len)
        LibNetcdf4.nc_get_att(@parent_id, @id, nil, bytes_val)
        @att_len == 1 ? bytes_val[0] : bytes_val
      when LibNetcdf4::NC_SHORT
        short_val = Slice(Int16).new(@att_len)
        LibNetcdf4.nc_get_att(@parent_id, @id, nil, short_val)
        @att_len == 1 ? short_val[0] : short_val
      when LibNetcdf4::NC_INT
        int_val = Slice(Int32).new(@att_len)
        LibNetcdf4.nc_get_att(@parent_id, @id, nil, int_val)
        @att_len == 1 ? int_val[0] : int_val
      when LibNetcdf4::NC_FLOAT, LibNetcdf4::NC_DOUBLE
        double_val = Slice(Float64).new(@att_len)
        LibNetcdf4.nc_get_att(@parent_id, @id, nil, double_val)
        @att_len == 1 ? double_val[0] : double_val
      when LibNetcdf4::NC_USHORT
        ushort_val = Slice(Int16).new(@att_len)
        LibNetcdf4.nc_get_att(@parent_id, @id, nil, ushort_vla)
        @att_len == 1 ? ushort_vla[0] : ushort_vla
      when LibNetcdf4::NC_UINT
        uint_val = Slice(Int32).new(@att_len)
        LibNetcdf4.nc_get_att(@parent_id, @id, nil, uint_val)
        @att_len == 1 ? uint_val[0] : uint_val
      when LibNetcdf4::NC_INT64
        i64_val = Slice(Int64).new(@att_len)
        LibNetcdf4.nc_get_att(@parent_id, @id, nil, i64_val)
        @att_len == 1 ? i64_val[0] : i64_val
      when LibNetcdf4::NC_UINT64
        ui64_val = Slice(UInt64).new(@att_len)
        LibNetcdf4.nc_get_att(@parent_id, @id, nil, ui64_val)
        @att_len == 1 ? ui64_val[0] : ui64_val
      when LibNetcdf4::NC_STRING, LibNetcdf4::NC_CHAR
        buffer = Bytes.new(@att_len)
        LibNetcdf4.nc_get_att(@ncid, @parent_id, @name, buffer)
        String.new(buffer)
      else
        raise Exception.new("Variable type not supported yet")
      end
    end
  end
end
