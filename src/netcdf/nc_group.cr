module Netcdf
  class NcGroup
    property parent_id : Int32
    property id : Int32
    property name : String

    def initialize(@parent_id, @id)
      name_buffer = Bytes.new(LibNetcdf4::NC_MAX_CHAR)
      LibNetcdf4.nc_inq_grpname(id, name_buffer)
      @name = String.new(name_buffer).gsub("\u0000", "").gsub("\u0001", "")
    end
  end
end
