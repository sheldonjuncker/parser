module parser.nodes.NotNode;
import parser.nodes.node;
import lexer.token;
import std.stdio;

class NotNode : Node
{
	Node right;
	this(TokenLocation location, Node right)
	{
		this.location = location;
		this.right = right;
	}	

	override void print()
	{
		write("( ");
		write("! ");
		right.print();
		write(" )");
	}
}