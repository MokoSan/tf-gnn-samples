private readonly object _syncRoot = new object();
private bool _isDisposed = false;

public override IsDisposed
{
    get 
    {
	lock ( #1 )
        {
		return #2
	}	
    }
}
