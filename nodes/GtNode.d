module parser.nodes.GtNode;
import parser.nodes.node;
import parser.nodes.BinaryNode;
import lexer.token;
import std.stdio;

class GtNode : BinaryNode
{
	this(TokenLocation location, Node left, Node right)
	{
		super(location, left, right);
	}
	
	override void print()
	{
		write("( ");
		left.print();
		write(" > ");
		right.print();
		write(" )");
	}
}