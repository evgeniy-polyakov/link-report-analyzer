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