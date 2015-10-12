package collision;

@:generic
class Proxy<T> extends T implements IProxy
{
	private var _proxy:Dynamic;
	
	public function setProxy(proxy:Dynamic):Void
	{
		_proxy = proxy;
	}
	
	public function getProxy():Dynamic
	{
		return _proxy;
	}
}