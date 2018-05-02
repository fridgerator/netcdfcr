module NetCDF
  module Root
    extend self

    # Returns an array of attributes
    def attributes
      num_attributes = uninitialized Int32
      NetCDF.call_netcdf { LibNetcdf4.nc_inq_natts(@id, pointerof(num_attributes)) }

      (0..num_attributes - 1).map do |i|
        name_buffer = Bytes.new(LibNetcdf4::NC_MAX_CHAR)
        NetCDF.call_netcdf { LibNetcdf4.nc_inq_attname(@parent_id, @id, i, name_buffer) }
        name = String.new(name_buffer).gsub("\u0000", "").gsub("\u0001", "")
        Attribute.new(@name, @parent_id, @id, i)
      end
    end

    # Returns an array of dimensoins
    def dimensions
      buffer = Slice(Int32).new(LibNetcdf4::NC_MAX_DIMS)
      num_dimensions = uninitialized Int32
      NetCDF.call_netcdf { LibNetcdf4.nc_inq_dimids(@id, pointerof(num_dimensions), buffer, 0) }
      dimension_ids = buffer[0, num_dimensions]
      dimension_ids.to_a.map do |id|
        Dimension.new(@id, id)
      end
    end

    # Returns an array of variables
    def variables
      buffer = Slice(Int32).new(LibNetcdf4::NC_MAX_VARS)
      num_vars = uninitialized Int32
      NetCDF.call_netcdf { LibNetcdf4.nc_inq_varids(@id, pointerof(num_vars), buffer) }
      var_ids = buffer[0, num_vars]

      var_ids.to_a.map do |id|
        Variable.new(@id, id)
      end
    end

    # Returns an array of groups
    def groups
      num_grps = uninitialized Int32
      ncids = uninitialized Int32
      NetCDF.call_netcdf { LibNetcdf4.nc_inq_grps(@id, pointerof(num_grps), pointerof(ncids)) }
      (0..num_grps - 1).map do |i|
        id = ncids + i
        Group.new(@id, id)
      end
    end

    # Adds and returns a new group
    def add_group(name)
      new_id = uninitialized Int32
      NetCDF.call_netcdf { LibNetcdf4.nc_def_grp(@id, name, pointerof(new_id)) }
      Group.new(@id, new_id)
    end

    # Adds a new dimension of `length`, where `length` is either an Int32 or "unlimited"
    def add_dimension(name, length : String | Int32)
      if length.is_a?(String) && length === "unlimited"
        len = UInt64.new(LibNetcdf4::NC_UNLIMITED)
      elsif length.is_a?(Int32)
        len = UInt64.new(length)
      end

      new_id = uninitialized Int32
      NetCDF.call_netcdf { LibNetcdf4.nc_def_dim(@id, name, len.not_nil!, pointerof(new_id)) }

      Dimension.new(@id, new_id)
    end

    # Adds a new variable.
    # `type_str` is one of "byte", "char", "short", "int", "ubyte", "ushort", "uint", "float", "double"
    # Dimensions is an array of dimensions for the new variable.
    def add_variable(name, type_str, dimensions : Array(Dimension))
      add_variable(name, type_str, dimensions.map(&.id))
    end

    def add_variable(name, type_str, dimension_ids : Array(Int32))
      var_type = NetCDF.get_type(type_str)

      if var_type == LibNetcdf4::NC_STRING
        raise Exception.new("Unsupported variable type")
      end

      ndims = dimension_ids.size
      first_dim_id = dimension_ids.first

      new_id = uninitialized Int32
      NetCDF.call_netcdf { LibNetcdf4.nc_def_var(@id, name, var_type, ndims, pointerof(first_dim_id), pointerof(new_id)) }

      Variable.new(@id, new_id)
    end

    def add_attribute(name, type_str, value)
      var_type = NetCDF.get_type(type_str)

      attribute = Attribute.new(name, LibNetcdf4::NC_GLOBAL, @id, 1, var_type)
      attribute.set_value(value)
      attribute
    end
  end
end
