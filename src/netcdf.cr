require "./lib_netcdf"
require "./netcdf/shared/*"
require "./netcdf/types/*"
require "./netcdf/*"

module NetCDF
  def self.types
    {
      "byte":   LibNetcdf4::NC_BYTE,
      "char":   LibNetcdf4::NC_CHAR,
      "short":  LibNetcdf4::NC_SHORT,
      "int":    LibNetcdf4::NC_INT,
      "float":  LibNetcdf4::NC_FLOAT,
      "double": LibNetcdf4::NC_DOUBLE,
      "ubyte":  LibNetcdf4::NC_UBYTE,
      "ushort": LibNetcdf4::NC_USHORT,
      "uint":   LibNetcdf4::NC_UINT,
      "string": LibNetcdf4::NC_STRING,
    }
  end

  def self.call_netcdf(&block)
    result = yield
    if result != LibNetcdf4::NC_NOERR
      raise Exception.new(
        String.new(LibNetcdf4.nc_strerror(result))
      )
    end
  end

  def self.get_type(type_str : String)
    t = NetCDF.types[type_str]?
    if t
      return t
    else
      raise Exception.new("Unkown variable type")
    end
  end
end
