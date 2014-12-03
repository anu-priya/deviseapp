# to fix issue with uninitialized constant Syck::Syck error
class Module

  def yaml_tag_read_class(name)
    # Constantize the object so that ActiveSupport can attempt
    # its auto loading magic. Will raise LoadError if not successful.
    name.gsub!(/^YAML::/, '') if name =~ /BadAlias/
    name.constantize
    name
  end 

end