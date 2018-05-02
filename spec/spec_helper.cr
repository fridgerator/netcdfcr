require "spec"
require "../src/netcdf"

# Create file for all the specs
path = "./test.nc"
file = NetCDF::File.open(path, "c")
file.close
File.exists?(path).should be_true

def open_file(mode = "r")
  path = "./test.nc"
  NetCDF::File.open(path, mode)
end

at_exit do
  File.delete(path)
end
