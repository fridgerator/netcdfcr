module Netcdf
  class NcVar
    property parent_id : Int32
    property id : Int32
    property name : String
    property var_type : Int32
    property ndims : Int32

    enum VarType
      NC_NAT    = 0
      NC_BYTE   = 1
      NC_CHAR   = 2
      NC_SHORT  = 3
      NC_INT    = 4
      NC_LONG   = NC_INT
      NC_FLOAT  =  5
      NC_DOUBLE =  6
      NC_UBYTE  =  7
      NC_USHORT =  8
      NC_UINT   =  9
      NC_INT64  = 10
      NC_UINT64 = 11
      NC_STRING = 12
    end

    def initialize(@parent_id, @id)
      LibNetcdf4.nc_inq_var(@parent_id, @id, nil, out var_type, out ndims, nil, nil)
      @var_type = VarType.new(var_type).value
      @ndims = ndims

      name_buffer = Bytes.new(LibNetcdf4::NC_MAX_CHAR)
      LibNetcdf4.nc_inq_varname(@parent_id, @id, name_buffer)
      @name = String.new(name_buffer).gsub("\u0000", "").gsub("\u0001", "")
    end
  end
end
