module parse.node;

/**
* Represents a node of the AST.
*/
class Node
{
	
}

class BlockNode : Node
{
	Node[] stmts;

	this(Node[] stmts)
	{
		this.stmts = stmts;
	}
}

class IfNode : Node
{
	Node cond;
	Node stmt;

	this(Node cond, Node stmt)
	{
		this.cond = cond;
		this.stmt = stmt;
	}
}