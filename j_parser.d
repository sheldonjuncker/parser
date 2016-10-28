module parser.j_parser;
import lexer.j_lexer;
import lexer.token;
import parser.all_nodes;
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
		message = "Unexpected " ~ found.lexeme ~  " " ~ where ~ " on " ~  found.location.toString() ~ ": expected " ~ expected;
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
	///The resulting AST
	Node ast;

	///The lexer object
	Lexer lexer;

	///The current token's index
	int tokenIndex;

	///The last error found while parsing
	ParseError error;

	///An array of function pointers for precedence
	Node delegate()[] prec;

	/**
	* Advances to the next token.
	*/
	void next()
	{
		if(tokenIndex < (lexer.tokens.length-1))
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
		if(newLoc.line > oldLoc. line || (newLoc.line == oldLoc.line && newLoc.column >= oldLoc.column))
			this.error = error;
	}

	/**
	* Gets the precedence level of a function.
	* @param func The Node delegate() to get precedence of.
	*/
	int getPrecedence(Node delegate() func)
	{
		for(int i=0; i<prec.length; i++)
		{
			if(prec[i] == func)
				return i;
		}
		return -1;
	}

	/**
	* Determines if a parse was successful.
	*/
	bool parseSuccess()
	{
		/*
		* Conditions:
		*	Lex was successful
		*	All tokens were eaten
		*/
		return (lexer.lexSuccess() && token().type == TokenType.Eof);
	}

	/**
	* The starting point for parsing the program.
	* program
	*	:	statements
	*/
	Node[] program()
	{
		//A program is 0 or more statements
		return statements();
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
	*	:	var ID ;
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
		
		//Var declaration
		else if((node = varDeclareStatement()) !is null)
		{
			try
			{
				if(!match(TokenType.Semi))
				{
					throw new ParseException(new ParseError("after variable declaration", token(), ";"));
				}
				return node;
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

		//Expression
		else if((node = expr()) !is null)
		{
			try
			{
				if(!match(TokenType.Semi))
				{
					throw new ParseException(new ParseError("after expression", token(), ";"));
				}
				return node;
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
			//Get location of start of block
			TokenLocation location = token().location;

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
			return new BlockNode(location, stmts);
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
		string where = "in if statement";

		try
		{
			//Get location of if
			TokenLocation location = token().location;

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
			return new IfNode(location, cond, stmt);
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
		string where = "in while statement";

		try
		{
			//Get location of while
			TokenLocation location = token().location;

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
			return new WhileNode(location, cond, stmt);
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
	* Parses a variable declaration.
	* var_declare
	* 	:	var ID
	*/
	Node varDeclareStatement()
	{
		//Save location state
		int save = tokenIndex;

		//The location to use for error reporting
		string where = "in variable declaration";

		try
		{
			//Get location of while
			TokenLocation location = token().location;

			//Match var
			if(!match(TokenType.Var))
			{
				throw new ParseException(new ParseError(where, token(), "var"));
			}

			Token id = token();

			//Match ID
			if(!match(TokenType.Ident))
			{
				throw new ParseException(new ParseError(where, token(), "identifier"));
			}

			//All good!
			return new VarDeclareNode(location, id.lexeme);
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
	* Guaranteed to be the highest level construct.
	*/
	Node expr()
	{
		//Call lowest level precedence
		return prec[0]();
	}

	/**
	* Parses assignment operations.
	* expr	:	prec2 = expr()
	*/
	Node assignment()
	{
		int precLevel = getPrecedence(&assignment);

		//Save location state
		int save = tokenIndex;

		//The location to use for error reporting
		string where = "in expression";

		try
		{
			//Get location of assignment
			TokenLocation location = token().location;

			//Get left hand side
			Node left = prec[precLevel + 1]();

			if(left is null)
			{
				throw new ParseException(new ParseError(where, token(), "left hand side of expression"));
			}

			//Check for =
			if(accept(TokenType.Assign))
			{
				//Eat token
				next();

				//Read right hand side of expression
				Node right = expr();
				if(right is null)
				{
					throw new ParseException(new ParseError(where, token(), "right hand side of expression"));
				}

				return new AssignNode(location, left, right);
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
	* Parses logical operators.
	* expr	:	comparison {AND,OR,XOR comparison}*
	*/
	Node logical()
	{
		//Expression's precedence level
		int precLevel = getPrecedence(&logical);

		//Save location state
		int save = tokenIndex;

		//The location to use for error reporting
		string where = "in expression";

		try
		{
			//Get location of logical expression
			TokenLocation location = token().location;

			//Get left hand side
			Node left = prec[precLevel + 1]();

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
				Node right = prec[precLevel + 1]();
				if(right is null)
				{
					throw new ParseException(new ParseError(where, token(), "right hand side of expression"));
				}

				//Build expression
				if(op.type == TokenType.And)
					left =  new AndNode(location, left, right);

				else if(op.type == TokenType.Or)
					left = new OrNode(location, left, right);

				else
					left = new XorNode(location, left, right);
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
	* expr	:	prec3 {cop prec3}*
	*/
	Node comparison()
	{
		int precLevel = getPrecedence(&comparison);

		//Save location state
		int save = tokenIndex;

		//The location to use for error reporting
		string where = "in expression";

		try
		{
			//Get location of logical expression
			TokenLocation location = token().location;

			//Get left hand side
			Node left = prec[precLevel + 1]();

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
				Node right = prec[precLevel + 1]();
				if(right is null)
				{
					throw new ParseException(new ParseError(where, token(), "right hand side of expression"));
				}

				//Build expression
				if(op.type == TokenType.Equals)
					left = new EqualsNode(location, left, right);

				else if(op.type == TokenType.Gt)
					left = new GtNode(location, left, right);

				else if(op.type == TokenType.Gte)
					left = new GteNode(location, left, right);

				else if(op.type == TokenType.Lt)
					left = new LtNode(location, left, right);

				else
					left = new LteNode(location, left, right);
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
	* expr	:	prec4 {+,- prec4}*
	*/
	Node mathLower()
	{
		int precLevel = getPrecedence(&mathLower);

		//Save location state
		int save = tokenIndex;

		//The location to use for error reporting
		string where = "in expression";

		try
		{
			//Get location of logical expression
			TokenLocation location = token().location;

			//Get left hand side
			Node left = prec[precLevel + 1]();

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
				Node right = prec[precLevel + 1]();
				if(right is null)
				{
					throw new ParseException(new ParseError(where, token(), "right hand side of expression"));
				}

				//Build expression
				if(op.type == TokenType.Plus)
					left = new AddNode(location, left, right);

				else
					left = new SubNode(location, left, right);
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
	* expr	:	prec4 {*,/,% prec4}*
	*/
	Node mathUpper()
	{
		int precLevel = getPrecedence(&mathUpper);

		//Save location state
		int save = tokenIndex;

		//The location to use for error reporting
		string where = "in expression";

		try
		{
			//Get location of logical expression
			TokenLocation location = token().location;

			//Get left hand side
			Node left = prec[precLevel + 1]();

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
				Node right = prec[precLevel + 1]();
				if(right is null)
				{
					throw new ParseException(new ParseError(where, token(), "right hand side of expression"));
				}

				//Build expression
				if(op.type == TokenType.Star)
					left = new MulNode(location, left, right);
				else if(op.type == TokenType.Slash)
					left = new DivNode(location, left, right);
				else
					left = new ModNode(location, left, right);
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
	* Parses logical not expression.
	* expr	:	! factor
	*/
	Node logicalNot()
	{
		int precLevel = getPrecedence(&logicalNot);

		//Save location state
		int save = tokenIndex;

		//The location to use for error reporting
		string where = "in expression";

		try
		{
			//Get location of logical expression
			TokenLocation location = token().location;

			//Match !
			if(match(TokenType.Not))
			{
				Node right = prec[precLevel + 1]();

				if(right is null)
				{
					throw new ParseException(new ParseError(where, token(), "expression after !"));
				}

				else
				{
					return new NotNode(location, right);
				}
			}

			//No !
			else
			{
				return prec[precLevel + 1]();
			}
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
	* expr	:	ID | NUM | STR | ( expr )
	*/
	Node factor()
	{
		int precLevel = getPrecedence(&factor);
		
		//Save location state
		int save = tokenIndex;

		//The location to use for error reporting
		string where = "in expression";
		
		try
		{
			//Get location of logical expression
			TokenLocation location = token().location;

			//Test for an identifier
			if(accept(TokenType.Ident))
			{
				Token id = token();
				next();
				return new IdentNode(location, id.lexeme);
			}

			//Test for a number
			else if(accept(TokenType.Double))
			{
				Token num = token();
				next();
				return new NumNode(location, num.lexeme);
			}

			//Test for a parenthesized expression
			else if(match(TokenType.Lprn))
			{
				//Get an expression
				Node exp = expr();

				if(exp is null)
				{
					throw new ParseException(new ParseError(where, token(), "expression after ("));
				}

				//Match the closing parenthesis
				if(!match(TokenType.Rprn))
				{
					throw new ParseException(new ParseError(where, token(), "expected )"));
				}

				return exp;
			}
			
			//No expression
			throw new ParseException(new ParseError(where, token(), "expected an expression"));
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
		//Location of first token
		TokenLocation location = token().location;

		//Generate AST
		ast = new BlockNode(location, program());

		//Report errors if any
		if(error !is null && token().type != TokenType.Eof)
		{
			throw new ParseException(error);
		}
	}

	/**
	* Constructor.
	* @param filename The file to open with the lexer.
	*/
	this(string filename)
	{
		//Setup precedence levels
		prec = [
			&this.assignment,
			&this.logical,
			&this.comparison,
			&this.mathLower,
			&this.mathUpper,
			&this.logicalNot,
			&this.factor
		];

		//Construct the Lexer
		lexer = new Lexer(filename);
	}
}