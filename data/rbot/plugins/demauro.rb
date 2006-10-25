# vim: set sw=2 et:
# demauro plugin: provides a link to the definition of a word
# from the Italian dictionary De Mauro/Paravia available online
# can also be used by other plugins to check if a given word exists
# or not (is_italian? method)
#
# This should be extended as a general dictionary lookup plugin, for multiple languages
#
# Author: Giuseppe "Oblomov" Bilotta <giuseppe.bilotta@gmail.com>
#
# TODO: cache results and reuse them if get_cached returns a cache copy

require 'uri'

DEMAURO_LEMMA = /<anchor>(.*?)(?: - (.*?))<go href="lemma.php\?ID=(\d+)"\/><\/anchor>/
class DeMauroPlugin < Plugin
  def initialize
    super
    @dmurl = "http://www.demauroparavia.it/"
    @wapurl = "http://wap.demauroparavia.it/"
  end


  def help(plugin, topic="")
    return "demauro <word> => provides a link to the definition of the word from the Italian dictionary De Mauro/Paravia"
  end

  def demauro(m, params)
    justcheck = params[:justcheck]

    parola = params[:parola].downcase
    url = @wapurl + "index.php?lemma=#{URI.escape(parola)}"
    xml = @bot.httputil.get_cached(url)
    if xml.nil?
      info = @bot.httputil.last_response
      info = info ? "(#{info.code} - #{info.message})" : ""
      return false if justcheck
      m.reply "An error occurred while looking for #{parola}#{info}"
      return
    end
    if xml=~ /Non ho trovato occorrenze per/
      return false if justcheck
      m.reply "Nothing found for #{parola}"
      return
    end
    entries = xml.scan(DEMAURO_LEMMA)
    text = parola
    if !entries.assoc(parola) and !entries.assoc(parola.upcase)
      return false if justcheck
      text += " not found. Similar words"
    end
    return true if justcheck
    text += ": "
    text += entries[0...5].map { |ar|
      "#{ar[0]} - #{ar[1].gsub(/<\/?em>/,'')}: #{@dmurl}#{ar[2]}"
    }.join(" | ")
    m.reply text
  end

  def is_italian?(word)
    return demauro(nil, :parola => word, :justcheck => true)
  end

end

plugin = DeMauroPlugin.new
plugin.map 'demauro :parola', :action => 'demauro'

