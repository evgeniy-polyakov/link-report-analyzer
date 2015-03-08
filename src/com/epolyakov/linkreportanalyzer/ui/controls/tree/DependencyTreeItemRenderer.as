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

	import flash.display.DisplayObject;

	import flash.geom.Rectangle;

	import mx.controls.treeClasses.TreeItemRenderer;
	import mx.controls.treeClasses.TreeListData;

	[Style(name="externalItemColor", type="uint", format="Color")]
	[Style(name="compiledItemColor", type="uint", format="Color")]
	[Style(name="filterSelectionColor", type="uint", format="Color")]

	[Style(name="disclosureIconOpen", type="Class")]
	[Style(name="disclosureIconClose", type="Class")]
	[Style(name="disclosureIconLeaf", type="Class")]
	[Style(name="disclosureIconOpenLast", type="Class")]
	[Style(name="disclosureIconCloseLast", type="Class")]
	[Style(name="disclosureIconLeafLast", type="Class")]
	[Style(name="disclosureIconLine", type="Class")]

	/**
	 * @author epolyakov
	 */
	public class DependencyTreeItemRenderer extends TreeItemRenderer
	{
		public var filter:ITextFilter;

		private var _lines:Vector.<DisplayObject> = new <DisplayObject>[];

		override protected function commitProperties():void
		{
			for each(var line:DisplayObject in _lines)
			{
				removeChild(line);
			}
			_lines = new <DisplayObject>[];

			if (data)
			{
				var color:uint;
				if (data.external)
				{
					color = getStyle("externalItemColor");
				}
				else
				{
					color = getStyle("compiledItemColor");
				}
				setStyle("color", color);
				setStyle("textRollOverColor", color);
				setStyle("textSelectedColor", color);
			}
			if (listData is TreeListData && data)
			{
				if (data.parent == null)
				{
					TreeListData(listData).disclosureIcon = null;
				}
				else
				{
					var disclosureIconStyle:String = "disclosureIcon";
					if (data.children == null)
					{
						disclosureIconStyle += "Leaf";
					}
					else if (TreeListData(listData).open)
					{
						disclosureIconStyle += "Open";
					} else
					{
						disclosureIconStyle += "Close";
					}
					if (isLast(data))
					{
						disclosureIconStyle += "Last";
					}
					TreeListData(listData).disclosureIcon = getStyle(disclosureIconStyle);

					var lineClass:Class = getStyle("disclosureIconLine") as Class;
					if (lineClass)
					{
						var node:Object = data.parent;
						for (var i:int = 0; i < TreeListData(listData).depth - 1; i++)
						{
							_lines[i] = new lineClass();
							_lines[i].visible = !isLast(node);
							node = node ? node.parent : null;
							addChild(_lines[i]);
						}
					}
				}
			}
			super.commitProperties();
		}

		override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
		{
			super.updateDisplayList(unscaledWidth, unscaledHeight);

			if (disclosureIcon)
			{
				disclosureIcon.visible = true;

				var x:int = disclosureIcon.x;
				for each (var line:DisplayObject in _lines)
				{
					line.x = x - line.width;
					x = line.x;
				}
			}

			graphics.clear();

			if (data && data.parent && filter && label)
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

		private function isLast(node:Object):Boolean
		{
			return node.parent && node.parent.children is Array &&
					node.parent.children.indexOf(node) == node.parent.children.length - 1;
		}
	}
}