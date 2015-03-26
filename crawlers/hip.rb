class Crawler < Watir::Browser
  def initialize user, password
    super()
    @user = user
    @password = password
    @library_name = 'PUT library'
  end

  def login
    goto 'http://pp-hip.pfsl.poznan.pl/' 
    a(title: 'Logowanie').click
    text_field(name: 'sec1').when_present.set @user
    text_field(name: 'sec2').set @password
    button(value: 'Logowanie').click
  end

  def books_info
    a(text: 'Konto czytelnika').click
    a(text: 'Wypożyczenia').click
    a(text: 'Data zwrotu').click
    books = tables(class: 'tableBackgroundHighlight')[1].rows[1..-1].reduce([]) do |books, row|
      if (Date.parse(row.tds[-2].text) - Date.today).to_i < Helper::DUE_DATE 
        books << "#{row.tds[1].text.split("\n").first} - #{Date.parse(row.tds[-2].text)}"
      end
    end
    books.to_a.empty? ? "Nie ma żadnych książek do oddania w najbliższym czasie" : books.join("\n\n")
  end

  def run
    login
    Libnotify.show summary: @library_name,
                   body: books_info,
                   timeout: Helper::NOTIFY_TIMEOUT
    close
  rescue => e
    puts e.message
    binding.pry
  end
end
