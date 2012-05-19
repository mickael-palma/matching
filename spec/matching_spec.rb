# encoding: utf-8

require "spec_helper"

describe Matching do
	it "should remove leading and trailing whitespace" do
	term = '  test strip  '
	term.remove_leading_and_trailing_whitespace.should == 'test strip'
	end

	it "should change all characters to lowercase" do
	term = 'TEST'
	term.change_all_characters_to_lowercase.should == 'test'
	end

	it "should remove all punctuation and control characters" do
	term = 'Hi, Are you OK ?'
	term.remove_punctuation_and_control_characters.should == 'Hi  Are you OK  '
	end

	it "should split the string into whitespace-separated tokens" do
	term = 'I am busy today'
	term.split_string_into_whitespace_separated_tokens.class.should == Array
	term.split_string_into_whitespace_separated_tokens.size.should == 4
	end

	it "sort the tokens and remove duplicates" do
	term = '1 1 2 3 9 7 7 6'
	term.sort_the_tokens_and_remove_duplicates.should == '1 2 3 6 7 9'
	end

	it "join the tokens back together" do
	term = '1 1 2 3 9 7 7 6'
	term.join_the_tokens_back_together.should == '11239776'
	end

	it "should normalize extended characters" do
	  term = 'Mickaël'
	  term.normalize_extended_characters.should == "Mickael"
	end

	context "fingerprint" do
		# remove leading and trailing whitespace
		# change all characters to their lowercase representation
		# remove all punctuation and control characters
		# split the string into whitespace-separated tokens
		# sort the tokens and remove duplicates
		# join the tokens back together
		# normalize extended western characters to their ASCII representation (for example "gödel" → "godel")
		it "should respond to fingerprint method" do
			term = 'test'
			term.should respond_to 'fingerprint'
		end

		test_cases = {
			'Hi, Are you OK ?' => 'arehiokyou',
			'1 2 3 55 6 7 8' => '12355678',
			'Xo Xo Gossip Girl !' => 'girlgossipxo',
			'11 12 11 101 101 10' => '101011112',
			'Gwenaëlle is a goddess' => "agoddessgwenaelleis"
		}


		test_cases.each do |k,v|
			it "should pass test cases" do
				term = k
				term.fingerprint.should == v
			end
		end
	end

	context "ngrams" do
		# change all characters to their lowercase representation
		# remove all punctuation, whitespace, and control characters
		# obtain all the string n-grams
		# sort the n-grams and remove duplicates
		# join the sorted n-grams back together
		# normalize extended western characters to their ASCII representation
		
		it "should respond to ngrams method" do
			term = 'test'
			term.should respond_to 'ngrams'
		end

		it "should return an array of ngrams" do
		  term = 'test'
		  term.ngram.class == Array
		end

		it "should return all the strings n-grams" do
		  term = 'testôë'
		  term.ngrams.should == "_te_esoestteto"
		end
	end

	context "ngram_score" do
	  	it "should return 0 when all ngrams match" do
		  term1 = 'testôë'
		  term2 = 'testôë'
		  term1.ngram_score(term2).class.should == Float
		  term1.ngram_score(term2).should == 0
		end

		it "should return 1 when no ngrams match" do
		  term1 = 'testôë'
		  term2 = 'azrgfd'
		  term1.ngram_score(term2).class.should == Float
		  term1.ngram_score(term2).should == 1
		end
	end
end