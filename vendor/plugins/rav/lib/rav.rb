load 'config/environment.rb'

require 'erb'

class RailsApplicationVisualizer
  DEFAULT_OPTIONS = {
    :models => true,
    :controllers => true,
  }

  def initialize(options = {})
    options  = DEFAULT_OPTIONS.merge(options)
    template = File.read('vendor/plugins/rav/diagram.dot.erb')

    @dot = ERB.new(template).result(binding)
  end

  def output(*filenames)
    filenames.each do |filename|
      format = filename.split('.').last
      
      if format == 'dot'
        # dot supports -Tdot, but this makes debugging easier :-)
        File.open(filename, 'w') { |io| io << @dot }
        return true
      else
        IO.popen("dot -T#{format} -o #{filename}", 'w') { |io| io << @dot }                 
        return $?.success?
      end
    end
  end

  protected

  # These two methods are called from diagram.dot.erb

  def models
    filenames_to_constants(model_filenames)
  end
  
  def controllers
    load 'app/controllers/application.rb'
    filenames_to_constants(controller_filenames) << ApplicationController
  end

  private

  def model_filenames
    filter_model_filenames(Dir.glob('app/models/*.rb'))
  end

  def filter_model_filenames(filenames)
    filenames.reject { |fn| fn.match(/_observer\.rb$/) }
  end

  def controller_filenames
    Dir.glob('app/controllers/**/*_controller.rb')
  end

  # app/models/fish.rb -> Fish class
  # app/controllers/foo/bar_controller.rb -> Foo::BarController class
  def filenames_to_constants(filenames)
    filenames.map do |filename|
      # Suggestions on how to make the next line a bit more sane are welcome
      filename.split('/')[2..-1].join('/').split('.').first.camelize.constantize # :-)
    end
  end
end
