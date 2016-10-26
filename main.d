import std.stdio;
import parse.parser;
import parse.node;

int main(string[] argv)
{
	//Initialize the parser
	Parser p = new Parser("code.txt");

	//Lex the input
	p.lex();

	//Parse the tokens
	p.parse();

	//Get the AST
	Node[] ast = p.ast;

	//Print out AST (~works)
	foreach(Node node; ast)
	{
		node.print();
	}


	return 0;
}