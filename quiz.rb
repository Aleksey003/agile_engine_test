require 'mechanize'
require 'nokogiri'

class Quiz
  def run
    agent = Mechanize.new
    result_hash = {}
    agent.agent.http.verify_mode = OpenSSL::SSL::VERIFY_NONE
    page = agent.get 'https://staqresults.staq.com'
    form = page.form_with id: 'form-signin'
    form.email = 'test@example.com'
    form.password = 'secret'
    page = form.submit
    table = page.search('table.table.table-striped')
    сolumns = table.search('thead > tr').search('th').map{ |n| n.text.downcase.to_sym }[1..-1]
    table.search('tbody > tr').each do |rows|
      rows_array =  rows.search('td').map{ |n| n.text }
      result_hash[rows_array.first] = Hash[сolumns.zip rows_array[1..-1]]
    end
    result_hash
  end
end