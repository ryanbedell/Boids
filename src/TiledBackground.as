package
{
	import flash.display.BitmapData;
	import flash.geom.Matrix;
	
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.textures.Texture;
	
	public class TiledBackground extends Sprite
	{
		public function TiledBackground()
		{
			super();
		}
		
		public function init(_width:Number,_height:Number,bitmapData:BitmapData):void
		{
			var text:Texture = Texture.fromBitmapData(bitmapData);
			
			var w:Number = _width/bitmapData.width;
			var h:Number = _height/bitmapData.height;
			
			var numI:int = 0;
			for(var i:Number = 0; i < _width; i += bitmapData.width)
			{
				var numJ:int = 0;
				for (var j:Number = 0; j < _height; j+= bitmapData.height)
				{
					var image:Image = new Image(text);
					image.x = i - numI;
					image.y =j - numJ;
					addChild(image);
					numJ++;
				}
				numI+=2;;
			}

			flatten();
		}
	}
}