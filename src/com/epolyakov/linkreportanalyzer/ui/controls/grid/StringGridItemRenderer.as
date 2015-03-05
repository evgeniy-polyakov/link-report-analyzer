package com.epolyakov.linkreportanalyzer.ui.controls.grid
{
	import spark.skins.spark.DefaultGridItemRenderer;

	[Style(name="externalItemColor", type="uint", format="Color")]
	[Style(name="compiledItemColor", type="uint", format="Color")]

	/**
	 * @author epolyakov
	 */
	public class StringGridItemRenderer extends DefaultGridItemRenderer
	{
		override public function set data(value:Object):void
		{
			super.data = value;
			if (value)
			{
				var color:uint;
				if (value.external)
				{
					color = getStyle("externalItemColor");
				}
				else
				{
					color = getStyle("compiledItemColor");
				}
				setStyle("color", color);
			}
		}
	}
}