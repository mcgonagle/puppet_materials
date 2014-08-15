#!/usr/bin/ruby

require 'yaml'

BASEDIR = Dir.chdir(File.dirname(__FILE__) + "/..") { Dir.getwd }
YAMLDIR = File.join(BASEDIR, "yaml")

# Read in a pure yaml representation of our node.
def read_node(node)
    nodefile = File.join(YAMLDIR, "#{node}.yaml")
    if FileTest.exist?(nodefile)
        return YAML.load_file(nodefile)
    else
        raise "Could not find information for %s" % node
    end
end

node = ARGV[0]

info = read_node(node)

# Iterate over any provided parents, merging in there information.
parents_seen = []
while parent = info["parent"]
    raise "Found inheritance loop with parent %s" % parent if parents_seen.include?(parent)

    parents_seen << parent

    info.delete("parent")

    parent_info = read_node(parent)

    # Include any parent classes in our list.
    if pclasses = parent_info["classes"]
        info["classes"] += pclasses
        info["classes"].uniq!
    end

    # And inherit parameters from our parent, while preferring our own values.
    if pparams = parent_info["parameters"]
        # When using Hash#merge, the hash being merged in wins, and we
        # want the subnode parameters to be the parent node parameters.
        info["parameters"] = pparams.merge(info["parameters"])
    end

    # Copy over any parent node name.
    if pparent = parent_info["parent"]
        info["parent"] = pparent
    end
end

puts YAML.dump(info)
