require 'erubi/capture'
require 'parser/current'

module ERBLint
  module ERBParser
    class << self
      def parse(file_content)
        file_content = transform_capture_blocks(file_content)
        eruby = Erubi::CaptureEngine.new(file_content)
        Parser::CurrentRuby.parse(eruby.src)
      rescue Parser::SyntaxError
        raise ParseError, 'File is not valid ERB and could not be parsed.'
      end

      class ParseError < StandardError
      end

      private

      def transform_capture_blocks(src)
        regexp = /<%(={1,2})(([\s\S]*?)(\sdo\s)(\|.*\|\s)?%>)/
        src.gsub(regexp) { "<%|#{$1}#{$2}" }
      end
    end
  end
end
