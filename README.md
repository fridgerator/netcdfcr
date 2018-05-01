# netcdf

**WIP - not ready for production use**

Crystal bindings to libnetcdf v4.

Based on [swillner's NodeJS](https://github.com/swillner/netcdf4-js) bindings

## Installation

NetCDF must be installed: `brew install hdf5 netcdf`

Add this to your application's `shard.yml`:

```yaml
dependencies:
  netcdf:
    github: fridgerator/netcdfcr
```

## Usage

**Right now, this library only reads netcdf files.  Write is not yet supported**

```crystal
require "netcdf"

file = NetCDF::File.open("path/to/file.nc")
group = file.groups.first
attr = group.attributes.first
puts attr.name
puts attr.value

variable = group.variables.first
puts variable.name
puts variable.read(0) # one dimension
puts variable.read(0, 0, 0) # 3 dimensions
puts variable.read_slice(0, 10, 0, 1, 0, 1) # read slice of 10 for 3 dimensions

attr = variable.attributes.first
puts attr.value

file.close
```

### Classes

#### File

Properties:

* `id`: NetCDF file id

Methods:

* `close()` : Close file
* `sync()` : Sync file to disk

#### Group

Properties:

* `parent_id` : NetCDF id of parent
* `id` : NetCDF id
* `name` : Group name

Methods:

* `full_name` : Full name
* `unlimited` : Returns array of unlimited Dimensions in group
* `attributes` : Returns an array of attributes
* `dimensions` : Returns an array of dimensions
* `variables` : Returns an array of variables
* `groups` : Returns an array of groups

#### Dimension

Properties:

* `parent_id` : NetCDF id of parent
* `id` : NetCDF id
* `name` : Dimension name
* `length` : Dimension length

#### Attribute

Properties:

* `parent_id` : NetCDF id of parent
* `id` : NetCDF id
* `name` : Attribute name
* `length` : Attribute length
* `attribute_type` : Attribute type `Int32`

Methods:

* `value` : Attribute value

#### Variable

Properties:

* `parent_id` : NetCDF id of parent
* `id` : NetCDF id
* `name` : Variable name
* `var_type` : Variable type `Int32`
* `ndims` : Number of dimensions

Methods:

* `attributes` : Returns an array of variable attributes
* `endianness` : Endianness: "little", "big", or "native"
* `checksum_mode` : Checksum mode: "none" or "fletcher32"
* `chunk_mode` : Chunk mode: "contiguous", or "chunked"
* `chunk_sizes` : Array of chunk sizes, one size per dimension
* `fill_mode` : Boolean switch for fill mode
* `fill_value` : Fill value
* `compression_shuffle` : Boolean switch for shuffle
* `compression_deflate` : Boolean switch for compression
* `compression_level` : Compression level (1-9)
* `read_slice` : Reads and returns an array of values (cf. "[Specify a Hyperslab](https://www.unidata.ucar.edu/software/netcdf/docs/programming_notes.html#specify_hyperslab)") at positions and sizes given for each dimension, `readSlice(pos1, size1, pos2, size2, ...)` e.g. `readSlice(2, 3, 4, 2)` gives an array of the values at position 2 for 3 steps along the first dimension and position 4 for 2 steps along the second one.
* `read` : Reads and returns a single value at positions, one argument per dimension.

## Contributing

1. Fork it ( https://github.com/[your-github-name]/netcdf/fork )
2. Create your feature branch (git checkout -b my-new-feature)
3. Commit your changes (git commit -am 'Add some feature')
4. Push to the branch (git push origin my-new-feature)
5. Create a new Pull Request

## Contributors

- [[your-github-name]](https://github.com/[your-github-name]) Nick Franken - creator, maintainer
