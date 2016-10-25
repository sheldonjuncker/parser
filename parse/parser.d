module parse.parser;
import parse.node;
import lex.lexer;
import lex.token;
import std.stdio;

class ParseError
{
	///The location of the error (in expression, if statement, etc.)
	string where;

	///The token that was found.
	Token found;

	///A string representing what was expected.
	string expected; 
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
	* Lexes the input into tokens.
	*/
	void lex()
	{
		lexer.lex();
	}

	/**
	* Parses the input and builds AST
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