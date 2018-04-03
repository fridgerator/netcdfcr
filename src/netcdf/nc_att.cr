module Netcdf
  class NcAtt
    property parent_id : Int32
    property id : Int32
    property name : String
    property value : Int32 | Int64 | String | Float32 | Float64

    def initialize(@parent_id, @id)
      name_buffer = Bytes.new(LibNetcdf4::NC_MAX_CHAR)

      LibNetcdf4.nc_inq_attname(@parent_id, LibNetcdf4::NC_GLOBAL, @id, name_buffer)
      @name = String.new(name_buffer).gsub("\u0000", "").gsub("\u0001", "")
      LibNetcdf4.nc_inq_attlen(@parent_id, LibNetcdf4::NC_GLOBAL, @name, out length)

      value_buffer = Bytes.new(length)
      LibNetcdf4.nc_get_att_text(@parent_id, LibNetcdf4::NC_GLOBAL, @name, value_buffer)
      @value = String.new(value_buffer).gsub("\u0000", "").gsub("\u0001", "")
    end
  end
end
