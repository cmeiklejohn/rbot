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
    "tumblrplus => Post urls in channels into tumblr feed."
  end

  def configure(m, params)
    return unless m.kind_of?(PrivMessage) && m.private?
    m.reply "#{m.replyto} you are going to configure tumblrplus for #{params[:channel]}"
  end

  def listen(m)
    return unless m.kind_of?(PrivMessage)
    return unless m.private?
    line = "You said: #{m.plainmessage}"
    m.reply "#{line}"
  end

end

plugin = TumblrPlus.new
plugin.map "tumblrplus configure :channel", :action => :configure
