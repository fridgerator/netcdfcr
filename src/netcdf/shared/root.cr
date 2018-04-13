module Netcdf
  module Root
    extend self

    def attributes
      num_attributes = uninitialized Int32
      Netcdf.call_netcdf { LibNetcdf4.nc_inq_natts(@id, pointerof(num_attributes)) }

      (0..num_attributes - 1).map do |i|
        name_buffer = Bytes.new(LibNetcdf4::NC_MAX_CHAR)
        Netcdf.call_netcdf { LibNetcdf4.nc_inq_attname(@parent_id, @id, i, name_buffer) }
        name = String.new(name_buffer).gsub("\u0000", "").gsub("\u0001", "")
        NcAtt.new(@name, @parent_id, @id, i)
      end
    end

    def dimensions
      buffer = Slice(Int32).new(LibNetcdf4::NC_MAX_DIMS)
      num_dimensions = uninitialized Int32
      Netcdf.call_netcdf { LibNetcdf4.nc_inq_dimids(@id, pointerof(num_dimensions), buffer, 0) }
      dimension_ids = buffer[0, num_dimensions]
      dimension_ids.to_a.map do |id|
        NcDimension.new(@id, id)
      end
    end

    def variables
      buffer = Slice(Int32).new(LibNetcdf4::NC_MAX_VARS)
      num_vars = uninitialized Int32
      Netcdf.call_netcdf { LibNetcdf4.nc_inq_varids(@id, pointerof(num_vars), buffer) }
      var_ids = buffer[0, num_vars]

      var_ids.to_a.map do |id|
        NcVar.new(@id, id)
      end
    end

    def groups
      num_grps = uninitialized Int32
      ncids = uninitialized Int32
      Netcdf.call_netcdf { LibNetcdf4.nc_inq_grps(@id, pointerof(num_grps), pointerof(ncids)) }
      (0..num_grps - 1).map do |i|
        id = ncids + i
        NcGroup.new(@id, id)
      end
    end
  end
end
