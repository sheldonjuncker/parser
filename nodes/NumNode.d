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

	override void print(int tabs=0)
	{
		write(num);
	}

	override bool isStatic()
	{
		//We know the value of a number at compile time
		return true;
	}
}
