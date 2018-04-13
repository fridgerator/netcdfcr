module Netcdf
  class NcFile
    include Root

    property id : Int32

    def self.open(path : String, mode : String = "r")
      id = uninitialized Int32
      Netcdf.call_netcdf { LibNetcdf4.nc_open(path, LibNetcdf4::NC_NOWRITE, pointerof(id)) }
      self.new(id)
    end

    def initialize(@id); end

    # Close file
    def close
      Netcdf.call_netcdf { LibNetcdf4.nc_close(@id) }
    end

    # Sync or "flush" file to disk
    def sync
      Netcdf.call_netcdf { LibNetcdf4.nc_sync(@id) }
    end
  end
end
