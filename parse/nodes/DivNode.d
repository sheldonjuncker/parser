module parse.nodes.DivNode;
import parse.nodes.node;
import parse.nodes.BinaryNode;

class DivNode : BinaryNode
{
	this(TokenLocation location, Node left, Node right)
	{
		super(location, left, right);
	}

	override void print()
	{
		write("( ");
		left.print();
		write(" / ");
		right.print();
		write(" )");
	}	
}