module parse.nodes.ModNode;
import parse.nodes.node;
import parse.nodes.BinaryNode;

class ModNode : BinaryNode
{
	this(Node left, Node right)
	{
		super(left, right);
	}

	override void print()
	{
		write("( ");
		left.print();
		write(" % ");
		right.print();
		write(" )");
	}	
}