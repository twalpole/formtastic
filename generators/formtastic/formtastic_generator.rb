class FormtasticGenerator < Rails::Generator::Base
  
  def initialize(*runtime_args)
    super
  end
  
  def manifest
    record do |m|
      m.directory File.join('config', 'initializers')
      m.template 'formtastic.rb',   File.join('config', 'initializers', 'formtastic.rb')

      m.directory File.join('public', 'stylesheets')
      m.template 'formtastic.css',         File.join('public', 'stylesheets', 'formtastic.css')
      m.template 'formtastic_ie.css',      File.join('public', 'stylesheets', 'formtastic_ie.css')
      m.template 'formtastic_changes.css', File.join('public', 'stylesheets', 'formtastic_changes.css')
    
      m.directory File.join('public', 'images', 'formtastic')
      m.template 'tick.png',    File.join('public', 'images', 'formtastic', 'tick.png')
      m.template 'cross.png',   File.join('public', 'images', 'formtastic', 'cross.png')
      m.template 'refresh.png', File.join('public', 'images', 'formtastic', 'refresh.png')
    end
  end
    
  protected
  
  def banner
    %{Usage: #{$0} #{spec.name}\nCopies images and stylesheets to public/ and a config initializer to config/initializers/formtastic.rb}
  end
  
end