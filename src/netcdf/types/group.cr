module NetCDF
  class Group
    include Root

    property parent_id : Int32
    property id : Int32
    property name : String

    def initialize(@parent_id, @id)
      name_buffer = Bytes.new(LibNetcdf4::NC_MAX_CHAR)
      NetCDF.call_netcdf { LibNetcdf4.nc_inq_grpname(id, name_buffer) }
      @name = String.new(name_buffer).gsub("\u0000", "").gsub("\u0001", "")
    end

    # Full name
    def full_name
      name_length = uninitialized Int32
      NetCDF.call_netcdf { LibNetcdf4.nc_inq_grpname_len(@id, pointerof(name_length)) }
      buffer = Bytes.new(name_length)
      NetCDF.call_netcdf { LibNetcdf4.nc_inq_grpname_full(@id, pointerof(name_length), buffer) }
      return String.new(buffer)
    end

    # Returns array of unlimited Dimensions in group
    def unlimited
      ndims = uninitialized Int32
      NetCDF.call_netcdf { LibNetcdf4.nc_inq_unlimdims(@id, pointerof(ndims), nil) }
      buffer = Slice(Int32).new(ndims)
      NetCDF.call_netcdf { LibNetcdf4.nc_inq_unlimdims(@id, nil, buffer) }
      dim_ids = buffer[0, ndims]
      dim_ids.to_a.map do |dimid|
        Dimension.new(@id, dimid)
      end
    end
  end
end
