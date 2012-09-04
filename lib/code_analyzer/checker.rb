# encoding: utf-8
module CodeAnalyzer
  # A checker class that takes charge of checking the sexp.
  class Checker
    # interesting nodes that the check will parse.
    def interesting_nodes
      self.class.interesting_nodes
    end

    # interesting files that the check will parse.
    def interesting_files
      self.class.interesting_files
    end

    # check if the checker will parse the node file.
    #
    # @param [String] the file name of node.
    # @return [Boolean] true if the checker will parse the file.
    def parse_file?(node_file)
      interesting_files.any? { |pattern| node_file =~ pattern }
    end

    # add error if source code violates rails best practice.
    #
    # @param [String] message, is the string message for violation of the rails best practice
    # @param [String] filename, is the filename of source code
    # @param [Integer] line_number, is the line number of the source code which is reviewing
    def add_error(message, filename = @node.file, line_number = @node.line)
      errors << RailsBestPractices::Core::Error.new(
        filename: filename,
        line_number: line_number,
        message: message,
        type: self.class.to_s,
        url: url
      )
    end

    # errors that vialote the rails best practices.
    def errors
      @errors ||= []
    end

    class <<self
      def interesting_nodes(*nodes)
        @interesting_nodes ||= []
        @interesting_nodes += nodes
      end

      def interesting_files(*file_patterns)
        @interesting_files ||= []
        @interesting_files += file_patterns
      end
    end
  end
end
