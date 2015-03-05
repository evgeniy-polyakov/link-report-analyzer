/**
 Copyright 2014 Evgeniy Polyakov

 Licensed under the Apache License, Version 2.0 (the "License");
 you may not use this file except in compliance with the License.
 You may obtain a copy of the License at

 http://www.apache.org/licenses/LICENSE-2.0

 Unless required by applicable law or agreed to in writing, software
 distributed under the License is distributed on an "AS IS" BASIS,
 WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 See the License for the specific language governing permissions and
 limitations under the License.
 */
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