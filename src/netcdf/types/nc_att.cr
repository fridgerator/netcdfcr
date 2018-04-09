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
      when LibNetcdf4::NC_BYTE
        b = UInt8.new(0)
        LibNetcdf4.nc_get_att(@parent_id, @id, nil, pointerof(b))
        puts b
        b
      when LibNetcdf4::NC_SHORT
        print "do NC_SHORT"
      when LibNetcdf4::NC_INT
        print "do NC_INT"
      when LibNetcdf4::NC_FLOAT
        print "do NC_FLOAT"
      when LibNetcdf4::NC_DOUBLE
        print "do NC_DOUBLE"
      when LibNetcdf4::NC_UBYTE
        print "do NC_UBYTE"
      when LibNetcdf4::NC_USHORT
        print "do NC_USHORT"
      when LibNetcdf4::NC_UINT
        print "do NC_UINT"
      when LibNetcdf4::NC_INT64
        print "do NC_INT64"
      when LibNetcdf4::NC_UINT64
        print "do NC_UINT64"
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
