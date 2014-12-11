# ResqueRanger #

Rake tasks and such for Resque.

## Installation ##

    gem install resque_ranger

## Usage ##

### In Rake ###

If you want to create the ResqueRanger rake tasks, then add the following to your Rakefile:

    require 'resque_ranger/rake'
    ResqueRanger::Rake.default!


This will create the following Rake tasks:

    rake queues:purge          # Deletes all items from each queue
    rake queues:size           # Displays the number of items in each queue

Alternatively, you might decide that you want to place the tasks into a different namespace.  If so, then just do the following:

    require 'resque_ranger/rake'

    namespace :my_namespace do
      ResqueRanger::Rake.create_tasks!
    end

This will create the following Rake tasks:

    rake my_namespace:purge    # Deletes all items from each queue
    rake my_namespace:size     # Displays the number of items in each queue

### In Code ###

In code, ResqueRanger just provides a more object-oriented interface to queues:

    require 'resque_ranger'

    ResqueRanger.queues.each do |q|
      puts q.size
      q.purge
    end

