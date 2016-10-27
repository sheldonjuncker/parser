module parse.nodes.BlockNode;
import parse.nodes.node;

class BlockNode : Node
{
	Node[] stmts;

	this(TokenLocation location, Node[] stmts)
	{
		this.location = location;
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