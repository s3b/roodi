require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe Roodi::Checks::IncompleteInitializeCheck do
  before(:each) do
    @roodi = Roodi::Core::Runner.new(Roodi::Checks::IncompleteInitializeCheck.new)
  end
  
  it "should not accept initialize methods without the super call" do
    content = <<-END
	class Base
		def initialize
		end
	end

	class Derived < Base
		def initialize
		end
	end
    END
    @roodi.check_content(content)
    errors = @roodi.errors
    errors.should_not be_empty
    errors[0].to_s.should eql("dummy-file.rb:7 - The class Derived has not invoked the initialize method of its base class.")
  end

  it "should accept initialize methods in classes that are not derived" do
    content = <<-END
	class Base
		def initialize
		end
	end
    END
    @roodi.check_content(content)
    @roodi.errors.should be_empty
  end

  it "should accept initialize methods that have a call to super for derived classes" do
    content = <<-END
	class Base
		def initialize
		end
	end

	class Derived < Base
		def initialize
			super
		end
	end

	class Derived1 < Base
		def initialize(arg)
			super(arg)
		end
	end

	class Derived2 < Base
		def initialize
			super()
		end
	end
    END
    @roodi.check_content(content)
    @roodi.errors.should be_empty
  end

end
