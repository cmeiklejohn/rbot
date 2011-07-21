#-- vim:sw=2:et
#++
#
# :title: tumblrplus - a work in progress
# :version: 0.1a
#
# Author:: Greg Maccarone <gmaccarone@gmail.com>
#
# Copyright:: (C) 2011 Greg Maccarone
#
# License:: public domain
#

class TumblrPlus < Plugin

  def help(plugin, topic="")
    "tumblr+ => Post urls in channels into tumblr feed."
  end

end

plugin = TumblrPlus.new

plugin.map "tumblrplus", :action => :help, :thread => "yes" #so it won't lock

