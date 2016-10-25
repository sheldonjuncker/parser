module parse.parser;
import parse.node;
import lex.lexer;
import lex.token;
import std.stdio;
import std.exception;

/**
* This class represents a parse error.
* It stores the type error, the expected token, and what was found instead.
*/
class ParseError
{
	///The location of the error (in expression, if statement, etc.)
	string where;

	///The token that was found.
	Token found;

	///A string representing what was expected.
	string expected; 

	/**
	* Convert to string for use in error reporting.
	*/
	override string toString()
	{
		string message;
		message = "Unexpected " ~ found.lexeme ~ " in " ~ where ~ " expected " ~ expected;
		return message;
	}

	/**
	* Constructor with initialization list.
	* @param where The location of the error
	* @param found The invalid token
	* @param expected The thing expected
	*/
	this(string where, Token found, string expected)
	{
		this.where = where;
		this.found = found;
		this.expected = expected;
	}
}

class ParseException : Exception
{
	ParseError error;

	this(ParseError error)
	{
		super(error.toString());
		this.error = error;
	}
}

class Parser
{
	///The lexer object
	Lexer lexer;

	///The current token's index
	int tokenIndex;

	///The last error found while parsing
	ParseError error;

	/**
	* Advances to the next token.
	*/
	void next()
	{
		if(tokenIndex < lexer.tokens.length)
			tokenIndex++;
	}

	/**
	* Gets the current token.
	*/
	Token token()
	{
		return lexer.tokens[tokenIndex];
	}

	/**
	* Matches a token type and advances if the match is successful.
	* @param type The token type to match against.
	*/
	bool match(TokenType type)
	{
		if(token().type == type)
		{
			next();
			return true;
		}

		else
		{
			return false;
		}
	}

	/**
	* Determines if the current token can be matched.
	* @param type The token type to test.
	*/
	bool accept(TokenType type)
	{
		return token().type == type;
	}

	/**
	* Logs an error.
	* @param error The error object to log.
	* @note The error is only logged if it occurs further
	* in the input than the last error.
	*/
	void logError(ParseError error)
	{
		//If we haven't seen an error yet, record it
		if(this.error is null)
			this.error = error;
		
		//Get error location info
		TokenLocation oldLoc = this.error.found.location;
		TokenLocation newLoc = error.found.location;

		//Only replace previous error if the new one is found further
		//in the stream of tokens.
		if(newLoc.line > oldLoc. line || (newLoc.line == oldLoc.line && newLoc.column > oldLoc.column))
			this.error = error;
	}

	/**
	* The starting point for parsing the program.
	* program
	*	:	statements
	*/
	Node[] program()
	{
		Node[] ast = statements();

		//Report the error.
		if(error !is null)
		{
			writeln(error.toString());
		}

		return ast;
	}

	/**
	* Parses statements.
	* statements
	*	:	statement *
	*/
	Node[] statements()
	{
		//The statements found
		Node[] stmts;

		//Find 0 or more statements
		Node stmt;
		while((stmt = statement()) !is null)
		{
			stmts ~= stmt;
		}

		return stmts;
	}

	/**
	* Parses a statement.
	* statement
	* 	:	block
	*	:	if
	*	:	else
	*	:	expr ;
	*/
	Node statement()
	{
		//Save location state
		int save = tokenIndex;
		Node node;

		//Block
		if((node = block()) !is null)
			return node;
		//If
		else if((node = ifStatement()) !is null)
			return node;
		//While
		else if((node = whileStatement()) !is null)
			return node;
		//Expression
		else if((node = expr()) !is null)
			return node;
		//Error
		else
		{
			//Restore  location
			tokenIndex = save;
			return null;
		}
	}

	/**
	* Parses a block statement.
	* block
	* 	:	{ statements }
	*/
	Node block()
	{
		//Save location state
		int save = tokenIndex;

		try
		{
			//Match a '{'
			if(!match(TokenType.Lbrc))
			{
				throw new ParseException(new ParseError("block", token(), "{"));
			}

			//Match 0 or more statements
			Node[] stmts = statements();

			//Match a '}'
			if(!match(TokenType.Rbrc))
			{
				throw new ParseException(new ParseError("block", token(), "}"));
			}

			//All good!
			return new BlockNode(stmts);
		}

		catch(ParseException error)
		{
			//Log error
			logError(error.error);

			//Restore location
			tokenIndex = save;
			return null;
		}
	}

	/**
	* Parses an if statement.
	* if
	* 	:	IF ( expr ) statement
	*/
	Node ifStatement()
	{
		//Save location state
		int save = tokenIndex;

		//The location to use for error reporting
		string where = "if statement";

		try
		{
			//Match if
			if(!match(TokenType.If))
			{
				throw new ParseException(new ParseError(where, token(), "if"));
			}

			//Match (
			if(!match(TokenType.Lprn))
			{
				throw new ParseException(new ParseError(where, token(), "("));
			}

			//Look for condition expression
			Node cond = expr();
			if(cond is null)
			{
				throw new ParseException(new ParseError(where, token(), "conditional expression"));
			}

			//Match )
			if(!match(TokenType.Rprn))
			{
				throw new ParseException(new ParseError(where, token(), ")"));
			}

			//Look for statement
			Node stmt = statement();
			if(stmt is null)
			{
				throw new ParseException(new ParseError(where, token(), "a statement"));
			}

			//All good!
			return new IfNode(cond, stmt);
		}

		catch(ParseException error)
		{
			//Log error
			logError(error.error);

			//Restore location
			tokenIndex = save;
			return null;
		}
	}

	/**
	* Parses an while statement.
	* while
	* 	:	WHILE ( expr ) statement
	*/
	Node whileStatement()
	{
		//Save location state
		int save = tokenIndex;

		//The location to use for error reporting
		string where = "while statement";

		try
		{
			//Match while
			if(!match(TokenType.While))
			{
				throw new ParseException(new ParseError(where, token(), "while"));
			}

			//Match (
			if(!match(TokenType.Lprn))
			{
				throw new ParseException(new ParseError(where, token(), "("));
			}

			//Look for condition expression
			Node cond = expr();
			if(cond is null)
			{
				throw new ParseException(new ParseError(where, token(), "conditional expression"));
			}

			//Match )
			if(!match(TokenType.Rprn))
			{
				throw new ParseException(new ParseError(where, token(), ")"));
			}

			//Look for statement
			Node stmt = statement();
			if(stmt is null)
			{
				throw new ParseException(new ParseError(where, token(), "a statement"));
			}

			//All good!
			return new WhileNode(cond, stmt);
		}

		catch(ParseException error)
		{
			//Log error
			logError(error.error);

			//Restore location
			tokenIndex = save;
			return null;
		}
	}

	/**
	* Parses an expression.
	* Parses logical-level expressions.
	* expr	:	prec1 {lop prec1}*
	*/
	Node expr()
	{
		//Save location state
		int save = tokenIndex;

		//The location to use for error reporting
		string where = "expression";

		try
		{
			//Get left hand side
			Node left = prec1();

			if(left is null)
			{
				throw new ParseException(new ParseError(where, token(), "left hand side of expression"));
			}

			//While we're looking at a &&, ||, or ^, keep going
			while(accept(TokenType.And) || accept(TokenType.Or) || accept(TokenType.Xor))
			{
				//Get the operator and eat token
				Token op = token();
				next();

				//Read right hand side of expression
				Node right = prec1();
				if(right is null)
				{
					throw new ParseException(new ParseError(where, token(), "right hand side of expression"));
				}

				//Build expression
				if(op.type == TokenType.And)
					return new AndNode(left, right);

				else if(op.type == TokenType.Or)
					return new OrNode(left, right);

				else
					return new XorNode(left, right);
			}

			//Only a left hand side
			return left;
		}

		catch(ParseException error)
		{
			//Log error
			logError(error.error);

			//Restore location
			tokenIndex = save;
			return null;
		}
	}

	/**
	* Parses comparison-level expressions.
	* expr	:	prec2 {cop prec2}*
	*/
	Node prec1()
	{
		//Save location state
		int save = tokenIndex;

		//The location to use for error reporting
		string where = "expression";

		try
		{
			//Get left hand side
			Node left = prec2();

			if(left is null)
			{
				throw new ParseException(new ParseError(where, token(), "left hand side of expression"));
			}

			//While we're looking at ==, >, <, >=, <= keep going
			while(accept(TokenType.Equals) || accept(TokenType.Gt) || accept(TokenType.Lt) || accept(TokenType.Gte) || accept(TokenType.Lte))
			{
				//Get the operator and eat token
				Token op = token();
				next();

				//Read right hand side of expression
				Node right = prec2();
				if(right is null)
				{
					throw new ParseException(new ParseError(where, token(), "right hand side of expression"));
				}

				//Build expression
				if(op.type == TokenType.Equals)
					return new EqualsNode(left, right);

				else if(op.type == TokenType.Gt)
					return new GtNode(left, right);

				else if(op.type == TokenType.Gte)
					return new GteNode(left, right);

				else if(op.type == TokenType.Lt)
					return new LtNode(left, right);

				else
					return new LteNode(left, right);
			}

			//Only a left hand side
			return left;
		}

		catch(ParseException error)
		{
			//Log error
			logError(error.error);

			//Restore location
			tokenIndex = save;
			return null;
		}
	}

	/**
	* Parses addition-level expressions.
	* expr	:	prec3 {aop prec3}*
	*/
	Node prec2()
	{
		//Save location state
		int save = tokenIndex;

		//The location to use for error reporting
		string where = "expression";

		try
		{
			//Get left hand side
			Node left = prec3();

			if(left is null)
			{
				throw new ParseException(new ParseError(where, token(), "left hand side of expression"));
			}

			//While we're looking at +, - keep going
			while(accept(TokenType.Plus) || accept(TokenType.Minus))
			{
				//Get the operator and eat token
				Token op = token();
				next();

				//Read right hand side of expression
				Node right = prec3();
				if(right is null)
				{
					throw new ParseException(new ParseError(where, token(), "right hand side of expression"));
				}

				//Build expression
				if(op.type == TokenType.Plus)
					return new AddNode(left, right);

				else
					return new SubNode(left, right);
			}

			//Only a left hand side
			return left;
		}

		catch(ParseException error)
		{
			//Log error
			logError(error.error);

			//Restore location
			tokenIndex = save;
			return null;
		}
	}

	/**
	* Parses multiplication-level expressions.
	* expr	:	prec4 {mop prec4}*
	*/
	Node prec3()
	{
		//Save location state
		int save = tokenIndex;

		//The location to use for error reporting
		string where = "expression";

		try
		{
			//Get left hand side
			Node left = prec4();

			if(left is null)
			{
				throw new ParseException(new ParseError(where, token(), "left hand side of expression"));
			}

			//While we're looking at *, /, % keep going
			while(accept(TokenType.Star) || accept(TokenType.Slash) || accept(TokenType.Percent))
			{
				//Get the operator and eat token
				Token op = token();
				next();

				//Read right hand side of expression
				Node right = prec4();
				if(right is null)
				{
					throw new ParseException(new ParseError(where, token(), "right hand side of expression"));
				}

				//Build expression
				if(op.type == TokenType.Star)
					return new MulNode(left, right);
				else if(op.type == TokenType.Slash)
					return new DivNode(left, right);
				else
					return new ModNode(left, right);
			}

			//Only a left hand side
			return left;
		}

		catch(ParseException error)
		{
			//Log error
			logError(error.error);

			//Restore location
			tokenIndex = save;
			return null;
		}
	}

	/**
	* Parses a factor.
	* expr	:	ID | NUM | ( expr )
	*/
	Node prec4()
	{
		return null;
	}

	/**
	* Lexes the input into tokens.
	*/
	void lex()
	{
		lexer.lex();
	}

	/**
	* Parses the lexed tokens and builds AST
	*/
	void parse()
	{

	}

	/**
	* Constructor.
	* @param filename The file to open with the lexer.
	*/
	this(string filename)
	{
		lexer = new Lexer(filename);
	}
}