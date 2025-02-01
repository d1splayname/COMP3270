#
#  Class Lexer - Reads a TINY program and emits tokens
#
class Lexer
# Constructor - Is passed a file to scan and outputs a token
#               each time nextToken() is invoked.
#   @c        - A one character lookahead 
	def initialize(filename)
		# Need to modify this code so that the program
		# doesn't abend if it can't open the file but rather
		# displays an informative message
		begin
			@f = File.open(filename,'r:utf-8')
		rescue
			puts "Error opening file"
		end
		# Go ahead and read in the first character in the source
		# code file (if there is one) so that you can begin
		# lexing the source code file 
		if (! @f.eof?)
			@c = @f.getc()
		else
			@c = "eof"
			@f.close()
		end
	end
	
	# Method nextCh() returns the next character in the file
	def nextCh()
		if (! @f.eof?)
			@c = @f.getc()
		else
			@c = "eof"
			# puts ("End of file")
		end
		
		return @c
	end

	# Method nextToken() reads characters in the file and returns
	# the next token
	def nextToken() 
		if @c == "eof"
			tok = Token.new(Token::EOF,"eof")
		elsif @c == "="
			tok = Token.new(Token::ASSIGN,@c)
			nextCh()
		elsif @c == "+"
			tok = Token.new(Token::ADDOP,@c)
			nextCh()
		elsif @c == "-"
			tok = Token.new(Token::SUBDOP,@c)
			nextCh()
		elsif @c == "*"
			tok = Token.new(Token::MULOP,@c)
			nextCh()
		elsif @c == "/"
			tok = Token.new(Token::DIVOP,@c)
			nextCh()
		elsif @c == "("
			tok = Token.new(Token::LPAREN,@c)
			nextCh()
		elsif @c == ")"
			tok = Token.new(Token::RPAREN,@c)
			nextCh()
		elsif (whitespace?(@c))
			str = ""
		
			while whitespace?(@c) && @c != "eof"
				str += @c
				nextCh()
			end

			tok = Token.new(Token::WS,str)
		elsif (letter?(@c))
			str = ""
			
			while letter?(@c) && @c != "eof"
				str += @c
				nextCh()
			end

			if str == "print" # function
				tok = Token.new(Token::PRINT,str)
			elsif str.length == 1 # variable
				tok = Token.new(Token::ALPHA,str)
			else # unknown
				puts ("unknown:" + @c)
				tok = Token.new(Token::UNKWN,str)
			end
		elsif (numeric?(@c))
			str = ""
			
			while numeric?(@c) && @c != "eof"
				str += @c
				nextCh()
			end

			tok = Token.new(Token::DIGIT,str)
		else
			tok = Token.new(Token::UNKWN,@c)
			nextCh()
		end

		return tok
	end
end
#
# Helper methods for Scanner
#
def letter?(lookAhead)
	lookAhead =~ /^[a-z]|[A-Z]$/
end

def numeric?(lookAhead)
	lookAhead =~ /^(\d)+$/
end

def whitespace?(lookAhead)
	lookAhead =~ /^(\s)+$/
end