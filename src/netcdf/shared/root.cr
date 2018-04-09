module Netcdf
  module Root
    extend self

    def attributes
      LibNetcdf4.nc_inq_natts(@id, out num_attributes)

      (0..num_attributes - 1).map do |i|
        name_buffer = Bytes.new(LibNetcdf4::NC_MAX_CHAR)
        LibNetcdf4.nc_inq_attname(@parent_id, @id, i, name_buffer)
        name = String.new(name_buffer).gsub("\u0000", "").gsub("\u0001", "")

        NcAtt.new(@name, @parent_id, @id, i)
      end
    end

    def dimensions
      buffer = Slice(Int32).new(LibNetcdf4::NC_MAX_DIMS)
      LibNetcdf4.nc_inq_dimids(@id, out num_dimensions, buffer, 0)
      dimension_ids = buffer[0, num_dimensions]
      dimension_ids.to_a.map do |id|
        NcDimension.new(@id, id)
      end
    end

    def variables
      buffer = Slice(Int32).new(LibNetcdf4::NC_MAX_VARS)
      LibNetcdf4.nc_inq_varids(@id, out num_vars, buffer)
      var_ids = buffer[0, num_vars]

      var_ids.to_a.map do |id|
        NcVar.new(@id, id)
      end
    end

    def groups
      LibNetcdf4.nc_inq_grps(@id, out num_grps, out ncids)

      (0..num_grps - 1).map do |i|
        id = ncids + i
        NcGroup.new(@id, id)
      end
    end
  end
end
