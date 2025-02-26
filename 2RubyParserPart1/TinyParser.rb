load "TinyToken.rb"
load "TinyLexer.rb"

class Parser < Lexer
    def initialize(filename)
        super(filename)
        consume()
    end
    
    def consume()
        @lookahead = nextToken()
        while @lookahead.type == Token::WS
            @lookahead = nextToken()
        end
    end

	def match(dtype)
		if (@lookahead.type != dtype)
		   puts "Expected #{dtype} found #{@lookahead.text}"
		   @parseErrors += 1
	  else
		  if (dtype == Token::ID)
			  dtype = "ID"
		  elsif (dtype == Token::INT)
			  dtype = "INT"
		  elsif (dtype == Token::ADDOP)
			  dtype = "ADDOP"
		  elsif (dtype == Token::SUBOP)
			  dtype = "SUBOP"
		  elsif (dtype == Token::MULTOP)
			  dtype = "MULTOP"
		  elsif (dtype == Token::DIVOP)
			  dtype = "DIVOP"
		  elsif (dtype == Token::LPAREN)
			  dtype = "LPAREN"
		  elsif (dtype == Token::RPAREN)
			  dtype = "RPAREN"
		  elsif (dtype == Token::ASSGN)
			  dtype = "ASSGN"
		  elsif (dtype == Token::PRINT)
			  dtype = "PRINT"
		  end

		  puts "Found #{dtype} Token: #{@lookahead.text}"
		end
		consume()
	 end

    def program()
        @parseErrors = 0
		while( @lookahead.type != Token::EOF)
			statement()  
      	end

		puts "There were #{@parseErrors} parse errors found."
    end

    def statement()
        puts "Entering STMT Rule"
        case @lookahead.type
        when Token::PRINT
            match(Token::PRINT)
            exp()
        else
            assign()
        end
        puts "Exiting STMT Rule"
    end

    def assign()
        puts "Entering ASSGN Rule"
        match(Token::ID)
        match(Token::ASSGN)
        exp()
        puts "Exiting ASSGN Rule"
    end

    def factor()
        puts "Entering FACTOR Rule"
        if @lookahead.type == Token::LPAREN
            match(Token::LPAREN)
            exp()
            match(Token::RPAREN)
		elsif @lookahead.type == Token::ID
			match(Token::ID)
		elsif @lookahead.type == Token::INT
			match(Token::INT)
        else
            puts "Expected ( or INT or ID found #{@lookahead.text}"
            @parseErrors += 1
            consume()
        end
        puts "Exiting FACTOR Rule"
    end

    def exp()
        puts "Entering EXP Rule"
        term()
        etail()
        puts "Exiting EXP Rule"
    end

    def term()
        puts "Entering TERM Rule"
        factor()
        ttail()
        puts "Exiting TERM Rule"
    end

    def etail()
        puts "Entering ETAIL Rule"
        if [Token::ADDOP, Token::SUBOP].include?(@lookahead.type)
            match(@lookahead.type)
            term()
            etail()
        else
            puts "Did not find ADDOP or SUBOP Token, choosing EPSILON production"
        end
        puts "Exiting ETAIL Rule"
    end

    def ttail()
        puts "Entering TTAIL Rule"
        if @lookahead.type == Token::MULTOP || @lookahead.type == Token::DIVOP
            match(@lookahead.type)
            factor()
            ttail()
        else
            puts "Did not find MULTOP or DIVOP Token, choosing EPSILON production"
        end
        puts "Exiting TTAIL Rule"
    end
end