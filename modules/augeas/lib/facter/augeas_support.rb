# This is a hack to install augeas during collecting of facts
# so that even catalogs containing "augeas" resources can be
# processed.
lambda do # we wrap the code to a lambda so that we can use "return" to exit early
  unless Puppet.features.augeas?
    # We don't have augeas support so let's try to install the needed library.
    begin
      catalog = Puppet::Resource::Catalog.new()
      catalog.add_resource(Puppet::Resource.new('Package', 'ruby-augeas'))
      catalog.to_ral.apply()

      # We need to re-open the Puppet module to reload the features
      # as they are cached, otherwise the installation of ruby-augeas
      # would go unnoticed.
      module Puppet
        @features = Puppet::Util::Feature.new('puppet/feature')
        load 'puppet/feature/base.rb'
      end

      require 'augeas'
    rescue SystemExit, NoMemoryError
      raise
    rescue Exception => e
      Facter.debug("could not install augeas support: #{e}\n#{e.backtrace}")
      return
    end
  end

  Facter.add('augeas_support') do
    setcode do
      version = nil
      Augeas::open('/', nil, Augeas::NO_MODL_AUTOLOAD) do |augeas|
        version = augeas.get('/augeas/version')
      end
      version
    end
  end
end.call
