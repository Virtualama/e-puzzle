webpackJsonp([1],[,,,,,,,,,,,,function(e,t,i){i(42);var n=i(4)(i(33),i(50),null,null);e.exports=n.exports},,,,,,,,,,,,,,,,,,,,function(e,t,i){"use strict";Object.defineProperty(t,"__esModule",{value:!0});var n=i(13),s=i(12),r=i.n(s);n.a.config.productionTip=!1,new n.a({el:"#app",template:"<App/>",components:{App:r.a}})},function(e,t,i){"use strict";Object.defineProperty(t,"__esModule",{value:!0});var n=i(46),s=i.n(n),r=i(36),o=i.n(r);t.default={name:"app",components:{Board:s.a},created:function(){this.autostart()},computed:{viewportHeight:function(){return Math.max(document.documentElement.clientWidth,window.innerWidth||0)},viewportWidth:function(){return Math.max(document.documentElement.clientHeight,window.innerHeight||0)}},methods:{autostart:function(){var e=this;o()("static/fingers.jpg",function(t){e.start({image:t.toDataURL(),size:{horizontal:3,vertical:3}})},{minWidth:this.viewportWidth,maxWidth:this.viewportWidth,minHeight:this.viewportHeight,maxHeight:this.viewportHeight,canvas:!0})},start:function(){var e;(e=this.$refs.board).start.apply(e,arguments)}}}},function(e,t,i){"use strict";Object.defineProperty(t,"__esModule",{value:!0});var n=i(44),s=i.n(n),r=i(47),o=i.n(r),a=i(14),l=i.n(a);t.default={components:{Tile:o.a},data:function(){return{image:null,size:{horizontal:0,vertical:0},tiles:[],tileSize:{width:0,height:0},moves:0,shuffledTiles:!1,farFromBeacon:!1}},watch:{locked:function(e,t){!e&&t&&this.performShuffle()},farFromBeacon:function(e,t){var i=this;e&&!t&&setTimeout(function(){i.farFromBeacon=!1},5e3)}},mounted:function(){this.locked||this.performShuffle()},computed:{viewportHeight:function(){return Math.max(document.documentElement.clientWidth,window.innerWidth||0)},viewportWidth:function(){return Math.max(document.documentElement.clientHeight,window.innerHeight||0)},locked:function(){return this.tiles.some(function(e){return e.isLocked})},frameSize:function(){return{width:this.tileSize.width*this.size.horizontal+"px",height:this.tileSize.height*this.size.vertical+"px"}},userHasMoved:function(){return this.moves>0},currentUser:function(){return this.getQueryParams().player_id},totalTiles:function(){return this.size.horizontal*this.size.vertical},solved:function(){if(!this.tiles.length)return!1;if(this.locked)return!1;for(var e=0;e<this.totalTiles;++e)if(this.tiles[e].styles.order!==this.tiles[e].position)return!1;return!0}},methods:{performShuffle:function(){var e=this;setTimeout(function(){e.shuffleTiles(),e.shuffledTiles=!0},5e3)},getQueryParams:function(e){return(e||document.location.search).replace(/(^\?)/,"").split("&").map(function(e){return e=e.split("="),this[e[0]]=e[1],this}.bind({}))[0]},start:function(e){var t=this,i=e.image,n=e.size;this.size=n,this.image=i;var s=new Image;s.onload=function(){t.tileSize.width=Math.floor(t.viewportHeight/n.horizontal),t.tileSize.height=Math.floor(t.viewportWidth/n.vertical),t.generateTiles()},s.src=i},generateTiles:function(){var e=this;this.tiles=[],l.a.get("/api/captures/by_user/"+this.currentUser).then(function(t){for(var i=t.data.list.map(function(e){return Number(e.tile)}),n=0;n<e.totalTiles;++n)e.tiles.push({styles:{background:0===n?"transparent":"url("+e.image+")",backgroundPositionX:"-"+n%e.size.horizontal*e.tileSize.width+"px",backgroundPositionY:"-"+Math.floor(n/e.size.horizontal)*e.tileSize.height+"px",width:e.tileSize.width+"px",height:e.tileSize.height+"px",order:n},position:n,isEmpty:0===n,isLocked:!i.includes(n)^0===n})})},shuffleTiles:function(){for(var e=this,t=0,i=5*this.totalTiles;t<i;++t)!function(t,i){var n=e.tiles.find(function(e){return e.isEmpty}),r=e.tiles.filter(function(t){return e.getAdjacentOrders(n).includes(t.styles.order)});e.switchTiles(n,s()(r))}()},unlock:function(e){var t=this,i=new URLSearchParams;i.append("user",this.currentUser),i.append("tile",e.position),i.append("image","otter"),l.a.post("/api/captures",i).then(function(i){console.log(i),"ok"===i.data.status?e.isLocked=!1:t.farFromBeacon=!0})},clickedTile:function(e){var t=this;if(!e.isEmpty){if(e.isLocked)return void this.unlock(e);if(!this.locked){var i=this.tiles.find(function(i){return i.isEmpty&&t.getAdjacentOrders(e).indexOf(i.styles.order)>-1});i&&this.switchTiles(i,e),this.moves+=1}}},switchTiles:function(e,t){var i=[t.styles.order,e.styles.order];e.styles.order=i[0],t.styles.order=i[1]},getAdjacentOrders:function(e){var t=e.styles.order;return[t%this.size.horizontal?t-1:null,(t+1)%this.size.horizontal?t+1:null,t-this.size.horizontal,t+this.size.horizontal]}}}},function(e,t,i){"use strict";Object.defineProperty(t,"__esModule",{value:!0}),t.default={props:["tile"],methods:{onTileClick:function(){this.$emit("clicked",this.tile)}}}},,,,,function(e,t){},function(e,t){},function(e,t){},,,,function(e,t,i){i(41);var n=i(4)(i(34),i(49),null,null);e.exports=n.exports},function(e,t,i){i(40);var n=i(4)(i(35),i(48),null,null);e.exports=n.exports},function(e,t){e.exports={render:function(){var e=this,t=e.$createElement;return(e._self._c||t)("div",{staticClass:"tile",class:{empty:e.tile.isEmpty,locked:e.tile.isLocked},style:e.tile.styles,on:{click:e.onTileClick}})},staticRenderFns:[]}},function(e,t){e.exports={render:function(){var e=this,t=e.$createElement,i=e._self._c||t;return i("div",{staticClass:"board"},[i("div",{staticClass:"frame-wrapper",style:e.frameSize},[e.solved&&e.userHasMoved?i("p",{staticClass:"win"},[i("span",[e._v("¡Enhorabuena, has completado el puzzle!")]),e._v(" "),i("span",[e._v("Ve a la pantalla de premios para comprobar si tu pincode tiene premio.")])]):e._e(),e._v(" "),e.farFromBeacon?i("p",{staticClass:"win"},[i("span",[e._v("¡Ooops!")]),e._v(" "),i("span",[e._v("Estás fuera del alcance. Para desbloquear la pieza acércate a uno de los puntos de venta de tus bebidas energéticas.")])]):e._e(),e._v(" "),e.locked||e.userHasMoved||e.shuffledTiles?e._e():i("p",{staticClass:"win"},[i("span",[e._v("¡Has desbloqueado todas las piezas!")]),e._v(" "),i("span",[e._v("Ahora se desordenarán y tendrás que volver a colocarlas.")])]),e._v(" "),i("div",{staticClass:"frame",style:e.frameSize},e._l(e.tiles,function(t){return i("Tile",{key:t.position,ref:"tiles",refInFor:!0,attrs:{tile:t},on:{clicked:e.clickedTile}})}))])])},staticRenderFns:[]}},function(e,t){e.exports={render:function(){var e=this,t=e.$createElement,i=e._self._c||t;return i("div",{attrs:{id:"app"}},[i("Board",{ref:"board"})],1)},staticRenderFns:[]}}],[32]);
//# sourceMappingURL=app.7d9e1d480ab29ec466f4.js.map