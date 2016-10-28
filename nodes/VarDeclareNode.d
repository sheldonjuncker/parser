module parser.nodes.VarDeclareNode;
import parser.nodes.node;
import lexer.token;
import std.stdio;

class VarDeclareNode : Node
{
	///Name of variable
	string name;

	this(TokenLocation location, string name)
	{
		this.location = location;
		this.name = name;
	}

	override void print(int tabs=0)
	{
		write("var " ~ name);
	}	
}