module Netcdf
  class NcFile
    property ncid : Int32

    def self.open(path : String, mode : String = "r")
      LibNetcdf4.nc_open(path, LibNetcdf4::NC_NOWRITE, out ncid)
      self.new(ncid)
    end

    def initialize(@ncid)
    end

    def close
      LibNetcdf4.nc_close(@ncid)
    end

    def attributes
      LibNetcdf4.nc_inq_natts(@ncid, out num_attributes)

      (0..num_attributes - 1).map do |i|
        ncid = Int32.new(i)
        NcAtt.new(@ncid, ncid)
      end
    end

    def dimensions
      buffer = Slice(Int32).new(LibNetcdf4::NC_MAX_DIMS)
      LibNetcdf4.nc_inq_dimids(@ncid, out num_dimensions, buffer, 0)
      dimension_ids = buffer[0, num_dimensions]
      dimension_ids.to_a.map do |id|
        NcDimension.new(@ncid, id)
      end
    end

    def variables
      buffer = Slice(Int32).new(LibNetcdf4::NC_MAX_VARS)
      LibNetcdf4.nc_inq_varids(@ncid, out num_vars, buffer)
      var_ids = [0, num_vars]

      var_ids.to_a.map do |id|
        NcVar.new(@ncid, id)
      end
    end

    def groups
      LibNetcdf4.nc_inq_grps(@ncid, out num_grps, out ncids)

      (0..num_grps - 1).map do |i|
        id = ncids + i
        NcGroup.new(@ncid, id)
      end
    end
  end
end
