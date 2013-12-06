class FilePattern < ActiveRecord::Base
	has_many :digital_collections

	# attr_accessor :pattern

	def name
		self.pattern
	end
	def title
		self.pattern
	end
	def to_s
		self.pattern
	end


	def regular_expression
		rest = pattern
        new_regex_string = ''
        tags_used = []

        while rest.length > 0 do
            if /^\[(?<raw_tag>[^\]]*)\](?<new_rest>.*)$/ =~ rest
                ## Extract the "tag" and "tag_length" from the pretty pattern
                # @logger.debug "Matched tag: #{raw_tag} (rest: #{new_rest})"

                tag_s, tag_length_s = raw_tag.split '_'
                tag = tag_s.to_sym
                tag_length = tag_length_s.to_i
                # @logger.debug tag
                # @logger.debug tag_length

                new_regex_string += if tags_used.include?(tag)
                        '\k<' + tag.to_s + '>' ## If a tag has already been used, refer back to the previous named capture.
                    else
                    	tags_used << tag
                        _generate_regex_for_tag tag, tag_length
                    end

            elsif /^(?<literal>[^\[]+)(?<new_rest>.*)$/ =~ rest
                # @logger.debug "Matched literal: #{literal} (rest: #{new_rest})"

                new_regex_string += Regexp.escape(literal)
            else
            	raise "regex error: should not happen"
            end
            rest = new_rest
	    end
        new_regex = Regexp.new(new_regex_string)
        new_regex
    end

	################################################################################
	private # methods below:
	################################################################################

	def _generate_regex_for_tag tag, tag_length
		'(?<' + tag.to_s + '>' +
			# if ancestor_value_hash[tag]
			# 	if tag_length > 0
			# 		"%0#{tag_length}d" % ancestor_value_hash[tag]
			# 	else
			# 		ancestor_value_hash[tag]
			# 	end
			# else
				case tag
					when :series
						"[0-9]{#{tag_length}}"
					when :subseries
						"[0-9]{#{tag_length}}"
					when :rg
						"[-RGM0-9.]+"
					when :item
						"[0-9]{#{tag_length}}"
					else
						raise "unrecognized tag: #{tag}"
					end + ')'  # remove if restoring concat, below.
			# end + ')'
	end

end # class
