require 'test/my-assertions'

module TestRSSMixin

	include RSS

	XMLDECL_VERSION = "1.0"
	XMLDECL_ENCODING = "UTF-8"
	XMLDECL_STANDALONE = "no"

	RDF_ABOUT = "http://www.xml.com/xml/news.rss"
	RDF_RESOURCE = "http://xml.com/universal/images/xml_tiny.gif"
	TITLE_VALUE = "XML.com"
	LINK_VALUE = "http://xml.com/pub"
	URL_VALUE = "http://xml.com/universal/images/xml_tiny.gif"
	NAME_VALUE = "hogehoge"
	DESCRIPTION_VALUE = "
    XML.com features a rich mix of information and services 
    for the XML community.
	"
	RESOURCES = [
		"http://xml.com/pub/2000/08/09/xslt/xslt.html",
		"http://xml.com/pub/2000/08/09/rdfdb/index.html",
	]

	private
	def make_xmldecl(v=XMLDECL_VERSION, e=XMLDECL_ENCODING, s=XMLDECL_STANDALONE)
		rv = "<?xml version='#{v}'"
		rv << " encoding='#{e}'" if e
		rv << " standalone='#{s}'" if s
		rv << "?>"
		rv
	end

	def make_RDF(content=nil, xmlns=[])
		<<-EORSS
#{make_xmldecl}
<rdf:RDF xmlns="#{URI}" xmlns:rdf="#{RDF::URI}"
#{xmlns.collect {|pre, uri| "xmlns:#{pre}='#{uri}'"}.join(' ')}>
#{block_given? ? yield : content}
</rdf:RDF>
EORSS
	end

	def make_channel(content=nil)
		<<-EOC
<channel rdf:about="#{RDF_ABOUT}">
	<title>#{TITLE_VALUE}</title>
	<link>#{LINK_VALUE}</link>
	<description>#{DESCRIPTION_VALUE}</description>

	<image rdf:resource="#{RDF_RESOURCE}" />

	<items>
		<rdf:Seq>
#{RESOURCES.collect do |res| '<rdf:li resource="' + res + '" />' end.join("\n")}
		</rdf:Seq>
	</items>

	<textinput rdf:resource="#{RDF_RESOURCE}" />

#{block_given? ? yield : content}
</channel>
EOC
	end

	def make_image(content=nil)
		<<-EOI
<image rdf:about="#{RDF_ABOUT}">
	<title>#{TITLE_VALUE}</title>
	<url>#{URL_VALUE}</url>
	<link>#{LINK_VALUE}</link>
#{block_given? ? yield : content}
</image>
EOI
	end

	def make_item(content=nil)
		<<-EOI
<item rdf:about="#{RDF_ABOUT}">
	<title>#{TITLE_VALUE}</title>
	<link>#{LINK_VALUE}</link>
	<description>#{DESCRIPTION_VALUE}</description>
#{block_given? ? yield : content}
</item>
EOI
	end

	def make_textinput(content=nil)
		<<-EOT
<textinput rdf:about="#{RDF_ABOUT}">
	<title>#{TITLE_VALUE}</title>
	<description>#{DESCRIPTION_VALUE}</description>
	<name>#{NAME_VALUE}</name>
	<link>#{LINK_VALUE}</link>
#{block_given? ? yield : content}
</textinput>
EOT
	end
end
