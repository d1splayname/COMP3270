#
#  Parser Class
#
load "TinyLexer.rb"
load "TinyToken.rb"
load "AST.rb"

class Parser < Lexer

    def initialize(filename)
        super(filename)
        consume()
    end

    def consume()
        @lookahead = nextToken()
        while(@lookahead.type == Token::WS)
            @lookahead = nextToken()
        end
    end

    def match(dtype)
        if (@lookahead.type != dtype)
            puts "Expected #{dtype} found #{@lookahead.text}"
			@errors_found+=1
        end
        consume()
    end

    def program()
        @errors_found = 0

        # make issues
        p = AST.new(Token.new("program","program"))
        
        while( @lookahead.type != Token::EOF)
            p.addChild(statement())
        end
        
        puts "There were #{@errors_found} parse errors found."
        
        # resolve above issues


        return p
    end

    def statement()
		stmt = AST.new(Token.new("statement","statement"))
        if (@lookahead.type == Token::PRINT)
			stmt = AST.new(@lookahead)
            match(Token::PRINT)
            stmt.addChild(exp())
        else
            stmt = assign()
        end
		return stmt
    end

    def exp()
        exp = AST.new(Token.new("exp","exp"))
        
        term = term()
        etail = etail()

        if etail == nil
            return term
        else
            etail.addChild(term)
            return etail
        end
    end            

    def term()
        term = AST.new(Token.new("term", "term"))
        
        factor = factor()
        ttail = ttail()
        
        if ttail == nil
            return factor
        else
            ttail.addChild(factor)
            return ttail
        end
    end

    def factor()
        factor = AST.new(Token.new("factor","factor"))

        if (@lookahead.type == Token::LPAREN)
            # puts("left paren")
            match(Token::LPAREN)
            factor = exp()
            if (@lookahead.type == Token::RPAREN)
                match(Token::RPAREN)
            else
				match(Token::RPAREN)
            end
        elsif (@lookahead.type == Token::INT)
            # puts("int")
            factor = AST.new(Token.new("int", @lookahead.text))
            match(Token::INT)
        elsif (@lookahead.type == Token::ID)
            # puts("id")
            factor = AST.new(Token.new("id", @lookahead.text))
            match(Token::ID)
        else
            puts "Expected ( or INT or ID found #{@lookahead.text}"
            @errors_found+=1
            consume()
        end

		return factor
    end

    def ttail()
        ttail = AST.new(@lookahead)

        if (@lookahead.type == Token::MULTOP)
            match(Token::MULTOP)
        elsif (@lookahead.type == Token::DIVOP)
            match(Token::DIVOP)
		else
			return nil
        end

        ttail.addChild(factor())
        ttail.addChild(ttail())

        return ttail
    end

    def etail()
        etail = AST.new(@lookahead)

        if (@lookahead.type == Token::ADDOP)
            match(Token::ADDOP)
        elsif (@lookahead.type == Token::SUBOP)
            match(Token::SUBOP)
		else
			return nil
        end

        etail.addChild(term())
        etail.addChild(etail())

        return etail
    end

    def assign()
        assign = AST.new(Token.new("assignment","assignment"))
		if (@lookahead.type == Token::ID)
			idtoken = AST.new(@lookahead)
			match(Token::ID)
			if (@lookahead.type == Token::ASSGN)
				assign = AST.new(@lookahead)
				assign.addChild(idtoken)
            	match(Token::ASSGN)
				assign.addChild(exp())
        	else
				match(Token::ASSGN)
			end
		else
			match(Token::ID)
        end
		return assign
	end
end