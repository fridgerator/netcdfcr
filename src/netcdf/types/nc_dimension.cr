module Netcdf
  class NcDimension
    property parent_id : Int32
    property id : Int32
    property name : String
    property length : Int32

    def initialize(@parent_id, @id)
      name_buffer = Bytes.new(LibNetcdf4::NC_MAX_CHAR)
      LibNetcdf4.nc_inq_dimname(@parent_id, @id, name_buffer)
      @name = String.new(name_buffer).gsub("\u0000", "").gsub("\u0001", "")
      LibNetcdf4.nc_inq_dimlen(@parent_id, @id, out dim_length)
      @length = dim_length.to_i32
    end
  end
end
