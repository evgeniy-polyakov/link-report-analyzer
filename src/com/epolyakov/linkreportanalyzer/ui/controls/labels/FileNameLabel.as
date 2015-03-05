package com.epolyakov.linkreportanalyzer.ui.controls.labels
{
	import mx.controls.Label;

	/**
	 * @author epolyakov
	 */
	public class FileNameLabel extends Label
	{
		private static var _defaultText:String = "";

		private var _text:String = "";

		public function FileNameLabel()
		{
			text = "";
		}

		override public function get text():String
		{
			return _text;
		}

		override public function set text(value:String):void
		{
			_text = value;
			if (value)
			{
				setStyle("fontStyle", "none");
				super.text = value;
			}
			else
			{
				setStyle("fontStyle", "italic");
				super.text = _defaultText;
			}
		}
	}
}