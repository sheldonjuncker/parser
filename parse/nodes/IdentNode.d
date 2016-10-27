module parse.nodes.IdentNode;
import parse.nodes.node;

class IdentNode : Node
{
	string ident;
	this(TokenLocation location, string ident)
	{
		this.location = location;
		this.ident = ident;
	}

	override void print()
	{
		write(ident);
	}	
}