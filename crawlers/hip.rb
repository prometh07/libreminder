class HipCrawler < Watir::Browser
  def initialize user, password, url, library
    super()
    @user = user
    @password = password
    @library_name = library
    @url = url
  end

  def login
    goto @url
    a(title: 'Logowanie').when_present.click
    text_field(name: 'sec1').set @user
    text_field(name: 'sec2').set @password
    button(value: 'Logowanie').click
  end

  def books_info
    a(text: /konto czytelnika/i).when_present.click
    a(text: 'Wypożyczenia').when_present.click
    a(text: 'Data zwrotu').when_present.click
    books = parse_books_table
    books.to_a.empty? ? "Nie ma żadnych książek do oddania w najbliższym czasie" : books.join("\n\n")
  end

  def parse_books_table
    tables(class: 'tableBackgroundHighlight')[1].rows[1..-1].select do |row|
      (Date.parse(row.tds[-2].text) - Date.today).to_i < Helper::DUE_DATE
    end.map { |row| "#{row.tds[1].text.split("\n").first} - #{Date.parse(row.tds[-2].text)}" }
  end

  def run
    login
    Helper.show_notification(@library_name, books_info, Helper::NOTIFY_TIMEOUT)
    Helper::LOGGER.info "#{@library_name} - done"
  rescue => e
    Helper.show_notification(@library_name, e.message, Helper::NOTIFY_TIMEOUT)
    Helper::LOGGER.error "#{@library_name} - #{e.message}"
  ensure
    close
  end
end
