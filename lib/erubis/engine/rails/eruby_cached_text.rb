require 'erubis'
require 'digest/sha1'
require 'action_view/template/handlers/erb'

module ActionView
  class Template
    module Handlers
      class ErubyCachedText < ::Erubis::Eruby

        @minimum_string_size = nil
        class << self
          attr_accessor :minimum_string_size
        end

        TEXT_CACHE = {}

        def self.clear_cache
          TEXT_CACHE.clear
        end

        def add_preamble(src)
          @newline_pending = 0
          src << "@output_buffer = output_buffer || ActionView::OutputBuffer.new;"
        end

        def add_text(src, text)
          return if text.empty?
          if text == "\n"
            @newline_pending += 1
            return
          end

          min_string_size = self.class.minimum_string_size

          # don't cache the string in memory
          if min_string_size && min_string_size > 0 && text.size < min_string_size
            src << "@output_buffer.safe_append='"
            src << "\n" * @newline_pending if @newline_pending > 0
            src << escape_text(text)
            src << "'.freeze;"
            @newline_pending = 0
            # cache the string in memory
          else
            if @newline_pending > 0
              nls = "\n" * @newline_pending
              text = nls << text
            end
            escaped = escape_text(text)
            digest = Digest::SHA1.hexdigest(escaped)
            key = :"#{digest}"
            unless TEXT_CACHE.has_key?(key)
              TEXT_CACHE[key] = escaped.freeze
            end
            src << "@output_buffer.safe_append="
            src << generate_lookup_text_code(digest) << ";"
          end
        end

        # Erubis toggles <%= and <%== behavior when escaping is enabled.
        # We override to always treat <%== as escaped.
        def add_expr(src, code, indicator)
          case indicator
          when '=='
            add_expr_escaped(src, code)
          else
            super
          end
        end

        BLOCK_EXPR = /\s+(do|\{)(\s*\|[^|]*\|)?\s*\Z/

          def add_expr_literal(src, code)
            flush_newline_if_pending(src)
            if code =~ BLOCK_EXPR
              src << '@output_buffer.append= ' << code
            else
              src << '@output_buffer.append=(' << code << ');'
            end
          end

        def add_expr_escaped(src, code)
          flush_newline_if_pending(src)
          if code =~ BLOCK_EXPR
            src << "@output_buffer.safe_append= " << code
          else
            src << "@output_buffer.safe_append=(" << code << ");"
          end
        end

        def add_stmt(src, code)
          flush_newline_if_pending(src)
          super
        end

        def add_postamble(src)
          flush_newline_if_pending(src)
          src << '@output_buffer.to_s'
        end

        def flush_newline_if_pending(src)
          if @newline_pending > 0
            src << "@output_buffer.safe_append='#{"\n" * @newline_pending}'.freeze;"
            @newline_pending = 0
          end
        end

        private

          def generate_lookup_text_code(digest)
            "ActionView::Template::Handlers::ErubyCachedText::TEXT_CACHE[:#{digest.inspect}]"
          end

      end
    end

      ERB.erb_implementation = ErubyCachedText

  end
end
