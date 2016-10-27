module parse.nodes.XorNode;
import parse.nodes.node;
import parse.nodes.BinaryNode;

class XorNode : BinaryNode
{
	this(TokenLocation location, Node left, Node right)
	{
		super(location, left, right);
	}

	override void print()
	{
		write("( ");
		left.print();
		write(" ^^ ");
		right.print();
		write(" )");
	}	
}