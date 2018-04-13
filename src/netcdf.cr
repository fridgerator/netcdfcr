require "./lib_netcdf"
require "./netcdf/shared/*"
require "./netcdf/types/*"
require "./netcdf/*"

module Netcdf
  def self.call_netcdf(&block)
    result = yield
    if result != LibNetcdf4::NC_NOERR
      raise Exception.new(
        String.new(LibNetcdf4.nc_strerror(result))
      )
    end
  end
end
