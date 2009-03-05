require 'rubygems'
require 'simple-rss'
require 'open-uri'

FEEDS_DOWNLOAD_DIR = 'downloads'
RSS_LINKS_FILENAME = 'rss_links'
CWD = File.expand_path(File.dirname(__FILE__))

def download_enclosure enclosure, description
	filename = File.basename(enclosure)
	output_dir = File.join(CWD, FEEDS_DOWNLOAD_DIR, description)
	FileUtils.mkdir_p output_dir
	FileUtils.chdir output_dir
		`wget #{enclosure}` unless File.exists?(File.join(output_dir, filename))
end

File.open(RSS_LINKS_FILENAME) do |file|
	while(rss_link = file.gets) do
		feed = SimpleRSS.parse open(rss_link)
		enclosure = feed.items.first.guid
		download_enclosure(enclosure, feed.description)
	end
end
