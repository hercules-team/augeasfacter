require 'augeas'
aug = Augeas::open(nil, nil, Augeas::NO_LOAD)

CONFIG = '/etc/puppet/augeasfacter.conf'
DEFAULT_TYPE = 'single'
DEFAULT_METHOD = 'value'
DEFAULT_SEP = ','

def path_label(path)
  path.split("/")[-1].split("[")[0]
end

def get_value(aug, path, method)
  Facter.debug("Retrieving value with method #{method}")
  if method == 'label'
    Facter.debug("Path is #{path}")
    path_label(path)
  elsif method == 'value'
    aug.get(path)
  else
    Facter.debug("Unknown method #{method} to retrieve path #{path}")
    return nil
  end
end

search_path = Facter.search_path().join(",")
Facter.debug("Search path is #{search_path}")

aug.transform(
  :lens => 'Puppet.lns',
  :name => 'Aug_Facts',
  :incl => CONFIG
)
aug.load!

aug.match("/files#{CONFIG}/*[label()!='#comment']").each do |fact|
  fact_name = path_label(fact)
  Facter.debug("Adding fact #{fact_name}")
  path  = aug.get("#{fact}/path")
  unless path
    Facter.debug("No path specified for fact #{fact_name}. Ignoring.")
    next
  end
  type  = aug.get("#{fact}/type") || DEFAULT_TYPE
  method = aug.get("#{fact}/method") || DEFAULT_METHOD
  Facter.add(fact_name) do 
    setcode do
      if type == 'single'
        node = aug.match(path)[0]
        get_value(aug, node, method) || nil
      elsif type == 'multiple'
        sep = aug.get("#{fact}/sep") || DEFAULT_SEP
        vals = Array.new()
        aug.match(path).each do |p|
          Facter.debug("Adding value from path #{p}")
          vals.push(get_value(aug, p, method))
        end
        vals.join(sep)
      else
        Facter.debug("Unknown type #{type} for fact #{fact_name}. Ignoring")
      end
    end
  end
end
