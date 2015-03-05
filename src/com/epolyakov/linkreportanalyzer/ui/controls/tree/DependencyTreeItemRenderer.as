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
package com.epolyakov.linkreportanalyzer.ui.controls.tree
{
	import com.epolyakov.linkreportanalyzer.ui.controls.filters.ITextFilter;

	import flash.geom.Rectangle;

	import mx.controls.treeClasses.TreeItemRenderer;

	[Style(name="externalItemColor", type="uint", format="Color")]
	[Style(name="compiledItemColor", type="uint", format="Color")]
	[Style(name="filterSelectionColor", type="uint", format="Color")]

	/**
	 * @author epolyakov
	 */
	public class DependencyTreeItemRenderer extends TreeItemRenderer
	{
		public var filter:ITextFilter;

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

		override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
		{
			super.updateDisplayList(unscaledWidth, unscaledHeight);

			if (disclosureIcon)
			{
				disclosureIcon.visible = true;
			}

			graphics.clear();

			if (data && filter && label)
			{
				const subString:String = filter.textFilter;
				if (subString)
				{
					const index:int = listData.label.indexOf(subString);
					if (index >= 0)
					{
						const startCharRect:Rectangle = label.getCharBoundaries(index);
						const endCharRect:Rectangle = label.getCharBoundaries(index + subString.length - 1);
						if (startCharRect && endCharRect)
						{
							const r:Rectangle = startCharRect.union(endCharRect);
							r.x += label.x;
							r.y += label.y;
							r.top = label.y;

							graphics.beginFill(getStyle("filterSelectionColor"));
							graphics.drawRect(r.x, r.y, r.width, r.height);
							graphics.endFill();
						}
					}
				}
			}
		}
	}
}