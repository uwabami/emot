require "thor"

module Emot
  class CLI < Thor
    desc "show [NAME]", "show emoji icon and unicode for NAME"
    option :only, aliases:'-o', desc:"set 'name', 'code' or 'icon'"
    option :inline, aliases:'-i', default:false, type: :boolean
    def show(name=nil)
      case name
      when nil, 'all'
        list =
          Emot.list.map do |name, (icon, code)|
            case options[:only]
            when 'name'
              "%s  %s" % [icon, c(name)]
            when 'code', 'unicode'
              "%s  %s" % [icon, code]
            when 'emoji', 'icon'
              "%s" % [icon]
            when 'nameonly'
              "%s" % [c(name)]
            else
              "%s  %s (%s)" % [icon ,c(name), code]
            end
          end
        puts (options[:inline] ? list.join("  ") : list)
        puts "\e[33m#{list.size}\e[0m #{c('emojis')}"
      else
        icon, code = Emot.list[name.intern]
        if icon
          print "%s  %s (%s)\n" % [icon, c(name), code]
        else
          puts "No emoji for '#{name}'"
        end
      end
    end

    desc "icons", "show all emoji icons"
    option :inline, aliases:'-i', default:true, type: :boolean
    def icons
      CLI.start(['show', '--only', 'emoji', '--inline', options[:inline].to_s])
    end

    desc "names", "show all available names for emoji"
    option :inline, aliases:'-i', default:false, type: :boolean
    def names
      CLI.start(['show', '--only', 'nameonly', '--inline', options[:inline].to_s])
    end

    desc "version", "Show Emot version"
    def version
      puts "Emot #{Emot::VERSION} (c) 2014 kyoendo"
    end
    map "-v" => :version

    no_tasks do
      def c(str, color=32)
        "\e[#{color}m#{str}\e[0m"
      end
    end
  end
end
