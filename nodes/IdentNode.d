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

	override void print()
	{
		write(ident);
	}	
}