module parser.nodes.IdentNode;
import parser.nodes.node;
import lexer.token;
import std.stdio;

class IdentNode : Node
{
	string ident;
	this(TokenLocation location, string ident)
	{
		this.location = location;
		this.ident = ident;
	}

	override void print(int tabs=0)
	{
		write(ident);
	}	

	override bool isLvalue()
	{
		return true;
	}
}