#
#  Class Token - Encapsulates the tokens in TINY
#
#   @type - the type of token (Category)
#   @text - the text the token represents (Lexeme)
#
class Token
	attr_accessor :type
	attr_accessor :text

# This is the only part of this class that you need to 
# modify.
	EOF = "eof"
	LPAREN = "("
	RPAREN = ")"
	ADDOP  = "+"
	SUBDOP  = "-"
	MULOP  = "*"
	DIVOP  = "/"
	WS = "whitespace"
	UNKWN = "unknown"
	ASSIGN = "="
	ALPHA = "id"
	DIGIT = "int"
	PRINT = "print"
	IF = "if"
	THEN = "then"
	WHILE = "while"
	LESS = "<"
	GREATER = ">"
	AND = "&"

# add the rest of the tokens needed based on the grammar
# specified in the Scanner class "TinyScanner.rb"

#constructor
	def initialize(type,text)
		@type = type
		@text = text
	end
	
	def get_type
		return @type
	end
	
	def get_text
		return @text
	end
	
# to string method
	def to_s
		return "#{@type} #{@text}"
	end
end