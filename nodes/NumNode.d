module parser.nodes.NumNode;
import parser.nodes.node;
import lexer.token;
import std.stdio;
import std.conv : to;

class NumNode : Node
{
	double num;
	this(TokenLocation location, string num)
	{
		this.location = location;
		this.num = to!double(num); 
	}	

	override void print()
	{
		write(num);
	}
}
