module parser.nodes.BinaryNode;
import parser.nodes.node;
import lexer.token;
import std.stdio;

class BinaryNode : Node
{
	Node left;
	Node right;

	this(TokenLocation location, Node left, Node right)
	{
		this.location = location;
		this.left = left;
		this.right = right;
	}

	override void analyzeVariables(Environment e)
	{
		left.analyzeVariables(e);
		right.analyzeVariables(e);
	}

	override bool isStatic()
	{
		//Only static if left-hand and right-hand sides are static
		return left.isStatic() && right.isStatic();
	}
}