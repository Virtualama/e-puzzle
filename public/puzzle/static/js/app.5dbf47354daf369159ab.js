webpackJsonp([1],{13:function(e,t,i){i(44);var s=i(11)(i(34),i(51),null,null);e.exports=s.exports},33:function(e,t,i){"use strict";Object.defineProperty(t,"__esModule",{value:!0});var s=i(14),r=i(13),o=i.n(r);s.a.config.productionTip=!1,new s.a({el:"#app",template:"<Board/>",components:{Board:o.a}})},34:function(e,t,i){"use strict";Object.defineProperty(t,"__esModule",{value:!0});var s=i(36),r=i.n(s),o=i(46),n=i.n(o),a=i(49),l=i.n(a),c=i(15),u=i.n(c),h=i(37),d=i.n(h),f=i(48),p=(i.n(f),u.a.create({baseURL:""}));t.default={components:{Tile:l.a},mounted:function(){this.start()},data:function(){return{image:null,size:{horizontal:0,vertical:0},tiles:[],tileSize:{width:0,height:0},moves:0,reorderedTiles:!1,farFromBeacon:!1,loaded:!1}},watch:{locked:function(e,t){!e&&t&&this.performShuffle()},farFromBeacon:function(e,t){var i=this;e&&!t&&setTimeout(function(){i.farFromBeacon=!1},1e4)}},computed:{viewportHeight:function(){return Math.max(document.documentElement.clientWidth,window.innerWidth||0)},viewportWidth:function(){return Math.max(document.documentElement.clientHeight,window.innerHeight||0)},locked:function(){return this.tiles.some(function(e){return e.isLocked})},frameSize:function(){return{width:this.tileSize.width*this.size.horizontal+"px",height:this.tileSize.height*this.size.vertical+"px"}},userHasMoved:function(){return this.moves>0},currentUser:function(){return new URLSearchParams(document.location.search).get("player_id")},totalTiles:function(){return this.size.horizontal*this.size.vertical},solved:function(){if(!this.tiles.length)return!1;if(this.locked)return!1;if(!this.userHasMoved||localStorage.image!==this.hash)return!1;if("solved"===localStorage[this.hash])return!1;for(var e=0;e<this.totalTiles;++e)if(this.tiles[e].styles.order!==this.tiles[e].position)return!1;return this.obtainPincode(),!0}},methods:{obtainPincode:function(){var e=this;this.unlock({position:0}).then(function(){localStorage[e.hash]="solved"})},performShuffle:function(){var e=this;setTimeout(function(){e.shuffleTiles()},5e3)},backupTiles:function(){localStorage.image=this.hash,localStorage.tileOrder=r()(this.tiles.map(function(e){return e.styles.order}))},restoreTiles:function(){if(localStorage.image===this.hash&&localStorage.tileOrder){var e=JSON.parse(localStorage.tileOrder);this.tiles.forEach(function(t,i){t.styles.order=e[i]}),this.reorderedTiles=!0}},start:function(){var e=this;p.get("/api/sponsor/the_sponsor/selections").then(function(t){d()(t.data.image_url,function(i){e.size=t.data.size,e.image=i.toDataURL(),e.hash=t.data.image_hash;var s=new Image;s.onload=function(){e.tileSize.width=Math.floor(e.viewportHeight/e.size.horizontal),e.tileSize.height=Math.floor(e.viewportWidth/e.size.vertical),e.generateTiles()},s.src=e.image},{maxWidth:e.viewportWidth,maxHeight:e.viewportHeight,canvas:!0,cover:!0,crossOrigin:!0})})},generateTiles:function(){var e=this;this.tiles=[],p.get("/api/captures/by_user/"+this.currentUser).then(function(t){for(var i=t.data.list.filter(function(t){return t.image===e.hash}).map(function(e){return Number(e.tile)}),s=0;s<e.totalTiles;++s)e.tiles.push({styles:{backgroundPositionX:"-"+s%e.size.horizontal*e.tileSize.width+"px",backgroundPositionY:"-"+Math.floor(s/e.size.horizontal)*e.tileSize.height+"px",width:e.tileSize.width+"px",height:e.tileSize.height+"px",order:s},position:s,isEmpty:0===s,isLocked:0!==s&&Boolean(!i.includes(s))});e.locked||localStorage.image===e.hash?e.restoreTiles():e.performShuffle(),e.loaded=!0})},shuffleTiles:function(){for(var e=this,t=0,i=5*this.totalTiles;t<i;++t)!function(t,i){var s=e.tiles.find(function(e){return e.isEmpty}),r=e.tiles.filter(function(t){return e.getAdjacentOrders(s).includes(t.styles.order)});e.switchTiles(s,n()(r))}();this.reorderedTiles=!0},unlock:function(e){var t=this,i=new URLSearchParams;return i.append("user",this.currentUser),i.append("tile",e.position),i.append("image",this.hash),p.post("/api/captures",i).then(function(i){console.log(i),"ok"===i.data.status?e.isLocked=!1:t.farFromBeacon=!0})},clickedTile:function(e){var t=this;if(!e.isEmpty){if(e.isLocked)return void this.unlock(e);if(!this.locked){var i=this.tiles.find(function(i){return i.isEmpty&&t.getAdjacentOrders(e).includes(i.styles.order)});i&&this.switchTiles(i,e),this.moves+=1,this.backupTiles()}}},switchTiles:function(e,t){var i=[t.styles.order,e.styles.order];e.styles.order=i[0],t.styles.order=i[1]},getAdjacentOrders:function(e){var t=e.styles.order;return[t%this.size.horizontal?t-1:null,(t+1)%this.size.horizontal?t+1:null,t-this.size.horizontal,t+this.size.horizontal]}}}},35:function(e,t,i){"use strict";Object.defineProperty(t,"__esModule",{value:!0}),t.default={props:["tile","image"],methods:{onTileClick:function(){this.$emit("clicked",this.tile)}},created:function(){this.tile.isEmpty||(this.tile.styles.backgroundImage="url("+this.image+")")}}},43:function(e,t){},44:function(e,t){},49:function(e,t,i){i(43);var s=i(11)(i(35),i(50),null,null);e.exports=s.exports},50:function(e,t){e.exports={render:function(){var e=this,t=e.$createElement;return(e._self._c||t)("div",{staticClass:"tile",class:{empty:e.tile.isEmpty,locked:e.tile.isLocked},style:e.tile.styles,on:{click:e.onTileClick}})},staticRenderFns:[]}},51:function(e,t){e.exports={render:function(){var e=this,t=e.$createElement,i=e._self._c||t;return i("div",{staticClass:"board"},[i("div",{staticClass:"frame-wrapper",style:e.frameSize},[e.solved&&e.userHasMoved?i("p",{staticClass:"notice"},[i("span",[e._v("¡Enhorabuena has completado el puzzle!!")]),e._v(" "),i("span",[e._v("Pulsa en premios para comprobar si te ha tocado una fantástica recompensa. ")])]):e._e(),e._v(" "),e.farFromBeacon?i("p",{staticClass:"notice"},[i("span",[e._v("¡Ops estás fuera del alcance!")]),e._v(" "),i("span",[e._v("Para desbloquear la pieza acércate a uno de los puntos de refrescos, neveras y expositores fuera de la zona habitual de refrescos.")])]):e._e(),e._v(" "),e.locked||e.userHasMoved||e.reorderedTiles||!e.loaded?e._e():i("p",{staticClass:"notice"},[i("span",[e._v("¡Ordena las piezas y podrás ganar una fantástico premio!")])]),e._v(" "),i("div",{staticClass:"frame",style:e.frameSize},e._l(e.tiles,function(t){return i("Tile",{key:t.position,ref:"tiles",refInFor:!0,attrs:{tile:t,image:e.image},on:{clicked:e.clickedTile}})}))])])},staticRenderFns:[]}}},[33]);
//# sourceMappingURL=app.5dbf47354daf369159ab.js.map