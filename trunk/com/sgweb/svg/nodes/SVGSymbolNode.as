/*
 Copyright (c) 2009 by contributors:

 * James Hight (http://labs.zavoo.com/)
 * Richard R. Masters

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

package com.sgweb.svg.nodes
{
    import com.sgweb.svg.core.SVGNode;

    /** 
     * Contains drawing instructions used by SVGUseNode
     * It is not rendered directly
     **/
    public class SVGSymbolNode extends SVGNode
    {        
        public function SVGSymbolNode(svgRoot:SVGRoot, xml:XML):void {
            super(svgRoot, xml);
        }    
        
        override protected function draw():void {
            //Do Nothing
        }
        
        override protected function generateGraphicsCommands():void {
            this._graphicsCommands = new Array();
            //Do Nothing
        }
        
        
    }
}