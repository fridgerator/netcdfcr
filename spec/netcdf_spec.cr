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
      file.add_dimension("latitude", 1)
      file.add_dimension("longitude", 1)
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
      time = file.dimensions[0]

      group.add_variable("RH", "int", [time])
      group.variables.size.should eq 1
      var = group.variables[0]
      var.name.should eq "RH"
      var.ndims.should eq 1
      var.var_type.should eq LibNetcdf4::NC_INT

      file.close
    end

    it "should write" do
      file = open_file("w")
      group = file.groups[0]
      var = group.variables[0]

      var.write(1, 10)
      var.read(1).should eq 10

      file.close
    end

    it "should write a slice" do
      file = open_file("w")
      group = file.groups[0]
      var = group.variables[0]

      vals = [5, 6, 2, 72, 56, 24, 99, 12, 82, 24]
      var.write_slice(1, 10, vals)
      var.read_slice(1, 10).should eq vals

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

      file.close
    end
  end
end
