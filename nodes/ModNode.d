module parser.nodes.ModNode;
import parser.nodes.node;
import parser.nodes.BinaryNode;
import lexer.token;
import std.stdio;

class ModNode : BinaryNode
{
	this(TokenLocation location, Node left, Node right)
	{
		super(location, left, right);
	}

	override void print(int tabs=0)
	{
		write("(");
		left.print(tabs);
		write(" % ");
		right.print(tabs);
		write(")");
	}	
}