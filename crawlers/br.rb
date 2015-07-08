class BRCrawler < HipCrawler
  def parse_books_table
    table(class: 'tableBackgroundHighlight').rows[1..-1].select do |row|
      (Date.parse(row.tds[-1].text) - Date.today).to_i < Helper::DUE_DATE
    end.map { |row| "#{row.tds[1].text.split("\n").first} - #{Date.parse(row.tds[-1].text)}" }
  end
end
