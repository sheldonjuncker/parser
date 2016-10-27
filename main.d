module parser.main;
import std.stdio;
import parser.j_parser;
import parser.nodes.node;

int main(string[] argv)
{
	//Initialize the parser
	Parser p = new Parser("code.txt");

	//Lex the input
	p.lex();

	//Parse the tokens
	p.parse();

	//Get the AST
	Node ast = p.ast;

	//Print out AST (~works)
	ast.print();
	
	return 0;
}