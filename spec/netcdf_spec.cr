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
      group = file.groups[0]
      group.add_dimension("time", 100)
      group.dimensions.size.should eq 1
      dimension = group.dimensions[0]
      dimension.name.should eq "time"
      dimension.length.should eq 100
      file.close
    end
  end

  describe NetCDF::Variable do
    it "should create a variable" do
      file = open_file("w")
      group = file.groups[0]
      group.add_variable("RH", "int", group.dimensions)
      group.variables.size.should eq 1
      var = group.variables[0]
      var.name.should eq "RH"
      var.ndims.should eq 1
      var.var_type.should eq LibNetcdf4::NC_INT
      file.close
    end
  end

  describe NetCDF::Attribute do
    it "should create an attribute" do
      file = open_file("w")
      group = file.groups[0]
      group.add_attribute("canopy_height", "double", 42.42)
    end
  end
end
