module parse.nodes.XorNode;
import parse.nodes.node;
import parse.nodes.BinaryNode;

class XorNode : BinaryNode
{
	this(Node left, Node right)
	{
		super(left, right);
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