require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe Roodi::Checks::MissingRespondsToCheck do
  before(:each) do
    @roodi = Roodi::Core::Runner.new(Roodi::Checks::MissingRespondsToCheck.new)
  end
  
  it "should not accept classes that have method_missing but no responds_to?" do
    content = <<-END
	class Foo
		def method_missing(method_name, *args)
		end
	end
    END
    @roodi.check_content(content)
    errors = @roodi.errors
    errors.should_not be_empty
    errors[0].to_s.should eql("dummy-file.rb:1 - Foo implemented method_missing but did not implement responds_to? .")
  end

  it "should accept classes that don't have method_missing overridden" do
    content = <<-END
	class Bar
		def initialize
		end
	end
    END
    @roodi.check_content(content)
    @roodi.errors.should be_empty
  end

  it "should accept classes that only have responds_to?" do
    content = <<-END
	class Bar
		def responds_to?(method_name)
		end
	end
    END
    @roodi.check_content(content)
    @roodi.errors.should be_empty
  end

  it "should accept classes that have both method_missing and responds_to?" do
    content = <<-END
	class Bar
		def method_missing(method_name, *args)
		end
		def responds_to?(method_name)
		end
	end
    END
    @roodi.check_content(content)
    @roodi.errors.should be_empty
  end

end
