module NetCDF
  class File
    include Root

    property parent_id : Int32
    property id : Int32

    def self.open(path : String, mode : String = "r")
      id = uninitialized Int32

      if mode == "r"
        NetCDF.call_netcdf { LibNetcdf4.nc_open(path, LibNetcdf4::NC_NOWRITE, pointerof(id)) }
      elsif mode == "w"
        NetCDF.call_netcdf { LibNetcdf4.nc_open(path, LibNetcdf4::NC_WRITE, pointerof(id)) }
      elsif mode == "c"
        NetCDF.call_netcdf { LibNetcdf4.nc_create(path, LibNetcdf4::NC_NETCDF4 | LibNetcdf4::NC_NOCLOBBER, pointerof(id)) }
      elsif mode == "c!"
        NetCDF.call_netcdf { LibNetcdf4.nc_create(path, LibNetcdf4::NC_NETCDF4 | LibNetcdf4::NC_CLOBBER, pointerof(id)) }
      else
        raise Exception.new("Mode not supported")
      end

      self.new(id)
    end

    def initialize(@id, @parent_id = LibNetcdf4::NC_GLOBAL); end

    # Close file
    def close
      NetCDF.call_netcdf { LibNetcdf4.nc_close(@id) }
    end

    # Sync or "flush" file to disk
    def sync
      NetCDF.call_netcdf { LibNetcdf4.nc_sync(@id) }
    end

    def attributes
      num_attributes = uninitialized Int32
      NetCDF.call_netcdf { LibNetcdf4.nc_inq_natts(@id, pointerof(num_attributes)) }

      (0..num_attributes - 1).map do |i|
        name_buffer = Bytes.new(LibNetcdf4::NC_MAX_NAME)
        NetCDF.call_netcdf { LibNetcdf4.nc_inq_attname(@id, LibNetcdf4::NC_GLOBAL, i, name_buffer) }
        name = String.new(name_buffer).gsub("\u0000", "")
        Attribute.new(name, @id, LibNetcdf4::NC_GLOBAL)
      end
    end

    def add_attribute(name, type_str, value)
      var_type = NetCDF.get_type(type_str)

      attribute = Attribute.new(name, @id, LibNetcdf4::NC_GLOBAL, var_type)
      attribute.set_value(value)
      attribute
    end
  end
end
