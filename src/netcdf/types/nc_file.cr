module Netcdf
  class NcFile
    include Root

    property id : Int32

    def self.open(path : String, mode : String = "r")
      LibNetcdf4.nc_open(path, LibNetcdf4::NC_NOWRITE, out id)
      self.new(id)
    end

    def initialize(@id)
    end

    def close
      LibNetcdf4.nc_close(@id)
    end
  end
end
