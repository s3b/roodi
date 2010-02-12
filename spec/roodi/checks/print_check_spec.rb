require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe Roodi::Checks::PrintCheck do
  before(:each) do
    @roodi = Roodi::Core::Runner.new(Roodi::Checks::PrintCheck.new)
  end
  
  it "should not accept puts statements within methods " do
    content = <<-END
	class Foo
		def bar
			a = [1,2,3]
			puts a.inspect
			puts "debug message"
			puts("debug message")
			p a
			p "debug message"
			p("debug message")
		end
	end
    END
    @roodi.check_content(content)
    errors = @roodi.errors
    errors.should_not be_empty
    errors[0].to_s.should eql("dummy-file.rb:5 - puts statement found.")
    errors[1].to_s.should eql("dummy-file.rb:6 - puts statement found.")
    errors[2].to_s.should eql("dummy-file.rb:6 - puts statement found.")
    errors[3].to_s.should eql("dummy-file.rb:8 - p statement found.")
    errors[4].to_s.should eql("dummy-file.rb:9 - p statement found.")
    errors[5].to_s.should eql("dummy-file.rb:9 - p statement found.")
  end

end
