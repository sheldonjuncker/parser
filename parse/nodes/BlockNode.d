module parse.nodes.BlockNode;
import parse.nodes.node;

class BlockNode : Node
{
	Node[] stmts;

	this(Node[] stmts)
	{
		this.stmts = stmts;
	}

	override void print()
	{
		writeln("{");
		foreach(Node node; stmts)
		{
			//Won't work for nested blocks.
			write("\t");
			node.print();
			write("\n");
		}
		writeln("}");
	}
}