require 'open-uri'
require 'nokogiri'

def process(id, date)
	host = 'http://seavers.iteye.com'
	cookie = IO.read('cookie.txt')
	agent = 'Mozilla/5.0 (X11; Linux i686) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/30.0.1599.14 Safari/537.36'

	html = open(host + '/admin/blogs/' + id + '/edit', 'User-Agent'=>agent, 'Cookie'=>cookie).read
	doc = Nokogiri::HTML(html)

	title = doc.search('#blog_title').attr('value').to_s
	text = doc.search('#editor_body').text
	category = doc.search('#blog_category_list').attr('value').to_s
	tag = doc.search('#blog_tag_list').attr('value').to_s
	

	content = text
		.gsub('[size=xx-large]', '#')
		.gsub('[size=x-large]', '##')
		.gsub('[size=large]', '###')
		.gsub('[size=medium]', '####')
		.gsub('[size=small]', '')
		.gsub('[size=x-small]', '')
		.gsub('[size=xx-small]', '')
		.gsub('[/size]', '')
		.gsub(/\[url=(.*)\](.*)\[\/url\]/, '[\2](\1)')
		.gsub('[url]', '').gsub('[/url]', '')
		.gsub('[b]', '*').gsub('[/b]', '*')
		.gsub('[list]', '').gsub('[/list]', '')
		.gsub('[b]', '*').gsub('[/b]', '*')
		.gsub('[*]', '* ')
		.gsub('[code]', '```').gsub('[/code]', '```')
		.gsub(/\[code="(.*)"\]/, '```')


	filename = date[0..9] + '-' + id + '.markdown'
	File.open('blog/' + filename, 'w') { |file|
		file.puts '---'
		file.puts 'layout: post'
		file.puts 'title: "' + title.to_s + '"'
		file.puts 'date: ' + date + ':00 +0800'
		file.puts 'comments: true'
		file.puts 'categories:'
		file.puts '- ' + category.to_s
		file.puts 'tags:'
		tag.split(',').each {|x|
			file.puts '- ' + x
		}
		file.puts '---'

		file.puts ''
		file.puts content 
	}

end

def spider(page)
	agent = 'Mozilla/5.0 (X11; Linux i686) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/30.0.1599.14 Safari/537.36'

	url = 'http://seavers.iteye.com/?page='+page.to_s
	html = open(url, 'User-Agent'=>agent)

	doc = Nokogiri::HTML(html)
	doc.search('.blog_main').each {|x|
		id = x.search('h3 a').attr('href').text[/[0-9]+/, 0]
		date = x.search('.blog_bottom .date').text
		puts id + "\t" + date
		process(id, date)
	}
end

##process('1416013', '2013-12-31 14:01')
(1..5).each {|page|
	spider(page)
}

#process('1853687', '2013-06-03 19:56')
