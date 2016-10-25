import std.stdio;
import parse.parser;
import parse.node;

int main(string[] argv)
{
	Parser p = new Parser("code.txt");
	p.lex();
	p.parse();
	return 0;
}