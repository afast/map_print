module MapPrint
  class Core
    def self.print(path)
      puts path
      Prawn::Document.generate(path) do
        text 'Hello World!'
      end
    end
  end
end
