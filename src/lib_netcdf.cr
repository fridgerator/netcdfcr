# https://github.com/Unidata/netcdf-c/blob/fe0d0ac28c08738e5485f63d6436f677d03cb438/include/netcdf.h

@[Link("netcdf")]
lib LibNetcdf4
  NC_GLOBAL                 = -1
  NC_NAT                    =  0
  NC_BYTE                   =  1
  NC_CHAR                   =  2
  NC_SHORT                  =  3
  NC_INT                    =  4
  NC_LONG                   = NC_INT
  NC_FLOAT                  =  5
  NC_DOUBLE                 =  6
  NC_UBYTE                  =  7
  NC_USHORT                 =  8
  NC_UINT                   =  9
  NC_INT64                  = 10
  NC_UINT64                 = 11
  NC_STRING                 = 12
  NC_MAX_ATOMIC_TYPE        = NC_STRING
  NC_VLEN                   =  13
  NC_OPAQUE                 =  14
  NC_ENUM                   =  15
  NC_COMPOUND               =  16
  NC_FIRSTUSERTYPEID        =  32
  NC_MAX_BYTE               = 127
  NC_MIN_BYTE               = ((-NC_MAX_BYTE) - 1)
  NC_MAX_CHAR               =   255
  NC_MAX_SHORT              = 32767
  NC_MIN_SHORT              = ((-NC_MAX_SHORT) - 1)
  NC_MAX_INT                = 2147483647
  NC_MIN_INT                = ((-NC_MAX_INT) - 1)
  NC_MIN_FLOAT              = (-NC_MAX_FLOAT)
  NC_MAX_DOUBLE             = 1.7976931348623157e+308
  NC_MIN_DOUBLE             = (-NC_MAX_DOUBLE)
  NC_MAX_UBYTE              = NC_MAX_CHAR
  X_INT64_MIN               = ((-X_INT64_MAX) - 1)
  NC_FILL                   =   0
  NC_NOFILL                 = 256
  NC_NOWRITE                =   0
  NC_WRITE                  =   1
  NC_CLOBBER                =   0
  NC_NOCLOBBER              =   4
  NC_DISKLESS               =   8
  NC_MMAP                   =  16
  NC_64BIT_DATA             =  32
  NC_CDF5                   = NC_64BIT_DATA
  NC_CLASSIC_MODEL          =   256
  NC_64BIT_OFFSET           =   512
  NC_LOCK                   =  1024
  NC_SHARE                  =  2048
  NC_NETCDF4                =  4096
  NC_MPIIO                  =  8192
  NC_MPIPOSIX               = 16384
  NC_INMEMORY               = 32768
  NC_PNETCDF                = (NC_MPIIO)
  NC_FORMAT_CLASSIC         = (1)
  NC_FORMAT_64BIT_OFFSET    = (2)
  NC_FORMAT_64BIT           = (NC_FORMAT_64BIT_OFFSET)
  NC_FORMAT_NETCDF4         = (3)
  NC_FORMAT_NETCDF4_CLASSIC = (4)
  NC_FORMAT_64BIT_DATA      = (5)
  NC_FORMAT_CDF5            = NC_FORMAT_64BIT_DATA
  NC_MAX_DIMS               = 1024
  NC_MAX_VARS               = 8192
  NC_MAX_NAME               =  256
  NX_MAX_VAR_DIMS           = 1024
  NC_ENDIAN_NATIVE          =    0
  NC_ENDIAN_LITTLE          =    1
  NC_ENDIAN_BIG             =    2
  NC_NOCHECKSUM             =    0
  NC_FLETCHER32             =    1
  NC_CHUNKED                =    0
  NC_CONTIGUOUS             =    1

  fun nc_inq_libvers : LibC::Char*
  fun nc_inq_libvers : LibC::Char*
  fun nc_strerror(ncerr : LibC::Int) : LibC::Char*
  fun nc__create(path : LibC::Char*, cmode : LibC::Int, initialsz : LibC::SizeT, chunksizehintp : LibC::SizeT*, ncidp : LibC::Int*) : LibC::Int
  fun nc_create(path : LibC::Char*, cmode : LibC::Int, ncidp : LibC::Int*) : LibC::Int
  fun nc__open(path : LibC::Char*, mode : LibC::Int, chunksizehintp : LibC::SizeT*, ncidp : LibC::Int*) : LibC::Int
  fun nc_open(path : LibC::Char*, mode : LibC::Int, ncidp : LibC::Int*) : LibC::Int
  fun nc_inq_path(ncid : LibC::Int, pathlen : LibC::SizeT*, path : LibC::Char*) : LibC::Int
  fun nc_inq_ncid(ncid : LibC::Int, name : LibC::Char*, grp_ncid : LibC::Int*) : LibC::Int
  fun nc_inq_grps(ncid : LibC::Int, numgrps : LibC::Int*, ncids : LibC::Int*) : LibC::Int
  fun nc_inq_grpname(ncid : LibC::Int, name : LibC::Char*) : LibC::Int
  fun nc_inq_grpname_full(ncid : LibC::Int, lenp : LibC::SizeT*, full_name : LibC::Char*) : LibC::Int
  fun nc_inq_grpname_len(ncid : LibC::Int, lenp : LibC::SizeT*) : LibC::Int
  fun nc_inq_grp_parent(ncid : LibC::Int, parent_ncid : LibC::Int*) : LibC::Int
  fun nc_inq_grp_ncid(ncid : LibC::Int, grp_name : LibC::Char*, grp_ncid : LibC::Int*) : LibC::Int
  fun nc_inq_grp_full_ncid(ncid : LibC::Int, full_name : LibC::Char*, grp_ncid : LibC::Int*) : LibC::Int
  fun nc_inq_varids(ncid : LibC::Int, nvars : LibC::Int*, varids : LibC::Int*) : LibC::Int
  fun nc_inq_dimids(ncid : LibC::Int, ndims : LibC::Int*, dimids : LibC::Int*, include_parents : LibC::Int) : LibC::Int
  fun nc_inq_typeids(ncid : LibC::Int, ntypes : LibC::Int*, typeids : LibC::Int*) : LibC::Int
  alias NcType = LibC::Int
  fun nc_inq_type_equal(ncid1 : LibC::Int, typeid1 : NcType, ncid2 : LibC::Int, typeid2 : NcType, equal : LibC::Int*) : LibC::Int
  fun nc_def_grp(parent_ncid : LibC::Int, name : LibC::Char*, new_ncid : LibC::Int*) : LibC::Int
  fun nc_rename_grp(grpid : LibC::Int, name : LibC::Char*) : LibC::Int
  fun nc_def_compound(ncid : LibC::Int, size : LibC::SizeT, name : LibC::Char*, typeidp : NcType*) : LibC::Int
  fun nc_insert_compound(ncid : LibC::Int, xtype : NcType, name : LibC::Char*, offset : LibC::SizeT, field_typeid : NcType) : LibC::Int
  fun nc_insert_array_compound(ncid : LibC::Int, xtype : NcType, name : LibC::Char*, offset : LibC::SizeT, field_typeid : NcType, ndims : LibC::Int, dim_sizes : LibC::Int*) : LibC::Int
  fun nc_inq_type(ncid : LibC::Int, xtype : NcType, name : LibC::Char*, size : LibC::SizeT*) : LibC::Int
  fun nc_inq_typeid(ncid : LibC::Int, name : LibC::Char*, typeidp : NcType*) : LibC::Int
  fun nc_inq_compound(ncid : LibC::Int, xtype : NcType, name : LibC::Char*, sizep : LibC::SizeT*, nfieldsp : LibC::SizeT*) : LibC::Int
  fun nc_inq_compound_name(ncid : LibC::Int, xtype : NcType, name : LibC::Char*) : LibC::Int
  fun nc_inq_compound_size(ncid : LibC::Int, xtype : NcType, sizep : LibC::SizeT*) : LibC::Int
  fun nc_inq_compound_nfields(ncid : LibC::Int, xtype : NcType, nfieldsp : LibC::SizeT*) : LibC::Int
  fun nc_inq_compound_field(ncid : LibC::Int, xtype : NcType, fieldid : LibC::Int, name : LibC::Char*, offsetp : LibC::SizeT*, field_typeidp : NcType*, ndimsp : LibC::Int*, dim_sizesp : LibC::Int*) : LibC::Int
  fun nc_inq_compound_fieldname(ncid : LibC::Int, xtype : NcType, fieldid : LibC::Int, name : LibC::Char*) : LibC::Int
  fun nc_inq_compound_fieldindex(ncid : LibC::Int, xtype : NcType, name : LibC::Char*, fieldidp : LibC::Int*) : LibC::Int
  fun nc_inq_compound_fieldoffset(ncid : LibC::Int, xtype : NcType, fieldid : LibC::Int, offsetp : LibC::SizeT*) : LibC::Int
  fun nc_inq_compound_fieldtype(ncid : LibC::Int, xtype : NcType, fieldid : LibC::Int, field_typeidp : NcType*) : LibC::Int
  fun nc_inq_compound_fieldndims(ncid : LibC::Int, xtype : NcType, fieldid : LibC::Int, ndimsp : LibC::Int*) : LibC::Int
  fun nc_inq_compound_fielddim_sizes(ncid : LibC::Int, xtype : NcType, fieldid : LibC::Int, dim_sizes : LibC::Int*) : LibC::Int
  fun nc_def_vlen(ncid : LibC::Int, name : LibC::Char*, base_typeid : NcType, xtypep : NcType*) : LibC::Int
  fun nc_inq_vlen(ncid : LibC::Int, xtype : NcType, name : LibC::Char*, datum_sizep : LibC::SizeT*, base_nc_typep : NcType*) : LibC::Int

  struct NcVlenT
    len : LibC::SizeT
    p : Void*
  end

  fun nc_free_vlen(vl : NcVlenT*) : LibC::Int
  fun nc_free_vlens(len : LibC::SizeT, vlens : NcVlenT*) : LibC::Int
  fun nc_put_vlen_element(ncid : LibC::Int, typeid1 : LibC::Int, vlen_element : Void*, len : LibC::SizeT, data : Void*) : LibC::Int
  fun nc_get_vlen_element(ncid : LibC::Int, typeid1 : LibC::Int, vlen_element : Void*, len : LibC::SizeT*, data : Void*) : LibC::Int
  fun nc_free_string(len : LibC::SizeT, data : LibC::Char**) : LibC::Int
  fun nc_inq_user_type(ncid : LibC::Int, xtype : NcType, name : LibC::Char*, size : LibC::SizeT*, base_nc_typep : NcType*, nfieldsp : LibC::SizeT*, classp : LibC::Int*) : LibC::Int
  fun nc_put_att(ncid : LibC::Int, varid : LibC::Int, name : LibC::Char*, xtype : NcType, len : LibC::SizeT, op : Void*) : LibC::Int
  fun nc_get_att(ncid : LibC::Int, varid : LibC::Int, name : LibC::Char*, ip : Void*) : LibC::Int
  fun nc_def_enum(ncid : LibC::Int, base_typeid : NcType, name : LibC::Char*, typeidp : NcType*) : LibC::Int
  fun nc_insert_enum(ncid : LibC::Int, xtype : NcType, name : LibC::Char*, value : Void*) : LibC::Int
  fun nc_inq_enum(ncid : LibC::Int, xtype : NcType, name : LibC::Char*, base_nc_typep : NcType*, base_sizep : LibC::SizeT*, num_membersp : LibC::SizeT*) : LibC::Int
  fun nc_inq_enum_member(ncid : LibC::Int, xtype : NcType, idx : LibC::Int, name : LibC::Char*, value : Void*) : LibC::Int
  fun nc_inq_enum_ident(ncid : LibC::Int, xtype : NcType, value : LibC::LongLong, identifier : LibC::Char*) : LibC::Int
  fun nc_def_opaque(ncid : LibC::Int, size : LibC::SizeT, name : LibC::Char*, xtypep : NcType*) : LibC::Int
  fun nc_inq_opaque(ncid : LibC::Int, xtype : NcType, name : LibC::Char*, sizep : LibC::SizeT*) : LibC::Int
  fun nc_put_var(ncid : LibC::Int, varid : LibC::Int, op : Void*) : LibC::Int
  fun nc_get_var(ncid : LibC::Int, varid : LibC::Int, ip : Void*) : LibC::Int
  fun nc_put_var1(ncid : LibC::Int, varid : LibC::Int, indexp : LibC::SizeT*, op : Void*) : LibC::Int
  fun nc_get_var1(ncid : LibC::Int, varid : LibC::Int, indexp : LibC::SizeT*, ip : Void*) : LibC::Int
  fun nc_put_vara(ncid : LibC::Int, varid : LibC::Int, startp : LibC::SizeT*, countp : LibC::SizeT*, op : Void*) : LibC::Int
  fun nc_get_vara(ncid : LibC::Int, varid : LibC::Int, startp : LibC::SizeT*, countp : LibC::SizeT*, ip : Void*) : LibC::Int
  alias X__DarwinPtrdiffT = LibC::Long
  alias PtrdiffT = X__DarwinPtrdiffT
  fun nc_put_vars(ncid : LibC::Int, varid : LibC::Int, startp : LibC::SizeT*, countp : LibC::SizeT*, stridep : PtrdiffT*, op : Void*) : LibC::Int
  fun nc_get_vars(ncid : LibC::Int, varid : LibC::Int, startp : LibC::SizeT*, countp : LibC::SizeT*, stridep : PtrdiffT*, ip : Void*) : LibC::Int
  fun nc_put_varm(ncid : LibC::Int, varid : LibC::Int, startp : LibC::SizeT*, countp : LibC::SizeT*, stridep : PtrdiffT*, imapp : PtrdiffT*, op : Void*) : LibC::Int
  fun nc_get_varm(ncid : LibC::Int, varid : LibC::Int, startp : LibC::SizeT*, countp : LibC::SizeT*, stridep : PtrdiffT*, imapp : PtrdiffT*, ip : Void*) : LibC::Int
  fun nc_def_var_deflate(ncid : LibC::Int, varid : LibC::Int, shuffle : LibC::Int, deflate : LibC::Int, deflate_level : LibC::Int) : LibC::Int
  fun nc_inq_var_deflate(ncid : LibC::Int, varid : LibC::Int, shufflep : LibC::Int*, deflatep : LibC::Int*, deflate_levelp : LibC::Int*) : LibC::Int
  fun nc_inq_var_szip(ncid : LibC::Int, varid : LibC::Int, options_maskp : LibC::Int*, pixels_per_blockp : LibC::Int*) : LibC::Int
  fun nc_def_var_fletcher32(ncid : LibC::Int, varid : LibC::Int, fletcher32 : LibC::Int) : LibC::Int
  fun nc_inq_var_fletcher32(ncid : LibC::Int, varid : LibC::Int, fletcher32p : LibC::Int*) : LibC::Int
  fun nc_def_var_chunking(ncid : LibC::Int, varid : LibC::Int, storage : LibC::Int, chunksizesp : LibC::SizeT*) : LibC::Int
  fun nc_inq_var_chunking(ncid : LibC::Int, varid : LibC::Int, storagep : LibC::Int*, chunksizesp : LibC::SizeT*) : LibC::Int
  fun nc_def_var_fill(ncid : LibC::Int, varid : LibC::Int, no_fill : LibC::Int, fill_value : Void*) : LibC::Int
  fun nc_inq_var_fill(ncid : LibC::Int, varid : LibC::Int, no_fill : LibC::Int*, fill_valuep : Void*) : LibC::Int
  fun nc_def_var_endian(ncid : LibC::Int, varid : LibC::Int, endian : LibC::Int) : LibC::Int
  fun nc_inq_var_endian(ncid : LibC::Int, varid : LibC::Int, endianp : LibC::Int*) : LibC::Int
  fun nc_set_fill(ncid : LibC::Int, fillmode : LibC::Int, old_modep : LibC::Int*) : LibC::Int
  fun nc_set_default_format(format : LibC::Int, old_formatp : LibC::Int*) : LibC::Int
  fun nc_set_chunk_cache(size : LibC::SizeT, nelems : LibC::SizeT, preemption : LibC::Float) : LibC::Int
  fun nc_get_chunk_cache(sizep : LibC::SizeT*, nelemsp : LibC::SizeT*, preemptionp : LibC::Float*) : LibC::Int
  fun nc_set_var_chunk_cache(ncid : LibC::Int, varid : LibC::Int, size : LibC::SizeT, nelems : LibC::SizeT, preemption : LibC::Float) : LibC::Int
  fun nc_get_var_chunk_cache(ncid : LibC::Int, varid : LibC::Int, sizep : LibC::SizeT*, nelemsp : LibC::SizeT*, preemptionp : LibC::Float*) : LibC::Int
  fun nc_redef(ncid : LibC::Int) : LibC::Int
  fun nc__enddef(ncid : LibC::Int, h_minfree : LibC::SizeT, v_align : LibC::SizeT, v_minfree : LibC::SizeT, r_align : LibC::SizeT) : LibC::Int
  fun nc_enddef(ncid : LibC::Int) : LibC::Int
  fun nc_sync(ncid : LibC::Int) : LibC::Int
  fun nc_abort(ncid : LibC::Int) : LibC::Int
  fun nc_close(ncid : LibC::Int) : LibC::Int
  fun nc_inq(ncid : LibC::Int, ndimsp : LibC::Int*, nvarsp : LibC::Int*, nattsp : LibC::Int*, unlimdimidp : LibC::Int*) : LibC::Int
  fun nc_inq_ndims(ncid : LibC::Int, ndimsp : LibC::Int*) : LibC::Int
  fun nc_inq_nvars(ncid : LibC::Int, nvarsp : LibC::Int*) : LibC::Int
  fun nc_inq_natts(ncid : LibC::Int, nattsp : LibC::Int*) : LibC::Int
  fun nc_inq_unlimdim(ncid : LibC::Int, unlimdimidp : LibC::Int*) : LibC::Int
  fun nc_inq_unlimdims(ncid : LibC::Int, nunlimdimsp : LibC::Int*, unlimdimidsp : LibC::Int*) : LibC::Int
  fun nc_inq_format(ncid : LibC::Int, formatp : LibC::Int*) : LibC::Int
  fun nc_inq_format_extended(ncid : LibC::Int, formatp : LibC::Int*, modep : LibC::Int*) : LibC::Int
  fun nc_def_dim(ncid : LibC::Int, name : LibC::Char*, len : LibC::SizeT, idp : LibC::Int*) : LibC::Int
  fun nc_inq_dimid(ncid : LibC::Int, name : LibC::Char*, idp : LibC::Int*) : LibC::Int
  fun nc_inq_dim(ncid : LibC::Int, dimid : LibC::Int, name : LibC::Char*, lenp : LibC::SizeT*) : LibC::Int
  fun nc_inq_dimname(ncid : LibC::Int, dimid : LibC::Int, name : LibC::Char*) : LibC::Int
  fun nc_inq_dimlen(ncid : LibC::Int, dimid : LibC::Int, lenp : LibC::SizeT*) : LibC::Int
  fun nc_rename_dim(ncid : LibC::Int, dimid : LibC::Int, name : LibC::Char*) : LibC::Int
  fun nc_inq_att(ncid : LibC::Int, varid : LibC::Int, name : LibC::Char*, xtypep : NcType*, lenp : LibC::SizeT*) : LibC::Int
  fun nc_inq_attid(ncid : LibC::Int, varid : LibC::Int, name : LibC::Char*, idp : LibC::Int*) : LibC::Int
  fun nc_inq_atttype(ncid : LibC::Int, varid : LibC::Int, name : LibC::Char*, xtypep : NcType*) : LibC::Int
  fun nc_inq_attlen(ncid : LibC::Int, varid : LibC::Int, name : LibC::Char*, lenp : LibC::SizeT*) : LibC::Int
  fun nc_inq_attname(ncid : LibC::Int, varid : LibC::Int, attnum : LibC::Int, name : LibC::Char*) : LibC::Int
  fun nc_copy_att(ncid_in : LibC::Int, varid_in : LibC::Int, name : LibC::Char*, ncid_out : LibC::Int, varid_out : LibC::Int) : LibC::Int
  fun nc_rename_att(ncid : LibC::Int, varid : LibC::Int, name : LibC::Char*, newname : LibC::Char*) : LibC::Int
  fun nc_del_att(ncid : LibC::Int, varid : LibC::Int, name : LibC::Char*) : LibC::Int
  fun nc_put_att_text(ncid : LibC::Int, varid : LibC::Int, name : LibC::Char*, len : LibC::SizeT, op : LibC::Char*) : LibC::Int
  fun nc_get_att_text(ncid : LibC::Int, varid : LibC::Int, name : LibC::Char*, ip : LibC::Char*) : LibC::Int
  fun nc_put_att_string(ncid : LibC::Int, varid : LibC::Int, name : LibC::Char*, len : LibC::SizeT, op : LibC::Char**) : LibC::Int
  fun nc_get_att_string(ncid : LibC::Int, varid : LibC::Int, name : LibC::Char*, ip : LibC::Char**) : LibC::Int
  fun nc_put_att_uchar(ncid : LibC::Int, varid : LibC::Int, name : LibC::Char*, xtype : NcType, len : LibC::SizeT, op : UInt8*) : LibC::Int
  fun nc_get_att_uchar(ncid : LibC::Int, varid : LibC::Int, name : LibC::Char*, ip : UInt8*) : LibC::Int
  fun nc_put_att_schar(ncid : LibC::Int, varid : LibC::Int, name : LibC::Char*, xtype : NcType, len : LibC::SizeT, op : LibC::Char*) : LibC::Int
  fun nc_get_att_schar(ncid : LibC::Int, varid : LibC::Int, name : LibC::Char*, ip : LibC::Char*) : LibC::Int
  fun nc_put_att_short(ncid : LibC::Int, varid : LibC::Int, name : LibC::Char*, xtype : NcType, len : LibC::SizeT, op : LibC::Short*) : LibC::Int
  fun nc_get_att_short(ncid : LibC::Int, varid : LibC::Int, name : LibC::Char*, ip : LibC::Short*) : LibC::Int
  fun nc_put_att_int(ncid : LibC::Int, varid : LibC::Int, name : LibC::Char*, xtype : NcType, len : LibC::SizeT, op : LibC::Int*) : LibC::Int
  fun nc_get_att_int(ncid : LibC::Int, varid : LibC::Int, name : LibC::Char*, ip : LibC::Int*) : LibC::Int
  fun nc_put_att_long(ncid : LibC::Int, varid : LibC::Int, name : LibC::Char*, xtype : NcType, len : LibC::SizeT, op : LibC::Long*) : LibC::Int
  fun nc_get_att_long(ncid : LibC::Int, varid : LibC::Int, name : LibC::Char*, ip : LibC::Long*) : LibC::Int
  fun nc_put_att_float(ncid : LibC::Int, varid : LibC::Int, name : LibC::Char*, xtype : NcType, len : LibC::SizeT, op : LibC::Float*) : LibC::Int
  fun nc_get_att_float(ncid : LibC::Int, varid : LibC::Int, name : LibC::Char*, ip : LibC::Float*) : LibC::Int
  fun nc_put_att_double(ncid : LibC::Int, varid : LibC::Int, name : LibC::Char*, xtype : NcType, len : LibC::SizeT, op : LibC::Double*) : LibC::Int
  fun nc_get_att_double(ncid : LibC::Int, varid : LibC::Int, name : LibC::Char*, ip : LibC::Double*) : LibC::Int
  fun nc_put_att_ushort(ncid : LibC::Int, varid : LibC::Int, name : LibC::Char*, xtype : NcType, len : LibC::SizeT, op : LibC::UShort*) : LibC::Int
  fun nc_get_att_ushort(ncid : LibC::Int, varid : LibC::Int, name : LibC::Char*, ip : LibC::UShort*) : LibC::Int
  fun nc_put_att_uint(ncid : LibC::Int, varid : LibC::Int, name : LibC::Char*, xtype : NcType, len : LibC::SizeT, op : LibC::UInt*) : LibC::Int
  fun nc_get_att_uint(ncid : LibC::Int, varid : LibC::Int, name : LibC::Char*, ip : LibC::UInt*) : LibC::Int
  fun nc_put_att_longlong(ncid : LibC::Int, varid : LibC::Int, name : LibC::Char*, xtype : NcType, len : LibC::SizeT, op : LibC::LongLong*) : LibC::Int
  fun nc_get_att_longlong(ncid : LibC::Int, varid : LibC::Int, name : LibC::Char*, ip : LibC::LongLong*) : LibC::Int
  fun nc_put_att_ulonglong(ncid : LibC::Int, varid : LibC::Int, name : LibC::Char*, xtype : NcType, len : LibC::SizeT, op : LibC::ULongLong*) : LibC::Int
  fun nc_get_att_ulonglong(ncid : LibC::Int, varid : LibC::Int, name : LibC::Char*, ip : LibC::ULongLong*) : LibC::Int
  fun nc_def_var(ncid : LibC::Int, name : LibC::Char*, xtype : NcType, ndims : LibC::Int, dimidsp : LibC::Int*, varidp : LibC::Int*) : LibC::Int
  fun nc_inq_var(ncid : LibC::Int, varid : LibC::Int, name : LibC::Char*, xtypep : NcType*, ndimsp : LibC::Int*, dimidsp : LibC::Int*, nattsp : LibC::Int*) : LibC::Int
  fun nc_inq_varid(ncid : LibC::Int, name : LibC::Char*, varidp : LibC::Int*) : LibC::Int
  fun nc_inq_varname(ncid : LibC::Int, varid : LibC::Int, name : LibC::Char*) : LibC::Int
  fun nc_inq_vartype(ncid : LibC::Int, varid : LibC::Int, xtypep : NcType*) : LibC::Int
  fun nc_inq_varndims(ncid : LibC::Int, varid : LibC::Int, ndimsp : LibC::Int*) : LibC::Int
  fun nc_inq_vardimid(ncid : LibC::Int, varid : LibC::Int, dimidsp : LibC::Int*) : LibC::Int
  fun nc_inq_varnatts(ncid : LibC::Int, varid : LibC::Int, nattsp : LibC::Int*) : LibC::Int
  fun nc_rename_var(ncid : LibC::Int, varid : LibC::Int, name : LibC::Char*) : LibC::Int
  fun nc_copy_var(ncid_in : LibC::Int, varid : LibC::Int, ncid_out : LibC::Int) : LibC::Int
end
