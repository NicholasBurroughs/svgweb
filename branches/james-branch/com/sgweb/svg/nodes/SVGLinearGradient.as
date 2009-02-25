/*
Copyright (c) 2008 James Hight
Copyright (c) 2008 Richard R. Masters, for his changes.

Permission is hereby granted, free of charge, to any person
obtaining a copy of this software and associated documentation
files (the "Software"), to deal in the Software without
restriction, including without limitation the rights to use,
copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the
Software is furnished to do so, subject to the following
conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
OTHER DEALINGS IN THE SOFTWARE.
*/

package com.sgweb.svg.nodes
{
    import com.sgweb.svg.data.SVGColors;
    import flash.events.Event;
    import flash.geom.Matrix;
    import flash.display.Graphics;
    import flash.display.GradientType;
    import flash.display.SpreadMethod;
    import flash.display.InterpolationMethod;
    
    public class SVGLinearGradient extends SVGNode
    {                
        public function SVGLinearGradient(svgRoot:SVGRoot, xml:XML):void {
            super(svgRoot, xml);
        }    

        /**
         *
         **/
        public function beginGradientFill(svgNode:SVGNode, graphics:Graphics):void {
            var colors:Array = [];
            var alphas:Array = [];
            var ratios:Array = [];
            for (var i:int = 0; i < this.numChildren; i++) {
                if (this.getChildAt(i) is SVGGradientStop) {
                    
                    var stop:SVGGradientStop  = SVGGradientStop(this.getChildAt(i));
                    if (stop.invalidDisplay) {
                        stop.doRedrawNow();
                    }

                    var color:Number = SVGColors.getColor(stop.getStyle('stop-color'));
                    colors.push(color);

                    var stopOpacity:String = stop.getStyle('stop-opacity');
                    if (stopOpacity == null)
                        stopOpacity="1";
                    var alpha:Number = SVGColors.cleanNumber(stopOpacity);
                    alphas.push(alpha);

                    var ratio:Number = SVGColors.cleanNumber(stop.xml.@offset);
                    ratio = ratio * 255;
                    ratios.push(ratio);
                }
            }


            var matrGrTr:Matrix = this.parseTransform(this.xml.@gradientTransform);


            var x1:Number = 0;
            if (this.xml.@x1 != null) {
                x1 = Math.round(Number(this.xml.@x1));
            }
            var y1:Number = 0;
            if (this.xml.@y1 != null) {
                y1 = Math.round(Number(this.xml.@y1));
            }
            var x2:Number = 0;
            if (this.xml.@x2 != null) {
                x2 = Math.round(Number(this.xml.@x2));
            }
            var y2:Number = 0;
            if (this.xml.@y2 != null) {
                y2 = Math.round(Number(this.xml.@y2));
            }

            var objectX:Number = 0;
            if (svgNode.xml.@x != null) {
                objectX = Math.round(Number(svgNode.xml.@x));
            }
            var objectY:Number = 0;
            if (svgNode.xml.@y != null) {
                objectY = Math.round(Number(svgNode.xml.@y));
            }

            var dx:Number = x2 - x1;
            var dy:Number = y2 - y1;
            var angle:Number = Math.atan2(dy, dx);

            // Disabled because i am currently doing the object adjustment at the
            // end, which seems to be necessary for radial gradients, but it is not
            // clear what the difference is. I will do it the same as radials to
            // be consistent, and on the hunch that it is correct.
            //var tx:Number = (x1 + x2) / 2 - objectX;
            //var ty:Number = (y1 + y2) / 2 - objectY;
            var tx:Number = (x1 + x2) / 2;
            var ty:Number = (y1 + y2) / 2;

            var gradientWidth:Number = Math.abs(x2 - x1);
            var gradientHeight:Number = Math.abs(y2 - y1);
            var sx:Number = Math.sqrt(gradientWidth*gradientWidth+gradientHeight*gradientHeight) / 1638.4;
            var sy:Number = 1;

            var matr:Matrix= new Matrix();
            matr.scale(sx, sy);
            matr.rotate(angle);
            matr.translate(tx, ty);
            
            if (matrGrTr != null)
                matr.concat(matrGrTr);

            matr.translate(-objectX, -objectY);

            var spreadMethod:String = SpreadMethod.PAD;
            if (this.xml.@['spreadMethod'] == 'reflect') {
                spreadMethod = SpreadMethod.REFLECT;
            }
            if (this.xml.@['spreadMethod'] == 'repeat') {
                spreadMethod = SpreadMethod.REPEAT;
            }

            var interpMethod:String = InterpolationMethod.RGB;

            //this.svgRoot.debug("id: " + svgNode.xml.@id);
            //this.svgRoot.debug("colors: " + colors);
            //this.svgRoot.debug("ratios: " + ratios);
            //this.svgRoot.debug("alphas: " + alphas);
            //this.svgRoot.debug("matr: " + matr);
            graphics.beginGradientFill(GradientType.LINEAR, colors, alphas, ratios, matr, spreadMethod, interpMethod);

        }



        /**
         *
         **/
        public function lineGradientStyle(svgNode:SVGNode, graphics:Graphics, line_alpha:Number):void {
            var colors:Array = [];
            var alphas:Array = [];
            var ratios:Array = [];
            for (var i:int = 0; i < this.numChildren; i++) {
                if (this.getChildAt(i) is SVGGradientStop) {
                    
                    var stop:SVGGradientStop  = SVGGradientStop(this.getChildAt(i));
                    if (stop.invalidDisplay) {
                        stop.doRedrawNow();
                    }

                    var color:Number = SVGColors.getColor(stop.getStyle('stop-color'));
                    colors.push(color);

                    var stopOpacity:String = stop.getStyle('stop-opacity');
                    if (stopOpacity == null)
                        stopOpacity="1";
                    var alpha:Number = SVGColors.cleanNumber(stopOpacity);
                    alpha = alpha * line_alpha;
                    alphas.push(alpha);

                    var ratio:Number = SVGColors.cleanNumber(stop.xml.@offset);
                    ratio = ratio * 255;
                    ratios.push(ratio);
                }
            }

            var matrGrTr:Matrix = this.parseTransform(this.xml.@gradientTransform);


            var x1:Number = 0;
            if (this.xml.@x1 != null) {
                x1 = Math.round(Number(this.xml.@x1));
            }
            var y1:Number = 0;
            if (this.xml.@y1 != null) {
                y1 = Math.round(Number(this.xml.@y1));
            }
            var x2:Number = 0;
            if (this.xml.@x2 != null) {
                x2 = Math.round(Number(this.xml.@x2));
            }
            var y2:Number = 0;
            if (this.xml.@y2 != null) {
                y2 = Math.round(Number(this.xml.@y2));
            }

            var objectX:Number = 0;
            if (svgNode.xml.@x != null) {
                objectX = Math.round(Number(svgNode.xml.@x));
            }
            var objectY:Number = 0;
            if (svgNode.xml.@y != null) {
                objectY = Math.round(Number(svgNode.xml.@y));
            }

            var gradientWidth:Number = Math.abs(x2 - x1);
            var gradientHeight:Number = Math.abs(y2 - y1);

            var dx:Number = x2 - x1;
            var dy:Number = y2 - y1;
            var angle:Number = Math.atan2(dy, dx);

            var tx:Number = (x1 + x2) / 2 - objectX;
            var ty:Number = (y1 + y2) / 2 - objectY;

            var sx:Number = Math.sqrt(gradientWidth*gradientWidth+gradientHeight*gradientHeight) / 1638.4;
            var sy:Number = 1;

            var matr:Matrix= new Matrix();
            matr.scale(sx, sy);
            matr.rotate(angle);
            matr.translate(tx, ty);
            
            if (matrGrTr != null)
                matr.concat(matrGrTr);

            var spreadMethod:String = SpreadMethod.PAD;
            if (this.xml.@['spreadMethod'] == 'reflect') {
                spreadMethod = SpreadMethod.REFLECT;
            }
            if (this.xml.@['spreadMethod'] == 'repeat') {
                spreadMethod = SpreadMethod.REPEAT;
            }
            var interpMethod:String = InterpolationMethod.RGB;
            //this.svgRoot.debug("id: " + svgNode.xml.@id);
            //this.svgRoot.debug("colors: " + colors);
            //this.svgRoot.debug("ratios: " + ratios);
            //this.svgRoot.debug("alphas: " + alphas);
            //this.svgRoot.debug("matr: " + matr);
            graphics.lineGradientStyle(GradientType.LINEAR, colors, alphas, ratios, matr, spreadMethod, interpMethod);

        }
        
        
        
    }
}