require 'resque_ranger/core'

require 'rake'

module ResqueRanger::Rake
  extend Rake::DSL


  # Creates the ResqueRanger tasks inside of the default
  # 'queues' namespace
  def self.default!
    namespace :queues do 
      create_tasks!
    end
  end


  def self.create_tasks!
    desc "Displays the number of items in each queue"
    task :size => :"resque:setup" do 
      ResqueRanger.queues.each do |q|
        puts "#{ q.name.inspect } --> #{ q.size }"
      end
    end

    desc "Deletes all items from each queue"
    task :purge => :"resque:setup" do 
      ResqueRanger.queues.each do |q|
        puts "Purging #{ q.name.inspect }  (#{ q.size } --> 0)"
      end
    end
  end

end


