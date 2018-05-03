require "./spec_helper"

describe NetCDF do
  describe NetCDF::Group do
    it "should create a group" do
      file = open_file("w")
      file.add_group("biomet")
      file.groups.size.should eq 1
      file.groups[0].name.should eq "biomet"
      file.close
    end
  end

  describe NetCDF::Dimension do
    it "should create a dimension" do
      file = open_file("w")
      file.add_dimension("time", 100)
      file.add_dimension("latitude", 100)
      file.add_dimension("longitude", 100)
      file.dimensions.size.should eq 3
      time = file.dimensions[0]
      time.name.should eq "time"
      time.length.should eq 100
      file.close
    end
  end

  describe NetCDF::Variable do
    it "should create a variable" do
      file = open_file("w")
      group = file.groups[0]
      group.add_variable("RH", "int", file.dimensions)
      group.variables.size.should eq 1
      var = group.variables[0]
      var.name.should eq "RH"
      var.ndims.should eq 3
      var.var_type.should eq LibNetcdf4::NC_INT
      file.close
    end
  end

  describe NetCDF::Attribute do
    it "should create an attribute" do
      file = open_file("w")
      group = file.groups[0]
      var = group.variables[0]
      var.add_attribute("canopy_height", "double", 42.42)
      att = var.attributes[0]
      att.name.should eq "canopy_height"
      att.value.should eq 42.42
      att.attribute_type.should eq LibNetcdf4::NC_DOUBLE
    end
  end
end
