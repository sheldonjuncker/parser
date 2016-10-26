module parse.nodes.IdentNode;
import parse.nodes.node;

class IdentNode : Node
{
	string ident;
	this(string ident)
	{
		this.ident = ident;
	}

	override void print()
	{
		write(ident);
	}	
}