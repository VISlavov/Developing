require 'rubygems'
require 'pdfkit'

class Pdf_parser
	
	def initialize
		
	end

	def send_html_to_pdf path_html, path_pdf
		kit = PDFKit.new(path_html)
		kit.to_file(path_pdf)
	end
end
