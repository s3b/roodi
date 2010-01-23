require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe Roodi::Checks::DuplicateTestsCheck do
  before(:each) do
    @roodi = Roodi::Core::Runner.new(Roodi::Checks::DuplicateTestsCheck.new)
  end
  
  it "should not accept tests with the same name in the same class" do
    content = <<-END
	class DupeTest
		def test_dupe_function
		end
		def test_dupe_function
		end
	end
    END
    @roodi.check_content(content)
    errors = @roodi.errors
    errors.should_not be_empty
    errors[0].to_s.should eql("dummy-file.rb:4 - Duplicate test test_dupe_function found in DupeTest.")
  end

  it "should accept tests with the same name in different classes" do
    content = <<-END
	class DupeTest
		def test_dupe_function
		end
	end
	class DupeTest2
		def test_dupe_function
		end
	end
    END
    @roodi.check_content(content)
    @roodi.errors.should be_empty
  end

  it "should reject only duplicate test definitions" do
    content = <<-END
	class DupeTest
		def dupe_function
		end
		def dupe_function
		end
	end
    END
    @roodi.check_content(content)
    @roodi.errors.should be_empty
  end

end
