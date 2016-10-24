module parse.parser;
import parse.node;
import lex.lexer;
import lex.token;
import std.stdio;

class Parser
{
	///The lexer object
	Lexer lexer;

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