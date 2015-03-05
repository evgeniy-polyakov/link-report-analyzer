package com.epolyakov.linkreportanalyzer.ui.controls.grid
{
	import com.epolyakov.linkreportanalyzer.data.Definition;

	import flash.events.MouseEvent;
	import flash.geom.Point;

	import mx.core.IToolTip;
	import mx.managers.ToolTipManager;

	[Style(name="totalSizeColor", type="uint", format="Color")]
	[Style(name="packageSizeColor", type="uint", format="Color")]
	/**
	 * @author epolyakov
	 */
	public class ProgressGridItemRenderer extends NumberGridItemRenderer
	{
		private var _toolTop:IToolTip;

		public function ProgressGridItemRenderer()
		{
			addEventListener(MouseEvent.ROLL_OVER, rollOverHandler);
			addEventListener(MouseEvent.ROLL_OUT, rollOutHandler);
		}

		override public function validateNow():void
		{
			super.validateNow();

			if (!parent)
			{
				return;
			}

			graphics.clear();
			if (data && column)
			{
				graphics.beginFill(0, 0);
				graphics.drawRect(0, 0, width, height);
				graphics.endFill();

				var color:uint;
				var relative:Number;
				var w:Number;

				relative = data[column.dataField + "Relative"];
				if (relative > 0.01)
				{
					color = getStyle("totalSizeColor");
					w = relative * width;
					graphics.beginFill(color);
					graphics.drawRect(0, 0, w, height / 2);
					graphics.endFill();
				}

				relative = data[column.dataField + "RelativePackage"];
				if (relative > 0.01)
				{
					color = getStyle("packageSizeColor");
					w = relative * width;
					graphics.beginFill(color);
					graphics.drawRect(0, height / 2, w, height / 2);
					graphics.endFill();
				}
			}
		}

		private function rollOverHandler(event:MouseEvent):void
		{
			destroyToolTip();
			createToolTip();
		}

		private function rollOutHandler(event:MouseEvent):void
		{
			destroyToolTip();
		}

		private function createToolTip():void
		{
			if (data && column && !Definition(data.definition).isExternal)
			{
				var text:String = "";
				var relative:Number;

				relative = data[column.dataField + "Relative"];
				relative *= 100;

				text += relative.toFixed(2) + "% in application\n";

				relative = data[column.dataField + "RelativePackage"];
				relative *= 100;

				text += relative.toFixed(2) + "% in package";

				var p:Point = new Point(width, 0);
				p = localToGlobal(p);
				_toolTop = ToolTipManager.createToolTip(text, p.x, p.y, null, this);
			}
		}

		private function destroyToolTip():void
		{
			if (_toolTop)
			{
				ToolTipManager.destroyToolTip(_toolTop);
				_toolTop = null;
			}
		}
	}
}