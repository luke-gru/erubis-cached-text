require 'erubis'
require 'digest/sha1'

module Erubis
  class ErubyCachedText < Basic::Engine
    include RubyEvaluator
    include RubyGenerator

    @minimum_string_size = nil
    class << self
      attr_accessor :minimum_string_size
    end

    TEXT_CACHE = {}

    def self.clear_cache
      TEXT_CACHE.clear
    end

    # @overridden
    def add_text(src, text)
      min_string_size = self.class.minimum_string_size
      if min_string_size && min_string_size > 0 && text.size < min_string_size
        return super
      end

      unless text.empty?
        digest = Digest::SHA1.hexdigest(text)
        key = :"#{digest}"
        unless TEXT_CACHE.has_key?(key)
          TEXT_CACHE[key] = text.freeze
        end
        src << " #{@bufvar} << " << generate_lookup_text_code(digest) << ";"
      end
    end

    private

      def generate_lookup_text_code(digest)
        "Erubis::ErubyCachedText::TEXT_CACHE[:#{digest.inspect}]"
      end

  end
end
