# encoding: utf-8
require "matching/version"

module Matching
	def fingerprint
		self.remove_leading_and_trailing_whitespace
		.change_all_characters_to_lowercase
		.remove_punctuation_and_control_characters
		.split_string_into_whitespace_separated_tokens
		.sort_the_tokens_and_remove_duplicates
		.join_the_tokens_back_together
		.normalize_extended_characters
	end

	def ngram(n=2)
		token = self.fingerprint


		ngrams = []

		# >>> Add initial n-gram
		ngrams << '_' + token.slice(0...(n-1))

		# >>> Compute n-grams from remaining characters of token
		i=0; while i < token.size do
			# >>> Slice text into n-sized chunks
			ngrams << slice = token.slice(i..i+(n-1)).ljust((n), '_')
			i += 1
		end

		ngrams
	end

	def ngrams(n=2)
		self.ngram(n)
		.sort_the_tokens_and_remove_duplicates
		.join_the_tokens_back_together
		.normalize_extended_characters
	end

	def ngram_score(term, n=2)
		matched_ngrams	= self.ngram(n) & term.ngram(n)
		all_ngrams		= self.ngram(n) + term.ngram(n)

		if matched_ngrams.size == 0
			score = 1.0
		elsif matched_ngrams.size == self.ngram(n).size
			score = 0.0
		else
			score = (all_ngrams.size.to_f - matched_ngrams.size.to_f) / all_ngrams.size.to_f
		end
		score
	end

	def remove_leading_and_trailing_whitespace
		self.strip
	end

	def change_all_characters_to_lowercase
		self.downcase
	end

	def remove_punctuation_and_control_characters
		self.gsub(/\p{Punct}|\p{Cntrl}/, ' ')
	end

	def split_string_into_whitespace_separated_tokens
		self.split
	end

	def sort_the_tokens_and_remove_duplicates
		if self.class == Array
			self.sort.uniq 
		else
			self.split_string_into_whitespace_separated_tokens.sort.uniq.join(' ')
		end
	end

	def join_the_tokens_back_together
		if self.class == Array
			self.join
		else
			self.split_string_into_whitespace_separated_tokens.join
		end
	end

	def normalize_extended_characters
		self.tr("ÀÁÂÃÄÅàáâãäåĀāĂăĄąÇçĆćĈĉĊċČčÐðĎďĐđÈÉÊËèéêëĒēĔĕĖėĘęĚěĜĝĞğĠġĢģĤĥĦħÌÍÎÏìíîïĨĩĪīĬĭĮįİıĴĵĶķĸĹĺĻļĽľĿŀŁłÑñŃńŅņŇňŉŊŋÒÓÔÕÖØòóôõöøŌōŎŏŐőŔŕŖŗŘřŚśŜŝŞşŠšſŢţŤťŦŧÙÚÛÜùúûüŨũŪūŬŭŮůŰűŲųŴŵÝýÿŶŷŸŹźŻżŽžﾠￂ ",
      			"aaaaaaaaaaaaaaaaaaccccccccccddddddeeeeeeeeeeeeeeeeeegggggggghhhhiiiiiiiiiiiiiiiiiijjkkkllllllllllnnnnnnnnnnnoooooooooooooooooorrrrrrsssssssssttttttuuuuuuuuuuuuuuuuuuuuwwyyyyyyzzzzzz | ")
	end
end

class String
	include Matching
end

class Array
	include Matching
end