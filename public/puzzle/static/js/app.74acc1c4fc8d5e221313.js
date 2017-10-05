webpackJsonp([1],{29:function(e,t,i){"use strict";Object.defineProperty(t,"__esModule",{value:!0});var s=i(10),r=i(9),n=i.n(r);s.a.config.productionTip=!1,window.app=new s.a({el:"#app",template:"<Board/>",components:{Board:n.a}})},30:function(e,t,i){"use strict";Object.defineProperty(t,"__esModule",{value:!0});var s=i(32),r=i.n(s),n=i(38),o=i.n(n),a=i(41),l=i.n(a),c=i(11),u=i.n(c),h=i(40),d=(i.n(h),u.a.create({baseURL:""}));t.default={components:{Tile:l.a},mounted:function(){var e=this;d.get("/api/sponsor/the_sponsor/selections").then(function(t){e.size=t.data.size,e.hash=t.data.image_hash,e.start(t.data.image_url)})},data:function(){return{image:null,size:{horizontal:0,vertical:0},tiles:[],tileSize:{width:0,height:0},moves:0,reorderedTiles:!1,farFromBeacon:!1,loaded:!1}},watch:{locked:function(e,t){!e&&t&&this.performShuffle()},farFromBeacon:function(e,t){var i=this;e&&!t&&d.get("/api/captures/by_user/"+this.currentUser).then(function(e){var t=e.data.list.filter(function(e){return e.image===i.hash}).map(function(e){return Number(e.tile)});setTimeout(function(){i.farFromBeacon=!1,i.tiles=[],i.drawTiles(t)},2e3)})}},computed:{viewportHeight:function(){return Math.max(document.documentElement.clientWidth,window.innerWidth||0)},viewportWidth:function(){return Math.max(document.documentElement.clientHeight,window.innerHeight||0)},locked:function(){return this.tiles.some(function(e){return e.isLocked})},frameSize:function(){return{width:this.tileSize.width*this.size.horizontal+"px",height:this.tileSize.height*this.size.vertical+"px"}},userHasMoved:function(){return this.moves>0},currentUser:function(){return new URLSearchParams(document.location.search).get("player_id")},totalTiles:function(){return this.size.horizontal*this.size.vertical},solved:function(){if(!this.tiles.length)return!1;if(this.locked)return!1;if(!this.userHasMoved||localStorage.image!==this.hash)return!1;if(localStorage.solved===this.hash)return!1;for(var e=0;e<this.totalTiles;++e)if(this.tiles[e].styles.order!==this.tiles[e].position)return!1;return this.obtainPincode(),!0}},methods:{obtainPincode:function(){var e=this;this.unlock({position:0}).then(function(){localStorage.solved=e.hash})},performShuffle:function(){var e=this;localStorage.clear(),setTimeout(function(){e.shuffleTiles()},5e3)},backupTiles:function(){localStorage.image=this.hash,localStorage.tiles=r()(this.tiles.map(function(e){var t=JSON.parse(r()(e));return delete t.styles.backgroundImage,t}))},restoreTiles:function(){var e=this;JSON.parse(localStorage.tiles).map(function(t){var i=0===t.position;return t.styles.backgroundImage=i?"none":"url("+e.image+")",t.isEmpty=i,t.isLocked=!1,t}).forEach(function(t){return e.tiles.push(t)}),this.reorderedTiles=!0},start:function(e){this.image=e,this.tileSize.width=Math.floor(this.viewportHeight/this.size.horizontal),this.tileSize.height=Math.floor(this.viewportWidth/this.size.vertical),this.generateTiles()},drawTiles:function(e){for(var t=0;t<this.totalTiles;++t)this.tiles.push({styles:{backgroundImage:0===t?"none":"url("+this.image+")",backgroundPositionX:"-"+t%this.size.horizontal*this.tileSize.width+"px",backgroundPositionY:"-"+Math.floor(t/this.size.horizontal)*this.tileSize.height+"px",backgroundSize:"100vw 100vh",width:this.tileSize.width+"px",height:this.tileSize.height+"px",order:t},position:t,isEmpty:0===t,isLocked:0!==t&&Boolean(!e.includes(t))})},generateTiles:function(){var e=this;d.get("/api/captures/by_user/"+this.currentUser).then(function(t){var i=t.data.list.filter(function(t){return t.image===e.hash}).map(function(e){return Number(e.tile)});i.length>=e.totalTiles-1?localStorage.image===e.hash&&localStorage.tiles?e.restoreTiles():(e.drawTiles(i),e.performShuffle()):e.drawTiles(i),e.loaded=!0})},shuffleTiles:function(){for(var e=this,t=0,i=5*this.totalTiles;t<i;++t)!function(t,i){var s=e.tiles.find(function(e){return e.isEmpty}),r=e.tiles.filter(function(t){return e.getAdjacentOrders(s).includes(t.styles.order)});e.switchTiles(s,o()(r))}();this.reorderedTiles=!0},unlock:function(e){var t=this,i=new FormData;return i.append("user",this.currentUser),i.append("tile",e.position),i.append("image",this.hash),d.post("/api/captures",i).then(function(i){"ok"===i.data.status?e.isLocked=!1:t.farFromBeacon=!0})},clickedTile:function(e){var t=this;if(!e.isEmpty){if(e.isLocked)return void this.unlock(e);if(!this.locked){var i=this.tiles.find(function(i){return i.isEmpty&&t.getAdjacentOrders(e).includes(i.styles.order)});i&&(this.switchTiles(i,e),this.moves+=1,this.backupTiles())}}},switchTiles:function(e,t){var i=[t.styles.order,e.styles.order];e.styles.order=i[0],t.styles.order=i[1]},getAdjacentOrders:function(e){var t=e.styles.order;return[t%this.size.horizontal?t-1:null,(t+1)%this.size.horizontal?t+1:null,t-this.size.horizontal,t+this.size.horizontal]}}}},31:function(e,t,i){"use strict";Object.defineProperty(t,"__esModule",{value:!0}),t.default={props:["tile"],methods:{onTileClick:function(){this.$emit("clicked",this.tile)}}}},35:function(e,t){},36:function(e,t){},41:function(e,t,i){i(35);var s=i(7)(i(31),i(42),null,null);e.exports=s.exports},42:function(e,t){e.exports={render:function(){var e=this,t=e.$createElement;return(e._self._c||t)("div",{staticClass:"tile",class:{empty:e.tile.isEmpty,locked:e.tile.isLocked},style:e.tile.styles,on:{click:e.onTileClick}})},staticRenderFns:[]}},43:function(e,t){e.exports={render:function(){var e=this,t=e.$createElement,i=e._self._c||t;return i("div",{staticClass:"board"},[i("div",{staticClass:"frame-wrapper",style:e.frameSize},[e.solved&&e.userHasMoved?i("p",{staticClass:"notice"},[i("span",[e._v("¡Enhorabuena has completado el puzzle!!")]),e._v(" "),i("span",[e._v("Pulsa en premios para comprobar si te ha tocado una fantástica recompensa. ")])]):e._e(),e._v(" "),i("p",{staticClass:"notice",class:{invisible:!e.farFromBeacon}},[i("span",[e._v("¡Ops estás fuera del alcance!")]),e._v(" "),i("span",[e._v("Para desbloquear la pieza acércate a uno de los puntos de refrescos, neveras y expositores fuera de la zona habitual de refrescos.")])]),e._v(" "),e.locked||e.userHasMoved||e.reorderedTiles||!e.loaded?e._e():i("p",{staticClass:"notice"},[i("span",[e._v("¡Ordena las piezas y podrás ganar una fantástico premio!")])]),e._v(" "),i("div",{staticClass:"frame",style:e.frameSize},e._l(e.tiles,function(t){return i("Tile",{key:t.position,ref:"tiles",refInFor:!0,attrs:{tile:t},on:{clicked:e.clickedTile}})}))])])},staticRenderFns:[]}},9:function(e,t,i){i(36);var s=i(7)(i(30),i(43),null,null);e.exports=s.exports}},[29]);
//# sourceMappingURL=app.74acc1c4fc8d5e221313.js.map